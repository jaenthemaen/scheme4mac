//
//  S4MSchemeBuiltin.h
//  Scheme4Mac
//
//  Created by Jan Müller on 27.09.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MSchemeObject.h"
typedef id(^builtin_process_t)(NSArray* args);

@interface S4MSchemeBuiltin : S4MSchemeObject
@property int minArgs;
@property int maxArgs;
-(S4MSchemeObject*)processWithArgs:(NSArray*)args;
@end

@interface S4MSchemeBuiltinPlus : S4MSchemeBuiltin
@end

@interface S4MSchemeBuiltinMinus : S4MSchemeBuiltin
@end

@interface S4MSchemeBuiltinDivision : S4MSchemeBuiltin
@end

@interface S4MSchemeBuiltinMultiplication : S4MSchemeBuiltin
@end

@interface S4MSchemeBuiltinModulo : S4MSchemeBuiltin
@end

@interface S4MSchemeBuiltinGreaterThan : S4MSchemeBuiltin
@end

@interface S4MSchemeBuiltinGreaterEqualThan : S4MSchemeBuiltin
@end

@interface S4MSchemeBuiltinLessThan : S4MSchemeBuiltin
@end

@interface S4MSchemeBuiltinLessEqualThan : S4MSchemeBuiltin
@end

@interface S4MSchemeBuiltinEqualValue : S4MSchemeBuiltin
@end

@interface S4MSchemeBuiltinAnd : S4MSchemeBuiltin
@end

@interface S4MSchemeBuiltinOr : S4MSchemeBuiltin
@end

@interface S4MSchemeBuiltinNot : S4MSchemeBuiltin
@end




