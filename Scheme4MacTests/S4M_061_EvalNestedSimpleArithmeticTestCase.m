//
//  S4M_061_EvalNestedSimpleArithmeticTestCase
//  Scheme4Mac
//
//  Created by Jan Müller on 26.09.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "../Scheme4Mac/SchemeREPL/S4MReader.h"
#import "../Scheme4Mac/SchemeREPL/S4MEval.h"
#import "../Scheme4Mac/SchemeREPL/S4MPrinter.h"
#import "../Scheme4Mac/SchemeREPL/S4MSymbolTable.h"
#import "../Scheme4Mac/SchemeREPL/S4MStringStreamUsingNSString.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeObject.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeNumber.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeInteger.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeFloat.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeSymbol.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeCons.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeEnvironment.h"

@interface S4M_061_EvalNestedSimpleArithmeticTestCase : XCTestCase

@end

@implementation S4M_061_EvalNestedSimpleArithmeticTestCase
{
    S4MStringStreamUsingNSString* inputStream;
    S4MStringStreamUsingNSString* outputStream;
    S4MSchemeObject* parsedResult;
    S4MSchemeObject* evaledResult;
    S4MSchemeEnvironment* topLevel;
}

- (void)setUp
{
    [super setUp];
    inputStream = [[S4MStringStreamUsingNSString alloc] init];
    outputStream = [[S4MStringStreamUsingNSString alloc] init];
    topLevel = [[S4MSchemeEnvironment alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    parsedResult = nil;
    evaledResult = nil;
    topLevel = nil;
    inputStream = nil;
    outputStream = nil;
}

- (void)testNestedAdditionOfIntegers {
    [inputStream setStream:@"(+ 1 (+ 2 3) 2)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"8"], @"1, 2, 3 and 2 not 8, instead: %@", [outputStream getStream]);
}

- (void)testNestedAdditionAndSubstraction {
    [inputStream setStream:@"(+ 1 (- 2 3) 2)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"2"], @"1, 2 and -1 not 2, instead: %@", [outputStream getStream]);
}

@end
