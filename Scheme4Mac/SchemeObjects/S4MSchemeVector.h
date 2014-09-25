//
//  S4MSchemeVector.h
//  Scheme4Mac
//
//  Created by Jan Müller on 25.09.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeObject.h"

@interface S4MSchemeVector : S4MSchemeObject

@property(strong)NSMutableArray* elements;

-(S4MSchemeObject*)getObjectAtIndex:(int)index;
-(void)setObject:(S4MSchemeObject*)object AtIndex:(int)index;
-(void)addObject:(S4MSchemeObject*)object;
-(int)vectorLength;

-(Boolean)isSchemeVector;

@end
