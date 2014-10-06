//
//  S4MEval.m
//  Scheme4Mac
//
//  Created by Jan Müller on 23.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MEval.h"
#import "S4MReader.h"
#import "S4MPrinter.h"
#import "S4MSchemeCons.h"
#import "S4MSymbolTable.h"
#import "S4MSchemeBuiltin.h"
#import "S4MSchemeVoid.h"
#import "S4MSchemeUserDefinedFunction.h"
#import "S4MSchemeTrue.h"
#import "S4MSchemeFalse.h"
#import "S4MSchemeNil.h"
#import "S4MSchemeNumber.h"
#import "S4MSchemeVector.h"
#import "S4MSchemeInteger.h"
#import "S4MSchemeString.h"

@implementation S4MEval
{
    NSDictionary* schemeSyntaxBindings;
}

#pragma mark Top Level Eval Functions

-(S4MSchemeObject*)evalObject:(S4MSchemeObject *)obj inEnvironment:(S4MSchemeEnvironment *)env
{
    if (!env) {
        env = _globalEnvironment;
    }
    
    if ([obj isSchemeCons]) {
        return [self evalList:obj inEnvironment:env];
    } else if ([obj isSchemeSymbol]) {
        return [env getBindingForKey:(S4MSchemeSymbol*)obj];
    } else {
        return obj;
    }
}

-(S4MSchemeObject*)evalList:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* list = (S4MSchemeCons*)obj;
    S4MSchemeObject* car = list.car;
    
    if ([car isSchemeSymbol]) {
        
        // check for builtin syntax
        if ([schemeSyntaxBindings objectForKey:((S4MSchemeSymbol*)car).name]){
            SEL syntaxSelector = [[schemeSyntaxBindings objectForKey:((S4MSchemeSymbol*)car).name] pointerValue];
            return [self performSelector:syntaxSelector withObject:obj withObject:env];
        } else {
            S4MSchemeObject* binding = [env getBindingForKey:(S4MSchemeSymbol*)car];
            
            // check for builtin functions
            if ([binding isSchemeBuiltin]) {
                S4MSchemeBuiltin* builtin = (S4MSchemeBuiltin*)binding;
                // process builtin function
                NSMutableArray* args = [[NSMutableArray alloc] init];
                
                S4MSchemeObject* currentArg = list.cdr;
                while (![currentArg isSchemeNil]) {
                    [args addObject:[self evalObject:((S4MSchemeCons*)currentArg).car inEnvironment:env]];
                    currentArg = ((S4MSchemeCons*)currentArg).cdr;
                }
                // TODO check for number of args
                
                if (args.count >= builtin.minArgs && args.count <= builtin.maxArgs) {
                    return [builtin processWithArgs:args];
                } else {
                    [NSException raise:@"Missing Arguments Exception" format:@"Builtin function requires at least %d args!", builtin.minArgs];
                    return nil;
                }
                
            } else if ([binding isSchemeUserDefinedFunction]) {
                S4MSchemeUserDefinedFunction* function = (S4MSchemeUserDefinedFunction*)binding;
                // process builtin function
                NSMutableArray* args = [[NSMutableArray alloc] init];
                
                S4MSchemeObject* currentArg = list.cdr;
                while (![currentArg isSchemeNil]) {
                    [args addObject:[self evalObject:((S4MSchemeCons*)currentArg).car inEnvironment:env]];
                    currentArg = ((S4MSchemeCons*)currentArg).cdr;
                }
                
                // only eval if number of args given and required matches!
                S4MSchemeEnvironment* execEnv = [[S4MSchemeEnvironment alloc] initWithParent:function.env];
                if (args.count == function.argsCount) {
                    for (int k = 0; k < args.count; k++) {
                        [execEnv addBinding:[args objectAtIndex:k] forKey:[function.args objectAtIndex:k]];
                    }
                    return [self evalObject:function.bodyList inEnvironment:execEnv];
                } else {
                    [NSException raise:@"Wrong Argument Count" format:@"User defined function takes %d args! Given were: %d", function.argsCount, (int)args.count];
                    return nil;
                }
            } else {
                return nil;
            }
        }
    } else {
        return nil;
    }
    
}

#pragma mark Syntax Functions

-(S4MSchemeObject*)evalSyntaxDisplay:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    // return cdr as is!
    S4MSchemeCons* displayExpr = (S4MSchemeCons*)obj;
    if ([displayExpr argumentsListLength] == 1) {
        S4MSchemeObject* evaledArg = [self evalObject:[displayExpr getListItemAtIndex:1] inEnvironment:env];
        // hack needed for Void: when printed via display call, void indeed is printed as #<void>!
        if ([evaledArg isSchemeVoid]) {
            evaledArg = [S4MSymbolTable getSymbolForName:@"#<void>"];
        }
        [self.delegate printSchemeObjectOnResultView:evaledArg];
        return [S4MSchemeVoid sharedInstance];
    } else {
        [NSException raise:@"Wrong Argument Count" format:@"display-expression takes exactly 1 argument! Given were: %d", [displayExpr argumentsListLength]];
        return nil;
    }
}

-(S4MSchemeObject*)evalSyntaxBegin:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    if (![obj isSchemeCons] || [((S4MSchemeCons*)obj) argumentsListLength] < 1) {
        [NSException raise:@"Wrong Argument Count" format:@"begin-expression takes at least 1 argument. Given were: %d", [((S4MSchemeCons*)obj) argumentsListLength]];
        return nil;
    } else {
        S4MSchemeCons* currentArg = (S4MSchemeCons*)((S4MSchemeCons*)obj).cdr;
        S4MSchemeObject* currentExpr = currentArg.car;
        S4MSchemeObject* currentResult = nil;
        while (currentArg) {
            currentResult = [self evalObject:currentExpr inEnvironment:env];
            if ([currentArg nextConsExists]) {
                currentArg = (S4MSchemeCons*)currentArg.cdr;
                currentExpr = currentArg.car;
            } else {
                currentArg = nil;
            }
        }
        return currentResult;
    }
}

