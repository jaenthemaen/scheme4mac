//
//  S4MStringStreamUsingNSString.h
//  Scheme4Mac
//
//  Created by Jan Müller on 23.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface S4MStringStreamUsingNSString : NSObject

@property BOOL preprocessed;

// designated initializer
- (id)initWithString:(NSString *)string;

-(void)setStream:(NSString*)string;
-(NSString*)getStream;
-(void)writeOnStream:(NSString*)string inFront:(BOOL) inFront;

-(NSString*)readChar;
-(NSString*)peekChar;
-(NSString*)lookAheadChar;
-(void)skipSpaces;

@end
