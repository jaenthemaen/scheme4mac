//
//  S4MAppDelegate.m
//  Scheme4Mac
//
//  Created by Jan Müller on 20.05.14.
//  Copyright (c) 2014 ___JAEN___. All rights reserved.
//

#import "S4MAppDelegate.h"
#import "SchemeREPL/S4MStringStreamUsingNSString.h"
#import "SchemeREPL/S4MReader.h"
#import "SchemeREPL/S4MPrinter.h"
#import "SchemeObjects/S4MSchemeObject.h"


// #import "NSString+ToStringArray.h"

@implementation S4MAppDelegate

@synthesize replReadTextView;
@synthesize replPrintTextView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
 
    // hard disable all funny quoting stuff
    self.replReadTextView.automaticQuoteSubstitutionEnabled = NO;
    self.replPrintTextView.automaticQuoteSubstitutionEnabled = NO;
    
    // set the font to white, won't stay as ordered in the nib file for now.
    self.replReadTextView.font = [NSFont fontWithName:@"Menlo" size:14];
    self.replReadTextView.textColor = [NSColor whiteColor];
    
    self.replPrintTextView.font = [NSFont fontWithName:@"Menlo" size:14];
    self.replPrintTextView.textColor = [NSColor whiteColor];
    
    
    
}

- (IBAction)eval:(id)sender
{
    NSString* readerInput = [[self.replReadTextView textStorage] string];
    
    // NSMutableArray* inputAsChars = [readerInput toStringArray];
    
    NSLog(@"got the reader input! \n%@", readerInput);
    
    // NSLog(@"got the reader input as string array. \n%@", inputAsChars);
    
    NSLog(@"--------------------------------------------------");
    
    S4MStringStreamUsingNSString* myStringStream = [[S4MStringStreamUsingNSString alloc] initWithString:readerInput];
    
    // parse the input string.
    S4MSchemeObject* parsedResult = [[S4MReader sharedInstance] readSchemeObjectFromStream:myStringStream];
    
    NSLog(@"This is the parsed result: %@", parsedResult);
    
    // now produce the string representation from the AST
    S4MStringStreamUsingNSString* resultStream = [[S4MStringStreamUsingNSString alloc] init];
    [[S4MPrinter sharedInstance] printSchemeObject:parsedResult onStream:resultStream];
    
    // and print it back out!
    [self.replPrintTextView setString:[resultStream getStream]];
}

@end