-(S4MSchemeObject*)evalSyntaxDefine:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    // first check for arguments count in general
    S4MSchemeCons* defineExpr = (S4MSchemeCons*)obj;
    int numberOfArgs = [defineExpr argumentsListLength];
    if (numberOfArgs != 2) {
        [NSException raise:@"Wrong Argument Count" format:@"define-expression takes 2 arguments. Given were: %d", numberOfArgs];
        return nil;
    } else {
        // normal define or shorthand syntax
        S4MSchemeObject* key = ((S4MSchemeCons*)defineExpr.cdr).car;
        S4MSchemeObject* value = ((S4MSchemeCons*)((S4MSchemeCons*)defineExpr.cdr).cdr).car;
        if ([key isSchemeSymbol]) {
            // simple define
            [env forceAddBinding:[self evalObject:value inEnvironment:env] forKey:(S4MSchemeSymbol*)key];
            return [S4MSchemeVoid sharedInstance];
        } else if ([key isSchemeCons]) {
            // shorthand syntax for lambda
            S4MSchemeCons* argList = (S4MSchemeCons*)key;
            // check that it's not an empty list!
            if ([argList listLength] >= 1) {
                // store the first arg as function name
                S4MSchemeSymbol* functionName = nil;
                if ([argList.car isSchemeSymbol]) {
                    functionName = (S4MSchemeSymbol*)argList.car;
                } else {
                    [NSException raise:NSInvalidArgumentException format:@"define-expression can only bind functions to symbols. Given was: %@", argList.car];
                    return nil;
                }
                
                NSMutableArray* args = [[NSMutableArray alloc] init];
                S4MSchemeObject* currentArg = nil;
                // if list contains arguments, store these
                while ([argList nextConsExists]) {
                    argList = (S4MSchemeCons*)argList.cdr;
                    currentArg = argList.car;
                    if ([argList.car isSchemeSymbol]) {
                        [args addObject:currentArg];
                    } else {
                        [NSException raise:NSInvalidArgumentException format:@"define-expression lambda arguments have to be symbols. Given was: %@", currentArg];
                        return nil;
                    }
                }
                [env forceAddBinding:[[S4MSchemeUserDefinedFunction alloc] initWithArgs:args AndBodyList:(S4MSchemeCons*)value AndEnv:env] forKey:functionName];
                return [S4MSchemeVoid sharedInstance];
            } else {
                [NSException raise:@"Bad Define Syntax" format:@"define-expression needs at least 1 key."];
                return nil;
            }
            return nil;
        } else {
            [NSException raise:NSInvalidArgumentException format:@"define-expression can only bind to symbols. Given was: %@", key];
            return nil;
        }
    }
}

-(S4MSchemeObject*)evalSyntaxLambda:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* lambdaExpr = (S4MSchemeCons*)obj;
    if ([lambdaExpr argumentsListLength] < 2) {
        [NSException raise:@"Wrong Argument Count" format:@"lambda-expression takes at least 2 arguments: argList and body[]! Given were: %d", [lambdaExpr argumentsListLength]];
        return nil;
    }
    // collect & store args in array:
    NSMutableArray* args = [[NSMutableArray alloc] init];
    S4MSchemeCons* argList = (S4MSchemeCons*)((S4MSchemeCons*)lambdaExpr.cdr).car;
    if ([argList isSchemeCons]) {
        S4MSchemeObject* currentArg = argList.car;
        if ([currentArg isSchemeSymbol]) {
            [args addObject:currentArg];
        } else {
            [NSException raise:NSInvalidArgumentException format:@"lambda-expression takes only symbols as args! Given was: %@", currentArg];
            return nil;
        }
        while ([argList nextConsExists]) {
            argList = (S4MSchemeCons*)argList.cdr;
            currentArg = argList.car;
            if ([currentArg isSchemeSymbol]) {
                [args addObject:currentArg];
            } else {
                [NSException raise:NSInvalidArgumentException format:@"lambda-expression takes only symbols as args! Given was: %@", currentArg];
                return nil;
            }
        }
    }
    S4MSchemeCons* bodyList = (S4MSchemeCons*)((S4MSchemeCons*)((S4MSchemeCons*)lambdaExpr.cdr).cdr).car;
    return [[S4MSchemeUserDefinedFunction alloc] initWithArgs:args AndBodyList:bodyList AndEnv:env];
}

-(S4MSchemeObject*)evalSyntaxIf:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* ifExpr = (S4MSchemeCons*)obj;
    // check if length is 3: cond, trueBranch, falseBranch
    if ([ifExpr argumentsListLength] != 3) {
        [NSException raise:@"Wrong Argument Count" format:@"if-expression takes exactly 3 arguments: condition, trueBranch, falseBranch! Given were: %d", [ifExpr argumentsListLength]];
        return nil;
    }
    S4MSchemeObject* cond = ((S4MSchemeCons*) ifExpr.cdr).car;
    S4MSchemeObject* trueBranch = ((S4MSchemeCons*)((S4MSchemeCons*) ifExpr.cdr).cdr).car;
    S4MSchemeObject* falseBranch = ((S4MSchemeCons*)((S4MSchemeCons*)((S4MSchemeCons*) ifExpr.cdr).cdr).cdr).car;
    
    if ([[self evalObject:cond inEnvironment:env] isSchemeFalse]) {
        return [self evalObject:falseBranch inEnvironment:env];
    } else {
        return [self evalObject:trueBranch inEnvironment:env];
    }
}

