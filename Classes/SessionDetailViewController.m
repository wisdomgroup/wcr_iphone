//
//  SessionDetailViewController.m
//  WindyCityRails
//
//  Created by Justin Love on 2010-08-31.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SessionDetailViewController.h"


@implementation SessionDetailViewController

@synthesize tableViewController;

@synthesize speakerWebsite;
@synthesize speakerTwitter;
@synthesize slidesURL;
@synthesize rateURL;
@synthesize videoURL;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.tableViewController = [[SessionDetailTableViewController alloc] initWithNibName:@"SessionDetailTableView" bundle:nil];
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [[self view] insertSubview:[tableViewController view] atIndex:0];
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.tableViewController = nil;
}


- (void)dealloc {
    [tableViewController release];
    [super dealloc];
}

- (IBAction)videoPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:videoURL]];
}

@end
