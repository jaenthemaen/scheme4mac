//
//  S4MSchemeObject.m
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeObject.h"

@implementation S4MSchemeObject

-(id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (Boolean)isSchemeObject{ return YES; }
- (Boolean)isSchemeBoolean{ return NO; }
- (Boolean)isSchemeFalse{ return NO; }
- (Boolean)isSchemeTrue{ return NO; }
- (Boolean)isSchemeCons{ return NO; }
- (Boolean)isSchemeNumber{ return NO; }
- (Boolean)isSchemeFloat{ return NO; }
- (Boolean)isSchemeInteger{ return NO; }
- (Boolean)isSchemeNil{ return NO; }
- (Boolean)isSchemeString{ return NO; }
- (Boolean)isSchemeSymbol{ return NO; }
- (Boolean)isSchemeVoid{ return NO; }
- (Boolean)isSchemeEnvironment{ return NO; }
- (Boolean)isSchemeContinuation{ return NO; }
- (Boolean)isSchemeVector{ return NO; };
- (Boolean)isSchemeBuiltin{ return NO; };
- (Boolean)isSchemeUserDefinedFunction{ return NO; };

@end
