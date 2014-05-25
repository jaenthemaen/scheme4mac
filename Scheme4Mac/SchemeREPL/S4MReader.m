//
//  S4MReader.m
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MReader.h"
#import "../SchemeObjects/S4MSchemeCons.h"
#import "../SchemeObjects/S4MSchemeNil.h"
#import "../SchemeObjects/S4MSchemeFloat.h"
#import "../SchemeObjects/S4MSchemeInteger.h"
#import "../SchemeObjects/S4MSchemeString.h"
#import "../SchemeObjects/S4MSchemeObject.h"
#import "S4MSymbolTable.h"

@implementation S4MReader

-(S4MSchemeObject*)readSchemeObjectFromStream:(S4MStringStreamUsingNSString *)stream
{
    // check if stream is empty:
    NSLog(@"Content of Stream before preprocessing: %@", stream.getStream);
    
    // check one if the paren counts are matching
    if (!stream.preprocessed) {
        // TODO test with large streams!
        if ([self preprocessStreamContentOfStream:[[S4MStringStreamUsingNSString alloc] initWithString:[stream getStream]]]) {
            stream.preprocessed = YES;
        } else {
            return nil;
        }
    }
    // check if stream is empty:
    NSLog(@"Content of Stream after preprocessing: %@", stream.getStream);
    
    // remove white spaces.
    [stream skipSpaces];
    NSString* peekChar = [stream peekChar];
    
    if (isnumber([peekChar characterAtIndex:0])) {
        return [self readNumberFromStream:stream];
    } else if ([peekChar isEqualToString:@"\""]){
        [stream readChar];
        return [self readStringFromStream:stream];
    } else if ([peekChar isEqualToString:@"'"]){
        [stream readChar];
        return [[S4MSchemeCons alloc] initWithCar:[S4MSymbolTable getSymbolForName:@"quote"]
                                           andCdr:[[S4MSchemeCons alloc] initWithCar:[self readSchemeObjectFromStream:stream]
                                                                              andCdr:[S4MSchemeNil sharedInstance]]];
    } else if ([peekChar isEqualToString:@"-"]){
        return [self readNumberFromStream:stream];
    } else if ([peekChar isEqualToString:@"("]){
        [stream readChar];
        return [self readListFromStream:stream];
    } else {
        return [self readSymbolFromStream:stream];
    }
}

