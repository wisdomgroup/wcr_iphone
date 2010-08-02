//
//  MapViewController.m
//  WindyCityDB
//
//  Created by Stanley Fisher on 5/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"

#define ZOOM_VIEW_TAG 100
#define ZOOM_STEP 1.5

#define FLOOR_PLAN_IMAGE @"venue_floor_plan.png"

@interface MapViewController (UtilityMethods)
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
- (UIScrollView*)floorPlanView;
@end

@implementation MapViewController

@synthesize mapView, venueDetailTableViewController, imageScrollView, locations;

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
    [super viewDidLoad];
    
    [self reloadData];
}

- (void)startLoadingDataAndNotify:(id<LocationsListObserver>) party {
    locations = [[LocationsList alloc] init];
    [locations parseLocationsAtURL:@"http://windycitydb.org/locations.xml" andNotify:party];
}

- (void)reloadData {
    [self.mapView removeAnnotations:[self.mapView annotations]];
    
    for (Location *location in self.locations.locations) {
        [self.mapView addAnnotation:location];
    }
    
    Location *location = [self.locations.locations objectAtIndex:0];
    [self performSelector:@selector(showAnnotation:) withObject:location afterDelay:2];
    
    // set center and zoom level
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = [location lat];
    newRegion.center.longitude = [location lon];
    newRegion.span.latitudeDelta = 0.093845;
    newRegion.span.longitudeDelta = 0.109863;
    [self.mapView setRegion:newRegion animated:YES];
}

- (void)showAnnotation:(Location*)location {
    [self.mapView selectAnnotation:location animated:YES];
}

- (void)mapModeChange:(id)sender {
    if ([sender selectedSegmentIndex] == 0) { // map
        [[self floorPlanView] removeFromSuperview];
    } else { // floor plan
        [[self view] addSubview:[self floorPlanView]];
    }
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
    self.venueDetailTableViewController = nil;
    self.imageScrollView = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [mapView release];
    [venueDetailTableViewController release];

    [imageScrollView release];
    
    [super dealloc];
}

- (UIScrollView*)floorPlanView {
    if (!imageScrollView) {
        // set up main scroll view
        imageScrollView = [[UIScrollView alloc] initWithFrame:[[self view] bounds]];
        [imageScrollView setBackgroundColor:[UIColor blackColor]];
        [imageScrollView setDelegate:self];
        [imageScrollView setBouncesZoom:YES];
        
        // add touch-sensitive image view to the scroll view
        TapDetectingImageView *imageView = [[TapDetectingImageView alloc] initWithImage:[UIImage imageNamed:FLOOR_PLAN_IMAGE]];
        [imageView setDelegate:self];
        [imageView setTag:ZOOM_VIEW_TAG];
        [imageScrollView setContentSize:[imageView frame].size];
        [imageScrollView addSubview:imageView];
        [imageView release];
        
        // calculate minimum scale to perfectly fit image width, and begin at that scale
        float minimumScale = [imageScrollView frame].size.width  / [imageView frame].size.width;
        [imageScrollView setMinimumZoomScale:minimumScale];
        [imageScrollView setZoomScale:minimumScale];
    }

    return imageScrollView;
}


#pragma mark -
#pragma mark MKMapViewDelegate

- (void)showDetails:(id)sender {
    [self.navigationController pushViewController:self.venueDetailTableViewController animated:YES];
    [self.venueDetailTableViewController setLocation:[self.locations.locations objectAtIndex:[sender tag]]];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(Location*)annotation {
    if ([annotation isKindOfClass:[Location class]]) {
        static NSString *venueAnnotationID = @"venueAnnotationID";
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:venueAnnotationID];
        if (!pinView) {
            MKPinAnnotationView *customPinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:venueAnnotationID] autorelease];
            customPinView.canShowCallout = YES;
            
            UIButton *detailsButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [detailsButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
            detailsButton.tag = annotation.tag;
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


#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [imageScrollView viewWithTag:ZOOM_VIEW_TAG];
}

/************************************** NOTE **************************************/
/* The following delegate method works around a known bug in zoomToRect:animated: */
/* In the next release after 3.0 this workaround will no longer be necessary      */
/**********************************************************************************/
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}

#pragma mark TapDetectingImageViewDelegate methods

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotSingleTapAtPoint:(CGPoint)tapPoint {
    // single tap does nothing for now
}

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint {
    // double tap zooms in
    float newScale = [imageScrollView zoomScale] * ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
    [imageScrollView zoomToRect:zoomRect animated:YES];
}

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotTwoFingerTapAtPoint:(CGPoint)tapPoint {
    // two-finger tap zooms out
    float newScale = [imageScrollView zoomScale] / ZOOM_STEP;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
    [imageScrollView zoomToRect:zoomRect animated:YES];
}

#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [imageScrollView frame].size.height / scale;
    zoomRect.size.width  = [imageScrollView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

#pragma mark LocationsListObserver methods

- (void)locationsDidFinishLoading:(LocationsList*)locations {
    [self reloadData];
}

@end