-(S4MSchemeObject*)evalSyntaxEq:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* eqExpr = (S4MSchemeCons*)obj;
    // check if length is 3: cond, trueBranch, falseBranch
    if ([eqExpr argumentsListLength] == 2) {
        S4MSchemeObject* obj1 = [self evalObject:[eqExpr getListItemAtIndex:1] inEnvironment:env];
        S4MSchemeObject* obj2 = [self evalObject:[eqExpr getListItemAtIndex:2] inEnvironment:env];
        return [self compareObject:obj1 ToObject:obj2 onTopLevel:YES];
    } else {
        [NSException raise:@"Wrong Argument Count" format:@"eq?-expression takes exactly 2 arguments! Given were: %d", [eqExpr argumentsListLength]];
        return nil;
    }
}

-(S4MSchemeObject*)compareObject:(S4MSchemeObject*)obj1 ToObject:(S4MSchemeObject*)obj2 onTopLevel:(BOOL)isTopLevel
{
    // are the 2 objects of the same class?
    if ([obj1 class] == [obj2 class]) {
        // in certain cases the content has to be compared as well:
        if ([[obj1 class] isSubclassOfClass:[S4MSchemeNumber class]]) {
            if ([((S4MSchemeNumber*)obj1).value isEqualToNumber:((S4MSchemeNumber*)obj2).value]) {
                return [S4MSchemeTrue sharedInstance];
            } else {
                return [S4MSchemeFalse sharedInstance];
            }
        } else if ([obj1 class] == [S4MSchemeSymbol class]) {
            if ([((S4MSchemeSymbol*)obj1).name isEqualToString:((S4MSchemeSymbol*)obj2).name]) {
                return [S4MSchemeTrue sharedInstance];
            } else {
                return [S4MSchemeFalse sharedInstance];
            }
        } else if ([obj1 class] == [S4MSchemeString class]) {
            if ([((S4MSchemeString*)obj1).content isEqualToString:((S4MSchemeString*)obj2).content]) {
                return [S4MSchemeTrue sharedInstance];
            } else {
                return [S4MSchemeFalse sharedInstance];
            }
        } else if ([obj1 class] == [S4MSchemeCons class]) {
            if ([(S4MSchemeCons*)obj1 listLength] == [(S4MSchemeCons*)obj2 listLength]) {
                for (int i = 0; i < [(S4MSchemeCons*)obj1 listLength]; i++) {
                    if ([[self compareObject:[(S4MSchemeCons*)obj1 getListItemAtIndex:i] ToObject:[(S4MSchemeCons*)obj2 getListItemAtIndex:i] onTopLevel:NO] isSchemeFalse]) {
                        return [S4MSchemeFalse sharedInstance];
                    }
                }
                if (isTopLevel) {
                    return [S4MSchemeTrue sharedInstance];
                } else {
                    return [S4MSchemeVoid sharedInstance];
                }
            } else {
                return [S4MSchemeFalse sharedInstance];
            }
        } else if ([obj1 class] == [S4MSchemeVector class]) {
            if ([(S4MSchemeVector*)obj1 vectorLength] == [(S4MSchemeVector*)obj2 vectorLength]) {
                for (int i = 0; i < [(S4MSchemeVector*)obj1 vectorLength]; i++) {
                    if ([[self compareObject:[(S4MSchemeVector*)obj1 getObjectAtIndex:i] ToObject:[(S4MSchemeVector*)obj2 getObjectAtIndex:i] onTopLevel:NO] isSchemeFalse]) {
                        return [S4MSchemeFalse sharedInstance];
                    }
                }
                if (isTopLevel) {
                    return [S4MSchemeTrue sharedInstance];
                } else {
                    return [S4MSchemeVoid sharedInstance];
                }
            } else {
                return [S4MSchemeFalse sharedInstance];
            }
        } else {
            return [S4MSchemeTrue sharedInstance];
        }
    } else {
        return [S4MSchemeFalse sharedInstance];
    }
}

// sets up new env, binds vars, executes expressions & returns result of last.
-(S4MSchemeObject*)evalSyntaxLet:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* letExpr = (S4MSchemeCons*)obj;
    if ([letExpr argumentsListLength] >= 2) {
        // two main parts, check for lists first!
        S4MSchemeObject* varDefList = ((S4MSchemeCons*) letExpr.cdr).car;
        S4MSchemeCons* varDefs = nil;
        if (!([varDefList isSchemeCons] || [varDefList isSchemeNil])) {
            [NSException raise:NSInvalidArgumentException format:@"let-expression var parameter must be list or nil! Given was: %@", varDefList];
            return nil;
        } else {
            if ([varDefList isSchemeCons]) {
                varDefs = (S4MSchemeCons*)varDefList;
            }
        }
        
        // create new env for var bindings!
        S4MSchemeEnvironment* letEnv = [[S4MSchemeEnvironment alloc] initWithParent:env];
        
        if (varDefs) {
            // iterate over var bindings
            S4MSchemeObject* currentVarBindingSlot = nil;
            S4MSchemeCons* currentVarBinding = nil;
            
            for (int a = 0; a < [varDefs listLength]; a++) {
                currentVarBindingSlot = [varDefs getListItemAtIndex:a];
                NSLog(@"listLength: %d", [(S4MSchemeCons*)currentVarBindingSlot listLength]);
                if (![currentVarBindingSlot isSchemeCons]
                    || ([(S4MSchemeCons*)currentVarBindingSlot listLength] != 2 )
                    || !([((S4MSchemeCons*)currentVarBindingSlot).car isSchemeSymbol])) {
                    [NSException raise:NSInvalidArgumentException format:@"let-expression arg binding has to be of type: (symbol binding)! Given was: %@", currentVarBindingSlot];
                    return nil;
                }
                currentVarBinding = (S4MSchemeCons*)currentVarBindingSlot;
                S4MSchemeSymbol* key = (S4MSchemeSymbol*)[currentVarBinding getListItemAtIndex:0];
                S4MSchemeObject* value = [currentVarBinding getListItemAtIndex:1];
                [letEnv addBinding:[self evalObject:value inEnvironment:env] forKey:key];
            }
        }
        
        S4MSchemeObject* lastResult = nil;
        // perform expressions one at a time, return result of last expression
        for (int b = 2; b < [letExpr listLength]; b++) {
            S4MSchemeObject* exprToBeEvaled = [letExpr getListItemAtIndex:b];
            if ([exprToBeEvaled isSchemeNil]) {
                [NSException raise:@"Missing Procedure Exception" format:@"Expected expression, got nil!"];
                return nil;
            }
            lastResult = [self evalObject:exprToBeEvaled inEnvironment:letEnv];
        }
        return lastResult;
        
    } else {
        [NSException raise:@"Wrong Argument Count" format:@"let-expression takes at least 2 arguments: (... variable definitions ...) & (... expressions ...)! Given were: %d", [letExpr argumentsListLength]];
        return nil;
    }
}

