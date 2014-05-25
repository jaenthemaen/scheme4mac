//
//  S4MSchemeString.m
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeString.h"

@implementation S4MSchemeString

@synthesize content = _content;

-(id)init
{
    return [self initWithContent:@""];
}

-(id)initWithContent:(NSString *)content
{
    if (self = [super init]) {
        self.content = content;
    }
    return self;
}

-(Boolean)isSchemeString { return YES; }

-(NSString *)description
{
    return self.content;
}

@end
