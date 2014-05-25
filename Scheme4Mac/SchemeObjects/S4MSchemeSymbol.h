//
//  S4MSchemeSymbol.h
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeObject.h"

@interface S4MSchemeSymbol : S4MSchemeObject

// designated initializer
-(id) initWithName:(NSString*)name;

@property(strong, nonatomic) NSString* name;

@end
