//
//  S4MStringStreamUsingNSString.m
//  Scheme4Mac
//
//  Created by Jan Müller on 23.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MStringStreamUsingNSString.h"

@interface S4MStringStreamUsingNSString()

@property(strong, nonatomic) NSMutableString* streamContent;

@end



@implementation S4MStringStreamUsingNSString

@synthesize streamContent = _streamContent;


-(id)init
{
    return [self initWithString:@""];
}

-(id)initWithString:(NSString *)string
{
    if (self = [super init]) {
        self.streamContent = [[NSMutableString alloc] initWithString:string];
    }
    return self;
}

-(void)setStream:(NSString *)string
{
    self.streamContent = [[NSMutableString alloc] initWithString:string];
}

-(NSString *)getStream
{
    return [NSString stringWithString:_streamContent];
}

-(void)writeOnStream:(NSString *)string
{
    [self.streamContent appendString:string];
}

-(NSString *)readChar
{
    if (self.streamContent.length >= 1) {
        NSString* theChar = [NSString stringWithFormat: @"%C", [self.streamContent characterAtIndex:0]];
        [self.streamContent deleteCharactersInRange:NSMakeRange(0, 1)];
        return theChar;
    } else {
        return nil;
    }
}

-(NSString *)lookAheadChar
{
    if (self.streamContent.length >= 2) {
        return [NSString stringWithFormat: @"%C", [self.streamContent characterAtIndex:1]];
    } else {
        return nil;
    }
}

-(NSString *)lookAheadTwiceChar
{
    if (self.streamContent.length >= 3) {
        return [NSString stringWithFormat: @"%C", [self.streamContent characterAtIndex:2]];
    } else {
        return nil;
    }
}


@end
