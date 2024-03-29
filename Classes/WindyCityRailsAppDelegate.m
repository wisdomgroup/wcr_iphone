//
//  WindyCityRailsAppDelegate.m
//  WindyCityRails
//
//  Created by Stanley Fisher on 5/14/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "WindyCityRailsAppDelegate.h"
#import "ResourceLoading.h"


@implementation WindyCityRailsAppDelegate

@synthesize window;
@synthesize tabBarController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
    
    // Create a final modal view controller
    for (UINavigationController *nav in [tabBarController viewControllers]) {
        UIButton* modalViewButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        [modalViewButton setTitle:@"About Us" forState:UIControlStateNormal];
        [modalViewButton addTarget:self action:@selector(aboutUsPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *modalBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:modalViewButton];
        nav.visibleViewController.navigationItem.rightBarButtonItem = modalBarButtonItem;
        [modalBarButtonItem release];
    }
    
    return YES;
}


/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"sync (resign)");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"did become active");
    for (UINavigationController *nav in [tabBarController viewControllers]) {
        if ([nav.visibleViewController respondsToSelector:@selector(startLoadingDataAndNotify:)]) {
            [(id)nav.visibleViewController startLoadingDataAndNotify:(id)nav.visibleViewController];
        }
    }
    
}

- (IBAction)aboutUsPressed:(id)sender {
    AboutUsViewController *aboutController = [[AboutUsViewController alloc] initWithNibName:@"AboutUsView" bundle:nil];
    [tabBarController presentModalViewController:aboutController animated:YES];
    [aboutController release];
}
@end

