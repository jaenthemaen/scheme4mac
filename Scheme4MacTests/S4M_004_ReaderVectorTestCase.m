//
//  S4M_004_ReaderVectorTestCase.m
//  Scheme4Mac
//
//  Created by Jan Müller on 25.09.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "../Scheme4Mac/SchemeREPL/S4MReader.h"
#import "../Scheme4Mac/SchemeREPL/S4MPrinter.h"
#import "../Scheme4Mac/SchemeREPL/S4MStringStreamUsingNSString.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeObject.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeNumber.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeInteger.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeFloat.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeSymbol.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeVector.h"

@interface S4M_004_ReaderVectorTestCase : XCTestCase

@end

@implementation S4M_004_ReaderVectorTestCase
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

- (void)testParsingOfSimpleVector {
    [inputStream setStream:@"#(1 2 3 4)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    XCTAssertTrue([parsedResult isSchemeVector], @"class is SchemeVector.");
    XCTAssertTrue([(S4MSchemeVector*)parsedResult vectorLength] == 4, @"four objects in vector");
    XCTAssertTrue((S4MSchemeInteger*)[(S4MSchemeVector*)parsedResult getObjectAtIndex:2].value == 3 , @"third item has the value 3 and is an integer");
}

- (void)testParsingOfVectorWithList {
    [inputStream setStream:@"#(1 (1 2) 3 4)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    XCTAssertTrue([parsedResult isSchemeVector], @"class is SchemeVector.");
    XCTAssertTrue([(S4MSchemeVector*)parsedResult vectorLength] == 4, @"four objects in vector");
    XCTAssertTrue([[(S4MSchemeVector*)parsedResult getObjectAtIndex:1] isSchemeCons], @"second item is a list");
}

@end
