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
}

@property (nonatomic, retain) IBOutlet UIImageView *speakerImageView;
@property (nonatomic, retain) UIImage *speakerImage;

@end
