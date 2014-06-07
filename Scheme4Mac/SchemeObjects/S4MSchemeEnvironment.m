//
//  S4MSchemeEnvironment.m
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeEnvironment.h"

@interface S4MSchemeEnvironment()

@property(strong, nonatomic)NSMutableDictionary* bindings;

@end

@implementation S4MSchemeEnvironment

@synthesize bindings = _bindings;
@synthesize parent = _parent;

-(id)init
{
    return [self initWithParent:nil];
}

-(S4MSchemeEnvironment *)initWithParent:(S4MSchemeEnvironment *)parent
{
    if (self = [super init]) {
        self.bindings = [[NSMutableDictionary alloc] initWithCapacity:50];
        self.parent = parent;
    }
    return self;
}

-(S4MSchemeObject *)getBindingForKey:(S4MSchemeSymbol *)key
{
    // First: search in own Dictionary:
    S4MSchemeObject* value = [self.bindings objectForKey:key];
    
    if (!value) {
        // key not found! now continue search in parent environment.
        if (self.parent) {
            return [self.parent getBindingForKey:key];
        } else {
            // if there's no parent environment we're in the global environment
            // and no binding exists for the given symbol.
            @throw [NSException exceptionWithName:@"UndefinedSymbolException"
                                    reason:@"No value bound to the given symbol was found"
                                  userInfo:nil];
        }
    } else {
        return value;
    }
    
}

-(void)addBinding:(S4MSchemeObject *)value forKey:(S4MSchemeSymbol *)key
{
    // check if passed value is nil:
    if (!value) {
        [NSException raise:NSInvalidArgumentException format:@"Argument was nil!"];
    }
    
    if ([self.bindings objectForKey:key]) {
        // pre-existing binding for key found. error!
        @throw [NSException exceptionWithName:@"SymbolAlreadyBoundException"
                                       reason:@"binding for given key exists already."
                                     userInfo:nil];
    } else {
        // no pre-existing binding found. good to go!
        [self.bindings setObject:value forKey:key];
    }
}

-(void)setBinding:(S4MSchemeObject *)value forKey:(S4MSchemeSymbol *)key
{
    // Check if value is not nil:
    if (!value) {
        [NSException raise:NSInvalidArgumentException format:@"Argument was nil!"];
    }
    
    // Check if binding for key exists, otherwise not allowed!
    S4MSchemeObject* oldVal = [self.bindings objectForKey:key];
    if (!oldVal) {
        @throw [NSException exceptionWithName:@"UndefinedSymbolException"
                                       reason:@"No value bound to the given symbol was found"
                                     userInfo:nil];
    }
    
    // Update the value:
    [self.bindings setObject:value forKey:key];
}

-(Boolean)isSchemeEnvironment { return YES; }

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@", self.bindings];
}

@end
