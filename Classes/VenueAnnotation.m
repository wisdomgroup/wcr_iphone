//
//  VenueAnnotation.m
//  WindyCityDB
//
//  Created by Stanley Fisher on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "VenueAnnotation.h"


@implementation VenueAnnotation

@synthesize latitude, longitude, venueTitle, venueSubtitle;

- (id)initWithLatitude:(double)newLatitude longitude:(double)newLongitude title:(NSString *)newTitle subtitle:(NSString *)newSubtitle {
    if (self = [super init]) {
        self.latitude = newLatitude;
        
        self.longitude = newLongitude;
        
        [newTitle retain];
        [self.venueTitle release];
        self.venueTitle = newTitle;
        
        [newSubtitle retain];
        [self.venueSubtitle release];
        self.venueSubtitle = newSubtitle;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = self.latitude;
    theCoordinate.longitude = self.longitude;
    return theCoordinate;
}

- (NSString *)title {
    return venueTitle;
}

- (NSString *)subtitle {
    return venueSubtitle;
}

@end
