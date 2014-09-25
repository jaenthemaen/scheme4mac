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

@implementation S4MEval


-(void)topLevelEvalWithAst:(S4MSchemeObject *)ast andOutputStream:(S4MStringStreamUsingNSString*)outputStream
{
    _outputStream = outputStream;
    if (!_globalEnvironment) {
        _globalEnvironment = [[S4MSchemeEnvironment alloc] initWithParent:nil];
        // later load standard library here!
        // [self loadStandardLibrary];
    }
    
    // set up a weak reference to self for the blocks
    __weak S4MEval *weakSelf = self;
    
    
    // set up printing continuation!
    S4MSchemeContinuation* printCont = [[S4MSchemeContinuation alloc] initWithParent:nil
                                                                                 ast:nil
                                                                                func:^id(S4MSchemeContinuation *blockCont){
                                                                                    [weakSelf printResultObjectFromContinuation:blockCont];
                                                                                    return nil;
                                                                                }
                                                                                args:[[NSMutableArray alloc] init]
                                                                             nextArg:0
                                                                                 env:nil];
    // set up root eval cont!
    S4MSchemeContinuation* currCont = [[S4MSchemeContinuation alloc] initWithParent:printCont
                                                                                ast:ast
                                                                               func:^(S4MSchemeContinuation *blockCont){
                                                                                   return [weakSelf evalSchemeObjectWithCont:blockCont];
                                                                               }
                                                                               args:nil
                                                                            nextArg:0
                                                                                env:self.globalEnvironment];
    
    while (currCont) {
        currCont = currCont.func(currCont);
    }
}

-(S4MSchemeContinuation *)evalSchemeObjectWithCont:(S4MSchemeContinuation *)cont
{
    __weak S4MEval *weakSelf = self;
    
    // is it a list?
    if ([cont.ast isSchemeCons]) {
        return [[S4MSchemeContinuation alloc] initWithParent:cont.parentCont
                                                         ast:cont.ast
                                                        func:^id(S4MSchemeContinuation *blockCont){
                                                            return [weakSelf evalSchemeObjectWithCont:blockCont];
                                                        }
                                                        args:[NSMutableArray arrayWithCapacity:[(S4MSchemeCons*)cont.ast argumentsListLength]]
                                                     nextArg:0
                                                         env:cont.env];
    } else if ([cont.ast isSchemeInteger]) {
        // check nextArg!
        if (cont.nextArg) {
            <#statements#>
        }
    } else if ([cont.ast isSchemeFloat]) {
        return nil;
    } else if ([cont.ast isSchemeString]) {
        return nil;
    } else if ([cont.ast isSchemeContinuation]) {
        return nil;
    } else if ([cont.ast isSchemeSymbol]) {
        return nil;
    } else if ([cont.ast isSchemeTrue]) {
        return nil;
    } else if ([cont.ast isSchemeFalse]) {
        return nil;
    } else {
        return nil;
    }
}

-(S4MSchemeContinuation *)evalFunctionWithCont:(S4MSchemeContinuation *)cont
{
    S4MSchemeObject* car = ((S4MSchemeCons*)cont.ast).car;
    if ([car isSchemeSymbol]) {
        // eval function
        S4MSchemeObject* binding = [cont.env getBindingForKey:(S4MSchemeSymbol*)car];
        
        
        return [[S4MSchemeContinuation alloc] init];
    } else {
        return nil;
    }
}



-(void)printResultObjectFromContinuation:(S4MSchemeContinuation*)cont
{
    [_printer printSchemeObject:cont.retVal onStream:self.outputStream];
}

+(S4MEval *)sharedInstance
{
    static S4MEval *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[S4MEval alloc] init];
    });
    return _sharedInstance;
}


-(S4MStringStreamUsingNSString *)outputStream
{
    if (!_outputStream) {
        _outputStream = [[S4MStringStreamUsingNSString alloc] init];
    }
    return _outputStream;
}

@end
