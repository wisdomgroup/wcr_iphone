//
//  SessionDetailTableViewController.m
//  WindyCityRails
//
//  Created by Stanley Fisher on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SessionDetailTableViewController.h"


void fitInLabel(UILabel* label, NSString* text, int maximumFont) {
    // derived from http://www.iphonedevsdk.com/forum/iphone-sdk-development/7420-uilabel-text-size.html
    //  This is actually quite imperfect -
    //  it adjusts font size based on frame height, which is affected by word wrap.
    
    UIFont* normalFont = [UIFont boldSystemFontOfSize:maximumFont];
    CGRect frame = label.frame;
    frame.size.height = 3000.0; // just make sure it's big enough
    CGSize result = [text sizeWithFont:normalFont constrainedToSize:frame.size lineBreakMode:UILineBreakModeWordWrap];
    if (result.height > label.frame.size.height) {
        int newFontSize = (label.frame.size.height / result.height) * (float)maximumFont;
        label.font = [UIFont boldSystemFontOfSize:newFontSize];
    } else {
        label.font = normalFont;
    }

    label.text = text;
}

@implementation SessionDetailTableViewController

@synthesize speakerImageView1;
@synthesize speakerImageView2;
@synthesize speakerImages;
@synthesize sessionTimes;
@synthesize sessionTitleLabel, sessionTitle;
@synthesize speakerNameLabel, speakerName;
@synthesize speakerCompanyLabel, speakerCompany;
@synthesize sessionDescription, speakerBio;


- (NSString *)cellTextFromIndexPath:(NSIndexPath *)indexPath {
    NSUInteger indexes[[indexPath length]];
    [indexPath getIndexes:indexes];
    if (indexes[0] == 0) {
        return self.sessionDescription;
    }
    else {
        return self.speakerBio;
    }

}

- (void)setUpSpeaker:(UIImageView*)speakerImageView withImage:(UIImage*)speakerImage {
    speakerImageView.image = speakerImage;
    speakerImageView.layer.borderWidth = 1;
    speakerImageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    speakerImageView.layer.masksToBounds = YES;
    speakerImageView.layer.cornerRadius = 10.0;
}

- (void)setUpDescription:(UILabel*)label withText:(NSString*)text {
    label.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;  // use as many lines as needed
    label.text = text;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = sessionTimes;

    if ([speakerImages count] >= 1) {
        [self setUpSpeaker: speakerImageView1 withImage:[speakerImages objectAtIndex:0]];
        speakerImageView1.hidden = NO;
    } else {
        speakerImageView1.hidden = YES;
    }


    fitInLabel(sessionTitleLabel, sessionTitle, 17);
    if ([speakerName isEqualToString:@"Various Speakers"]) {
        speakerNameLabel.hidden = YES;
        speakerCompanyLabel.hidden = YES;
    } else {
        speakerNameLabel.text = speakerName;
        speakerNameLabel.hidden = NO;
        speakerCompanyLabel.text = speakerCompany;
        speakerNameLabel.hidden = NO;
    }

    CGRect bounds = sessionTitleLabel.superview.bounds;
    CGRect titleFrame = sessionTitleLabel.frame;
    if ([speakerImages count] < 2) {
        bounds.size.height = 141;
        speakerImageView2.hidden = YES;
        titleFrame.size.width = 195;
        titleFrame.origin.x = speakerImageView2.frame.origin.x;
        titleFrame.origin.y = speakerImageView1.frame.origin.y;
    } else {
        bounds.size.height = 200;
        [self setUpSpeaker: speakerImageView2 withImage:[speakerImages objectAtIndex:1]];
        speakerImageView2.hidden = NO;
        titleFrame.size.width = speakerNameLabel.frame.size.width;
        titleFrame.origin.x = speakerNameLabel.frame.origin.x;
        titleFrame.origin.y = speakerImageView1.frame.origin.y + speakerImageView1.frame.size.height;
    }
    sessionTitleLabel.superview.bounds = bounds;
    sessionTitleLabel.frame = titleFrame;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if ([speakerName isEqualToString:@"Various Speakers"]) {
        return 1;
    } else {
        return 2;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Session Description";
    }
    else {
        return @"About the Speaker";
    }

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UILabel *label = cell.textLabel;
    [self setUpDescription:label withText:[self cellTextFromIndexPath:indexPath]];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellText = [self cellTextFromIndexPath:indexPath];
    
    CGSize constraintSize = CGSizeMake(tableView.bounds.size.width - 40, MAXFLOAT);
    CGSize textSize = [cellText sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return (textSize.height + 20);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [speakerImageView1 release];
    [speakerImageView2 release];
    [speakerImages release];
    
    [sessionTitleLabel release];
    [sessionTitle release];
    
    [speakerNameLabel release];
    [speakerName release];
    
    [speakerCompanyLabel release];
    [speakerCompany release];
    
    [sessionDescription release];
    [speakerBio release];
    
    [super dealloc];
}


@end

