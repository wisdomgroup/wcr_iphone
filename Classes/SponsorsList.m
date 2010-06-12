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

@synthesize name, url, logo, description;

- (id)init {
    self = [super init];
    if (self) {
        self.name = [[NSMutableString alloc] init];
        self.url = [[NSURL alloc] init];
        self.logo = [[UIImage alloc] init];
        self.description = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)dealloc {
    [self.name release];
    [self.url release];
    [self.logo release];
    [self.description release];
    
    [super dealloc];
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

@end


@implementation SponsorsList

@synthesize sponsorsFeedConnection;
@synthesize sponsorsData;
@synthesize observer;

@synthesize parser;
@synthesize levels;

@synthesize currentElementName;
@synthesize currentSponsor;
@synthesize currentSponsorURL;
@synthesize currentSponsorLogoPath;
@synthesize currentLevel;

- (void)dealloc {
    [self.sponsorsFeedConnection release];
    [self.sponsorsData release];

    [self.parser release];
    [self.levels release];
    
    [self.currentElementName release];
    [self.currentSponsor release];
    [self.currentSponsorURL release];
    [self.currentSponsorLogoPath release];
    [self.currentLevel release];
        
    [super dealloc];
}

- (void)parseSponsorsAtURL:(NSString *)sponsorsXMLURL andNotify:(id<SponsorsListObserver>) party {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    self.observer = party;
    
    NSData *cached = [[NSUserDefaults standardUserDefaults] dataForKey:@"sponsors.xml"];
    if (cached) {
        [self parseData:cached];
        return;
    }
    
    NSURLRequest *sponsorsURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:sponsorsXMLURL]];
    self.sponsorsFeedConnection = [[[NSURLConnection alloc] initWithRequest:sponsorsURLRequest delegate:self] autorelease];
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
    else if ([elementName isEqualToString:@"logo"]) {
        SAFE_RELEASE(self.currentSponsorLogoPath)
        self.currentSponsorLogoPath = [[NSMutableString alloc] init];
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
        [self.currentSponsorLogoPath appendString:string];
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
    else if ([elementName isEqualToString:@"logo"]) {
        NSURL *logoURL = [NSURL URLWithString:self.currentSponsorLogoPath];
        NSData *logoData = [NSData dataWithContentsOfURL:logoURL];
        self.currentSponsor.logo = [UIImage imageWithData:logoData];
        SAFE_RELEASE(self.currentSponsorLogoPath)
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
    self.sponsorsData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [sponsorsData appendData:data];
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
    self.sponsorsFeedConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.sponsorsFeedConnection = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   

    [self parseData:sponsorsData];
    
    [[NSUserDefaults standardUserDefaults] setObject:sponsorsData forKey:@"sponsors.xml"];
    
    self.sponsorsData = nil;
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
