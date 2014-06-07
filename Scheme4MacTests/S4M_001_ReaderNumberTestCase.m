//
//  S4M_001_ReaderNumberTestCase.m
//  Scheme4Mac
//
//  Created by Jan Müller on 26.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "../Scheme4Mac/SchemeREPL/S4MReader.h"
#import "../Scheme4Mac/SchemeREPL/S4MPrinter.h"
#import "../Scheme4Mac/SchemeREPL/S4MStringStreamUsingNSString.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeObject.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeNumber.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeInteger.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeFloat.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeSymbol.h"


@interface S4M_001_ReaderNumberTestCase : XCTestCase

@end

@implementation S4M_001_ReaderNumberTestCase
{
    S4MStringStreamUsingNSString* inputStream;
    S4MStringStreamUsingNSString* outputStream;
    S4MSchemeObject* parsedResult;
}

- (void)setUp
{
    [super setUp];
    inputStream = [[S4MStringStreamUsingNSString alloc] init];
    outputStream = [[S4MStringStreamUsingNSString alloc] init];
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    parsedResult = nil;
}

- (void)testSimpleIntegerParsing
{
    [inputStream setStream:@"100"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    [[S4MPrinter sharedInstance] printSchemeObject:parsedResult onStream:outputStream];
    XCTAssertTrue([@"100" isEqualToString:[outputStream getStream]], @"integer being parsed incorrectly.");
    XCTAssertTrue([parsedResult isKindOfClass:[S4MSchemeInteger class]], @"class is not SchemeInteger.");
}

- (void)testSimpleIntegerSymbolSeparation
{
    [inputStream setStream:@"100asbdg"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    [[S4MPrinter sharedInstance] printSchemeObject:parsedResult onStream:outputStream];
    XCTAssertTrue([@"100asbdg" isEqualToString:[outputStream getStream]], @"100asbdg is not a symbol.");
    XCTAssertTrue([parsedResult isKindOfClass:[S4MSchemeSymbol class]], @"class is not SchemeSymbol.");
}

- (void)testSimpleIntegerLeadingZeros
{
    [inputStream setStream:@"000000234"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    [[S4MPrinter sharedInstance] printSchemeObject:parsedResult onStream:outputStream];
    XCTAssertTrue([@"234" isEqualToString:[outputStream getStream]], @"leading zeros are not ignored.");
    XCTAssertTrue([parsedResult isKindOfClass:[S4MSchemeInteger class]], @"class is not SchemeInteger.");
}

- (void)testFloatParsing
{
    [inputStream setStream:@"1234.5678"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    [[S4MPrinter sharedInstance] printSchemeObject:parsedResult onStream:outputStream];
    
    // string representation of double not comparable. check for value range instead.
    //XCTAssertTrue([@"1234.5678" isEqualToString:[outputStream getStream]], @"float being parsed incorrectly: %@", [outputStream getStream]);
    XCTAssertTrue([parsedResult isKindOfClass:[S4MSchemeFloat class]], @"class is not SchemeFloat.");
    XCTAssertEqualWithAccuracy(1234.5678, ((S4MSchemeFloat*)parsedResult).value, 0.001, @"float is parsed falsely");
}

- (void)testFloatParsingTrailingDot
{
    [inputStream setStream:@"1234."];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    [[S4MPrinter sharedInstance] printSchemeObject:parsedResult onStream:outputStream];
    
    // string representation of double not comparable. check for value range instead.
    // XCTAssertTrue([@"1234" isEqualToString:[outputStream getStream]], @"float being parsed incorrectly: %@", [outputStream getStream]);
    XCTAssertTrue([parsedResult isKindOfClass:[S4MSchemeFloat class]], @"class is SchemeFloat.");
}

@end
