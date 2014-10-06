//
//  S4MSchemeFloat.m
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeFloat.h"
#import "S4MSchemeNumberFormatter.h"

@implementation S4MSchemeFloat

-(id)init
{
    return [self initWithValue:0.0];
}

-(id)initWithValue:(float) value
{
    if (self = [super init]) {
        self.value = [NSNumber numberWithFloat:value];
    }
    return self;
}

-(Boolean)isSchemeFloat { return YES; }

-(NSString *)description
{
    return [S4MSchemeNumberFormatter localizedStringFromNumber:self.value numberStyle:NSNumberFormatterDecimalStyle];
}

@end
