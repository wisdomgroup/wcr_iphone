//
//  SessionDetailTableViewController.h
//  WindyCityRails
//
//  Created by Stanley Fisher on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SessionDetailTableViewController : UITableViewController {
    UIImageView *speakerImageView1;
    UIImageView *speakerImageView2;
    NSMutableArray *speakerImages;
    
    NSString *sessionTimes;

    UILabel *sessionTitleLabel;
    NSString *sessionTitle;
    
    UILabel *speakerNameLabel;
    NSString *speakerName;
    
    UILabel *speakerCompanyLabel;
    NSString *speakerCompany;
    
    NSString *sessionDescription;
    NSString *speakerBio;
}

@property (nonatomic, retain) IBOutlet UIImageView *speakerImageView1;
@property (nonatomic, retain) IBOutlet UIImageView *speakerImageView2;
@property (nonatomic, retain) NSMutableArray* speakerImages;

@property (nonatomic, retain) NSString *sessionTimes;

@property (nonatomic, retain) IBOutlet UILabel *sessionTitleLabel;
@property (nonatomic, retain) NSString *sessionTitle;

@property (nonatomic, retain) IBOutlet UILabel *speakerNameLabel;
@property (nonatomic, retain) NSString *speakerName;

@property (nonatomic, retain) IBOutlet UILabel *speakerCompanyLabel;
@property (nonatomic, retain) NSString *speakerCompany;

@property (nonatomic, retain) NSString *sessionDescription;
@property (nonatomic, retain) NSString *speakerBio;

@property (nonatomic, readonly) NSUInteger numberOfSpeakers;

- (void)setUpSpeaker:(UIImageView*)speakerImageView withImage:(UIImage*)speakerImage;
- (void)setUpDescription:(UILabel*)label withText:(NSString*)text;
- (UITableViewCell *)tableView:(UITableView *)tableView sessionCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView speakerCellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
