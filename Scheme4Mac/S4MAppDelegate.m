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
#import "SchemeREPL/S4MEval.h"
#import "SchemeObjects/S4MSchemeObject.h"


// #import "NSString+ToStringArray.h"

@interface S4MAppDelegate()

@property(strong, nonatomic)S4MEval* eval;
@property(strong, nonatomic)S4MPrinter* printer;
@property(strong, nonatomic)S4MReader* reader;

@end


@implementation S4MAppDelegate

@synthesize replReadTextView;
@synthesize replPrintTextView;

const int FONT_SIZE = 14;
const NSString* FONT = @"Menlo";

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
    
    // set up REPL objects
    self.eval = [S4MEval sharedInstance];
    self.printer = [S4MPrinter sharedInstance];
    self.reader = [S4MReader sharedInstance];
    
    
    
}

- (IBAction)repl:(id)sender
{
    NSString* readerInput = [[self.replReadTextView textStorage] string];
    NSLog(@"got the reader input! \n%@", readerInput);
    NSLog(@"--------------------------------------------------");
    
    // set up the streams for input & output:
    S4MStringStreamUsingNSString* inputStream = [[S4MStringStreamUsingNSString alloc] initWithString:readerInput];
    S4MStringStreamUsingNSString* resultStream = [[S4MStringStreamUsingNSString alloc] init];
    
    // build up the ast by parsing the input stream:
    S4MSchemeObject* ast = [self.reader readSchemeObjectFromStream:inputStream];
    
    // Create root Continuation pointing the printing function:
    
    
    // print the result:
    [self.printer printSchemeObject:ast onStream:resultStream];
    
    // and print it back out!
    [self.replPrintTextView setString:[resultStream getStream]];
    
}

-(void)printResult:(id)result
{
    
}

@end
