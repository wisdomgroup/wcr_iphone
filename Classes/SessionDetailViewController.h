//
//  SessionDetailViewController.h
//  WindyCityRails
//
//  Created by Justin Love on 2010-08-31.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SessionDetailTableViewController.h"

#import <UIKit/UIKit.h>

@interface SessionDetailViewController : UIViewController <UIActionSheetDelegate> {
    SessionDetailTableViewController *tableViewController;
    
    NSString *sessionTimes;
    
    NSString *speakerWebsite;
    NSString *speakerTwitter;
    NSString *slidesURL;
    NSString *rateURL;
    NSString *videoURL;
}

@property (nonatomic, retain) SessionDetailTableViewController *tableViewController;

@property (nonatomic, retain) NSString *sessionTimes;

@property (nonatomic, retain) NSString *speakerWebsite;
@property (nonatomic, retain) NSString *speakerTwitter;
@property (nonatomic, retain) NSString *slidesURL;
@property (nonatomic, retain) NSString *rateURL;
@property (nonatomic, retain) NSString *videoURL;

- (void)openURL:(NSString *)path;
- (NSString*)urlFor:(NSString *)title;
- (void)addButton:(NSString *)title toActionSheet:(UIActionSheet *)actionSheet;

- (IBAction)videoPressed:(id)sender;
- (IBAction)linksPressed:(id)sender;

@end
