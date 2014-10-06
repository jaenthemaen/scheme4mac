//
//  S4M_062_EvalIfTestCase.m
//  Scheme4Mac
//
//  Created by Jan Müller on 30.09.14.
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

@interface S4M_062_EvalIfTestCase : XCTestCase

@end

@implementation S4M_062_EvalIfTestCase
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

- (void)testSimpleArithmeticIf {
    [inputStream setStream:@"(if (> 2 3) 2 3)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"3"], @"2 not smaller than 3, instead: %@", [outputStream getStream]);
}

- (void)testIfWithTooFewArgs {
    [inputStream setStream:@"(if (> 2 3) 2)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    XCTAssertThrowsSpecificNamed([[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil]
                                 , NSException, @"Wrong Argument Count", @"doesnt throw right exception!");
}

- (void)testIfWithTooManyArgs {
    [inputStream setStream:@"(if (> 2 3) 2 3 4)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    XCTAssertThrowsSpecificNamed([[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil]
                                 , NSException, @"Wrong Argument Count", @"doesnt throw right exception!");
}

@end
