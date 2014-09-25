//
//  S4M_060_EvalWithContinuationsBasicTestCase.m
//  Scheme4Mac
//
//  Created by Jan Müller on 07.06.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "../Scheme4Mac/SchemeREPL/S4MReader.h"
#import "../Scheme4Mac/SchemeREPL/S4MPrinter.h"
#import "../Scheme4Mac/SchemeREPL/S4MEval.h"
#import "../Scheme4Mac/SchemeREPL/S4MSymbolTable.h"
#import "../Scheme4Mac/SchemeREPL/S4MStringStreamUsingNSString.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeObject.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeNumber.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeInteger.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeFloat.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeSymbol.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeCons.h"
#import "../Scheme4Mac/SchemeObjects/S4MSchemeEnvironment.h"


@interface S4M_060_EvalWithContinuationsBasicTestCase : XCTestCase

@end

@implementation S4M_060_EvalWithContinuationsBasicTestCase
{
    S4MStringStreamUsingNSString* inputStream;
    S4MStringStreamUsingNSString* outputStream;
    S4MSchemeObject* parsedResult;
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
    topLevel = nil;
    inputStream = nil;
    outputStream = nil;
}

- (void)testSimpleAddition
{
    // TODO: (+ 1 2)
//    [inputStream setStream:@"(+ 1 2)"];
//    S4MSchemeObject* ast = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
//    S4MSchemeContinuation* printCont = [S4MSchemeContinuation alloc] initWithParent:nil andAst:nil andFunction:NSSelector andArguments: andEnvironment:
    
    
    
}

@end