// sets up new env for every var as a stack, executes expressions & returns result of last.
-(S4MSchemeObject*)evalSyntaxLetStar:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* letExpr = (S4MSchemeCons*)obj;
    if ([letExpr argumentsListLength] >= 2) {
        // two main parts, check for lists first!
        S4MSchemeObject* varDefList = ((S4MSchemeCons*) letExpr.cdr).car;
        S4MSchemeCons* varDefs = nil;
        if (!([varDefList isSchemeCons] || [varDefList isSchemeNil])) {
            [NSException raise:NSInvalidArgumentException format:@"let*-expression var parameter must be list or nil! Given was: %@", varDefList];
            return nil;
        } else {
            if ([varDefList isSchemeCons]) {
                varDefs = (S4MSchemeCons*)varDefList;
            }
        }
        
        // create new env for var bindings!
        S4MSchemeEnvironment* letEnv = [[S4MSchemeEnvironment alloc] initWithParent:env];
        
        if (varDefs) {
            // iterate over var bindings
            S4MSchemeObject* currentVarBindingSlot = nil;
            S4MSchemeCons* currentVarBinding = nil;
            
            for (int a = 0; a < [varDefs listLength]; a++) {
                // if there is more than one var binding, cascade environments!
                if (a > 0) {
                    letEnv = [[S4MSchemeEnvironment alloc] initWithParent:letEnv];
                }
                
                currentVarBindingSlot = [varDefs getListItemAtIndex:a];
                NSLog(@"listLength: %d", [(S4MSchemeCons*)currentVarBindingSlot listLength]);
                if (![currentVarBindingSlot isSchemeCons]
                    || ([(S4MSchemeCons*)currentVarBindingSlot listLength] != 2 )
                    || !([((S4MSchemeCons*)currentVarBindingSlot).car isSchemeSymbol])) {
                    [NSException raise:NSInvalidArgumentException format:@"let*-expression arg binding has to be of type: (symbol binding)! Given was: %@", currentVarBindingSlot];
                    return nil;
                }
                currentVarBinding = (S4MSchemeCons*)currentVarBindingSlot;
                S4MSchemeSymbol* key = (S4MSchemeSymbol*)[currentVarBinding getListItemAtIndex:0];
                S4MSchemeObject* value = [currentVarBinding getListItemAtIndex:1];
                [letEnv addBinding:[self evalObject:value inEnvironment:letEnv.parent] forKey:key];
            }
        }
        
        S4MSchemeObject* lastResult = nil;
        // perform expressions one at a time, return result of last expression
        for (int b = 2; b < [letExpr listLength]; b++) {
            S4MSchemeObject* exprToBeEvaled = [letExpr getListItemAtIndex:b];
            if ([exprToBeEvaled isSchemeNil]) {
                [NSException raise:@"Missing Procedure Exception" format:@"Expected expression, got nil!"];
                return nil;
            }
            lastResult = [self evalObject:exprToBeEvaled inEnvironment:letEnv];
        }
        return lastResult;
        
    } else {
        [NSException raise:@"Wrong Argument Count" format:@"let*-expression takes at least 2 arguments: (... variable definitions ...) & (... expressions ...)! Given were: %d", [letExpr argumentsListLength]];
        return nil;
    }
}

-(S4MSchemeObject*)evalSyntaxSet:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* setExpr = (S4MSchemeCons*)obj;
    if ([setExpr argumentsListLength] == 2) {
        S4MSchemeObject* varArg = ((S4MSchemeCons*) setExpr.cdr).car;
        if (![varArg isSchemeSymbol]) {
            [NSException raise:NSInvalidArgumentException format:@"set-expression takes only symbols as first argument! Given was: %@", varArg];
            return nil;
        }
        S4MSchemeSymbol* varName = (S4MSchemeSymbol*)varArg;
        S4MSchemeObject* evaledValue = [self evalObject:((S4MSchemeCons*)((S4MSchemeCons*) setExpr.cdr).cdr).car inEnvironment:env];
        if ([env hasBindingForKey:varName]) {
           [env setBinding:evaledValue forKey:varName];
            return [S4MSchemeVoid sharedInstance];
        } else {
            [NSException raise:@"Undefined Symbol Exception" format:@"Could not set value of an undefined variable."];
            return nil;
        }
    } else {
        [NSException raise:@"Wrong Argument Count" format:@"set-expression takes exactly 2 arguments: variable value! Given were: %d", [setExpr argumentsListLength]];
        return nil;
    }
}

-(S4MSchemeObject*)evalSyntaxQuote:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    // return cdr as is!
    S4MSchemeCons* quoteExpr = (S4MSchemeCons*)obj;
    if ([quoteExpr argumentsListLength] == 1) {
        return ((S4MSchemeCons*)quoteExpr.cdr).car;
    } else {
        [NSException raise:@"Wrong Argument Count" format:@"quote-expression takes exactly 1 argument! Given were: %d", [quoteExpr argumentsListLength]];
        return nil;
    }
}

#pragma mark Lists, Vectors & Pairs Syntax

