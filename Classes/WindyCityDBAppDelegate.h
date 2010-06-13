//
//  WindyCityDBAppDelegate.h
//  WindyCityDB
//
//  Created by Stanley Fisher on 5/14/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SessionsTableViewController.h"
#import "SponsorsTableViewController.h"

@interface WindyCityDBAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, SessionsListObserver> {
    UIWindow *window;
    UITabBarController *tabBarController;
    SessionsTableViewController *sessionsController;
    SponsorsTableViewController *sponsorsController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet SessionsTableViewController *sessionsController;
@property (nonatomic, retain) IBOutlet SponsorsTableViewController *sponsorsController;

- (IBAction)aboutUsPressed:(id)sender;

@end
