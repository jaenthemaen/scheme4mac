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

-(id)init
{
    return [self initWithString:@""];
}

-(id)initWithString:(NSString *)string
{
    if (self = [super init]) {
        self.streamContent = [[NSMutableString alloc] initWithString:string];
        self.preprocessed = NO;
    }
    return self;
}

-(void)setStream:(NSString *)string
{
    self.streamContent = [[NSMutableString alloc] initWithString:string];
    self.preprocessed = NO;
}

-(NSString *)getStream
{
    return [NSString stringWithString:_streamContent];
}

-(void)writeOnStream:(NSString *)string inFront:(BOOL)inFront
{
    if(inFront){
        [self.streamContent insertString:string atIndex:0];
    } else {
        [self.streamContent appendString:string];
        
    }
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

-(NSString *)peekChar
{
    if (self.streamContent.length >= 1) {
        return [NSString stringWithFormat: @"%C", [self.streamContent characterAtIndex:0]];
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

-(void)skipSpaces
{
    self.streamContent = [NSMutableString stringWithString:[self.streamContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}

-(BOOL)isEmpty
{
    if (self.streamContent.length > 0) {
        return NO;
    } else {
        return YES;
    }
}


@end
