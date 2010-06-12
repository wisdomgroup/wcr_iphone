//
//  SponsorsList.m
//  WindyCityDB
//
//  Created by Stanley Fisher on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SponsorsList.h"

// This framework was imported so we could use the kCFURLErrorNotConnectedToInternet error code.
#import <CFNetwork/CFNetwork.h>

#define SAFE_RELEASE(var) if (var) { [var release]; var = nil; }


@implementation Sponsor

@synthesize name, url, logoPath, logo, description;

- (id)init {
    self = [super init];
    if (self) {
        self.name = [[NSMutableString alloc] init];
        self.url = [[NSURL alloc] init];
        self.logoPath = [[NSMutableString alloc] init];
        self.logo = [[UIImage alloc] init];
        self.description = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)dealloc {
    [self.name release];
    [self.url release];
    [self.logoPath release];
    [self.logo release];
    [self.description release];
    
    [super dealloc];
}

- (void)loadResources {
    NSURL *logoURL = [NSURL URLWithString:self.logoPath];
    [[URLCacheConnection alloc] initWithURL:logoURL delegate:self];
}

#pragma mark URLCacheConnection delegate methods

- (void) connectionDidFail:(URLCacheConnection *)theConnection {
}

- (void) connectionHasData:(URLCacheConnection *)theConnection {
    SAFE_RELEASE(self.logo);
    self.logo = [UIImage imageWithData:[theConnection receivedData]];
}

- (void) connectionDidFinish:(URLCacheConnection *)theConnection {
}

@end


@implementation Level

@synthesize name, sponsors;

- (id)init {
    self = [super init];
    if (self) {
        self.name = [[NSMutableString alloc] init];
        self.sponsors = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [self.name release];
    [self.sponsors release];
    
    [super dealloc];
}

- (void)loadResources {
    for (Sponsor *sponsor in self.sponsors) {
        [sponsor loadResources];
    }
}

@end


@implementation SponsorsList

@synthesize sponsorsFeedConnection;
@synthesize observer;

@synthesize parser;
@synthesize levels;

@synthesize currentElementName;
@synthesize currentSponsor;
@synthesize currentSponsorURL;
@synthesize currentLevel;

- (void)dealloc {
    [self.sponsorsFeedConnection release];

    [self.parser release];
    [self.levels release];
    
    [self.currentElementName release];
    [self.currentSponsor release];
    [self.currentSponsorURL release];
    [self.currentLevel release];
        
    [super dealloc];
}

- (void)parseSponsorsAtURL:(NSString *)sponsorsXMLURL andNotify:(id<SponsorsListObserver>) party {
    self.observer = party;
    
    NSURL *sponsorsURL = [NSURL URLWithString:sponsorsXMLURL];
    self.sponsorsFeedConnection = [[URLCacheConnection alloc] initWithURL:sponsorsURL delegate:self];
}

// type checking hack; couldn't make SessionsListObserver accept performSelectorOnMainThread:... without a warning
- (void)notifyObserver {
    [self.observer sponsorsDidFinishLoading:self];
}

#pragma mark NSXMLParser

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    SAFE_RELEASE(self.levels)
    self.levels = [[NSMutableArray alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    SAFE_RELEASE(self.currentElementName)
    self.currentElementName = [[NSString alloc] initWithString:elementName];
    
    if ([elementName isEqualToString:@"level"]) {
        SAFE_RELEASE(self.currentLevel)
        self.currentLevel = [[Level alloc] init];
        self.currentLevel.name = [attributeDict valueForKey:@"name"];
    }
    else if ([elementName isEqualToString:@"sponsor"]) {
        SAFE_RELEASE(self.currentSponsor)
        self.currentSponsor = [[Sponsor alloc] init];
    }
    else if ([elementName isEqualToString:@"url"]) {
        SAFE_RELEASE(self.currentSponsorURL)
        self.currentSponsorURL = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([self.currentElementName isEqualToString:@"name"]) {
        [self.currentSponsor.name appendString:string];
    }
    else if ([self.currentElementName isEqualToString:@"url"]) {
        [self.currentSponsorURL appendString:string];
    }
    else if ([self.currentElementName isEqualToString:@"logo"]) {
        [self.currentSponsor.logoPath appendString:string];
    }
    else if ([self.currentElementName isEqualToString:@"description"]) {
        [self.currentSponsor.description appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"sponsor"]) {
        [self.currentLevel.sponsors addObject:self.currentSponsor];
        SAFE_RELEASE(self.currentSponsor)
    }
    else if ([elementName isEqualToString:@"level"]) {
        [self.levels addObject:self.currentLevel];
        SAFE_RELEASE(self.currentLevel)
    }
    else if ([elementName isEqualToString:@"url"]) {
        self.currentSponsor.url = [NSURL URLWithString:self.currentSponsorURL];
        SAFE_RELEASE(self.currentSponsorURL)
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
    self.sponsorsFeedConnection = nil;
}

- (void)parseData:(NSData*)data {
    
    self.parser = [[NSXMLParser alloc] initWithData:data];
    [self.parser setDelegate:self];
    [self.parser setShouldProcessNamespaces:NO];
    [self.parser setShouldReportNamespacePrefixes:NO];
    [self.parser setShouldResolveExternalEntities:NO];
    [self.parser parse];
    [self loadResources];
    
    [self performSelectorOnMainThread:@selector(notifyObserver) withObject:nil waitUntilDone:NO];
}

- (void)loadResources {
    for (Level *level in self.levels) {
        [level loadResources];
    }
}

@end
