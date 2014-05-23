//
//  S4MSchemeTrue.m
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeTrue.h"

@implementation S4MSchemeTrue

+(S4MSchemeTrue *)sharedInstance
{
    static S4MSchemeTrue *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[S4MSchemeTrue alloc] init];
    });
    return _sharedInstance;
}

-(Boolean)isSchemeTrue { return YES; }

-(NSString *)description
{
    return @"#t";
}

@end
