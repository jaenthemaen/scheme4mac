//
//  S4MSchemeObject.h
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface S4MSchemeObject : NSObject

-(Boolean)isSchemeObject;
-(Boolean)isSchemeBoolean;
-(Boolean)isSchemeFalse;
-(Boolean)isSchemeTrue;
-(Boolean)isSchemeCons;
-(Boolean)isSchemeNumber;
-(Boolean)isSchemeFloat;
-(Boolean)isSchemeInteger;
-(Boolean)isSchemeNil;
-(Boolean)isSchemeString;
-(Boolean)isSchemeSymbol;
-(Boolean)isSchemeVoid;
-(Boolean)isSchemeEnvironment;
-(Boolean)isSchemeContinuation;

@end
