//
//  S4MPrinter.m
//  Scheme4Mac
//
//  Created by Jan Müller on 23.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MPrinter.h"

@implementation S4MPrinter


















+(S4MPrinter *)sharedInstance
{
    static S4MPrinter *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[S4MPrinter alloc] init];
    });
    return _sharedInstance;
}

@end
