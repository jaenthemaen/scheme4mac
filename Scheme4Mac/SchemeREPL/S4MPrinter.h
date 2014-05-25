//
//  S4MPrinter.h
//  Scheme4Mac
//
//  Created by Jan Müller on 23.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../SchemeObjects/S4MSchemeObject.h"
#import "S4MStringStreamUsingNSString.h"

@interface S4MPrinter : NSObject

-(void)printSchemeObject:(S4MSchemeObject*)object onStream:(S4MStringStreamUsingNSString*)stream;

+ (S4MPrinter*) sharedInstance;

@end
