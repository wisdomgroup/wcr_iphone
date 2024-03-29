//
//  VenueDetailTableViewController.m
//  WindyCityRails
//
//  Created by Stanley Fisher on 6/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "VenueDetailTableViewController.h"

@implementation VenueDetailTableViewController

@synthesize locationManager;
@synthesize titleLabel;
@synthesize addressLabel;
@synthesize photo;
@synthesize lat;
@synthesize lon;
@synthesize spinner;


- (CLLocationManager *)locationManager {
    
    if (locationManager != nil) {
		
        return locationManager;
		
    }
    
    locationManager = [[CLLocationManager alloc] init];
	
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
	
    locationManager.delegate = self;
	
	
	
    return locationManager;
}


- (void)locationManager:(CLLocationManager *)manager

    didUpdateToLocation:(CLLocation *)newLocation

           fromLocation:(CLLocation *)oldLocation {
	
	NSLog(@"%f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    [manager stopUpdatingLocation];
    [spinner stopAnimating];
}



- (void)locationManager:(CLLocationManager *)manager

       didFailWithError:(NSError *)error {
	
    NSLog(@"%@", error);
    [manager stopUpdatingLocation];
    [spinner stopAnimating];
}

- (void)setLocation:(Location*)location {
    self.titleLabel.text = location.venue_long;
    self.addressLabel.text = location.address;
    self.photo.image = location.photo;
    self.lat = location.lat;
    self.lon = location.lon;
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect bounds = self.view.frame;
    bounds.origin.x = bounds.origin.x + (bounds.size.width / 2);
    bounds.origin.y = bounds.origin.y + (bounds.size.height - 150);
    spinner.center = bounds.origin;
    [[self view] addSubview:spinner];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[self locationManager] startUpdatingLocation];
    [spinner startAnimating];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [locationManager stopUpdatingLocation];
    [spinner stopAnimating];
}

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = @"Get Directions";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CLLocationCoordinate2D coordinate = [[locationManager location] coordinate];
    NSString *url;
    
    if (coordinate.latitude > -0.001 && coordinate.latitude < 0.001
     && coordinate.longitude > -0.001 && coordinate.longitude < 0.001) {
        url = [NSString stringWithFormat: @"http://maps.google.com/maps?daddr=%f,%f",
               lat, lon];
    } else {
        url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f",
               coordinate.latitude, coordinate.longitude, lat, lon];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [locationManager release];
    [super dealloc];
}


@end

