//
//  S4MSchemeContinuation.m
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeContinuation.h"

@implementation S4MSchemeContinuation

@synthesize ast = _ast;
@synthesize func = _func;
@synthesize retVal = _retVal;
@synthesize args = _args;
@synthesize nextArg = _nextArg;
@synthesize parentCont = _parentCont;
@synthesize env = _env;

-(id)initWithParent:(S4MSchemeContinuation *)parentCont
                ast:(S4MSchemeObject *)ast
               func:(continuation_function_call_t)func
               args:(NSMutableArray *)args
            nextArg:(int)nextArg
                env:(S4MSchemeEnvironment *)env
{
    if ([self init]) {
        _parentCont = parentCont;
        _ast = ast;
        _func = func;
        _args = args;
        _nextArg = nextArg;
        _env = env;
    }
    return self;
}

-(Boolean)isSchemeContinuation { return YES; }

@end
