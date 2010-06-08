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


@interface SponsorsList : NSObject {
    int version;
    
    NSXMLParser *parser;
    NSMutableArray *levels;
    
    // xml cache
    NSString *currentElementName;
    Sponsor *currentSponsor;
    NSMutableString *currentSponsorURL;
    NSMutableString *currentSponsorLogoPath;
    Level *currentLevel;
}

@property (nonatomic, retain) NSXMLParser *parser;
@property (nonatomic, retain) NSMutableArray *levels;

@property (nonatomic, retain) NSString *currentElementName;
@property (nonatomic, retain) Sponsor *currentSponsor;
@property (nonatomic, retain) NSMutableString *currentSponsorURL;
@property (nonatomic, retain) NSMutableString *currentSponsorLogoPath;
@property (nonatomic, retain) Level *currentLevel;

- (void)parseSponsorsAtURL:(NSString *)sponsorsXMLURL;

@end