- (S4MSchemeObject*)readSymbolFromStream:(S4MStringStreamUsingNSString *)stream
{
    NSString* symbolName = @"";
    NSString* peekChar = [stream peekChar];
    
    while (peekChar && ![peekChar isEqualToString:@"("]
                    && ![peekChar isEqualToString:@")"]
                    && ![[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[peekChar characterAtIndex:0]]) {
        symbolName = [NSString stringWithFormat:@"%@%@", symbolName, [stream readChar]];
        peekChar = [stream peekChar];
    }
    
    return [S4MSymbolTable getSymbolForName:symbolName];
}

- (S4MSchemeObject*)readListFromStream:(S4MStringStreamUsingNSString *)stream
{
    [stream skipSpaces];
    NSString* peekChar = [stream peekChar];
    
    if (!peekChar) {
        [NSException raise:@"Unfinished List" format:@"No closing bracket found before end."];
        return nil;
    } else if ([peekChar isEqualToString:@")"]) {
        [stream readChar];
        return [[S4MSchemeNil alloc] init];
    } else {
        S4MSchemeObject* element = [self readSchemeObjectFromStream:stream];
        S4MSchemeObject* restList = [self readListFromStream:stream];
        return [[S4MSchemeCons alloc] initWithCar:element andCdr:restList];
    }
}

- (S4MSchemeObject*)readNumberFromStream:(S4MStringStreamUsingNSString *)stream
{
    NSMutableString* value = [[NSMutableString alloc] init];
    BOOL isFloat = NO;
    
    // minus for negative number?
    if ([[stream peekChar] isEqualToString:@"-"]) {
        // ... but is the next char a number indeed?
        if (isnumber([[stream lookAheadChar] characterAtIndex:0])) {
            [value appendString:[stream readChar]];
        }
    }
    
    NSString* peekChar = [stream peekChar];
    while (peekChar && isnumber([peekChar characterAtIndex:0])) {
        [value appendString:[stream readChar]];
        peekChar = [stream peekChar];
    }
    
    // If the iteration stopped at a '.' it
    // must continue and assume it reads a float value.
    // If another character shows up before whitespace or bracket
    // it is assumed to be a symbol!
    // TODO extended float values!
    
    NSString* stopChar = peekChar;
    
    if ([stopChar isEqualToString:@"."]) {
        isFloat = YES;
        [value appendString:[stream readChar]];
        
        // new peek char var for inner loop
        NSString* peekChar = [stream peekChar];
        while (peekChar && isnumber([peekChar characterAtIndex:0])) {
            [value appendString:[stream readChar]];
            peekChar = [stream peekChar];
        }
        
        // checks for both kinds of brackets, spaces and None-Type as legit next chars.
        // right?
        if (peekChar && ![[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[peekChar characterAtIndex:0]]
                          && ![peekChar isEqualToString:@"("] && ![peekChar isEqualToString:@")"]) {
            [stream writeOnStream:value inFront:YES];
            return [self readSymbolFromStream:stream];
        }
    } else if (stopChar && ![stopChar isEqualToString:@"("]
                        && ![stopChar isEqualToString:@")"]
               && ![[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[stopChar characterAtIndex:0]]){
        // previously here the stream would have been set back to preprocessed = NO. why?
        [stream writeOnStream:value inFront:YES];
        return [self readSymbolFromStream:stream];
    }
    
    if (isFloat) {
        return [[S4MSchemeFloat alloc] initWithValue:[NSNumber numberWithFloat:[value floatValue]]];
    } else {
        return [[S4MSchemeInteger alloc] initWithValue:[NSNumber numberWithInteger:[value integerValue]]];
    }
}

- (S4MSchemeObject*)readStringFromStream:(S4MStringStreamUsingNSString *)stream
{
    NSMutableString* stringContent = [[NSMutableString alloc] init];
    NSString* escapeChar = nil;
    NSString* peekChar = [stream peekChar];
    
    while (peekChar && ![peekChar isEqualToString:@"\""]) {
        if ([peekChar isEqualToString:@"\\"]) {
            [stream readChar];
            escapeChar = [stream peekChar];
            
            // is it a newline operator?
            if ([escapeChar isEqualToString:@"n"]) {
                [stringContent appendString:@"\n"];
            } else {
                // is it no special string?
                [stringContent appendString:escapeChar];
            }
            // read away "escaped" char:
            [stream readChar];
        } else {
            [stringContent appendString:[stream readChar]];
        }
        peekChar = [stream peekChar];
    }
    
    if (!peekChar) {
        [NSException raise:@"Unfinished string" format:@"string is unfinished: \"%@", stringContent];
        return nil;
    } else if ([peekChar isEqualToString:@"\""]) {
        // if string properly finished, read away quotes:
        [stream readChar];
        return [[S4MSchemeString alloc] initWithContent:stringContent];
    } else {
        [NSException raise:@"Unfinished string" format:@"string is unfinished: \"%@", stringContent];
        return nil;
    }
}

-(BOOL)preprocessStreamContentOfStream:(S4MStringStreamUsingNSString *)stream
{
    BOOL parenOpened = NO;
    int parenOpenedCount = 0;
    int parenClosedCount = 0;
    
    NSString* currentChar = [stream readChar];
    while (currentChar) {
        if ([currentChar isEqualToString:@"("]) {
            parenOpenedCount++;
            parenOpened = YES;
        } else if ([currentChar isEqualToString:@")"]) {
            if (!parenOpened) {
                raise(1);
            } else {
                parenClosedCount++;
                if (parenOpenedCount == parenClosedCount) {
                    parenOpened = NO;
                }
            }
        }
        currentChar = [stream readChar];
    }
    
    if (parenOpenedCount == parenClosedCount) {
        return YES;
    } else {
        [NSException raise:@"Input string malformed!"
                    format:@"Input string has unbalanced parentheses. opened: %d, closed: %d", parenOpenedCount, parenClosedCount];
        return NO;
    }
}

+(S4MReader *)sharedInstance
{
    static S4MReader *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[S4MReader alloc] init];
    });
    return _sharedInstance;
}

@end
