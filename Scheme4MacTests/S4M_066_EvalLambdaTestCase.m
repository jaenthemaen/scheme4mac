//
//  S4M_066_EvalLambdaTestCase.m
//  Scheme4Mac
//
//  Created by Jan Müller on 02.10.14.
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
#import "../Scheme4Mac/SchemeObjects/S4MSchemeUserDefinedFunction.h"

@interface S4M_066_EvalLambdaTestCase : XCTestCase

@end

@implementation S4M_066_EvalLambdaTestCase
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

- (void)testSimpleLambda {
    [inputStream setStream:@"(lambda () 30)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    XCTAssertTrue([evaledResult isSchemeUserDefinedFunction], @"lambda not returning userDefinedFunction, instead: %@", [evaledResult className]);
    XCTAssertTrue(((S4MSchemeUserDefinedFunction*)evaledResult).argsCount == 0, @"userDefinedFunction doesn't have 0 args, instead: %d", ((S4MSchemeUserDefinedFunction*)evaledResult).argsCount);
    XCTAssertTrue([((S4MSchemeUserDefinedFunction*)evaledResult).bodyList isSchemeInteger], @"lambda not returning userDefinedFunction, instead: %@", [evaledResult className]);
}

- (void)testLambdaWithWrongArgType {
    [inputStream setStream:@"(lambda (10 20) 30)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    XCTAssertThrowsSpecificNamed([[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil]
                                 , NSException, NSInvalidArgumentException, @"doesnt throw right exception!");
}

- (void)testLambdaWithWrongArgTypeTwo {
    [inputStream setStream:@"(lambda (\"abcde\") 30)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    XCTAssertThrowsSpecificNamed([[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil]
                                 , NSException, NSInvalidArgumentException, @"doesnt throw right exception!");
}

@end
