//
//  AllTaskTableViewController.h
//  Tisk Task 2
//
//  Created by Jordan Zucker on 11/11/11.
//  Copyright (c) 2011 University of Illinois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskInfo.h"
#import "AddViewController.h"
#import "DetailViewController.h"


@interface AllTaskTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, AddViewControllerDelegate>
{
    NSManagedObjectContext *managedObjectContext;
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *addingManagedObjectContext;
}

@property (nonatomic, retain) NSManagedObjectContext *addingManagedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (IBAction) addTask;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (IBAction)todaySwitchValueChanged:(id)sender;

- (void) scheduleReminder:(TaskInfo *)taskInfo;

- (void) cancelReminder:(TaskInfo *)taskInfo;


@end
