//
//  Locations.h
//  WindyCityDB
//
//  Created by Justin Love on 6/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "URLCacheConnection.h"


@interface Location : NSObject <URLCacheConnectionDelegate, MKAnnotation> {
    NSMutableString *venue_short;
    NSMutableString *venue_long;
    NSMutableString *address;
    float lat;
    float lon;
    NSMutableString *photoPath;
    UIImage *photo;
}

@property (nonatomic, retain) NSMutableString *venue_short;
@property (nonatomic, retain) NSMutableString *venue_long;
@property (nonatomic, retain) NSMutableString *address;
@property float lat;
@property float lon;
@property (nonatomic, retain) NSMutableString *photoPath;
@property (nonatomic, retain) UIImage *photo;

- (void)loadResources;

@end

@protocol LocationsListObserver;

@interface LocationsList : NSObject <URLCacheConnectionDelegate> {
    int version;
    
    // for downloading the xml data
    URLCacheConnection *feedConnection;
    id<LocationsListObserver> observer;
    
    NSXMLParser *parser;
    NSMutableArray *locations;
    
    // xml cache
    NSString *currentElementName;
    Location *currentLocation;
}

@property (nonatomic, retain) URLCacheConnection *feedConnection;
@property (nonatomic, retain) id<LocationsListObserver> observer;

@property (nonatomic, retain) NSXMLParser *parser;
@property (nonatomic, retain) NSMutableArray *locations;

@property (nonatomic, retain) NSString *currentElementName;
@property (nonatomic, retain) Location *currentLocation;

- (void)parseLocationsAtURL:(NSString *)locationsXMLURL andNotify:(id <LocationsListObserver>)party;
- (void)notifyObserver;
- (void)parseData:(NSData*)data;
- (void)loadResources;

@end

@protocol LocationsListObserver

- (void)locationsDidFinishLoading:(LocationsList*)locations;

@end

