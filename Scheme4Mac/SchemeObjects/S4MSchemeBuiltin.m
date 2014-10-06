//
//  S4MSchemeBuiltin.m
//  Scheme4Mac
//
//  Created by Jan Müller on 27.09.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeBuiltin.h"
#import "S4MSchemeNumber.h"
#import "S4MSchemeFloat.h"
#import "S4MSchemeInteger.h"
#import "S4MSchemeTrue.h"
#import "S4MSchemeFalse.h"

@implementation S4MSchemeBuiltin

-(S4MSchemeObject *)processWithArgs:(NSArray *)args
{
    [NSException raise:@"SchemeBuiltin Superclass Processing" format:@"SchemeBuiltin cannot process anything. Call on subclasses!"];
    return nil;
}

-(id)init
{
    if (self = [super init]) {
        self.minArgs = -1;
        self.maxArgs = positiveInfinity;
    }
    return self;
}

-(Boolean)isSchemeBuiltin { return YES; }

@end


@implementation S4MSchemeBuiltinPlus

-(id)init
{
    if (self = [super init]) {
        self.minArgs = 0;
    }
    return self;
}

-(S4MSchemeObject *)processWithArgs:(NSArray *)args
{
    float resultFloat = 0;
    BOOL floatInArray = NO;
    for (S4MSchemeObject* op in args) {
        if ([op isSchemeNumber]) {
            if ([op isSchemeFloat]) {
                floatInArray = YES;
            }
            resultFloat += [op.value floatValue];
        } else {
            [NSException raise:@"NaN Exception" format:@"Operand handed to computation was not a number: %@", op];
        }
    }
    if (floatInArray) {
        return [[S4MSchemeFloat alloc] initWithValue:resultFloat];
    } else {
        return [[S4MSchemeInteger alloc] initWithValue:(int)resultFloat];
    }
}

@end

@implementation S4MSchemeBuiltinMinus

-(id)init
{
    if (self = [super init]) {
        // TODO Args counts überprüfen!
        self.minArgs = 1;
    }
    return self;
}

-(S4MSchemeObject *)processWithArgs:(NSArray *)args
{
    float resultFloat = 0;
    BOOL floatInArray = NO;
    
    for (int i = 0; i < args.count; i++) {
        S4MSchemeObject* op = [args objectAtIndex:i];
        if ([op isSchemeNumber]) {
            if ([op isSchemeFloat]) {
                floatInArray = YES;
            }
            if (i > 0) {
                resultFloat -= [((S4MSchemeNumber*)op).value floatValue];
            } else {
                if (args.count == 1) {
                    resultFloat = -1.0 * [((S4MSchemeNumber*)op).value floatValue];
                } else {
                    resultFloat = [((S4MSchemeNumber*)op).value floatValue];
                }
            }
        } else {
            [NSException raise:@"NaN Exception" format:@"Operand handed to computation was not a number: %@", op];
        }
    }
    if (floatInArray) {
        return [[S4MSchemeFloat alloc] initWithValue:resultFloat];
    } else {
        return [[S4MSchemeInteger alloc] initWithValue:(int)resultFloat];
    }
}

@end

@implementation S4MSchemeBuiltinDivision

-(id)init
{
    if (self = [super init]) {
        // TODO Args counts überprüfen!
        self.minArgs = 1;
    }
    return self;
}

-(S4MSchemeObject *)processWithArgs:(NSArray *)args
{
    float resultFloat = 0;
    
    for (int i = 0; i < args.count; i++) {
        S4MSchemeObject* op = [args objectAtIndex:i];
        if ([op isSchemeNumber]) {
            float opValue = [((S4MSchemeNumber*)op).value floatValue];
            if (i > 0) {
                if (opValue == 0.0) {
                    [NSException raise:@"Division By Zero Exception" format:@"Cannot divide by zero!"];
                    return nil;
                }
                resultFloat = resultFloat / opValue;
            } else {
                // if args length > 1 save as denominator, if == 1 return 1 / op value
                if (args.count == 1) {
                    resultFloat = 1.0 / opValue;
                } else {
                    resultFloat = opValue;
                }
            }
        } else {
            [NSException raise:@"NaN Exception" format:@"Operand handed to computation was not a number: %@", op];
        }
    }
    
    return [[S4MSchemeFloat alloc] initWithValue:resultFloat];
}

