//
//  S4M_003_ReaderSymbolIdentityTestCase.m
//  Scheme4Mac
//
//  Created by Jan Müller on 30.05.14.
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
#import "../Scheme4Mac/SchemeObjects/S4MSchemeCons.h"

@interface S4M_003_ReaderSymbolIdentityTestCase : XCTestCase

@end

@implementation S4M_003_ReaderSymbolIdentityTestCase
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

- (void)testIdentityOfTwoStrings
{
    [inputStream setStream:@"(a a)"];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    S4MSchemeSymbol* firstA = (S4MSchemeSymbol*)((S4MSchemeCons*) parsedResult).car;
    S4MSchemeSymbol* secondA = (S4MSchemeSymbol*) ((S4MSchemeCons*)((S4MSchemeCons*) parsedResult).cdr).car;
    
    XCTAssertEqualObjects(firstA, secondA, @"two identical symbols arent the same object.");
}

@end
