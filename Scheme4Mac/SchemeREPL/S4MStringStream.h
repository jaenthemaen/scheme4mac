//
//  S4MStringStream.h
//  Scheme4Mac
//
//  Created by Jan Müller on 23.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface S4MStringStream : NSObject

-(void) setStream: (NSString*) stream;
-(NSString*) getStream;
-(char) readChar;
-(char) lookAheadChar;
-(char) lookAheadTwiceChar;

@end
