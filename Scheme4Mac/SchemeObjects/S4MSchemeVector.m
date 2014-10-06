//
//  S4MSchemeVector.m
//  Scheme4Mac
//
//  Created by Jan Müller on 25.09.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeVector.h"

@implementation S4MSchemeVector

-(id)init
{
    if (self = [super init]) {
        _elements = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)setObject:(S4MSchemeObject *)object AtIndex:(int)index
{
    if (object && index >= 0 && index < _elements.count) {
        [_elements setObject:object atIndexedSubscript:index];
    } else {
        [NSException raise:@"Index Out Of Bounds Exception" format:@"Index of %d doesn't exist for this vector.", index];
    }
}

-(S4MSchemeObject *)getObjectAtIndex:(int)index
{
    if (index >= 0 && index < _elements.count) {
        return [_elements objectAtIndex:index];
    } else {
        [NSException raise:@"Index Out Of Bounds Exception" format:@"Index of %d doesn't exist for this vector.", index];
        return nil;
    }
}

-(void)addObject:(S4MSchemeObject *)object
{
    [_elements addObject:object];
}

-(int)vectorLength
{
    return (int)_elements.count;
}

- (Boolean)isSchemeVector{ return YES; };

@end
