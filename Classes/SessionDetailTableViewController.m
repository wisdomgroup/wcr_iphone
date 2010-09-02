//
//  SessionDetailTableViewController.m
//  WindyCityRails
//
//  Created by Stanley Fisher on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SessionDetailTableViewController.h"

#define TEXT_TAG 1
#define HEADSHOT_TAG 2
#define SESSION_TEXT_WIDTH 300.0
#define SPEAKER_TEXT_WIDTH 190.0

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

NSUInteger sectionFromIndexPath(NSIndexPath *indexPath) {
    NSUInteger indexes[[indexPath length]];
    [indexPath getIndexes:indexes];
    return indexes[0];
}

NSUInteger speakerFromIndexPath(NSIndexPath *indexPath) {
    NSUInteger indexes[[indexPath length]];
    [indexPath getIndexes:indexes];
    return indexes[1];
}

@implementation SessionDetailTableViewController

@synthesize speakerImages;
@synthesize sessionTitleLabel, sessionTitle;
@synthesize speakerNameLabel, speakerName;
@synthesize speakerCompany;
@synthesize sessionDescription, speakerBio;

- (NSUInteger)numberOfSpeakers {
    if ([self.speakerName isEqualToString:@"Various Speakers"]) {
        return 0;
    } else {
        return [self.speakerImages count];
    }
}

#define SESSION_SECTION 0
#define SPEAKER_SECTION 1

- (NSString *)cellTextFromIndexPath:(NSIndexPath *)indexPath {
    if (sectionFromIndexPath(indexPath) == SPEAKER_SECTION) {
        if (self.numberOfSpeakers > 1) {
            return [[self.speakerBio componentsSeparatedByString:@"\n\n"] objectAtIndex:speakerFromIndexPath(indexPath)];
        } else {
            return self.speakerBio;
        }
    } else {
        return self.sessionDescription;
    }
}

- (void)setUpSpeaker:(UIImageView*)speakerImageView withImage:(UIImage*)speakerImage {
    speakerImageView.image = speakerImage;
    speakerImageView.layer.borderWidth = 0;
    speakerImageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    speakerImageView.layer.masksToBounds = YES;
    speakerImageView.layer.cornerRadius = 10.0;
}

- (void)setUpDescription:(UILabel*)label withText:(NSString*)text {
    label.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;  // use as many lines as needed
    label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    label.text = text;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView sessionCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SpeakerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        // Configure the cell...
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }    
    
    [self setUpDescription:cell.textLabel withText:[self cellTextFromIndexPath:indexPath]];
    
    return cell;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView speakerCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SessionCell";
    
    UILabel *label;
    UIImageView *imageView;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        // Configure the cell...
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        while ([[cell.contentView subviews] count] > 0) {
            UIView *labelToClear = [[cell.contentView subviews] objectAtIndex:0];
            [labelToClear removeFromSuperview];
        }
        
        label = [[[UILabel alloc] initWithFrame:CGRectMake(120.0, 0.0, SPEAKER_TEXT_WIDTH, 15.0)] autorelease];
        label.tag = TEXT_TAG;
        [cell.contentView addSubview:label];
        
        imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, 77.0, 77.0)] autorelease];
        imageView.tag = HEADSHOT_TAG;
        [cell.contentView addSubview:imageView];
    } else {
        label = (UILabel*)[cell.contentView viewWithTag:TEXT_TAG];
        imageView = (UIImageView*)[cell.contentView viewWithTag:HEADSHOT_TAG];
    }    
    
    [self setUpDescription:label withText:[self cellTextFromIndexPath:indexPath]];
    [self setUpSpeaker:imageView withImage:[speakerImages objectAtIndex:speakerFromIndexPath(indexPath)]];
    
    return cell;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    fitInLabel(sessionTitleLabel, sessionTitle, 20);
    if (self.numberOfSpeakers == 0) {
        speakerNameLabel.hidden = YES;
    } else {
        speakerNameLabel.text = [NSString stringWithFormat:@"%@, %@", speakerName, speakerCompany];
        speakerNameLabel.hidden = NO;
    }
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
    if (self.numberOfSpeakers == 0) {
        return 1;
    } else {
        return 2;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == SPEAKER_SECTION) {
        return self.numberOfSpeakers;
    } else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == SESSION_SECTION) {
        return @"Session Description";
    } else {
        if (self.numberOfSpeakers > 1) {
            return @"About the Speakers";
        } else {
            return @"About the Speaker";
        }
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (sectionFromIndexPath(indexPath) == SESSION_SECTION) {
        return [self tableView:tableView sessionCellForRowAtIndexPath:indexPath];
    } else {
        return [self tableView:tableView speakerCellForRowAtIndexPath:indexPath];
    }
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
    
    CGSize constraintSize;
    if (sectionFromIndexPath(indexPath) == SESSION_SECTION) {
        constraintSize = CGSizeMake(SESSION_TEXT_WIDTH, MAXFLOAT);
    } else {
        constraintSize = CGSizeMake(SPEAKER_TEXT_WIDTH, MAXFLOAT);
    }
    CGSize textSize = [cellText sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return (textSize.height + 40);
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
    [speakerImages release];
    
    [sessionTitleLabel release];
    [sessionTitle release];
    
    [speakerNameLabel release];
    [speakerName release];
    
    [speakerCompany release];
    
    [sessionDescription release];
    [speakerBio release];
    
    [super dealloc];
}


@end

