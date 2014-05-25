//
//  S4MSchemeVoid.m
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeVoid.h"

@implementation S4MSchemeVoid

+(S4MSchemeVoid *)sharedInstance
{
    static S4MSchemeVoid *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[S4MSchemeVoid alloc] init];
    });
    return _sharedInstance;
}

-(Boolean)isSchemeVoid { return YES; }

-(NSString *)description
{
    return @"SCHEME_VOID";
}

@end
