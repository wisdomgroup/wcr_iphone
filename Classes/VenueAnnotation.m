//
//  VenueAnnotation.m
//  WindyCityDB
//
//  Created by Stanley Fisher on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "VenueAnnotation.h"


@implementation VenueAnnotation

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = 41.835677;
    theCoordinate.longitude = -87.62588;
    return theCoordinate;
}

- (NSString *)title {
    return @"WindyCityDB";
}

- (NSString *)subtitle {
    return @"IIT McCormick Tribune Campus Center";
}

- (void)dealloc {
    [super dealloc];
}

@end
