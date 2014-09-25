//
//  S4MSchemeCons.m
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeCons.h"
#import "S4MSchemeNil.h"

@implementation S4MSchemeCons

@synthesize car = _car;
@synthesize cdr = _cdr;

-(id)init
{
    return [self initWithCar:[S4MSchemeNil sharedInstance] andCdr:[S4MSchemeNil sharedInstance]];
}

-(id)initWithCar:(S4MSchemeObject *)car andCdr:(S4MSchemeObject *)cdr
{
    if (self = [super init]) {
        self.car = car;
        self.cdr = cdr;
    }
    return self;
}

-(int)listLength
{
    int length = 1;
    S4MSchemeCons* currCons = self;
    while ([currCons.cdr isSchemeCons]) {
        length++;
        currCons = (S4MSchemeCons*)currCons.cdr;
    }
    return length;
}

-(int)argumentsListLength
{
    return [self listLength] -1;
}

-(Boolean)isSchemeCons { return YES; }

-(NSString *)description
{
    // missing implementation for nil...
    // will be implemented the std way anyhow
    // optimization using description later!
    
    if (![self.cdr isSchemeCons]) {
        return [NSString stringWithFormat:@"(%@ . %@)", self.car, self.cdr];
    } else {
        return [NSString stringWithFormat:@"(%@ %@", self.car, self.cdr];
    }
}

@end
