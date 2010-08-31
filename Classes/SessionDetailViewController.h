//
//  SessionDetailViewController.h
//  WindyCityRails
//
//  Created by Justin Love on 2010-08-31.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SessionDetailTableViewController.h"

#import <UIKit/UIKit.h>

@interface SessionDetailViewController : UIViewController {
    SessionDetailTableViewController *tableViewController;
}

@property (nonatomic, retain) SessionDetailTableViewController *tableViewController;

@end
