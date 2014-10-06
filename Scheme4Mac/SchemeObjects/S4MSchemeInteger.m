//
//  S4MSchemeInteger.m
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeInteger.h"
#import "S4MSchemeNumberFormatter.h"

@implementation S4MSchemeInteger

@synthesize value = _value;

-(id)init
{
    return [self initWithValue:0];
}

-(id)initWithValue:(int)value
{
    if (self = [super init]) {
        self.value = [NSNumber numberWithInt:value];
    }
    return self;
}

-(Boolean)isSchemeInteger { return YES; }

-(NSString *)description
{
    return [S4MSchemeNumberFormatter localizedStringFromNumber:self.value numberStyle:NSNumberFormatterDecimalStyle];
}

@end
