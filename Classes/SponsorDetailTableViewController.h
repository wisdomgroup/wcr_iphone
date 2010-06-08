//
//  SponsorDetailTableViewController.h
//  WindyCityDB
//
//  Created by Stanley Fisher on 6/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SponsorDetailTableViewController : UITableViewController {
    UIView *logoImageViewContainer;
    UIImageView *logoImageView;
    UIImage *logo;
    NSString *name;
    NSString *description;
    NSURL *url;
}

@property (nonatomic, retain) IBOutlet UIView *logoImageViewContainer;
@property (nonatomic, retain) IBOutlet UIImageView *logoImageView;
@property (nonatomic, retain) UIImage *logo;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSURL *url;

@end