@end

@implementation S4MSchemeBuiltinMultiplication

-(id)init
{
    if (self = [super init]) {
        self.minArgs = 1;
    }
    return self;
}

-(S4MSchemeObject *)processWithArgs:(NSArray *)args
{
    float resultFloat = 1;
    BOOL floatInArray = NO;
    for (S4MSchemeObject* op in args) {
        if ([op isSchemeNumber]) {
            if ([op isSchemeFloat]) {
                floatInArray = YES;
            }
            resultFloat *= [op.value floatValue];
        } else {
            [NSException raise:@"NaN Exception" format:@"Operand handed to computation was not a number: %@", op];
        }
    }
    if (floatInArray) {
        return [[S4MSchemeFloat alloc] initWithValue:resultFloat];
    } else {
        return [[S4MSchemeInteger alloc] initWithValue:(int)resultFloat];
    }
}

@end

@implementation S4MSchemeBuiltinModulo

-(id)init
{
    if (self = [super init]) {
        self.minArgs = 2;
        self.maxArgs = 2;
    }
    return self;
}

-(S4MSchemeObject *)processWithArgs:(NSArray *)args
{
    for (S4MSchemeObject* op in args) {
        if (![op isSchemeNumber]) {
            [NSException raise:@"NaN Exception" format:@"Operand handed to computation was not a number: %@", op];
            return nil;
        } else if (![op isSchemeInteger]) {
            [NSException raise:@"Illegal Argument Type Exception" format:@"Modulo only works with integers."];
            return nil;
        }
    }
    S4MSchemeInteger* op1 = [args objectAtIndex:0];
    S4MSchemeInteger* op2 = [args objectAtIndex:1];
    
    // check if second argument is not 0:
    if ([op2.value intValue] == 0) {
        [NSException raise:@"Illegal Argument Type Exception" format:@"Modulo by zero not defined"];
        return nil;
    }
    return [[S4MSchemeInteger alloc] initWithValue: [op1.value intValue]%[op2.value intValue]];
}

@end

@implementation S4MSchemeBuiltinGreaterThan

-(id)init
{
    if (self = [super init]) {
        self.minArgs = 2;
    }
    return self;
}

-(S4MSchemeObject *)processWithArgs:(NSArray *)args
{
    for (S4MSchemeObject* op in args) {
        if (![op isSchemeNumber]) {
            [NSException raise:@"NaN Exception" format:@"Operand handed to comparison was not a number: %@", op];
            return nil;
        }
    }
    
    for (int i = 0; i < args.count - 1; i++) {
        S4MSchemeNumber* op1 = [args objectAtIndex:i];
        S4MSchemeNumber* op2 = [args objectAtIndex:i+1];
        if (![op1.value isGreaterThan:op2.value]) {
            return [S4MSchemeFalse sharedInstance];
        }
    }
    
    return [S4MSchemeTrue sharedInstance];
}

@end

@implementation S4MSchemeBuiltinGreaterEqualThan

-(id)init
{
    if (self = [super init]) {
        self.minArgs = 2;
    }
    return self;
}

-(S4MSchemeObject *)processWithArgs:(NSArray *)args
{
    for (S4MSchemeObject* op in args) {
        if (![op isSchemeNumber]) {
            [NSException raise:@"NaN Exception" format:@"Operand handed to comparison was not a number: %@", op];
            return nil;
        }
    }
    
    for (int i = 0; i < args.count - 1; i++) {
        S4MSchemeNumber* op1 = [args objectAtIndex:i];
        S4MSchemeNumber* op2 = [args objectAtIndex:i+1];
        if (![op1.value isGreaterThanOrEqualTo:op2.value]) {
            return [S4MSchemeFalse sharedInstance];
        }
    }
    
    return [S4MSchemeTrue sharedInstance];
}

@end

@implementation S4MSchemeBuiltinLessThan

-(id)init
{
    if (self = [super init]) {
        self.minArgs = 2;
    }
    return self;
}

