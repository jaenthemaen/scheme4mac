//
//  S4MEval.m
//  Scheme4Mac
//
//  Created by Jan Müller on 23.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MEval.h"
#import "S4MReader.h"
#import "S4MPrinter.h"
#import "S4MSchemeCons.h"

@implementation S4MEval


-(void)topLevelEvalWithAst:(S4MSchemeObject *)ast andOutputStream:(S4MStringStreamUsingNSString*)outputStream
{
    _outputStream = outputStream;
    if (!_globalEnvironment) {
        _globalEnvironment = [[S4MSchemeEnvironment alloc] initWithParent:nil];
        // later load standard library here!
        // [self loadStandardLibrary];
    }
    
//    while (currCont) {
//        currCont = currCont.func(currCont);
//    }
}

-(S4MSchemeObject*)evalSchemeObject:(S4MSchemeObject *)ast
{
//    // is it a list?
//    if ([cont.ast isSchemeCons]) {
//        return [[S4MSchemeContinuation alloc] initWithParent:cont.parentCont
//                                                         ast:cont.ast
//                                                        func:^id(S4MSchemeContinuation *blockCont){
//                                                            return [weakSelf evalSchemeObjectWithCont:blockCont];
//                                                        }
//                                                        args:[NSMutableArray arrayWithCapacity:[(S4MSchemeCons*)cont.ast argumentsListLength]]
//                                                     nextArg:0
//                                                         env:cont.env];
//    } else if ([cont.ast isSchemeInteger]) {
//        // check nextArg!
//        if (cont.nextArg) {
//            <#statements#>
//        }
//    } else if ([cont.ast isSchemeFloat]) {
//        return nil;
//    } else if ([cont.ast isSchemeString]) {
//        return nil;
//    } else if ([cont.ast isSchemeContinuation]) {
//        return nil;
//    } else if ([cont.ast isSchemeSymbol]) {
//        return nil;
//    } else if ([cont.ast isSchemeTrue]) {
//        return nil;
//    } else if ([cont.ast isSchemeFalse]) {
//        return nil;
//    } else {
//        return nil;
//    }
    return nil;
}



-(S4MSchemeObject *)evalFunctionWithAst:(S4MSchemeObject *)cont
{
//    S4MSchemeObject* car = ((S4MSchemeCons*)cont.ast).car;
//    if ([car isSchemeSymbol]) {
//        // eval function
//        S4MSchemeObject* binding = [cont.env getBindingForKey:(S4MSchemeSymbol*)car];
//        
//        
//        return [[S4MSchemeContinuation alloc] init];
//    } else {
//        return nil;
//    }
    return nil;
}



-(void)printResult:(S4MSchemeObject*)result
{
    [_printer printSchemeObject:result onStream:self.outputStream];
}

+(S4MEval *)sharedInstance
{
    static S4MEval *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[S4MEval alloc] init];
    });
    return _sharedInstance;
}


-(S4MStringStreamUsingNSString *)outputStream
{
    if (!_outputStream) {
        _outputStream = [[S4MStringStreamUsingNSString alloc] init];
    }
    return _outputStream;
}

@end
