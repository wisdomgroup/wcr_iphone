//
//  SessionDetailTableViewController.h
//  WindyCityDB
//
//  Created by Stanley Fisher on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SessionDetailTableViewController : UITableViewController {
    UIImageView *speakerImageView;
    UIImage *speakerImage;
    
    UILabel *sessionTitleLabel;
    NSString *sessionTitle;
    
    UILabel *speakerNameLabel;
    NSString *speakerName;
    
    UILabel *speakerCompanyLabel;
    NSString *speakerCompany;
    
    NSString *sessionDescription;
    NSString *speakerBio;
}

@property (nonatomic, retain) IBOutlet UIImageView *speakerImageView;
@property (nonatomic, retain) UIImage *speakerImage;

@property (nonatomic, retain) IBOutlet UILabel *sessionTitleLabel;
@property (nonatomic, retain) NSString *sessionTitle;

@property (nonatomic, retain) IBOutlet UILabel *speakerNameLabel;
@property (nonatomic, retain) NSString *speakerName;

@property (nonatomic, retain) IBOutlet UILabel *speakerCompanyLabel;
@property (nonatomic, retain) NSString *speakerCompany;

@property (nonatomic, retain) NSString *sessionDescription;
@property (nonatomic, retain) NSString *speakerBio;

@end
