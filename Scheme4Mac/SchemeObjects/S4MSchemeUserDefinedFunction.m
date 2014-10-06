//
//  S4MSchemeUserDefinedFunction.m
//  Scheme4Mac
//
//  Created by Jan Müller on 30.09.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeUserDefinedFunction.h"

@implementation S4MSchemeUserDefinedFunction

-(id)initWithArgs:(NSArray*)args AndBodyList:(S4MSchemeObject*)bodyList AndEnv:(S4MSchemeEnvironment*)env
{
    if (self = [super init]) {
        _args = args;
        _bodyList = bodyList;
        _env = env;
    }
    return self;
}

-(int)argsCount
{
    return (int)_args.count;
}

-(NSString *)description
{
    if (_name) {
        return [NSString stringWithFormat:@"<procedure:%@>", _name];
    } else {
        return @"<procedure>";
    }
}

-(Boolean)isSchemeUserDefinedFunction{ return YES; };

@end
