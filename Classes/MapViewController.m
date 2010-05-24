//
//  MapViewController.m
//  WindyCityDB
//
//  Created by Stanley Fisher on 5/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "VenueAnnotation.h"

@implementation MapViewController

@synthesize mapView, venueDetailViewController;

#pragma mark -

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    VenueAnnotation *venueAnnotation = [[VenueAnnotation alloc] init];
    [self.mapView addAnnotation:venueAnnotation];
    [venueAnnotation release];
    
    // set center and zoom level
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 41.857671;
    newRegion.center.longitude = -87.642746;
    newRegion.span.latitudeDelta = 0.093845;
    newRegion.span.longitudeDelta = 0.109863;
    [self.mapView setRegion:newRegion animated:YES];
    
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    self.mapView = nil;
    self.venueDetailViewController = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [mapView release];
    [venueDetailViewController release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (void)showDetails:(id)sender {
    [self.navigationController pushViewController:self.venueDetailViewController animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[VenueAnnotation class]]) {
        static NSString *venueAnnotationID = @"venueAnnotationID";
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:venueAnnotationID];
        if (!pinView) {
            MKPinAnnotationView *customPinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:venueAnnotationID] autorelease];
            customPinView.canShowCallout = YES;
            
            UIButton *detailsButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [detailsButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
            customPinView.pinColor = MKPinAnnotationColorRed;
            customPinView.animatesDrop = YES;
            customPinView.rightCalloutAccessoryView = detailsButton;
            
            return customPinView;
        }
        else {
            pinView.annotation = annotation;
            return pinView;
        }

    }
    
    else {
        return nil;
    }

}


@end
