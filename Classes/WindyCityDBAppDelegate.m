//
//  WindyCityDBAppDelegate.m
//  WindyCityDB
//
//  Created by Stanley Fisher on 5/14/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "WindyCityDBAppDelegate.h"


@implementation WindyCityDBAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize sessionsController;
@synthesize sponsorsController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
    
    [sessionsController startLoadingDataAndNotify:self];

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

- (void)sessionsDidFinishLoading:(SessionsList*)sessions {
    [sponsorsController startLoadingDataAndNotify:sponsorsController];
    [sessionsController sessionsDidFinishLoading:sessions];
}

- (IBAction)aboutUsPressed:(id)sender {
    AboutUsViewController *aboutController = [[AboutUsViewController alloc] initWithNibName:@"AboutUsView" bundle:nil];
    [tabBarController presentModalViewController:aboutController animated:YES];
    [aboutController release];
}

@end

