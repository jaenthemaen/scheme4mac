//
//  S4MSchemeCons.m
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeCons.h"

@implementation S4MSchemeCons

@synthesize car = _car;
@synthesize cdr = _cdr;

-(Boolean)isSchemeCons { return YES; }

-(NSString *)description
{
    // missing implementation for nil...
    // will be implemented the std way anyhow
    // optimization using description later!
    
    if (![self.car isSchemeCons]) {
        return [NSString stringWithFormat:@"(%@ . %@)", self.car, self.cdr];
    } else {
        return [NSString stringWithFormat:@"(%@ %@)", self.car, self.cdr];
    }
}

@end
