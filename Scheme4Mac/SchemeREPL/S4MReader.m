//
//  S4MReader.m
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MReader.h"

@implementation S4MReader










+(S4MReader *)sharedInstance
{
    static S4MReader *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[S4MReader alloc] init];
    });
    return _sharedInstance;
}

@end
