//
//  S4MPrinter.m
//  Scheme4Mac
//
//  Created by Jan Müller on 23.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MPrinter.h"
#import "../SchemeObjects/S4MSchemeCons.h"
#import "../SchemeObjects/S4MSchemeEnvironment.h"
#import "../SchemeObjects/S4MSchemeFalse.h"
#import "../SchemeObjects/S4MSchemeTrue.h"
#import "../SchemeObjects/S4MSchemeInteger.h"
#import "../SchemeObjects/S4MSchemeNumber.h"
#import "../SchemeObjects/S4MSchemeFloat.h"
#import "../SchemeObjects/S4MSchemeString.h"
#import "../SchemeObjects/S4MSchemeSymbol.h"
#import "../SchemeObjects/S4MSchemeVoid.h"
#import "../SchemeObjects/S4MSchemeObject.h"
#import "../SchemeObjects/S4MSchemeNil.h"
#import "../SchemeObjects/S4MSchemeVector.h"

@implementation S4MPrinter

-(void)printSchemeObject:(S4MSchemeObject *)object onStream:(S4MStringStreamUsingNSString *)stream
{
    // TODO check if stream is empty!? afterwards?
    if ([object isSchemeCons]) {
        [self printSchemeList:(S4MSchemeCons*)object onStream:stream];
    } else if ([object isSchemeInteger]) {
        [stream writeOnStream:[((S4MSchemeInteger*) object) description] inFront:NO];
    } else if ([object isSchemeFloat]) {
        [stream writeOnStream:[((S4MSchemeFloat*) object) description] inFront:NO];
    } else if ([object isSchemeString]) {
        [stream writeOnStream:[NSString stringWithFormat:@"\"%@\"", ((S4MSchemeString*) object).content] inFront:NO];
    } else if ([object isSchemeSymbol]) {
        [stream writeOnStream:((S4MSchemeSymbol*)object).name inFront:NO];
    } else if ([object isSchemeFalse]) {
        [stream writeOnStream:@"#f" inFront:NO];
    } else if ([object isSchemeTrue]) {
        [stream writeOnStream:@"#t" inFront:NO];
    } else if ([object isSchemeVoid]) {
        // TODO for different contexts.
        return;
    } else if ([object isSchemeNil]) {
        [stream writeOnStream:@"()" inFront:NO];
    } else if ([object isSchemeVector]) {
        [self printSchemeVector:(S4MSchemeVector*)object onStream:stream];
    }   else {
        [NSException raise:@"Kind of Scheme Object not found" format:@"Unknown scheme object: %@", object];
    }
}


-(void)printSchemeVector:(S4MSchemeVector*)vector onStream:(S4MStringStreamUsingNSString *)stream
{
    [stream writeOnStream:@"#(" inFront:NO];
    for (int i = 0; i < vector.vectorLength; i++) {
        [self printSchemeObject:[vector getObjectAtIndex:i] onStream:stream];
        if (i != vector.vectorLength - 1) {
            [stream writeOnStream:@" " inFront:NO];
        }
    }
    [stream writeOnStream:@")" inFront:NO];
}

-(void)printSchemeList:(S4MSchemeCons*)list onStream:(S4MStringStreamUsingNSString *)stream
{
    [stream writeOnStream:@"(" inFront:NO];
    [self printSchemeRestList:list onStream:stream];
}

-(void)printSchemeRestList:(S4MSchemeCons*)restList onStream:(S4MStringStreamUsingNSString *)stream
{
    [self printSchemeObject:restList.car onStream:stream];
    if ([restList.cdr isSchemeNil]) {
        [stream writeOnStream:@")" inFront:NO];
    } else if (restList.cdr.isSchemeCons) {
        [stream writeOnStream:@" " inFront:NO];
        [self printSchemeRestList:(S4MSchemeCons*)restList.cdr onStream:stream];
    } else {
        // here we have a malformed cons!
        [stream writeOnStream:@" . " inFront:NO];
        [self printSchemeObject:restList.cdr onStream:stream];
        [stream writeOnStream:@")" inFront:NO];
    }
}

+(S4MPrinter *)sharedInstance
{
    static S4MPrinter *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[S4MPrinter alloc] init];
    });
    return _sharedInstance;
}

@end
