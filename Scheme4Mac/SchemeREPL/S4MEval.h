//
//  S4MEval.h
//  Scheme4Mac
//
//  Created by Jan Müller on 23.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../SchemeObjects/S4MSchemeObject.h"
#import "../SchemeObjects/S4MSchemeEnvironment.h"
#import "S4MPrinter.h"
#import "S4MAppDelegate.h"

@interface S4MEval : NSObject

@property(strong, nonatomic) S4MSchemeEnvironment* globalEnvironment;
@property(strong, nonatomic) S4MAppDelegate* delegate;

+ (S4MEval*) sharedInstance;
-(S4MSchemeObject*)evalObject:(S4MSchemeObject*)obj inEnvironment:(S4MSchemeEnvironment*)env;
-(void)resetEnvironment;

@end
