//
//  Sessions.m
//  WindyCityDB
//
//  Created by Stanley Fisher on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SessionsList.h"

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

@synthesize parser;
@synthesize sessions;

@synthesize currentElementName;
@synthesize currentSpeakerHeadshotPath;
@synthesize currentSession;

- (void)dealloc {
    [self.parser release];
    [self.sessions release];
    
    [self.currentElementName release];
    [self.currentSpeakerHeadshotPath release];
    [self.currentSession release];
    
    [super dealloc];
}

- (void)parseSessionsAtURL:(NSString *)sessionsXMLURL {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURL *url = [[NSURL alloc] initWithString:sessionsXMLURL];
    
    self.parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [self.parser setDelegate:self];
    [self.parser setShouldProcessNamespaces:NO];
    [self.parser setShouldReportNamespacePrefixes:NO];
    [self.parser setShouldResolveExternalEntities:NO];
    [self.parser parse];
    
    [url release];
}

// source: http://stackoverflow.com/questions/2606134/iphone-xcode-how-to-convert-nsstring-html-markup-to-plain-text-nsstring
- (NSString *)flattenHTML:(NSString *)html {
	
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
	
    while ([theScanner isAtEnd] == NO) {
		
        [theScanner scanUpToString:@"<" intoString:NULL] ; 
		
        [theScanner scanUpToString:@">" intoString:&text] ;
		
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    //
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
    return html;
}

- (NSString *)replaceEntities:(NSString *)html {
	html = [html stringByReplacingOccurrencesOfString:@"&#8211;" withString:@"-"];
	html = [html stringByReplacingOccurrencesOfString:@"&#8216;" withString:@"`"];
	html = [html stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"'"];
	html = [html stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
	return html;
}

- (NSString *)cleanupText:(NSString *)html {
	return [self replaceEntities:[self flattenHTML:html]];
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
        [self.currentSession.speaker.bio appendString:[self cleanupText:string]];
    }
    else if ([self.currentElementName isEqualToString:@"headshot"]) {
        [self.currentSpeakerHeadshotPath appendString:string];
    }
    else if ([self.currentElementName isEqualToString:@"description"]) {
        [self.currentSession.description appendString:[self cleanupText:string]];
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

@end
