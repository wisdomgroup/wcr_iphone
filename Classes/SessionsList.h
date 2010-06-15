//
//  Sessions.h
//  WindyCityDB
//
//  Created by Stanley Fisher on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "URLCacheConnection.h"


@interface Speaker : NSObject <URLCacheConnectionDelegate> {
    NSMutableString *name;
    NSMutableString *company;
    NSMutableString *bio;
    NSMutableString *headshotPath;
    UIImage *headshot;
}

@property (nonatomic, retain) NSMutableString *name;
@property (nonatomic, retain) NSMutableString *company;
@property (nonatomic, retain) NSMutableString *bio;
@property (nonatomic, retain) NSMutableString *headshotPath;
@property (nonatomic, retain) UIImage *headshot;

- (void)loadResources;

@end


@interface Session : NSObject {
    NSMutableString *title;
    Speaker *speaker;
    NSMutableString *description;
    NSMutableString *startTime;
    NSMutableString *endTime;
}

@property (nonatomic, retain) NSMutableString *title;
@property (nonatomic, retain) Speaker *speaker;
@property (nonatomic, retain) NSMutableString *description;
@property (nonatomic, retain) NSMutableString *startTime;
@property (nonatomic, retain) NSMutableString *endTime;

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
    Session *currentSession;
}

@property (nonatomic, retain) URLCacheConnection *sessionsFeedConnection;
@property (nonatomic, retain) id<SessionsListObserver> observer;

@property (nonatomic, retain) NSXMLParser *parser;
@property (nonatomic, retain) NSMutableArray *sessions;

@property (nonatomic, retain) NSString *currentElementName;
@property (nonatomic, retain) Session *currentSession;

- (void)parseSessionsAtURL:(NSString *)sessionsXMLURL andNotify:(id <SessionsListObserver>)party;
- (void)notifyObserver;
- (void)parseData:(NSData*)data;
- (void)loadResources;

@end

@protocol SessionsListObserver

- (void)sessionsDidFinishLoading:(SessionsList*)sessions;

@end

