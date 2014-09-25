//
//  S4MEval.h
//  Scheme4Mac
//
//  Created by Jan Müller on 23.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../SchemeObjects/S4MSchemeObject.h"
#import "../SchemeObjects/S4MSchemeContinuation.h"
#import "S4MPrinter.h"

@interface S4MEval : NSObject

@property(strong, nonatomic) S4MSchemeEnvironment* globalEnvironment;
@property(strong, nonatomic) S4MPrinter* printer;
@property(strong, nonatomic) S4MStringStreamUsingNSString* outputStream;

+ (S4MEval*) sharedInstance;

-(void)topLevelEvalWithAst:(S4MSchemeObject*)ast andOutputStream:(S4MStringStreamUsingNSString*)outputStream;
-(S4MSchemeContinuation*)evalSchemeObjectWithCont:(S4MSchemeContinuation*)cont;
-(S4MSchemeContinuation*)evalFunctionWithCont:(S4MSchemeContinuation*)cont;

@end
