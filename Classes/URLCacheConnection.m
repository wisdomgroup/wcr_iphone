/*

File: URLCacheConnection.m
Abstract: The NSURL connection class for the URLCache sample.

Version: 1.0

Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
("Apple") in consideration of your agreement to the following terms, and your
use, installation, modification or redistribution of this Apple software
constitutes acceptance of these terms.  If you do not agree with these terms,
please do not use, install, modify or redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and subject
to these terms, Apple grants you a personal, non-exclusive license, under
Apple's copyrights in this original Apple software (the "Apple Software"), to
use, reproduce, modify and redistribute the Apple Software, with or without
modifications, in source and/or binary forms; provided that if you redistribute
the Apple Software in its entirety and without modifications, you must retain
this notice and the following text and disclaimers in all such redistributions
of the Apple Software.
Neither the name, trademarks, service marks or logos of Apple Inc. may be used
to endorse or promote products derived from the Apple Software without specific
prior written permission from Apple.  Except as expressly stated in this notice,
no other rights or licenses, express or implied, are granted by Apple herein,
including but not limited to any patent rights that may be infringed by your
derivative works or by other works in which the Apple Software may be
incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2008 Apple Inc. All Rights Reserved.

*/

#import "URLCacheConnection.h"
#import "URLCacheAlert.h"

@implementation URLCacheConnection

@synthesize delegate;
@synthesize receivedData;
@synthesize fileName;
@synthesize lastModified;


/* This method initiates the load request. The connection is asynchronous, 
 and we implement a set of delegate methods that act as callbacks during 
 the load. */

- (id) initWithURL:(NSURL *)theURL delegate:(id<URLCacheConnectionDelegate>)theDelegate maxAge:(NSTimeInterval)maxAge
{
    if (self = [super init]) {

        self.delegate = theDelegate;

        /* create the NSMutableData instance that will hold the received data */
        receivedData = [[NSMutableData alloc] initWithLength:0];
        
        self.fileName = [[theURL path] lastPathComponent];
        NSData *cached = [[NSUserDefaults standardUserDefaults] dataForKey:self.fileName];
        if (cached) {
            NSLog(@"cached %@", self.fileName);
            [receivedData appendData:cached];
            [self.delegate connectionHasData:self];
            NSDate *retrieved = [[NSUserDefaults standardUserDefaults] objectForKey:[self dateKey]];
            if (retrieved && [retrieved compare:[NSDate dateWithTimeIntervalSinceNow:-maxAge]] == NSOrderedDescending) {
                NSLog(@"cache valid");
                [self finish:nil];
                return nil;
            }
            // else check for a fresh copy
        }
                  
        NSLog(@"get %@", self.fileName);

        
        /* Create the request. This application does not use a NSURLCache 
         disk or memory cache, so our cache policy is to satisfy the request
         by loading the data from its source. */
        
        NSURLRequest *theRequest = [NSURLRequest requestWithURL:theURL];
        
        /* Create the connection with the request and start loading the
         data. The connection object is owned both by the creator and the
         loading system. */
            
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:theRequest 
                                                                      delegate:self 
                                                              startImmediately:YES];
        if (connection == nil) {
            /* inform the user that the connection failed */
            NSString *message = NSLocalizedString (@"Unable to initiate request.", 
                                                   @"NSURLConnection initialization method failed.");
            URLCacheAlertWithMessage(message);
        } else {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;   
        }

    }

    return self;
}

- (void) finish:(NSURLConnection *)connection {
    [self.delegate connectionDidFinish:self];
    if (connection) {
        [connection release];
    }
    [self release];
}

- (NSString*) dateKey {
    return [self.fileName stringByAppendingString:@":retrieved"];
}

- (void)dealloc
{
    [receivedData release];
    [lastModified release];
    [super dealloc];
}


#pragma mark NSURLConnection delegate methods

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    /* This method is called when the server has determined that it has
     enough information to create the NSURLResponse. It can be called
     multiple times, for example in the case of a redirect, so each time
     we reset the data. */
    
    [self.receivedData setLength:0];
    
    /* Try to retrieve last modified date from HTTP header. If found, format  
     date so it matches format of cached image file modification date. */
    
    if ([response isKindOfClass:[NSHTTPURLResponse self]]) {
        NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
        NSString *modified = [headers objectForKey:@"Last-Modified"];
        if (modified) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
            self.lastModified = [dateFormatter dateFromString:modified];
            [dateFormatter release];
        }
        else {
            /* default if last modified date doesn't exist (not an error) */
            self.lastModified = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
        }
    }
}


- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    /* Append the new data to the received data. */
    [self.receivedData appendData:data];
}


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
    URLCacheAlertWithError(error);
    [self.delegate connectionDidFail:self];
    [self finish:connection];
}


- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"write %@", self.fileName);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
    [[NSUserDefaults standardUserDefaults] setObject:receivedData forKey:self.fileName];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:[self dateKey]];
    [self.delegate connectionHasData:self];
    [self finish:connection];
}


@end
