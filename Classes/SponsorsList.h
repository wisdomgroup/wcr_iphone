//
//  SponsorsList.h
//  WindyCityDB
//
//  Created by Stanley Fisher on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Sponsor : NSObject {
    NSMutableString *name;
    NSURL *url;
    UIImage *logo;
    NSMutableString *description;
}

@property (nonatomic, retain) NSMutableString *name;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) UIImage *logo;
@property (nonatomic, retain) NSMutableString *description;

@end


@interface Level : NSObject {
    NSMutableString *name;
    NSMutableArray *sponsors;
}

@property (nonatomic, retain) NSMutableString *name;
@property (nonatomic, retain) NSMutableArray *sponsors;

@end

@protocol SponsorsListObserver;

@interface SponsorsList : NSObject {
    int version;
    
    // for downloading the xml data
    NSURLConnection *sponsorsFeedConnection;
    NSMutableData *sponsorsData;
    id<SponsorsListObserver> observer;

    NSXMLParser *parser;
    NSMutableArray *levels;
    
    // xml cache
    NSString *currentElementName;
    Sponsor *currentSponsor;
    NSMutableString *currentSponsorURL;
    NSMutableString *currentSponsorLogoPath;
    Level *currentLevel;
}

@property (nonatomic, retain) NSURLConnection *sponsorsFeedConnection;
@property (nonatomic, retain) NSMutableData *sponsorsData;
@property (nonatomic, retain) id<SponsorsListObserver> observer;

@property (nonatomic, retain) NSXMLParser *parser;
@property (nonatomic, retain) NSMutableArray *levels;

@property (nonatomic, retain) NSString *currentElementName;
@property (nonatomic, retain) Sponsor *currentSponsor;
@property (nonatomic, retain) NSMutableString *currentSponsorURL;
@property (nonatomic, retain) NSMutableString *currentSponsorLogoPath;
@property (nonatomic, retain) Level *currentLevel;

- (void)parseSponsorsAtURL:(NSString *)sponsorsXMLURL andNotify:(id <SponsorsListObserver>)party;
- (void)notifyObserver;
- (void)handleError:(NSError *)error;

@end

@protocol SponsorsListObserver

- (void)sponsorsDidFinishLoading:(SponsorsList*)sponsors;

@end
