//
//  SessionDetailViewController.h
//  WindyCityDB
//
//  Created by Stanley Fisher on 6/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionDetailViewController : UIViewController {
    UIImageView *speakerImageView;
    UIImage *speakerImage;
    
    UILabel *sessionTitleLabel;
    NSString *sessionTitle;
    
    UILabel *speakerNameLabel;
    NSString *speakerName;
    
    UILabel *speakerCompanyLabel;
    NSString *speakerCompany;
    
    UITextView *sessionDescriptionTextView;
    NSString *sessionDescription;
    
    UITextView *speakerBioTextView;
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

@property (nonatomic, retain) IBOutlet UITextView *sessionDescriptionTextView;
@property (nonatomic, retain) NSString *sessionDescription;

@property (nonatomic, retain) IBOutlet UITextView *speakerBioTextView;
@property (nonatomic, retain) NSString *speakerBio;

@end
