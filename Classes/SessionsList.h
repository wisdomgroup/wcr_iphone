//
//  Sessions.h
//  WindyCityRails
//
//  Created by Stanley Fisher on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "URLCacheConnection.h"


@interface LoadableImage : NSObject <URLCacheConnectionDelegate> {
    NSMutableString *imagePath;
    UIImage *image;
}

@property (nonatomic, retain) NSMutableString *imagePath;
@property (nonatomic, retain) UIImage *image;

- (void)loadResources;

@end

@interface Speaker : NSObject {
    NSMutableString *name;
    NSMutableString *company;
    NSMutableString *bio;
    NSMutableArray *headshots;
}

@property (nonatomic, retain) NSMutableString *name;
@property (nonatomic, retain) NSMutableString *company;
@property (nonatomic, retain) NSMutableString *bio;
@property (nonatomic, retain) NSMutableArray *headshots;

- (void)loadResources;

@end


@interface Session : NSObject {
    NSMutableString *title;
    Speaker *speaker;
    NSMutableString *description;
    NSMutableString *startTime;
    NSMutableString *endTime;
    NSMutableString *speakerWebsite;
    NSMutableString *speakerTwitter;
    NSMutableString *slidesURL;
    NSMutableString *rateURL;
    NSMutableString *videoURL;
}

@property (nonatomic, retain) NSMutableString *title;
@property (nonatomic, retain) Speaker *speaker;
@property (nonatomic, retain) NSMutableString *description;
@property (nonatomic, retain) NSMutableString *startTime;
@property (nonatomic, retain) NSMutableString *endTime;
@property (nonatomic, readonly) NSString *timeRange;
@property (nonatomic, retain) NSMutableString *speakerWebsite;
@property (nonatomic, retain) NSMutableString *speakerTwitter;
@property (nonatomic, retain) NSMutableString *slidesURL;
@property (nonatomic, retain) NSMutableString *rateURL;
@property (nonatomic, retain) NSMutableString *videoURL;


- (void)loadResources;

@end

@protocol SessionsListObserver;

@interface SessionsList : NSObject <URLCacheConnectionDelegate> {
    int version;
    
    // for downloading the xml data
    URLCacheConnection *sessionsFeedConnection;
    id<SessionsListObserver> observer;

    NSXMLParser *parser;
    NSMutableArray *sessions;
    
    // xml cache
    NSString *currentElementName;
    NSString *currentCategoryName;
    Session *currentSession;
}

@property (nonatomic, retain) URLCacheConnection *sessionsFeedConnection;
@property (nonatomic, retain) id<SessionsListObserver> observer;

@property (nonatomic, retain) NSXMLParser *parser;
@property (nonatomic, retain) NSMutableArray *sessions;

@property (nonatomic, retain) NSString *currentElementName;
@property (nonatomic, retain) NSString *currentCategoryName;
@property (nonatomic, retain) Session *currentSession;

- (void)parseSessionsAtURL:(NSString *)sessionsXMLURL andNotify:(id <SessionsListObserver>)party;
- (void)notifyObserver;
- (void)parseData:(NSData*)data;
- (void)loadResources;

@end

@protocol SessionsListObserver

- (void)sessionsDidFinishLoading:(SessionsList*)sessions;

@end

