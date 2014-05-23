//
//  S4MAppDelegate.m
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MAppDelegate.h"
#import "S4MStringStreamUsingNSString.h"
// #import "NSString+ToStringArray.h"

@implementation S4MAppDelegate

@synthesize replReadTextView;
@synthesize replPrintTextView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
 
    // [self.replReadTextView se];
    
}

- (IBAction)eval:(id)sender
{
    NSString* readerInput = [[self.replReadTextView textStorage] string];
    
    // NSMutableArray* inputAsChars = [readerInput toStringArray];
    
    NSLog(@"got the reader input! \n%@", readerInput);
    
    // NSLog(@"got the reader input as string array. \n%@", inputAsChars);
    
    NSLog(@"--------------------------------------------------");
    
    S4MStringStreamUsingNSString* myStringStream = [[S4MStringStreamUsingNSString alloc] initWithString:readerInput];
    NSString* currentChar = [myStringStream readChar];
    while (currentChar != nil) {
        NSLog(@"%@ \n", currentChar);
        currentChar = [myStringStream readChar];
    }
    
}

@end
