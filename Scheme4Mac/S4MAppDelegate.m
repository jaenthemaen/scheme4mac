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
{
    S4MStringStreamUsingNSString* inputStream;
    S4MStringStreamUsingNSString* resultStream;
}

const int FONT_SIZE = 14;
const NSString* FONT = @"Menlo";

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // set the delegate for the reading view to capture key combos
    self.replReadTextView.delegate = self;
    
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
    self.eval.delegate = self;
    self.printer = [S4MPrinter sharedInstance];
    self.reader = [S4MReader sharedInstance];
    
    // set up streams for reading / printing
    inputStream = [[S4MStringStreamUsingNSString alloc] init];
    resultStream = [[S4MStringStreamUsingNSString alloc] init];
    
}

- (IBAction)repl:(id)sender
{
    NSString* readerInput = [[self.replReadTextView textStorage] string];
    // now try it as lines:
    readerInput = [self getCodeCleanedFromComments:readerInput];
    
    // quick fix to enable multiple statements in input without explicit begin statement!
    readerInput = [NSString stringWithFormat:@"(begin %@)", readerInput];
    
    // set input stream for repl:
    [inputStream setStream:readerInput];
    
    @try {
        // build up the ast by parsing the input stream:
        S4MSchemeObject* ast = [self.reader readSchemeObjectFromStream:inputStream];
        
        // eval the ast
        S4MSchemeObject* result = [self.eval evalObject:ast inEnvironment:nil];
        
        // create string output:
        [self printSchemeObjectOnResultView:result];
    }
    @catch (NSException *e) {
        [self.replPrintTextView setString:[NSString stringWithFormat:@"%@%@ > Error: %@\n",
                                           [[self.replPrintTextView textStorage] string],
                                           [self getCurrentDateString],
                                           e]];
        [self scrollResultViewToBottom];
    }
}

-(NSString*)getCodeCleanedFromComments:(NSString*)code
{
    NSString *allTheText = code;
    NSMutableArray *linesOfCode = [[NSMutableArray alloc] init];
    
    int length = (int)[allTheText length];
    NSRange aRange = NSMakeRange(0, 1);
    while (aRange.location < length) {
        unsigned long start, end, contentEnd;
        
        [allTheText getLineStart:&start end:&end contentsEnd:&contentEnd forRange:aRange];
        
        if (contentEnd > start) {
            NSString* line = [allTheText substringWithRange:NSMakeRange(start, contentEnd - start)];
            NSRange range = [line rangeOfString:@";"];
            if (range.location != NSNotFound) {
                line = [line substringToIndex:range.location];
            }
            [linesOfCode addObject:line];
        }
        aRange.location = end;
    }
    return [linesOfCode componentsJoinedByString:@""];
}

- (IBAction)clearOutput:(id)sender
{
    [self.replPrintTextView setString:@""];
    [self scrollResultViewToBottom];
}

- (IBAction)resetEnvironment:(id)sender
{
    [self.eval resetEnvironment];
}

-(void)printSchemeObjectOnResultView:(S4MSchemeObject*)obj
{
    [self.printer printSchemeObject:obj onStream:resultStream];
    // only print if the printer prints something on the result stream!
    if (![[resultStream getStream] isEqualToString:@""]) {
        [self.replPrintTextView setString:[NSString stringWithFormat:@"%@%@ > %@\n",
                                           [[self.replPrintTextView textStorage] string],
                                           [self getCurrentDateString],
                                           [resultStream getStream]]];
        [resultStream setStream:@""];
        [self scrollResultViewToBottom];
    }
}

-(NSString*)getCurrentDateString
{
    NSDate *now = [[NSDate alloc] init];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm:ss"];
    return [format stringFromDate:now];
}

-(void)scrollResultViewToBottom
{
    [self.replPrintTextView scrollToEndOfDocument:[self.replPrintTextView textStorage]];
}

-(BOOL)isCommandEnterEvent:(NSEvent*)e
{
    NSUInteger flags = (e.modifierFlags & NSDeviceIndependentModifierFlagsMask);
    BOOL isCommand = (flags & NSCommandKeyMask) == NSCommandKeyMask;
    BOOL isEnter = (e.keyCode == 0x24);
    return (isCommand && isEnter);
}

-(BOOL)isCommandDeleteEvent:(NSEvent*)e
{
    NSUInteger flags = (e.modifierFlags & NSDeviceIndependentModifierFlagsMask);
    BOOL isCommand = (flags & NSCommandKeyMask) == NSCommandKeyMask;
    BOOL isDelete = (e.keyCode == 0x33);
    return (isCommand && isDelete);
}

-(BOOL)textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector{
    if ([self isCommandEnterEvent:[NSApp currentEvent]]) {
        [self handleCommandEnter];
        return YES;
    } else if ([self isCommandDeleteEvent:[NSApp currentEvent]]) {
        [self handleCommandDelete];
        return YES;
    }
    return NO;
}

-(void)handleCommandEnter
{
    [self repl:nil];
}

-(void)handleCommandDelete
{
    [self.replReadTextView setString:@""];
}

@end
