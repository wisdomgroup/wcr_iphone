//
//  VenueAnnotation.h
//  WindyCityDB
//
//  Created by Stanley Fisher on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>


@interface VenueAnnotation : NSObject <MKAnnotation> {
    double latitude;
    double longitude;
    NSString *venueTitle;
    NSString *venueSubtitle;
}

@property double latitude;
@property double longitude;
@property (nonatomic, retain) NSString *venueTitle;
@property (nonatomic, retain) NSString *venueSubtitle;

- (id)initWithLatitude:(double)newLatitude longitude:(double)newLongitude title:(NSString *)newTitle subtitle:(NSString *)newSubtitle;
- (NSString *)title;
- (NSString *)subtitle;

@end