-(S4MSchemeObject*)evalSyntaxVector:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* vectorExpr = (S4MSchemeCons*)obj;
    S4MSchemeVector* resultingVector = [[S4MSchemeVector alloc] init];
    if ([vectorExpr argumentsListLength] == 0) {
        return [[S4MSchemeVector alloc] init];
    }
    // at least 1 arg exists!
    
    S4MSchemeObject* currentEvaledArg = nil;
    for (int i = 1; i < [vectorExpr listLength]; i++) {
        currentEvaledArg = [self evalObject:[vectorExpr getListItemAtIndex:i] inEnvironment:env];
        if (![currentEvaledArg isSchemeVoid]) {
            [resultingVector addObject:currentEvaledArg];
        } else {
            [NSException raise:NSInvalidArgumentException format:@"vector-expression does not allow void as argument. Perhaps function call as arg by accident?"];
            return nil;
        }
    }
    
    return resultingVector;
}

-(S4MSchemeObject*)evalSyntaxVectorLength:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* vectorExpr = (S4MSchemeCons*)obj;
    
    if ([vectorExpr argumentsListLength] == 1) {
        S4MSchemeObject* evaledArg = [self evalObject:[vectorExpr getListItemAtIndex:1] inEnvironment:env];
        if ([evaledArg isSchemeVector]) {
            return [[S4MSchemeInteger alloc] initWithValue:((S4MSchemeVector*)evaledArg).vectorLength];
        } else {
            [NSException raise:NSInvalidArgumentException format:@"vector-length-expression expects vector as argument! Given was: %@", evaledArg];
            return nil;
        }
    } else {
        [NSException raise:@"Wrong Argument Count" format:@"vector-length-expression takes exactly 1 argument of type vector! Given were: %d", [vectorExpr argumentsListLength]];
        return nil;
    }
}

-(S4MSchemeObject*)evalSyntaxVectorRef:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* vectorRefExpr = (S4MSchemeCons*)obj;
    if ([vectorRefExpr argumentsListLength] == 2) {
        S4MSchemeObject* evaledTarget = [self evalObject:[vectorRefExpr getListItemAtIndex:1] inEnvironment:env];
        S4MSchemeObject* evaledArg = [self evalObject:[vectorRefExpr getListItemAtIndex:2] inEnvironment:env];
        if ([evaledTarget isSchemeVector]) {
            if ([evaledArg isSchemeInteger]) {
                return [((S4MSchemeVector*)evaledTarget) getObjectAtIndex:[((S4MSchemeInteger*)evaledArg).value intValue]];
            } else {
                [NSException raise:NSInvalidArgumentException format:@"vector-ref-expression expects ineger as second argument! Given was: %@", evaledArg];
                return nil;
            }
        } else {
            [NSException raise:NSInvalidArgumentException format:@"vector-ref-expression expects vector as first argument! Given was: %@", evaledTarget];
            return nil;
        }
    } else {
        [NSException raise:@"Wrong Argument Count" format:@"vector-ref-expression takes exactly 2 arguments: <vector> <index>! Given were: %d", [vectorRefExpr argumentsListLength]];
        return nil;
    }
}

-(S4MSchemeObject*)evalSyntaxVectorSet:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* vectorSetExpr = (S4MSchemeCons*)obj;
    if ([vectorSetExpr argumentsListLength] == 3) {
        S4MSchemeObject* evaledTarget = [self evalObject:[vectorSetExpr getListItemAtIndex:1] inEnvironment:env];
        S4MSchemeObject* evaledIndex = [self evalObject:[vectorSetExpr getListItemAtIndex:2] inEnvironment:env];
        S4MSchemeObject* evaledValue = [self evalObject:[vectorSetExpr getListItemAtIndex:3] inEnvironment:env];
        if ([evaledTarget isSchemeVector]) {
            if ([evaledIndex isSchemeInteger]) {
                if (![evaledValue isSchemeVoid]) {
                    [((S4MSchemeVector*)evaledTarget) setObject:evaledValue AtIndex:[((S4MSchemeInteger*)evaledIndex).value intValue]];
                    return [S4MSchemeVoid sharedInstance];
                } else {
                    [NSException raise:NSInvalidArgumentException format:@"vector-set!-expression does not allow void as argument. Perhaps function call as arg by accident?"];
                    return nil;
                }
            } else {
                [NSException raise:NSInvalidArgumentException format:@"vector-set!-expression expects ineger as second argument! Given was: %@", evaledIndex];
                return nil;
            }
        } else {
            [NSException raise:NSInvalidArgumentException format:@"vector-set!-expression expects vector as first argument! Given was: %@", evaledTarget];
            return nil;
        }
    } else {
        [NSException raise:@"Wrong Argument Count" format:@"vector-set!-expression takes exactly 3 arguments: <vector> <index> <object>! Given were: %d", [vectorSetExpr argumentsListLength]];
        return nil;
    }
}

-(S4MSchemeObject*)evalSyntaxVectorCopy:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* vectorCopyExpr = (S4MSchemeCons*)obj;
    S4MSchemeVector* resultingVector = [[S4MSchemeVector alloc] init];
    if ([vectorCopyExpr argumentsListLength] == 1) {
        S4MSchemeObject* evaledArg = [self evalObject:[vectorCopyExpr getListItemAtIndex:1] inEnvironment:env];
        if ([evaledArg isSchemeVector]) {
            NSMutableArray* elems = [NSMutableArray arrayWithArray:((S4MSchemeVector*)evaledArg).elements];
            resultingVector.elements = elems;
        } else {
            [NSException raise:NSInvalidArgumentException format:@"vector-copy-expression expects vector as argument! Given was: %@", evaledArg];
            return nil;
        }
    } else {
        [NSException raise:@"Wrong Argument Count" format:@"vector-copy-expression takes exactly 1 argument of type vector! Given were: %d", [vectorCopyExpr argumentsListLength]];
        return nil;
    }
    return resultingVector;
}

