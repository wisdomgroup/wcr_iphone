//
//  Sessions.m
//  WindyCityDB
//
//  Created by Stanley Fisher on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SessionsList.h"

// This framework was imported so we could use the kCFURLErrorNotConnectedToInternet error code.
#import <CFNetwork/CFNetwork.h>

#define SAFE_RELEASE(var) if (var) { [var release]; var = nil; }


@implementation Speaker

@synthesize name, company, bio, headshot;

- (id)init {
    self = [super init];
    if (self) {
        self.name = [[NSMutableString alloc] init];
        self.company = [[NSMutableString alloc] init];
        self.bio = [[NSMutableString alloc] init];
        self.headshot = [[UIImage alloc] init];
    }
    return self;
}

- (void)dealloc {
    [self.name release];
    [self.company release];
    [self.bio release];
    [self.headshot release];
    
    [super dealloc];
}

@end


@implementation Session

@synthesize title, speaker, description, startTime, endTime;

- (id)init {
    self = [super init];
    if (self) {
        self.title = [[NSMutableString alloc] init];
        self.speaker = [[Speaker alloc] init];
        self.description = [[NSMutableString alloc] init];
        self.startTime = [[NSMutableString alloc] init];
        self.endTime = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)dealloc {
    [self.title release];
    [self.speaker release];
    [self.description release];
    [self.startTime release];
    [self.endTime release];
    
    [super dealloc];
}

@end

// Referenced Apple's SeismicXML example app in the documentation

@implementation SessionsList

@synthesize sessionsFeedConnection;
@synthesize sessionsData;
@synthesize observer;

@synthesize parser;
@synthesize sessions;

@synthesize currentElementName;
@synthesize currentSpeakerHeadshotPath;
@synthesize currentSession;

- (void)dealloc {
    [self.sessionsFeedConnection release];
    [self.sessionsData release];
    
    [self.parser release];
    [self.sessions release];
    
    [self.currentElementName release];
    [self.currentSpeakerHeadshotPath release];
    [self.currentSession release];
    
    [super dealloc];
}

- (void)parseSessionsAtURL:(NSString *)sessionsXMLURL andNotify:(id<SessionsListObserver>) party {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    self.observer = party;
    
    CFDataRef cached = CFPreferencesCopyAppValue((CFStringRef)@"sessions.xml", kCFPreferencesCurrentApplication);
    if (cached) {
        [self parseData:(NSData*)cached];
        return;
    }
    
    NSURLRequest *sessionsURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:sessionsXMLURL]];
    self.sessionsFeedConnection = [[[NSURLConnection alloc] initWithRequest:sessionsURLRequest delegate:self] autorelease];
}

// type checking hack; couldn't make SessionsListObserver accept performSelectorOnMainThread:... without a warning
- (void)notifyObserver {
    [self.observer sessionsDidFinishLoading:self];
}

#pragma mark NSXMLParser

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    SAFE_RELEASE(self.sessions)
    self.sessions = [[NSMutableArray alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    SAFE_RELEASE(self.currentElementName)
    self.currentElementName = [[NSString alloc] initWithString:elementName];
    
    if ([elementName isEqualToString:@"session"]) {
        SAFE_RELEASE(self.currentSession)
        self.currentSession = [[Session alloc] init];
    }
    else if ([elementName isEqualToString:@"headshot"]) {
        SAFE_RELEASE(self.currentSpeakerHeadshotPath)
        self.currentSpeakerHeadshotPath = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([self.currentElementName isEqualToString:@"title"]) {
        [self.currentSession.title appendString:string];
    }
    else if ([self.currentElementName isEqualToString:@"name"]) {
        [self.currentSession.speaker.name appendString:string];
    }
    else if ([self.currentElementName isEqualToString:@"company"]) {
        [self.currentSession.speaker.company appendString:string];
    }
    else if ([self.currentElementName isEqualToString:@"bio"]) {
        [self.currentSession.speaker.bio appendString:string];
    }
    else if ([self.currentElementName isEqualToString:@"headshot"]) {
        [self.currentSpeakerHeadshotPath appendString:string];
    }
    else if ([self.currentElementName isEqualToString:@"description"]) {
        [self.currentSession.description appendString:string];
    }
    else if ([self.currentElementName isEqualToString:@"start_time"]) {
        [self.currentSession.startTime appendString:string];
    }
    else if ([self.currentElementName isEqualToString:@"end_time"]) {
        [self.currentSession.endTime appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"session"]) {
        [self.sessions addObject:self.currentSession];
        SAFE_RELEASE(self.currentSession)
    }
    else if ([elementName isEqualToString:@"headshot"]) {
        NSURL *headshotURL = [NSURL URLWithString:self.currentSpeakerHeadshotPath];
        NSData *headshotData = [NSData dataWithContentsOfURL:headshotURL];
        self.currentSession.speaker.headshot = [UIImage imageWithData:headshotData];
        SAFE_RELEASE(self.currentSpeakerHeadshotPath)
    }
    
    SAFE_RELEASE(self.currentElementName)
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark NSURLConnection delegate methods

// The following are delegate methods for NSURLConnection. Similar to callback functions, this is how the connection object,
// which is working in the background, can asynchronously communicate back to its delegate on the thread from which it was
// started - in this case, the main thread.

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.sessionsData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [sessionsData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
    if ([error code] == kCFURLErrorNotConnectedToInternet) {
        // if we can identify the error, we can present a more precise message to the user.
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NSLocalizedString(@"No Connection Error",                             @"Error message displayed when not connected to the Internet.") forKey:NSLocalizedDescriptionKey];
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain code:kCFURLErrorNotConnectedToInternet userInfo:userInfo];
        [self handleError:noConnectionError];
    } else {
        // otherwise handle the error generically
        [self handleError:error];
    }
    self.sessionsFeedConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.sessionsFeedConnection = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   

    [self parseData:sessionsData];
    
    CFPreferencesSetAppValue((CFStringRef)@"sessions.xml", sessionsData, kCFPreferencesCurrentApplication);
    
    self.sessionsData = nil;
}

- (void)parseData:(NSData*)data {
    
    self.parser = [[NSXMLParser alloc] initWithData:data];
    [self.parser setDelegate:self];
    [self.parser setShouldProcessNamespaces:NO];
    [self.parser setShouldReportNamespacePrefixes:NO];
    [self.parser setShouldResolveExternalEntities:NO];
    [self.parser parse];
    
    [self performSelectorOnMainThread:@selector(notifyObserver) withObject:nil waitUntilDone:NO];
}

// Handle errors in the download or the parser by showing an alert to the user. This is a very simple way of handling the error,
// partly because this application does not have any offline functionality for the user. Most real applications should
// handle the error in a less obtrusive way and provide offline functionality to the user.
- (void)handleError:(NSError *)error {
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error Title", @"Title for alert displayed when download or parse error occurs.") message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

@end
