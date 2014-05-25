//
//  S4MSchemeSymbol.m
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeSymbol.h"

@implementation S4MSchemeSymbol

@synthesize name = _name;

-(id)init
{
    return [self initWithName:@"UNINITIALIZED_SYMBOL"];
}

-(id)initWithName:(NSString *)name
{
    if (self = [super init]) {
        self.name = name;
    }
    return self;
}

-(Boolean)isSchemeSymbol { return YES; }

-(NSString *)description
{
    return self.name;
}

@end
