//
//  SessionDetailViewController.m
//  WindyCityDB
//
//  Created by Stanley Fisher on 6/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SessionDetailViewController.h"


@implementation SessionDetailViewController

@synthesize speakerImageView, speakerImage;
@synthesize sessionTitleLabel, sessionTitle;
@synthesize speakerNameLabel, speakerName;
@synthesize speakerCompanyLabel, speakerCompany;
@synthesize sessionDescriptionTextView, sessionDescription;
@synthesize speakerBioTextView, speakerBio;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    speakerImageView.image = speakerImage;
    sessionTitleLabel.text = sessionTitle;
    speakerNameLabel.text = speakerName;
    speakerCompanyLabel.text = speakerCompany;
    sessionDescriptionTextView.text = sessionDescription;
    speakerBioTextView.text = speakerBio;
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
}


- (void)dealloc {
    [speakerImageView release];
    [speakerImage release];
    
    [sessionTitleLabel release];
    [sessionTitle release];
    
    [speakerNameLabel release];
    [speakerName release];
    
    [speakerCompanyLabel release];
    [speakerCompany release];
    
    [sessionDescriptionTextView release];
    [sessionDescription release];
    
    [speakerBioTextView release];
    [speakerBio release];
    
    [super dealloc];
}


@end
