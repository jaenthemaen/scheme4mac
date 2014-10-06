//
//  S4MAppDelegate.h
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "S4MSchemeObject.h"

@interface S4MAppDelegate : NSObject <NSApplicationDelegate, NSTextViewDelegate>
@property (strong) IBOutlet NSTextView *replReadTextView;
@property (strong) IBOutlet NSTextView *replPrintTextView;
@property (strong) IBOutlet NSScrollView *replReadScrollView;
@property (strong) IBOutlet NSScrollView *replPrintScrollView;
- (IBAction)repl:(id)sender;
- (IBAction)clearOutput:(id)sender;
- (IBAction)resetEnvironment:(id)sender;
-(void)printSchemeObjectOnResultView:(S4MSchemeObject*)obj;

@end
