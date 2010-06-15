//
//  LocationsList.m
//  WindyCityDB
//
//  Created by Justin Love on 2010-06-13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LocationsList.h"

#define SAFE_RELEASE(var) if (var) { [var release]; var = nil; }


@implementation Location

@synthesize venue_short, venue_long, address, lat, lon, photoPath, photo, tag;

- (id)init {
    self = [super init];
    if (self) {
        self.venue_short = [[NSMutableString alloc] init];
        self.venue_long = [[NSMutableString alloc] init];
        self.address = [[NSMutableString alloc] init];
        self.lat = 0.0;
        self.lon = 0.0;
        self.photoPath = [[NSMutableString alloc] init];
        self.photo = [[UIImage alloc] init];
        self.tag = 0;
    }
    return self;
}

- (void)dealloc {
    [self.venue_short release];
    [self.venue_long release];
    [self.address release];
    [self.photoPath release];
    [self.photo release];
    
    [super dealloc];
}

- (void)loadResources {
    if (self.photoPath.length > 0) {
        NSURL *photoURL = [NSURL URLWithString:self.photoPath];
        [[URLCacheConnection alloc] initWithURL:photoURL delegate:self];
    }
}

#pragma mark URLCacheConnection delegate methods

- (void) connectionDidFail:(URLCacheConnection *)theConnection {
}

- (void) connectionHasData:(URLCacheConnection *)theConnection {
    self.photo = [UIImage imageWithData:[theConnection receivedData]];
}

- (void) connectionDidFinish:(URLCacheConnection *)theConnection {
}

#pragma mark MKAnnotation delegate methods

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = self.lat;
    theCoordinate.longitude = self.lon;
    return theCoordinate;
}

- (NSString *)title {
    return self.venue_short;
}

- (NSString *)subtitle {
    return self.venue_long;
}


@end


// Referenced Apple's SeismicXML example app in the documentation

@implementation LocationsList

@synthesize feedConnection;
@synthesize observer;

@synthesize parser;
@synthesize locations;

@synthesize currentElementName;
@synthesize currentLocation;

- (void)dealloc {
    [self.feedConnection release];
    
    [self.parser release];
    [self.locations release];
    
    [self.currentElementName release];
    [self.currentLocation release];
    
    [super dealloc];
}

- (void)parseLocationsAtURL:(NSString *)locationsXMLURL andNotify:(id<LocationsListObserver>) party {
    self.observer = party;
    
    NSURL *locationsURL = [NSURL URLWithString:locationsXMLURL];
    self.feedConnection = [[URLCacheConnection alloc] initWithURL:locationsURL delegate:self];
}

// type checking hack; couldn't make LocationsListObserver accept performSelectorOnMainThread:... without a warning
- (void)notifyObserver {
    [self.observer locationsDidFinishLoading:self];
}

#pragma mark NSXMLParser

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    SAFE_RELEASE(self.locations)
    self.locations = [[NSMutableArray alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    SAFE_RELEASE(self.currentElementName)
    self.currentElementName = [[NSString alloc] initWithString:elementName];
    
    if ([elementName isEqualToString:@"location"]) {
        SAFE_RELEASE(self.currentLocation)
        self.currentLocation = [[Location alloc] init];
        self.currentLocation.tag = [self.locations count];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([self.currentElementName isEqualToString:@"venue_short"]) {
        [self.currentLocation.venue_short appendString:string];
    }
    else if ([self.currentElementName isEqualToString:@"venue_long"]) {
        [self.currentLocation.venue_long appendString:string];
    }
    else if ([self.currentElementName isEqualToString:@"address"]) {
        [self.currentLocation.address appendString:string];
    }
    else if ([self.currentElementName isEqualToString:@"lat"]) {
        self.currentLocation.lat = atof([string UTF8String]);
    }
    else if ([self.currentElementName isEqualToString:@"long"]) {
        self.currentLocation.lon = atof([string UTF8String]);
    }
    else if ([self.currentElementName isEqualToString:@"photo"]) {
        [self.currentLocation.photoPath appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"location"]) {
        [self.locations addObject:self.currentLocation];
        SAFE_RELEASE(self.currentLocation)
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
    self.feedConnection = nil;
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
    for (Location *location in self.locations) {
        [location loadResources];
    }
}

@end
