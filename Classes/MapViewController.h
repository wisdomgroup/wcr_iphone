//
//  MapViewController.h
//  WindyCityDB
//
//  Created by Stanley Fisher on 5/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "VenueDetailViewController.h"


@interface MapViewController : UIViewController <MKMapViewDelegate> {
    MKMapView *mapView;
    VenueDetailViewController *venueDetailViewController;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet VenueDetailViewController *venueDetailViewController;

@end
