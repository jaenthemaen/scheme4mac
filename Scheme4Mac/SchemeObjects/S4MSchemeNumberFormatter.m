//
//  S4MSchemeNumberFormatter.m
//  Scheme4Mac
//
//  Created by Jan Müller on 30.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeNumberFormatter.h"

@implementation S4MSchemeNumberFormatter

-(id)init
{
    if (self = [super init]) {
        // now define the custom properties for the scheme number formatter!
        [self setHasThousandSeparators:NO];
        // TODO max min, point instead of comma
        [self setLocale: [NSLocale localeWithLocaleIdentifier:@"en_US"]];
    }
    return self;
}

+(S4MSchemeNumberFormatter *)sharedInstance
{
    static S4MSchemeNumberFormatter *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[S4MSchemeNumberFormatter alloc] init];
    });
    return _sharedInstance;
}

@end
