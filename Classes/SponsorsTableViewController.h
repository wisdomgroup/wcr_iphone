//
//  SponsorsTableViewController.h
//  WindyCityDB
//
//  Created by Stanley Fisher on 5/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SponsorsList.h"


@interface SponsorsTableViewController : UITableViewController {
    SponsorsList *sponsors;
}

@property (nonatomic, retain) SponsorsList *sponsors;

@end