-(S4MSchemeObject *)processWithArgs:(NSArray *)args
{
    for (S4MSchemeObject* op in args) {
        if (![op isSchemeNumber]) {
            [NSException raise:@"NaN Exception" format:@"Operand handed to comparison was not a number: %@", op];
            return nil;
        }
    }
    
    for (int i = 0; i < args.count - 1; i++) {
        S4MSchemeNumber* op1 = [args objectAtIndex:i];
        S4MSchemeNumber* op2 = [args objectAtIndex:i+1];
        if (![op1.value isLessThan:op2.value]) {
            return [S4MSchemeFalse sharedInstance];
        }
    }
    
    return [S4MSchemeTrue sharedInstance];
}

@end

@implementation S4MSchemeBuiltinLessEqualThan

-(id)init
{
    if (self = [super init]) {
        self.minArgs = 2;
    }
    return self;
}

-(S4MSchemeObject *)processWithArgs:(NSArray *)args
{
    for (S4MSchemeObject* op in args) {
        if (![op isSchemeNumber]) {
            [NSException raise:@"NaN Exception" format:@"Operand handed to comparison was not a number: %@", op];
            return nil;
        }
    }
    
    for (int i = 0; i < args.count - 1; i++) {
        S4MSchemeNumber* op1 = [args objectAtIndex:i];
        S4MSchemeNumber* op2 = [args objectAtIndex:i+1];
        if (![op1.value isLessThanOrEqualTo:op2.value]) {
            return [S4MSchemeFalse sharedInstance];
        }
    }
    
    return [S4MSchemeTrue sharedInstance];
}

@end

@implementation S4MSchemeBuiltinEqualValue

-(id)init
{
    if (self = [super init]) {
        self.minArgs = 2;
    }
    return self;
}

-(S4MSchemeObject *)processWithArgs:(NSArray *)args
{
    for (S4MSchemeObject* op in args) {
        if (![op isSchemeNumber]) {
            [NSException raise:@"NaN Exception" format:@"Operand handed to comparison was not a number: %@", op];
            return nil;
        }
    }
    
    for (int i = 0; i < args.count - 1; i++) {
        S4MSchemeNumber* op1 = [args objectAtIndex:i];
        S4MSchemeNumber* op2 = [args objectAtIndex:i+1];
        if (![op1.value isEqualToNumber:op2.value]) {
            return [S4MSchemeFalse sharedInstance];
        }
    }
    
    return [S4MSchemeTrue sharedInstance];
}

@end

@implementation S4MSchemeBuiltinNot

-(id)init
{
    if (self = [super init]) {
        self.minArgs = 1;
        self.maxArgs = 1;
    }
    return self;
}

-(S4MSchemeObject *)processWithArgs:(NSArray *)args
{
    // only returns true if argument is the scheme false
    if ([[args objectAtIndex:0] isSchemeFalse]) {
        return [S4MSchemeTrue sharedInstance];
    } else {
        return [S4MSchemeFalse sharedInstance];
    }
}

@end

@implementation S4MSchemeBuiltinAnd

-(id)init
{
    if (self = [super init]) {
        self.minArgs = 0;
    }
    return self;
}

-(S4MSchemeObject *)processWithArgs:(NSArray *)args
{
    // returns false if a false value exists, otherwise the last value or true
    for (S4MSchemeObject* op in args) {
        if ([op isSchemeFalse]) {
            return op;
        }
    }
    
    if (args.count > 0) {
        return [args objectAtIndex:args.count-1];
    } else {
        return [S4MSchemeTrue sharedInstance];
    }
}

@end

@implementation S4MSchemeBuiltinOr

-(id)init
{
    if (self = [super init]) {
        self.minArgs = 0;
    }
    return self;
}

-(S4MSchemeObject *)processWithArgs:(NSArray *)args
{
    // returns true if a true value exists, otherwise the last value or false
    for (S4MSchemeObject* op in args) {
        if (![op isSchemeFalse]) {
            return op;
        }
    }
    
    if (args.count > 0) {
        return [args objectAtIndex:args.count-1];
    } else {
        return [S4MSchemeFalse sharedInstance];
    }
}

@end
