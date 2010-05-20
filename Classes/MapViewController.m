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

@synthesize mapView;

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
    NSString *venueSubtitle = [NSString localizedStringWithFormat:@"%@\n%@", @"IIT McCormick Tribune", @"Campus Center"];
    VenueAnnotation *venue = [[VenueAnnotation alloc] initWithLatitude:41.835677 longitude:-87.62588 title:@"WindyCityDB" subtitle:venueSubtitle];
    [self.mapView addAnnotation:venue];
    
    [venueSubtitle release];
    [venue release];
    
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [mapView release];
    
    [super dealloc];
}


@end
