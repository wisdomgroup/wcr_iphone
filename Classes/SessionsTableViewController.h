//
//  ScheduleTableViewController.h
//  WindyCityDB
//
//  Created by Stanley Fisher on 5/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SessionsList.h"


@interface SessionsTableViewController : UITableViewController {
    SessionsList *sessions;
}

@property (nonatomic, retain) SessionsList *sessions;

- (void)sessionsDidFinishLoading:(SessionsList*)sessions;

@end

