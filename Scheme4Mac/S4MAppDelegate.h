//
//  S4MAppDelegate.h
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "S4MSchemeContinuation.h"

@interface S4MAppDelegate : NSObject <NSApplicationDelegate>
@property (strong) IBOutlet NSTextView *replReadTextView;
@property (strong) IBOutlet NSTextView *replPrintTextView;
- (IBAction)repl:(id)sender;
- (void)printResultWithContinuation:(S4MSchemeContinuation*)continuation;

@end