-(S4MSchemeObject*)evalSyntaxList:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* listExpr = (S4MSchemeCons*)obj;
    if ([listExpr argumentsListLength] == 0) {
        return [S4MSchemeNil sharedInstance];
    }
    
    // at least 1 arg exists!
    
    S4MSchemeCons* currArgListCons = listExpr;
    S4MSchemeObject* currArg = nil;
    S4MSchemeCons* resultList = [[S4MSchemeCons alloc] init];
    S4MSchemeCons* currentResultCons = resultList;
    BOOL firstArgStored = NO;
    
    while ([currArgListCons nextConsExists]) {
        currArgListCons = (S4MSchemeCons*)currArgListCons.cdr;
        currArg = [self evalObject:currArgListCons.car inEnvironment:env];
        if (!firstArgStored) {
            currentResultCons.car = currArg;
            firstArgStored = YES;
        } else {
            currentResultCons.cdr = [[S4MSchemeCons alloc] initWithCar:currArg andCdr:[S4MSchemeNil sharedInstance]];
            currentResultCons = (S4MSchemeCons*)currentResultCons.cdr;
        }
    }
    
    return resultList;
}


-(S4MSchemeObject*)evalSyntaxCons:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* consExpr = (S4MSchemeCons*)obj;
    if ([consExpr argumentsListLength] == 2) {
        S4MSchemeObject* evaledArg1 = [self evalObject:((S4MSchemeCons*)consExpr.cdr).car inEnvironment:env];
        S4MSchemeObject* evaledArg2 = [self evalObject:((S4MSchemeCons*)((S4MSchemeCons*)consExpr.cdr).cdr).car inEnvironment:env];
        return [[S4MSchemeCons alloc] initWithCar:evaledArg1 andCdr:evaledArg2];
    } else {
        [NSException raise:@"Wrong Argument Count" format:@"cons-expression takes exactly 2 arguments: car and cdr! Given were: %d", [consExpr argumentsListLength]];
        return nil;
    }
}

-(S4MSchemeObject*)evalSyntaxCar:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* carExpr = (S4MSchemeCons*)obj;
    if ([carExpr argumentsListLength] == 1) {
        S4MSchemeObject* evaledArg = [self evalObject:((S4MSchemeCons*)carExpr.cdr).car inEnvironment:env];
        if ([evaledArg isSchemeCons]) {
            return ((S4MSchemeCons*)evaledArg).car;
        } else {
            [NSException raise:NSInvalidArgumentException format:@"car-expression takes only pairs as argument! Given was: %@", evaledArg];
            return nil;
        }
    } else {
        [NSException raise:@"Wrong Argument Count" format:@"car-expression takes exactly 1 argument! Given were: %d", [carExpr argumentsListLength]];
        return nil;
    }
}

-(S4MSchemeObject*)evalSyntaxCdr:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* cdrExpr = (S4MSchemeCons*)obj;
    if ([cdrExpr argumentsListLength] == 1) {
        S4MSchemeObject* evaledArg = [self evalObject:((S4MSchemeCons*)cdrExpr.cdr).car inEnvironment:env];
        if ([evaledArg isSchemeCons]) {
            return ((S4MSchemeCons*)evaledArg).cdr;
        } else {
            [NSException raise:NSInvalidArgumentException format:@"cdr-expression takes only pairs as argument! Given was: %@", evaledArg];
            return nil;
        }
    } else {
        [NSException raise:@"Wrong Argument Count" format:@"cdr-expression takes exactly 1 argument! Given were: %d", [cdrExpr argumentsListLength]];
        return nil;
    }
}

-(S4MSchemeObject*)evalSyntaxSetCar:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* setCarExpr = (S4MSchemeCons*)obj;
    if ([setCarExpr argumentsListLength] == 2) {
        S4MSchemeObject* evaledTarget = [self evalObject:[setCarExpr getListItemAtIndex:1] inEnvironment:env];
        S4MSchemeObject* evaledArg = [self evalObject:[setCarExpr getListItemAtIndex:2] inEnvironment:env];
        if ([evaledTarget isSchemeCons]) {
            ((S4MSchemeCons*)evaledTarget).car = evaledArg;
            return [S4MSchemeVoid sharedInstance];
        } else {
            [NSException raise:NSInvalidArgumentException format:@"set-car!-expression takes only works on pairs & lists! Given was: %@", evaledTarget];
            return nil;
        }
    } else {
        [NSException raise:@"Wrong Argument Count" format:@"set-car!-expression takes exactly 2 argumenta! Given were: %d", [setCarExpr argumentsListLength]];
        return nil;
    }
}

-(S4MSchemeObject*)evalSyntaxSetCdr:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* setCdrExpr = (S4MSchemeCons*)obj;
    if ([setCdrExpr argumentsListLength] == 2) {
        S4MSchemeObject* evaledTarget = [self evalObject:[setCdrExpr getListItemAtIndex:1] inEnvironment:env];
        S4MSchemeObject* evaledArg = [self evalObject:[setCdrExpr getListItemAtIndex:2] inEnvironment:env];
        if ([evaledTarget isSchemeCons]) {
            ((S4MSchemeCons*)evaledTarget).cdr = evaledArg;
            return [S4MSchemeVoid sharedInstance];
        } else {
            [NSException raise:NSInvalidArgumentException format:@"set-cdr!-expression takes only works on pairs & lists! Given was: %@", evaledTarget];
            return nil;
        }
    } else {
        [NSException raise:@"Wrong Argument Count" format:@"set-cdr!-expression takes exactly 2 argumenta! Given were: %d", [setCdrExpr argumentsListLength]];
        return nil;
    }
}



#pragma mark Type Checks

