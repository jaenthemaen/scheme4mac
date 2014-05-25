//
//  S4MSymbolTable.h
//  Scheme4Mac
//
//  Created by Jan Müller on 24.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../SchemeObjects/S4MSchemeSymbol.h"

@interface S4MSymbolTable : NSObject

+(S4MSchemeSymbol*)getSymbolForName:(NSString*)name;

@end
