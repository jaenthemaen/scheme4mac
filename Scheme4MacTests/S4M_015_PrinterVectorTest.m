//
//  S4M_015_PrinterSimpleVectorTest.m
//  Scheme4Mac
//
//  Created by Jan Müller on 26.09.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "S4MPrinter.h"
#import "S4MReader.h"

@interface S4M_015_PrinterVectorTest : XCTestCase

@end

@implementation S4M_015_PrinterVectorTest
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

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testSimpleVectorOutput {
    [inputStream setStream:@"#(1 2 3 4)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    [[S4MPrinter sharedInstance] printSchemeObject:parsedResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"#(1 2 3 4)"], "simple vector of 4 digits printed right");
}

- (void)testVectorWithListOutput {
    [inputStream setStream:@"#(1 (1 2) 3 4)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    [[S4MPrinter sharedInstance] printSchemeObject:parsedResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"#(1 (1 2) 3 4)"], "simple vector of 4 digits printed right");
}

@end
