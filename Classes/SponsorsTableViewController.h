//
//  SponsorsTableViewController.h
//  WindyCityRails
//
//  Created by Stanley Fisher on 5/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SponsorsList.h"
#import "ResourceLoading.h"


@interface SponsorsTableViewController : UITableViewController <SponsorsListObserver, MasterResourceLoading> {
    SponsorsList *sponsors;
    
    UIActivityIndicatorView *spinner;
}

@property (nonatomic, retain) SponsorsList *sponsors;

- (void)startLoadingDataAndNotify:(id<SponsorsListObserver>) party;

@end
