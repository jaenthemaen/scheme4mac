//
//  S4MSchemeContinuation.h
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeObject.h"
#import "S4MSchemeEnvironment.h"

typedef id (^continuation_function_call_t)(id cont);

@interface S4MSchemeContinuation : S4MSchemeObject

@property(strong)S4MSchemeObject* ast;
@property(strong) continuation_function_call_t func;
@property(strong)S4MSchemeObject* retVal;
@property(strong)NSMutableArray* args;
@property int nextArg;
@property(strong)S4MSchemeContinuation* parentCont;
@property(strong)S4MSchemeEnvironment* env;

// designated initializer
-(id)initWithParent:(S4MSchemeContinuation*)parentCont
                ast:(S4MSchemeObject*)ast
               func:(continuation_function_call_t)func
               args:(NSMutableArray*)args
            nextArg:(int)nextArg
                env:(S4MSchemeEnvironment*)env;

@end
