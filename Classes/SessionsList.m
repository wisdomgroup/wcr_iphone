//
//  Sessions.m
//  WindyCityRails
//
//  Created by Stanley Fisher on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SessionsList.h"
#import "CacheDefaults.h"

#define SAFE_RELEASE(var) if (var) { [var release]; var = nil; }

@implementation LoadableImage

@synthesize imagePath, image;

- (id)init {
    self = [super init];
    if (self) {
        self.imagePath = [[NSMutableString alloc] init];
        self.image = [[UIImage alloc] init];
    }
    return self;
}

- (void)dealloc {
    [self.imagePath release];
    [self.image release];
    
    [super dealloc];
}

- (void)loadResources {
    NSURL *imageURL = [NSURL URLWithString:self.imagePath];
    [[URLCacheConnection alloc] initWithURL:imageURL delegate:self maxAge:IMAGE_AGE];
}

#pragma mark URLCacheConnection delegate methods

- (void) connectionDidFail:(URLCacheConnection *)theConnection {
}

- (void) connectionHasData:(URLCacheConnection *)theConnection {
    self.image = [UIImage imageWithData:[theConnection receivedData]];
}

- (void) connectionDidFinish:(URLCacheConnection *)theConnection {
}

@end


@implementation Speaker

@synthesize name, company, bio, headshots;

- (id)init {
    self = [super init];
    if (self) {
        self.name = [[NSMutableString alloc] init];
        self.company = [[NSMutableString alloc] init];
        self.bio = [[NSMutableString alloc] init];
        self.headshots = [NSMutableArray arrayWithCapacity:2];
    }
    return self;
}

- (void)dealloc {
    [self.name release];
    [self.company release];
    [self.bio release];
    [self.headshots release];
    
    [super dealloc];
}

- (void)loadResources {
    for (LoadableImage *image in self.headshots) {
        [image loadResources];
    }
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

- (void)loadResources {
    [self.speaker loadResources];
}

- (NSString*)timeRange {
    return [NSString stringWithFormat:@"%@ - %@", self.startTime, self.endTime];
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
    self.sessionsFeedConnection = [[URLCacheConnection alloc] initWithURL:sessionsURL delegate:self maxAge:XML_AGE];
}

// type checking hack; couldn't make SessionsListObserver accept performSelectorOnMainThread:... without a warning
- (void)notifyObserver {
    [self.observer sessionsDidFinishLoading:self];
}

#pragma mark NSXMLParser

//- (void)parserDidStartDocument:(NSXMLParser *)parser {
//}

- (void)parser:(NSXMLParser *)theParser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    SAFE_RELEASE(self.currentElementName)
    self.currentElementName = [[NSString alloc] initWithString:elementName];
    
    if ([elementName isEqualToString:@"sessions"]) {
        NSString *v = [attributeDict objectForKey:@"version"];
        if (v && atoi([v UTF8String]) <= version) {
            [theParser abortParsing];
        } else {
            NSLog(@"sessions updated %d -> %@", version, v);
            SAFE_RELEASE(self.sessions)
            self.sessions = [[NSMutableArray alloc] init];
        }
    } else if ([elementName isEqualToString:@"session"]) {
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
    else if ([self.currentElementName isEqualToString:@"headshot"]
          || [self.currentElementName isEqualToString:@"headshot2"]) {
        LoadableImage *image = [[LoadableImage alloc] init];
        [image.imagePath appendString:[string stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        [self.currentSession.speaker.headshots addObject:image];
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
    [self loadResources];
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

- (void)loadResources {
    for (Session *session in self.sessions) {
        [session loadResources];
    }
}

@end
