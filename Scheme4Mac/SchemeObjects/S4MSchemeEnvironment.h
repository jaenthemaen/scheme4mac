//
//  S4MSchemeEnvironment.h
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeObject.h"
#import "S4MSchemeSymbol.h"

@interface S4MSchemeEnvironment : S4MSchemeObject

@property(strong, nonatomic)S4MSchemeEnvironment* parent;

// designated initializer
-(S4MSchemeEnvironment*)initWithParent:(S4MSchemeEnvironment*)parent;

// handling of bindings
-(S4MSchemeObject*)getBindingForKey:(S4MSchemeSymbol*)key;
-(BOOL)hasBindingForKey:(S4MSchemeSymbol*)key;
-(void)addBinding:(S4MSchemeObject*)value forKey:(S4MSchemeSymbol*)key;
-(void)forceAddBinding:(S4MSchemeObject*)value forKey:(S4MSchemeSymbol*)key;
-(void)setBinding:(S4MSchemeObject*)value forKey:(S4MSchemeSymbol*)key;

@end
