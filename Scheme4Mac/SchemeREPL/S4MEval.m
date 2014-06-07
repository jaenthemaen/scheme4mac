//
//  S4MEval.m
//  Scheme4Mac
//
//  Created by Jan Müller on 23.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MEval.h"

@implementation S4MEval

+(S4MEval *)sharedInstance
{
    static S4MEval *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[S4MEval alloc] init];
    });
    return _sharedInstance;
}

@end
