//
//  ScheduleTableViewController.h
//  WindyCityRails
//
//  Created by Stanley Fisher on 5/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SessionsList.h"
#import "ResourceLoading.h"


@interface SessionsTableViewController : UITableViewController <SessionsListObserver, MasterResourceLoading> {
    SessionsList *sessions;
    
    UIActivityIndicatorView *spinner;
}

@property (nonatomic, retain) SessionsList *sessions;

- (void)startLoadingDataAndNotify:(id<SessionsListObserver>) party;

@end

