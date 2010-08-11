//
//  SponsorsList.h
//  WindyCityRails
//
//  Created by Stanley Fisher on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "URLCacheConnection.h"


@interface Sponsor : NSObject <URLCacheConnectionDelegate> {
    NSMutableString *name;
    NSURL *url;
    NSMutableString *logoPath;
    UIImage *logo;
    NSMutableString *description;
}

@property (nonatomic, retain) NSMutableString *name;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSMutableString *logoPath;
@property (nonatomic, retain) UIImage *logo;
@property (nonatomic, retain) NSMutableString *description;

- (void)loadResources;

@end


@interface Level : NSObject {
    NSMutableString *name;
    NSMutableArray *sponsors;
}

@property (nonatomic, retain) NSMutableString *name;
@property (nonatomic, retain) NSMutableArray *sponsors;

- (void)loadResources;

@end

@protocol SponsorsListObserver;

@interface SponsorsList : NSObject <URLCacheConnectionDelegate> {
    int version;
    
    // for downloading the xml data
    URLCacheConnection *sponsorsFeedConnection;
    id<SponsorsListObserver> observer;

    NSXMLParser *parser;
    NSMutableArray *levels;
    
    // xml cache
    NSString *currentElementName;
    Sponsor *currentSponsor;
    NSMutableString *currentSponsorURL;
    Level *currentLevel;
}

@property (nonatomic, retain) URLCacheConnection *sponsorsFeedConnection;
@property (nonatomic, retain) id<SponsorsListObserver> observer;

@property (nonatomic, retain) NSXMLParser *parser;
@property (nonatomic, retain) NSMutableArray *levels;

@property (nonatomic, retain) NSString *currentElementName;
@property (nonatomic, retain) Sponsor *currentSponsor;
@property (nonatomic, retain) NSMutableString *currentSponsorURL;
@property (nonatomic, retain) Level *currentLevel;

- (void)parseSponsorsAtURL:(NSString *)sponsorsXMLURL andNotify:(id <SponsorsListObserver>)party;
- (void)notifyObserver;
- (void)parseData:(NSData*)data;
- (void)loadResources;

@end

@protocol SponsorsListObserver

- (void)sponsorsDidFinishLoading:(SponsorsList*)sponsors;

@end
