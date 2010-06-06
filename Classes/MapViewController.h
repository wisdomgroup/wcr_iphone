//
//  MapViewController.h
//  WindyCityDB
//
//  Created by Stanley Fisher on 5/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

//#import "VenueDetailViewController.h"
#import "VenueDetailTableViewController.h"


@interface MapViewController : UIViewController <MKMapViewDelegate> {
    MKMapView *mapView;
    //VenueDetailViewController *venueDetailViewController;
    VenueDetailTableViewController *venueDetailViewController;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
//@property (nonatomic, retain) IBOutlet VenueDetailViewController *venueDetailViewController;
@property (nonatomic, retain) IBOutlet VenueDetailTableViewController *venueDetailViewController;

@end
