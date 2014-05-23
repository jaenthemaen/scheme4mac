//
//  S4MSchemeNil.m
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeNil.h"

@implementation S4MSchemeNil

+(S4MSchemeNil *)sharedInstance
{
    static S4MSchemeNil *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[S4MSchemeNil alloc] init];
    });
    return _sharedInstance;
}

-(Boolean)isSchemeNil { return YES; }

@end
