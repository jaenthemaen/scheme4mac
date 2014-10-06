//
//  S4M_060_EvalSimpleArithmeticTestCase.m
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

@interface S4M_060_EvalSimpleArithmeticTestCase : XCTestCase

@end

@implementation S4M_060_EvalSimpleArithmeticTestCase
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

- (void)testAdditionOfIntegers {
    [inputStream setStream:@"(+ 1 2)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"3"], @"1 and 2 are not 3, instead: %@", [outputStream getStream]);
}

- (void)testAdditionOfFloats {
    [inputStream setStream:@"(+ 3.7 2.22)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"5.92"], @"3.7 and 2.22 are not 5.92, instead: %@", [outputStream getStream]);
}

- (void)testAdditionOfIntegersAndFloats {
    [inputStream setStream:@"(+ 3.7 2.22 3)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"8.92"], @"3.7, 3 and 2.22 are not 5.92, instead: %@", [outputStream getStream]);
}

- (void)testSubstractionOfIntegersAndFloats {
    [inputStream setStream:@"(- 15 7.5)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"7.5"], @"15 minus 7.5 not 7.5, instead: %@", [outputStream getStream]);
}

- (void)testDivisionOfIntegers {
    [inputStream setStream:@"(/ 10 4)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"2.5"], @"10 div by 4 not 2.5, instead: %@", [outputStream getStream]);
}

- (void)testDivisionByZero {
    [inputStream setStream:@"(/ 10 0)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    XCTAssertThrowsSpecificNamed([[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil]
                                 , NSException, @"Division By Zero Exception", @"doesnt throw right exception!");
}

- (void)testDivisionWithSingleOperand {
    [inputStream setStream:@"(/ 10)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"0.1"], @"division with 10 as single op not 0.1, instead: %@", [outputStream getStream]);
}

- (void)testMultiplicationOfIntegers {
    [inputStream setStream:@"(* 10 4)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"40"], @"10 times 4 not 40, instead: %@", [outputStream getStream]);
}

- (void)testMultiplicationOfFloats {
    [inputStream setStream:@"(* 10.5 1.5)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"15.75"], @"10.5 times 1.5 not 15.75, instead: %@", [outputStream getStream]);
}

- (void)testModuloOfIntegers {
    [inputStream setStream:@"(modulo 10 4)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"2"], @"10 modulo 4 not 2, instead: %@", [outputStream getStream]);
}

- (void)testModuloByZeroException {
    [inputStream setStream:@"(modulo 10 0)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    XCTAssertThrowsSpecificNamed([[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil]
                                 , NSException, @"Illegal Argument Type Exception", @"doesnt throw right exception!");
}

- (void)testModuloWithFloatsException {
    [inputStream setStream:@"(modulo 10.7 0.3)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    XCTAssertThrowsSpecificNamed([[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil]
                                 , NSException, @"Illegal Argument Type Exception", @"doesnt throw right exception!");
}

- (void)testGreaterThanRight {
    [inputStream setStream:@"(> 10.5 1.5)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"#t"], @"10.5 not greater 1.5, instead: %@", [outputStream getStream]);
}

- (void)testGreaterThanFalse {
    [inputStream setStream:@"(> 10.5 11.5)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"#f"], @"10.5 not smaller 11.5, instead: %@", [outputStream getStream]);
}

- (void)testGreaterThanFalseType {
    [inputStream setStream:@"(> 10.5 \"abcd\")"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    XCTAssertThrowsSpecificNamed([[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil]
                                 , NSException, @"NaN Exception", @"doesnt throw right exception!");
}

- (void)testGreaterEqualThanRight {
    [inputStream setStream:@"(>= 10.5 10.5)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"#t"], @"10.5 not greater equal 10.5, instead: %@", [outputStream getStream]);
}

- (void)testGreaterEqualThanFalse {
    [inputStream setStream:@"(>= 10.5 11.5)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"#f"], @"10.5 not smaller 11.5, instead: %@", [outputStream getStream]);
}

- (void)testLessThanRight {
    [inputStream setStream:@"(< -1.5 0)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"#t"], @"-1.5 not less than 0, instead: %@", [outputStream getStream]);
}

- (void)testLessThanFalse {
    [inputStream setStream:@"(< 25 11.5)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"#f"], @"25 not greater 11.5, instead: %@", [outputStream getStream]);
}

- (void)testLessThanFalseType {
    [inputStream setStream:@"(< 10.5 \"abcd\")"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    XCTAssertThrowsSpecificNamed([[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil]
                                 , NSException, @"NaN Exception", @"doesnt throw right exception!");
}

- (void)testLessEqualThanRight {
    [inputStream setStream:@"(<= 0 0)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"#t"], @"10.5 not Less equal 10.5, instead: %@", [outputStream getStream]);
}

- (void)testLessEqualThanRightMultiple {
    [inputStream setStream:@"(<= 0 0 10 1000 10000 10000)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"#t"], @"10.5 not Less equal 10.5, instead: %@", [outputStream getStream]);
}

- (void)testLessEqualThanFalse {
    [inputStream setStream:@"(<= 10.5 11.5 10.5)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"#f"], @"11.5 not greater 10.5, instead: %@", [outputStream getStream]);
}

- (void)testEqualValueRight {
    [inputStream setStream:@"(= 0 0)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"#t"], @"0 not equal 0, instead: %@", [outputStream getStream]);
}

- (void)testEqualValueRightMultiple {
    [inputStream setStream:@"(= 10 10.0 10 10.000)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"#t"], @"10 not equal 10.0 etc, instead: %@", [outputStream getStream]);
}

- (void)testEqualValueFalse {
    [inputStream setStream:@"(= 10.5 10.5 10)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"#f"], @"10 not inequal 10.5, instead: %@", [outputStream getStream]);
}

- (void)testNotWithFalse {
    [inputStream setStream:@"(not #f)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"#t"], @"not #f is not #t, instead: %@", [outputStream getStream]);
}

- (void)testNotWithNumber {
    [inputStream setStream:@"(not 123)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"#f"], @"not number not #f, instead: %@", [outputStream getStream]);
}

- (void)testAndWithObjects {
    [inputStream setStream:@"(and (+ 12 23) (- 12 11))"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"1"], @"and not returning 1 (the last object), instead: %@", [outputStream getStream]);
}

- (void)testAndWithComparisons {
    [inputStream setStream:@"(and (< 12 23) (> 12 11))"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"#t"], @"and not returning true as expected, instead: %@", [outputStream getStream]);
}

- (void)testOrWithObjects {
    [inputStream setStream:@"(or (+ 12 23) (- 12 11))"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"35"], @"or not returning 35 (the first object), instead: %@", [outputStream getStream]);
}

- (void)testOrWithComparisons {
    [inputStream setStream:@"(and (> 12 23) (= 12 11) (< 1 -10))"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"#f"], @"or not returning false as expected, instead: %@", [outputStream getStream]);
}

- (void)testAndWithoutArgs {
    [inputStream setStream:@"(and)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"#t"], @"and not returning true as expected, instead: %@", [outputStream getStream]);
}

- (void)testOrWithoutArgs {
    [inputStream setStream:@"(or)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"#f"], @"or not returning false as expected, instead: %@", [outputStream getStream]);
}

@end
