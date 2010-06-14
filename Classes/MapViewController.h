//
//  MapViewController.h
//  WindyCityDB
//
//  Created by Stanley Fisher on 5/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "VenueDetailTableViewController.h"
#import "VenueAnnotation.h"
#import "TapDetectingImageView.h"


@interface MapViewController : UIViewController <MKMapViewDelegate, UIScrollViewDelegate, TapDetectingImageViewDelegate> {
    MKMapView *mapView;
    VenueDetailTableViewController *venueDetailTableViewController;

    UIScrollView *imageScrollView;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet VenueDetailTableViewController *venueDetailTableViewController;
@property (nonatomic, retain) IBOutlet UIScrollView *imageScrollView;

- (void)showAnnotation:(VenueAnnotation*)venueAnnotation;
- (void)mapModeChange:(id)sender;

@end
