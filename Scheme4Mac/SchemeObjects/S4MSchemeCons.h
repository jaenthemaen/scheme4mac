//
//  S4MSchemeCons.h
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeObject.h"

@interface S4MSchemeCons : S4MSchemeObject

// designated initializer
-(id)initWithCar:(S4MSchemeObject*)car andCdr:(S4MSchemeObject*)cdr;

@property(strong, nonatomic) S4MSchemeObject* car;
@property(strong, nonatomic) S4MSchemeObject* cdr;

@end
