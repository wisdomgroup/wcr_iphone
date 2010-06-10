//
//  ScheduleTableViewController.m
//  WindyCityDB
//
//  Created by Stanley Fisher on 5/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SessionDetailTableViewController.h"
#import "SessionsList.h"
#import "SessionsTableViewController.h"

@implementation SessionsTableViewController

@synthesize sessions;

- (Session *)sessionFromIndexPath:(NSIndexPath *)indexPath {
    NSUInteger indexes[[indexPath length]];
    [indexPath getIndexes:indexes];
    return (Session *)[self.sessions.sessions objectAtIndex:indexes[0]];
}

- (void)sessionsDidFinishLoading:(SessionsList*)sessions {
    [(UITableView*)[self view] reloadData];
    [spinner stopAnimating];
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.sessions = [[SessionsList alloc] init];
    [sessions parseSessionsAtURL:@"http://windycitydb.org/sessions.xml" andNotify:self];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = [[self view] center];
    [spinner startAnimating];
    [[self view] addSubview:spinner];
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
    return [self.sessions.sessions count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return ((Session *)[self.sessions.sessions objectAtIndex:section]).startTime;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    Session *session = [self sessionFromIndexPath:indexPath];
    NSString *detailText = [NSString stringWithFormat:@"%@, %@", session.speaker.name, session.speaker.company];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = session.title;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;  // use as many lines as needed
    cell.detailTextLabel.text = detailText;
    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.detailTextLabel.numberOfLines = 0;
    
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
    Session *session = [self sessionFromIndexPath:indexPath];
    
    NSString *cellText = session.title;
    NSString *cellDetailText = [NSString stringWithFormat:@"%@, %@", session.speaker.name, session.speaker.company];
    
    CGSize constraintSize = CGSizeMake(tableView.bounds.size.width - 50, MAXFLOAT);
    CGSize textSize = [cellText sizeWithFont:[UIFont boldSystemFontOfSize:17.0] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    CGSize detailTextSize = [cellDetailText sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return (textSize.height + detailTextSize.height + 20);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Session *session = [self sessionFromIndexPath:indexPath];
    
    // Navigation logic may go here. Create and push another view controller.
    SessionDetailTableViewController *detailViewController = [[SessionDetailTableViewController alloc] initWithNibName:@"SessionDetailTableView" bundle:nil];
    detailViewController.speakerImage = session.speaker.headshot;
    detailViewController.sessionTitle = session.title;
    detailViewController.speakerName = session.speaker.name;
    detailViewController.speakerCompany = session.speaker.company;
    detailViewController.sessionDescription = session.description;
    detailViewController.speakerBio = session.speaker.bio;
    
    // Pass the selected object to the new view controller.
	[self.navigationController pushViewController:detailViewController animated:YES];

	[detailViewController release];
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
    [self.sessions release];
    
    [super dealloc];
}


@end

