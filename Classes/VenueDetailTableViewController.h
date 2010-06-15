//
//  VenueDetailTableViewController.h
//  WindyCityDB
//
//  Created by Stanley Fisher on 6/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationsList.h"


@interface VenueDetailTableViewController : UITableViewController <CLLocationManagerDelegate> {

    CLLocationManager *locationManager;
    UILabel *titleLabel;
    UILabel *addressLabel;
    UIImageView *photo;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (assign) IBOutlet UILabel *titleLabel;
@property (assign) IBOutlet UILabel *addressLabel;
@property (assign) IBOutlet UIImageView *photo;

- (void)setLocation:(Location*)location;

@end
