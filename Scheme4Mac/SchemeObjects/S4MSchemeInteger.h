//
//  S4MSchemeInteger.h
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeNumber.h"

@interface S4MSchemeInteger : S4MSchemeNumber

//designated initializer
-(id)initWithValue:(int)value;

@property int value;

@end
