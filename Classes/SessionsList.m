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

@synthesize name, company, bio, headshotPath, headshot;

- (id)init {
    self = [super init];
    if (self) {
        self.name = [[NSMutableString alloc] init];
        self.company = [[NSMutableString alloc] init];
        self.bio = [[NSMutableString alloc] init];
        self.headshotPath = [[NSMutableString alloc] init];
        self.headshot = [[UIImage alloc] init];
    }
    return self;
}

- (void)dealloc {
    [self.name release];
    [self.company release];
    [self.bio release];
    [self.headshotPath release];
    [self.headshot release];
    
    [super dealloc];
}

- (void)loadResources {
    NSURL *headshotURL = [NSURL URLWithString:self.headshotPath];
    [[URLCacheConnection alloc] initWithURL:headshotURL delegate:self];
}

#pragma mark URLCacheConnection delegate methods

- (void) connectionDidFail:(URLCacheConnection *)theConnection {
}

- (void) connectionHasData:(URLCacheConnection *)theConnection {
    SAFE_RELEASE(self.headshot);
    self.headshot = [UIImage imageWithData:[theConnection receivedData]];
}

- (void) connectionDidFinish:(URLCacheConnection *)theConnection {
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
@synthesize observer;

@synthesize parser;
@synthesize sessions;

@synthesize currentElementName;
@synthesize currentSession;

- (void)dealloc {
    [self.sessionsFeedConnection release];
    
    [self.parser release];
    [self.sessions release];
    
    [self.currentElementName release];
    [self.currentSession release];
    
    [super dealloc];
}

- (void)parseSessionsAtURL:(NSString *)sessionsXMLURL andNotify:(id<SessionsListObserver>) party {
    self.observer = party;
    
    NSURL *sessionsURL = [NSURL URLWithString:sessionsXMLURL];
    self.sessionsFeedConnection = [[URLCacheConnection alloc] initWithURL:sessionsURL delegate:self];
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
        [self.currentSession.speaker.headshotPath appendString:string];
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
        [self.currentSession.speaker loadResources];
    }
    
    SAFE_RELEASE(self.currentElementName)
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
}

#pragma mark URLCacheConnection delegate methods

- (void) connectionDidFail:(URLCacheConnection *)theConnection {
}

- (void) connectionHasData:(URLCacheConnection *)theConnection {
    [self parseData:[theConnection receivedData]];
}

- (void) connectionDidFinish:(URLCacheConnection *)theConnection {
    self.sessionsFeedConnection = nil;
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

@end
