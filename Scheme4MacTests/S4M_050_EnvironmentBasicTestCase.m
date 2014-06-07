//
//  S4M_050_EnvironmentBasicTestCase.m
//  Scheme4Mac
//
//  Created by Jan Müller on 03.06.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "../Scheme4Mac/SchemeREPL/S4MReader.h"
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

@interface S4M_050_EnvironmentBasicTestCase : XCTestCase

@end

@implementation S4M_050_EnvironmentBasicTestCase

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

- (void)testBindingAndGettingSymbol{
    [topLevel addBinding:[[S4MSchemeInteger alloc] initWithValue:20]
                  forKey:[S4MSymbolTable getSymbolForName:@"a"]];
    
    S4MSchemeObject* binding = [topLevel getBindingForKey:[S4MSymbolTable getSymbolForName:@"a"]];

    XCTAssertTrue([binding isSchemeInteger], @"value bound to a is not an integer!");
}

- (void)testBindingAlreadyBoundSymbolFails{
    [topLevel addBinding:[[S4MSchemeInteger alloc] initWithValue:20]
                  forKey:[S4MSymbolTable getSymbolForName:@"a"]];
    
    XCTAssertThrowsSpecificNamed([topLevel addBinding:[[S4MSchemeInteger alloc] initWithValue:20]
                                               forKey:[S4MSymbolTable getSymbolForName:@"a"]]
                                 , NSException, @"SymbolAlreadyBoundException", @"doesnt throw right exception!");
}

- (void)testSettingBoundSymbol{
    [topLevel addBinding:[[S4MSchemeInteger alloc] initWithValue:20]
                  forKey:[S4MSymbolTable getSymbolForName:@"a"]];
    
    [topLevel setBinding:[[S4MSchemeInteger alloc] initWithValue:50]
                  forKey:[S4MSymbolTable getSymbolForName:@"a"]];
    
    S4MSchemeObject* binding = [topLevel getBindingForKey:[S4MSymbolTable getSymbolForName:@"a"]];
    
    XCTAssertTrue([binding isSchemeInteger], @"value bound to a is NOT an integer!");
    XCTAssertTrue(((S4MSchemeInteger*)binding).value == 50, @"value has not been updated!");
}

- (void)testGettingUnknownBindingFails{
    XCTAssertThrowsSpecificNamed([topLevel getBindingForKey:[S4MSymbolTable getSymbolForName:@"abc"]]
                                 , NSException, @"UndefinedSymbolException", @"doesnt throw right exception!");
}

- (void)testSettingUnboundBindingFails{
    XCTAssertThrowsSpecificNamed([topLevel setBinding:[[S4MSchemeInteger alloc] initWithValue:50]
                                               forKey:[S4MSymbolTable getSymbolForName:@"horst"]]
                                 , NSException, @"UndefinedSymbolException", @"doesnt throw right exception!");
}

- (void)testSettingWithNilFails{
    [topLevel addBinding:[[S4MSchemeInteger alloc] initWithValue:20]
                  forKey:[S4MSymbolTable getSymbolForName:@"a"]];
    
    XCTAssertThrowsSpecificNamed([topLevel setBinding:nil
                                               forKey:[S4MSymbolTable getSymbolForName:@"a"]]
                                 , NSException, NSInvalidArgumentException , @"doesnt throw right exception!");
}

- (void)testAddingWithNilAsValueFails{
    XCTAssertThrowsSpecificNamed([topLevel addBinding:nil
                                               forKey:[S4MSymbolTable getSymbolForName:@"peter"]]
                                 , NSException, NSInvalidArgumentException , @"doesnt throw right exception!");
}

- (void)testGettingFromParentEnvironment{
    [topLevel addBinding:[[S4MSchemeInteger alloc] initWithValue:20]
                  forKey:[S4MSymbolTable getSymbolForName:@"a"]];
    
    S4MSchemeEnvironment* subLevel = [[S4MSchemeEnvironment alloc] initWithParent:topLevel];
    
    S4MSchemeObject* binding = [subLevel getBindingForKey:[S4MSymbolTable getSymbolForName:@"a"]];
    
    XCTAssertTrue([binding isSchemeInteger], @"value bound to a is NOT an integer!");
    XCTAssertTrue(((S4MSchemeInteger*)binding).value == 20, @"value has not been updated!");
}

- (void)testGettingUnboundFromParentFails{
    [topLevel addBinding:[[S4MSchemeInteger alloc] initWithValue:20]
                  forKey:[S4MSymbolTable getSymbolForName:@"a"]];
    
    S4MSchemeEnvironment* subLevel = [[S4MSchemeEnvironment alloc] initWithParent:topLevel];
    
    XCTAssertThrowsSpecificNamed([subLevel getBindingForKey:[S4MSymbolTable getSymbolForName:@"b"]]
                                 , NSException, @"UndefinedSymbolException", @"doesnt throw right exception!");
}




@end
