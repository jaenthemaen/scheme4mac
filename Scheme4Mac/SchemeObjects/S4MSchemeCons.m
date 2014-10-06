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

-(Boolean)nextConsExists
{
    return [self.cdr isSchemeCons];
}

-(S4MSchemeObject*)getListItemAtIndex:(int)index;
{
    if (index >= [self listLength] || index < 0) {
        [NSException raise:NSInvalidArgumentException format:@"list index out of bounds! Given was: %d, list length is: %d", index, [self listLength]];
        return nil;
    }
    if (index == 0) {
        return _car;
    }
    int iterationCounter = 0;
    S4MSchemeCons* currCons = self;
    while (iterationCounter < index) {
        currCons = (S4MSchemeCons*)currCons.cdr;
        iterationCounter++;
    }
    return currCons.car;
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
