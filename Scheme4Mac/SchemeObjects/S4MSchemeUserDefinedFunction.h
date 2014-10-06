//
//  S4MSchemeUserDefinedFunction.h
//  Scheme4Mac
//
//  Created by Jan Müller on 30.09.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeObject.h"
#import "S4MSchemeEnvironment.h"
#import "S4MSchemeCons.h"

@interface S4MSchemeUserDefinedFunction : S4MSchemeObject

-(id)initWithArgs:(NSArray*)args AndBodyList:(S4MSchemeObject*)bodyList AndEnv:(S4MSchemeEnvironment*)env;

@property(strong, nonatomic)NSArray* args;
@property(nonatomic)int argsCount;
@property(strong, nonatomic)S4MSchemeObject* bodyList;
@property(strong, nonatomic)S4MSchemeEnvironment* env;
@property(strong, nonatomic)NSString* name;

@end
