//
//  SessionDetailViewController.m
//  WindyCityRails
//
//  Created by Justin Love on 2010-08-31.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SessionDetailViewController.h"

static NSString *const speakerWebsiteTitle = @"Speaker Website";
static NSString *const speakerTwitterTitle = @"Speaker Twitter";
static NSString *const slideURLTitle = @"Slides";
static NSString *const rateURLTitle = @"Rate Speaker";

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

- (void)openURL:(NSString *)path {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];
}

- (NSString*)urlFor:(NSString *)title {
    if ([title isEqualToString:speakerWebsiteTitle]) {
        return speakerWebsite;
    } else if ([title isEqualToString:speakerTwitterTitle]) {
        return speakerTwitter;
    } else if ([title isEqualToString:slideURLTitle]) {
        return slidesURL;
    } else if ([title isEqualToString:rateURLTitle]) {
        return rateURL;
    } else {
        return nil;
    }
}

- (void)addButton:(NSString *)title toActionSheet:(UIActionSheet *)actionSheet {
    if ([[self urlFor:title] length] > 0) {
        [actionSheet addButtonWithTitle:title];
    }
}

- (IBAction)videoPressed:(id)sender {
    if ([videoURL length] > 0) {
        [self openURL:videoURL];
    } else {
        /* open an alert with an OK button */
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Stay tuned!" 
                                                        message:@"WindyCityRails session videos will be available in late September."
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (IBAction)linksPressed:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc]
                            initWithTitle:@"Links"
                            delegate:self
                            cancelButtonTitle:nil
                            destructiveButtonTitle:nil
                            otherButtonTitles:nil];
    [self addButton:speakerWebsiteTitle toActionSheet:sheet];
    [self addButton:speakerTwitterTitle toActionSheet:sheet];
    [self addButton:slideURLTitle toActionSheet:sheet];
    [self addButton:rateURLTitle toActionSheet:sheet];
    [sheet addButtonWithTitle:@"Cancel"];
    [sheet setCancelButtonIndex:[sheet numberOfButtons] - 1];
    [sheet showInView:self.view];
    [sheet release];
}

#pragma mark UIActionSheetDelegate delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self openURL:[self urlFor:[actionSheet buttonTitleAtIndex:buttonIndex]]];
}

@end
