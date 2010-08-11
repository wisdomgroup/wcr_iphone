//
//  MapViewController.h
//  WindyCityRails
//
//  Created by Stanley Fisher on 5/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "VenueDetailTableViewController.h"
#import "TapDetectingImageView.h"
#import "LocationsList.h"
#import "ResourceLoading.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, UIScrollViewDelegate, TapDetectingImageViewDelegate, LocationsListObserver, MasterResourceLoading> {
    MKMapView *mapView;
    VenueDetailTableViewController *venueDetailTableViewController;

    UIScrollView *imageScrollView;
    
    LocationsList *locations;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet VenueDetailTableViewController *venueDetailTableViewController;
@property (nonatomic, retain) IBOutlet UIScrollView *imageScrollView;
@property (nonatomic, retain) IBOutlet LocationsList *locations;

- (void)startLoadingDataAndNotify:(id<LocationsListObserver>) party;
- (void)reloadData;
- (void)showAnnotation:(Location*)location;
- (void)mapModeChange:(id)sender;

@end
