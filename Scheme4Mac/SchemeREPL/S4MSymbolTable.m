//
//  S4MSymbolTable.m
//  Scheme4Mac
//
//  Created by Jan Müller on 24.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSymbolTable.h"

@implementation S4MSymbolTable

static NSMutableDictionary* table;

// checks if a symbol exists already and returns either that
// or a new instance of schemesymbol.
+(S4MSchemeSymbol *)getSymbolForName:(NSString *)name
{
    S4MSchemeSymbol* requestedSymbol = [table objectForKey:name];
    if (!requestedSymbol) {
        requestedSymbol = [[S4MSchemeSymbol alloc] initWithName:name];
        [table setObject:requestedSymbol forKey:name];
    }
    return requestedSymbol;
}

// initialize is a framework method thad is executed only once,
// as the class gets loaded.
+(void)initialize
{
    table = [[NSMutableDictionary alloc] init];
}

@end