-(S4MSchemeObject*)evalSyntaxPair:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* pairExpr = (S4MSchemeCons*)obj;
    if ([pairExpr argumentsListLength] == 1) {
        S4MSchemeObject* evaledArg = [self evalObject:[pairExpr getListItemAtIndex:1] inEnvironment:env];
        if ([evaledArg isSchemeCons]) {
            return [S4MSchemeTrue sharedInstance];
        } else {
            return [S4MSchemeFalse sharedInstance];
        }
    } else {
        [NSException raise:@"Wrong Argument Count" format:@"pair?-expression takes exactly 1 argument! Given were: %d", [pairExpr argumentsListLength]];
        return nil;
    }
}

-(S4MSchemeObject*)evalSyntaxVectorCheck:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* vectorExpr = (S4MSchemeCons*)obj;
    if ([vectorExpr argumentsListLength] == 1) {
        S4MSchemeObject* evaledArg = [self evalObject:[vectorExpr getListItemAtIndex:1] inEnvironment:env];
        if ([evaledArg isSchemeVector]) {
            return [S4MSchemeTrue sharedInstance];
        } else {
            return [S4MSchemeFalse sharedInstance];
        }
    } else {
        [NSException raise:@"Wrong Argument Count" format:@"vector?-expression takes exactly 1 argument! Given were: %d", [vectorExpr argumentsListLength]];
        return nil;
    }
}

-(S4MSchemeObject*)evalSyntaxBoolean:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* booleanExpr = (S4MSchemeCons*)obj;
    if ([booleanExpr argumentsListLength] == 1) {
        S4MSchemeObject* evaledArg = [self evalObject:[booleanExpr getListItemAtIndex:1] inEnvironment:env];
        return [evaledArg isSchemeBoolean] ? [S4MSchemeTrue sharedInstance] : [S4MSchemeFalse sharedInstance];
    } else {
        [NSException raise:@"Wrong Argument Count" format:@"boolean?-expression takes exactly 1 argument! Given were: %d", [booleanExpr argumentsListLength]];
        return nil;
    }
}

-(S4MSchemeObject*)evalSyntaxListCheck:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* listExpr = (S4MSchemeCons*)obj;
    if ([listExpr argumentsListLength] == 1) {
        S4MSchemeObject* evaledArg = [self evalObject:[listExpr getListItemAtIndex:1] inEnvironment:env];
        if ([evaledArg isSchemeNil]) {
            return [S4MSchemeTrue sharedInstance];
        } else if ([evaledArg isSchemeCons]) {
            // check if valid list (meaning last cdr must be nil!)
            S4MSchemeCons* currCons = (S4MSchemeCons*)evaledArg;
            while ([currCons nextConsExists]) {
                currCons = (S4MSchemeCons*)currCons.cdr;
            }
            return [currCons.cdr isSchemeNil] ? [S4MSchemeTrue sharedInstance] : [S4MSchemeFalse sharedInstance];
        } else {
            return [S4MSchemeFalse sharedInstance];
        }
    } else {
        [NSException raise:@"Wrong Argument Count" format:@"list?-expression takes exactly 1 argument! Given were: %d", [listExpr argumentsListLength]];
        return nil;
    }
}

-(S4MSchemeObject*)evalSyntaxString:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* stringExpr = (S4MSchemeCons*)obj;
    if ([stringExpr argumentsListLength] == 1) {
        S4MSchemeObject* evaledArg = [self evalObject:[stringExpr getListItemAtIndex:1] inEnvironment:env];
        return [evaledArg isSchemeString] ? [S4MSchemeTrue sharedInstance] : [S4MSchemeFalse sharedInstance];
    } else {
        [NSException raise:@"Wrong Argument Count" format:@"string?-expression takes exactly 1 argument! Given were: %d", [stringExpr argumentsListLength]];
        return nil;
    }
}

#pragma mark Numeric Syntax

-(S4MSchemeObject*)evalSyntaxPositive:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* positiveExpr = (S4MSchemeCons*)obj;
    if ([positiveExpr argumentsListLength] == 1) {
        S4MSchemeObject* evaledArg = [self evalObject:[positiveExpr getListItemAtIndex:1] inEnvironment:env];
        if ([evaledArg isSchemeNumber]) {
            return [((S4MSchemeNumber*)evaledArg).value isGreaterThan:@0] ? [S4MSchemeTrue sharedInstance] : [S4MSchemeFalse sharedInstance];
        } else {
            [NSException raise:NSInvalidArgumentException format:@"positive?-expression expects number argument! Given was: %@", evaledArg];
            return nil;
        }
    } else {
        [NSException raise:@"Wrong Argument Count" format:@"positive?-expression takes exactly 1 argument! Given were: %d", [positiveExpr argumentsListLength]];
        return nil;
    }
}

-(S4MSchemeObject*)evalSyntaxNegative:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env
{
    S4MSchemeCons* negativeExpr = (S4MSchemeCons*)obj;
    if ([negativeExpr argumentsListLength] == 1) {
        S4MSchemeObject* evaledArg = [self evalObject:[negativeExpr getListItemAtIndex:1] inEnvironment:env];
        if ([evaledArg isSchemeNumber]) {
            return [((S4MSchemeNumber*)evaledArg).value isLessThan:@0] ? [S4MSchemeTrue sharedInstance] : [S4MSchemeFalse sharedInstance];
        } else {
            [NSException raise:NSInvalidArgumentException format:@"negative?-expression expects number argument! Given was: %@", evaledArg];
            return nil;
        }
    } else {
        [NSException raise:@"Wrong Argument Count" format:@"negative?-expression takes exactly 1 argument! Given were: %d", [negativeExpr argumentsListLength]];
        return nil;
    }
}

#pragma mark Initialization

+(S4MEval *)sharedInstance
{
    static S4MEval *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[S4MEval alloc] init];
    });
    return _sharedInstance;
}

