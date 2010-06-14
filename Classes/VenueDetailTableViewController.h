//
//  VenueDetailTableViewController.h
//  WindyCityDB
//
//  Created by Stanley Fisher on 6/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface VenueDetailTableViewController : UITableViewController {

    CLLocationManager *locationManager;

}

@property (nonatomic, retain) CLLocationManager *locationManager;

@end
