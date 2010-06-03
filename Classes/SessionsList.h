//
//  Sessions.h
//  WindyCityDB
//
//  Created by Stanley Fisher on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Speaker : NSObject {
    NSMutableString *name;
    NSMutableString *company;
    NSMutableString *bio;
    UIImage *headshot;
}

@property (nonatomic, retain) NSMutableString *name;
@property (nonatomic, retain) NSMutableString *company;
@property (nonatomic, retain) NSMutableString *bio;
@property (nonatomic, retain) UIImage *headshot;

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

@end


@interface SessionsList : NSObject {
    int version;
    
    NSXMLParser *parser;
    NSMutableArray *sessions;
    
    // xml cache
    NSString *currentElementName;
    NSMutableString *currentSpeakerHeadshotPath;
    Session *currentSession;
}

@property (nonatomic, retain) NSXMLParser *parser;
@property (nonatomic, retain) NSMutableArray *sessions;

@property (nonatomic, retain) NSString *currentElementName;
@property (nonatomic, retain) NSMutableString *currentSpeakerHeadshotPath;
@property (nonatomic, retain) Session *currentSession;

- (void)parseSessionsAtURL:(NSString *)sessionsXMLURL;

@end
