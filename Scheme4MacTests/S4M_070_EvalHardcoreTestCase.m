//
//  S4M_070_EvalHardcoreTestCase.m
//  Scheme4Mac
//
//  Created by Jan Müller on 06.10.14.
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

@interface S4M_070_EvalHardcoreTestCase : XCTestCase

@end

@implementation S4M_070_EvalHardcoreTestCase
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

- (void)deactivated_testYCombinator {
    [inputStream setStream:[NSString stringWithFormat:@"(begin (define Y"
     "(lambda (f)"
      "((lambda (x) (x x))"
       "(lambda (g)"
        "(f (lambda (x) ((g g) x)))))))"
     "(define fac"
      "(Y"
       "(lambda (f)"
        "(lambda (x)"
         "(if (< x 2)"
          "1"
          "(* x (f (- x 1))))))))"
    "(fac 6))"]];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"720"], @"faculty with lambdas not working properly: (fac 6) not returning 720, instead: %@", [outputStream getStream]);
}

- (void)testIota {
    [inputStream setStream:[NSString stringWithFormat:@"(begin (define iota (lambda (start end step) (begin (define helper (lambda (cur list) (if (eq? cur start) list (helper (- cur step) (cons cur list))))) (helper end '())))) (iota 10 1 -1))"]];
    parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:inputStream];
    evaledResult = [[S4MEval sharedInstance] evalObject:parsedResult inEnvironment:nil];
    [[S4MPrinter sharedInstance] printSchemeObject:evaledResult onStream:outputStream];
    XCTAssertTrue([[outputStream getStream] isEqualToString:@"(9 8 7 6 5 4 3 2 1)"], @"iota not returning list from 10 downwards, instead: %@", [outputStream getStream]);
}

@end
