//
//  S4MReader.h
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../SchemeObjects/S4MSchemeObject.h"
#import "S4MStringStreamUsingNSString.h"

@interface S4MReader : NSObject

+ (S4MReader*) sharedInstance;

-(S4MSchemeObject*) readSchemeObjectFromStream:(S4MStringStreamUsingNSString*) stream;
-(BOOL) preprocessStreamContentOfStream:(S4MStringStreamUsingNSString*) stream;

@end
