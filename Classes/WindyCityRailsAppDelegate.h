//
//  WindyCityRailsAppDelegate.h
//  WindyCityRails
//
//  Created by Stanley Fisher on 5/14/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AboutUsViewController.h"

@interface WindyCityRailsAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

- (IBAction)aboutUsPressed:(id)sender;

@end
