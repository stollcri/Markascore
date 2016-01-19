//
//  SportsTableViewController.h
//  Markascore
//
//  Created by Christopher Stoll on 1/10/16.
//  Copyright © 2016 Christopher Stoll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface SportsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) id currentSport;

@end
