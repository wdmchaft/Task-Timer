//
//  AllTaskTableViewController.m
//  Tisk Task 2
//
//  Created by Jordan Zucker on 11/11/11.
//  Copyright (c) 2011 University of Illinois. All rights reserved.
//

#import "AllTaskTableViewController.h"

@implementation AllTaskTableViewController

@synthesize managedObjectContext;
@synthesize addingManagedObjectContext;
@synthesize fetchedResultsController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
	// Configure the add button.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTask)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.fetchedResultsController = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return 0;
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell to show the book's title
	TaskInfo *taskInfo = [fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = taskInfo.title;
    
    BOOL todayBOOL = [taskInfo.isToday boolValue];
    
    UISwitch *todaySwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    if (todayBOOL == YES) {
        [todaySwitch setOn:YES];
    }
    else
    {
        [todaySwitch setOn:NO];
    }
    [todaySwitch addTarget:self action:@selector(todaySwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    todaySwitch.tag = indexPath.row;
    cell.accessoryView = todaySwitch;
    [todaySwitch release];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		// Delete the managed object.
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		
		NSError *error;
		if (![context save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
    }
    /*
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
     */
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"selected row");
    // Create and push a detail view controller.
	DetailViewController *detailViewController = [[DetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    TaskInfo *selectedInfo = (TaskInfo *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    // Pass the selected book to the new view controller.
    detailViewController.taskInfo = selectedInfo;
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
     
}

#pragma mark -
#pragma mark Adding a Book

/**
 Creates a new book, an AddViewController to manage addition of the book, and a new managed object context for the add controller to keep changes made to the book discrete from the application's managed object context until the book is saved.
 IMPORTANT: It's not necessary to use a second context for this. You could just use the existing context, which would simplify some of the code -- you wouldn't need to merge changes after a save, for example. This implementation, though, illustrates a pattern that may sometimes be useful (where you want to maintain a separate set of edits).  The root view controller sets itself as the delegate of the add controller so that it can be informed when the user has completed the add operation -- either saving or canceling (see addViewController:didFinishWithSave:).
 */
- (IBAction)addTask {
	
    AddViewController *addViewController = [[AddViewController alloc] initWithStyle:UITableViewStyleGrouped];
	addViewController.delegate = self;
	
	// Create a new managed object context for the new book -- set its persistent store coordinator to the same as that from the fetched results controller's context.
	NSManagedObjectContext *addingContext = [[NSManagedObjectContext alloc] init];
	self.addingManagedObjectContext = addingContext;
	[addingContext release];
	
	[addingManagedObjectContext setPersistentStoreCoordinator:[[fetchedResultsController managedObjectContext] persistentStoreCoordinator]];
    
	addViewController.taskInfo = (TaskInfo *)[NSEntityDescription insertNewObjectForEntityForName:@"TaskInfo" inManagedObjectContext:addingContext];
    
    NSDate *today = [NSDate date];
    [addViewController.taskInfo setValue:today forKey:@"creationDate"];
    NSNumber *noBOOL = [NSNumber numberWithBool:NO];
    [addViewController.taskInfo setValue:noBOOL forKey:@"isCompleted"];
    
    
    
    /*
    NSManagedObject *taskDetails = [NSEntityDescription insertNewObjectForEntityForName:@"TaskDetails" inManagedObjectContext:addingContext];
    [taskDetails setValue:@"blah" forKey:@"specifics"];
    
    [taskDetails setValue:addViewController.taskInfo forKey:@"info"];
    [addViewController.taskInfo setValue:taskDetails forKey:@"details"];
     */
    
    //[addViewController.taskInfo setValue:<#(id)#> forKey:<#(NSString *)#>
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addViewController];
	
    [self.navigationController presentModalViewController:navController animated:YES];
	
	[addViewController release];
	[navController release];
}



/**
 Add controller's delegate method; informs the delegate that the add operation has completed, and indicates whether the user saved the new book.
 */

- (void)addViewController:(AddViewController *)controller didFinishWithSave:(BOOL)save {
	
	if (save) {
		/*
		 The new book is associated with the add controller's managed object context.
		 This is good because it means that any edits that are made don't affect the application's main managed object context -- it's a way of keeping disjoint edits in a separate scratchpad -- but it does make it more difficult to get the new book registered with the fetched results controller.
		 First, you have to save the new book.  This means it will be added to the persistent store.  Then you can retrieve a corresponding managed object into the application delegate's context.  Normally you might do this using a fetch or using objectWithID: -- for example
		 
		 NSManagedObjectID *newBookID = [controller.book objectID];
		 NSManagedObject *newBook = [applicationContext objectWithID:newBookID];
		 
		 These techniques, though, won't update the fetch results controller, which only observes change notifications in its context.
		 You don't want to tell the fetch result controller to perform its fetch again because this is an expensive operation.
		 You can, though, update the main context using mergeChangesFromContextDidSaveNotification: which will emit change notifications that the fetch results controller will observe.
		 To do this:
		 1	Register as an observer of the add controller's change notifications
		 2	Perform the save
		 3	In the notification method (addControllerContextDidSave:), merge the changes
		 4	Unregister as an observer
		 */
		NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
		[dnc addObserver:self selector:@selector(addControllerContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:addingManagedObjectContext];
		
		NSError *error;
		if (![addingManagedObjectContext save:&error]) 
        {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
		[dnc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:addingManagedObjectContext];
	}
	// Release the adding managed object context.
	self.addingManagedObjectContext = nil;
    
	// Dismiss the modal view to return to the main list
    [self dismissModalViewControllerAnimated:YES];
}



/**
 Notification from the add controller's context's save operation. This is used to update the fetched results controller's managed object context with the new book instead of performing a fetch (which would be a much more computationally expensive operation).
 */
- (void)addControllerContextDidSave:(NSNotification*)saveNotification {
	
	NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
	// Merging changes causes the fetched results controller to update its results
	[context mergeChangesFromContextDidSaveNotification:saveNotification];	
}


#pragma mark -
#pragma mark Fetched results controller

/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
	// Create and configure a fetch request with the Book entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskInfo" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isCompleted == %@", [NSNumber numberWithBool:NO]];
    [fetchRequest setPredicate:predicate];
    
	
	// Create the sort descriptors array.
	//NSSortDescriptor *authorDescriptor = [[NSSortDescriptor alloc] initWithKey:@"author" ascending:YES];
	NSSortDescriptor *titleDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:titleDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"All"];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	
	// Memory management.
	[aFetchedResultsController release];
	[fetchRequest release];
	//[authorDescriptor release];
	[titleDescriptor release];
	[sortDescriptors release];
	
	return fetchedResultsController;
}    


/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
	UITableView *tableView = self.tableView;
    
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
			break;
			
		case NSFetchedResultsChangeUpdate:
			[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[self.tableView endUpdates];
}
     
#pragma mark -
#pragma mark Today Switch
- (IBAction)todaySwitchValueChanged:(id)sender
{
    //NSLog(@"today switch value changed");
    UITableViewCell *cell = (UITableViewCell *) [sender superview];
    NSIndexPath *switchIndexPath = [self.tableView indexPathForCell:cell];

    //[self.tableView indexPathForCell:<#(UITableViewCell *)#>
    TaskInfo *selectedInfo = (TaskInfo *)[[self fetchedResultsController] objectAtIndexPath:switchIndexPath];
    //NSLog(@"selectedInfo is %@", selectedInfo);
    //NSLog(@"title is %@", selectedInfo.title);
    
    NSNumber *newToday;
    BOOL oldToday = [selectedInfo.isToday boolValue];
    if (oldToday == YES) {
        newToday = [NSNumber numberWithBool:NO];
        [self cancelReminder:selectedInfo];
    }
    else
    {
        newToday = [NSNumber numberWithBool:YES];
        [self scheduleReminder:selectedInfo];
    }
    
    [selectedInfo setValue:newToday forKey:@"isToday"];
    
    NSError *error;
    if (![managedObjectContext save:&error]) 
    {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    //NSLog(@"selectedInfo is now %@", selectedInfo);
    
    
    
    /*
    NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
    [dnc addObserver:self selector:@selector(addControllerContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:selectedInfo];
    
    NSError *error;
    if (![selectedInfo save:&error]) 
    {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    [dnc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:selectedInfo];
     */
    
}

#pragma mark -
#pragma mark Reminders

- (void) scheduleReminder:(TaskInfo *)taskInfo
{
    NSLog(@"scheduleReminder with %@", taskInfo);
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (localNotification == nil) {
        return;
    }
    
    /*
    need to figure out precisely when to fire timer, some factors:
     1. how much time left in day vs. how much time left in task
     2. time zone
     3. how many times have you been reminded? should i keep track of that? probably, but won't for now
     4. how long duration is in general. Remind more frequently for shorter tasks but can't take 3 hours to remind for a 3 hour task
     
     */
    double duration = [taskInfo.duration doubleValue];
    //double elapsed = [taskInfo.elapsedTime doubleValue];
    //double reminderTime = duration - elapsed;
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:duration];
    localNotification.fireDate = date;
    localNotification.alertBody = [NSString stringWithFormat:@"%@ still needs work today", taskInfo.title];
    localNotification.alertAction = @"Start Working";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber++;
    
    NSManagedObjectID *taskID = [taskInfo objectID];
    NSURL *taskURL = [taskID URIRepresentation];
    
    NSString *URLString = [taskURL absoluteString];
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:taskInfo.title, @"title", URLString, @"taskURLString", @"reminder", @"type", nil];
    
    
    localNotification.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    
    [localNotification release];
    
    
    
}

- (void) cancelReminder:(TaskInfo *)taskInfo
{
    NSLog(@"cancelReminder for %@", taskInfo);
    
    // need to disable notification for timer
    NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    UILocalNotification *notification = nil;
    for (notification in notificationArray) {
        NSString *title = [notification.userInfo objectForKey:@"title"];
        NSString *type = [notification.userInfo objectForKey:@"type"];
        //NSDate *endTime = [notification.userInfo objectForKey:@"endTime"];
        //if ((title == taskInfo.title) && (endTime == taskInfo.projectedEndTime))
        //check for notification type "alarm"
        if (([title isEqualToString:taskInfo.title]) && ([type isEqualToString:@"reminder"]))
        {
            //notification.applicationIconBadgeNumber--;
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            
            // **** do i need to release this notification???
        }
    }
    
    
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[fetchedResultsController release];
	[managedObjectContext release];
	[addingManagedObjectContext release];
    [super dealloc];
}


@end
