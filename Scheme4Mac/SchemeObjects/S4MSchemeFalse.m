//
//  S4MSchemeFalse.m
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeFalse.h"

@implementation S4MSchemeFalse

+(S4MSchemeFalse *)sharedInstance
{
    static S4MSchemeFalse *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[S4MSchemeFalse alloc] init];
    });
    return _sharedInstance;
}

- (Boolean)isSchemeFalse { return YES; }

-(NSString *)description
{
    return @"#f";
}

@end