-(id)init
{
    if (self = [super init]) {
        _globalEnvironment = [[S4MSchemeEnvironment alloc] init];
        [self initializeGlobalEnvironment];
        schemeSyntaxBindings = @{@"begin": [NSValue valueWithPointer: @selector(evalSyntaxBegin:inEnvironment:)],
                                 @"define": [NSValue valueWithPointer: @selector(evalSyntaxDefine:inEnvironment:)],
                                 @"lambda": [NSValue valueWithPointer: @selector(evalSyntaxLambda:inEnvironment:)],
                                 @"cons": [NSValue valueWithPointer: @selector(evalSyntaxCons:inEnvironment:)],
                                 @"car": [NSValue valueWithPointer: @selector(evalSyntaxCar:inEnvironment:)],
                                 @"cdr": [NSValue valueWithPointer: @selector(evalSyntaxCdr:inEnvironment:)],
                                 @"set-car!": [NSValue valueWithPointer: @selector(evalSyntaxSetCar:inEnvironment:)],
                                 @"set-cdr!": [NSValue valueWithPointer: @selector(evalSyntaxSetCdr:inEnvironment:)],
                                 @"list": [NSValue valueWithPointer: @selector(evalSyntaxList:inEnvironment:)],
                                 @"vector": [NSValue valueWithPointer: @selector(evalSyntaxVector:inEnvironment:)],
                                 @"vector-copy": [NSValue valueWithPointer: @selector(evalSyntaxVectorCopy:inEnvironment:)],
                                 @"vector-length": [NSValue valueWithPointer: @selector(evalSyntaxVectorLength:inEnvironment:)],
                                 @"vector-ref": [NSValue valueWithPointer: @selector(evalSyntaxVectorRef:inEnvironment:)],
                                 @"vector-set!": [NSValue valueWithPointer: @selector(evalSyntaxVectorSet:inEnvironment:)],
                                 @"if": [NSValue valueWithPointer: @selector(evalSyntaxIf:inEnvironment:)],
                                 @"let": [NSValue valueWithPointer: @selector(evalSyntaxLet:inEnvironment:)],
                                 @"let*": [NSValue valueWithPointer: @selector(evalSyntaxLetStar:inEnvironment:)],
                                 @"set!": [NSValue valueWithPointer: @selector(evalSyntaxSet:inEnvironment:)],
                                 @"pair?": [NSValue valueWithPointer: @selector(evalSyntaxPair:inEnvironment:)],
                                 @"vector?": [NSValue valueWithPointer: @selector(evalSyntaxVectorCheck:inEnvironment:)],
                                 @"boolean?": [NSValue valueWithPointer: @selector(evalSyntaxBoolean:inEnvironment:)],
                                 @"list?": [NSValue valueWithPointer: @selector(evalSyntaxListCheck:inEnvironment:)],
                                 @"string?": [NSValue valueWithPointer: @selector(evalSyntaxString:inEnvironment:)],
                                 @"positive?": [NSValue valueWithPointer: @selector(evalSyntaxPositive:inEnvironment:)],
                                 @"negative?": [NSValue valueWithPointer: @selector(evalSyntaxNegative:inEnvironment:)],
                                 @"eq?": [NSValue valueWithPointer: @selector(evalSyntaxEq:inEnvironment:)],
                                 @"display": [NSValue valueWithPointer: @selector(evalSyntaxDisplay:inEnvironment:)],
                                 @"quote": [NSValue valueWithPointer: @selector(evalSyntaxQuote:inEnvironment:)]};
    }
    return self;
}

-(void)initializeGlobalEnvironment
{
    [_globalEnvironment addBinding:[[S4MSchemeBuiltinPlus alloc] init] forKey:[S4MSymbolTable getSymbolForName:@"+"]];
    [_globalEnvironment addBinding:[[S4MSchemeBuiltinMinus alloc] init] forKey:[S4MSymbolTable getSymbolForName:@"-"]];
    [_globalEnvironment addBinding:[[S4MSchemeBuiltinDivision alloc] init] forKey:[S4MSymbolTable getSymbolForName:@"/"]];
    [_globalEnvironment addBinding:[[S4MSchemeBuiltinMultiplication alloc] init] forKey:[S4MSymbolTable getSymbolForName:@"*"]];
    [_globalEnvironment addBinding:[[S4MSchemeBuiltinModulo alloc] init] forKey:[S4MSymbolTable getSymbolForName:@"modulo"]];
    [_globalEnvironment addBinding:[[S4MSchemeBuiltinGreaterThan alloc] init] forKey:[S4MSymbolTable getSymbolForName:@">"]];
    [_globalEnvironment addBinding:[[S4MSchemeBuiltinGreaterEqualThan alloc] init] forKey:[S4MSymbolTable getSymbolForName:@">="]];
    [_globalEnvironment addBinding:[[S4MSchemeBuiltinLessThan alloc] init] forKey:[S4MSymbolTable getSymbolForName:@"<"]];
    [_globalEnvironment addBinding:[[S4MSchemeBuiltinLessEqualThan alloc] init] forKey:[S4MSymbolTable getSymbolForName:@"<="]];
    [_globalEnvironment addBinding:[[S4MSchemeBuiltinEqualValue alloc] init] forKey:[S4MSymbolTable getSymbolForName:@"="]];
    [_globalEnvironment addBinding:[[S4MSchemeBuiltinNot alloc] init] forKey:[S4MSymbolTable getSymbolForName:@"not"]];
    [_globalEnvironment addBinding:[[S4MSchemeBuiltinAnd alloc] init] forKey:[S4MSymbolTable getSymbolForName:@"and"]];
    [_globalEnvironment addBinding:[[S4MSchemeBuiltinOr alloc] init] forKey:[S4MSymbolTable getSymbolForName:@"or"]];
}

-(void)resetEnvironment
{
    _globalEnvironment = [[S4MSchemeEnvironment alloc] init];
    [self initializeGlobalEnvironment];
}

@end
