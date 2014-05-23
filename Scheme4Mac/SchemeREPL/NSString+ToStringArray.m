//
//  NSString+ToStringArray.m
//  Scheme4Mac
//
//  Created by Jan Müller on 23.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "NSString+ToStringArray.h"

@implementation NSString (ToStringArray)

-(NSMutableArray *)toStringArray
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSUInteger i = 0;
    while (i < self.length) {
        NSRange range = [self rangeOfComposedCharacterSequenceAtIndex:i];
        NSString *chStr = [self substringWithRange:range];
        [arr addObject:chStr];
        i += range.length;
    }
    
    return arr;
}

@end
