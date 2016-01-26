//
//  SportsTableViewController.m
//  Markascore
//
//  Created by Christopher Stoll on 1/10/16.
//  Copyright © 2016 Christopher Stoll. All rights reserved.
//

#import "SportsTableViewController.h"
#import "SportTableViewController.h"
#import "Sport.h"

@interface SportsTableViewController ()

@end

@implementation SportsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    
    // Create a tutorial if there are not other MarkShows
    if ([self.tableView numberOfRowsInSection:0] <= 0) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
        
        Sport *moAcademicChallenge = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        moAcademicChallenge.name = @"🎓 Academic Challange 🎓";
        moAcademicChallenge.periodQuantity = @1;
        moAcademicChallenge.periodTime = @0;
        moAcademicChallenge.scoreTypeAname = @"Point";
        moAcademicChallenge.scoreTypeApoints = @10;
        moAcademicChallenge.scoreTypeBname = @"Bonus";
        moAcademicChallenge.scoreTypeBpoints = @5;
        moAcademicChallenge.scoreTypeCname = @"";
        moAcademicChallenge.scoreTypeCpoints = @0;
        moAcademicChallenge.scoreTypeDname = @"";
        moAcademicChallenge.scoreTypeDpoints = @0;
        moAcademicChallenge.scoreTypeEname = @"Point";
        moAcademicChallenge.scoreTypeEpoints = @10;
        moAcademicChallenge.scoreTypeFname = @"Bonus";
        moAcademicChallenge.scoreTypeFpoints = @5;
        moAcademicChallenge.periodTimeUp = @NO;
        moAcademicChallenge.periodTimeUpCum = @NO;
        
        Sport *moSoccer = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        moSoccer.name = @"⚽️ Soccer ⚽️";
        moSoccer.periodQuantity = @2;
        moSoccer.periodTime = @45;
        moSoccer.scoreTypeAname = @"Goal";
        moSoccer.scoreTypeApoints = @1;
        moSoccer.scoreTypeBname = @"PK";
        moSoccer.scoreTypeBpoints = @1;
        moSoccer.scoreTypeCname = @"";
        moSoccer.scoreTypeCpoints = @0;
        moSoccer.scoreTypeDname = @"";
        moSoccer.scoreTypeDpoints = @0;
        moSoccer.scoreTypeEname = @"Goal";
        moSoccer.scoreTypeEpoints = @1;
        moSoccer.scoreTypeFname = @"PK";
        moSoccer.scoreTypeFpoints = @1;
        moSoccer.periodTimeUp = @YES;
        moSoccer.periodTimeUpCum = @YES;
        
        Sport *moFutsal = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        moFutsal.name = @"⚽️ Futsal ⚽️";
        moFutsal.periodQuantity = @2;
        moFutsal.periodTime = @20;
        moFutsal.scoreTypeAname = @"Goal";
        moFutsal.scoreTypeApoints = @1;
        moFutsal.scoreTypeBname = @"";
        moFutsal.scoreTypeBpoints = @0;
        moFutsal.scoreTypeCname = @"";
        moFutsal.scoreTypeCpoints = @0;
        moFutsal.scoreTypeDname = @"";
        moFutsal.scoreTypeDpoints = @0;
        moFutsal.scoreTypeEname = @"Goal";
        moFutsal.scoreTypeEpoints = @1;
        moFutsal.scoreTypeFname = @"PK";
        moFutsal.scoreTypeFpoints = @1;
        moFutsal.periodTimeUp = @YES;
        moFutsal.periodTimeUpCum = @YES;
        
        Sport *moBaseball = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        moBaseball.name = @"⚾️ Baseball ⚾️";
        moBaseball.periodQuantity = @11;
        moBaseball.periodTime = @0;
        moBaseball.scoreTypeAname = @"Run";
        moBaseball.scoreTypeApoints = @1;
        moBaseball.scoreTypeBname = @"";
        moBaseball.scoreTypeBpoints = @0;
        moBaseball.scoreTypeCname = @"";
        moBaseball.scoreTypeCpoints = @0;
        moBaseball.scoreTypeDname = @"";
        moBaseball.scoreTypeDpoints = @0;
        moBaseball.scoreTypeEname = @"Run";
        moBaseball.scoreTypeEpoints = @1;
        moBaseball.scoreTypeFname = @"";
        moBaseball.scoreTypeFpoints = @0;
        moBaseball.periodTimeUp = @NO;
        moBaseball.periodTimeUpCum = @NO;
        
        Sport *moBasketball = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        moBasketball.name = @"🏀 Basketball 🏀";
        moBasketball.periodQuantity = @4;
        moBasketball.periodTime = @12;
        moBasketball.scoreTypeAname = @"Basket";
        moBasketball.scoreTypeApoints = @2;
        moBasketball.scoreTypeBname = @"3 points";
        moBasketball.scoreTypeBpoints = @3;
        moBasketball.scoreTypeCname = @"Foul";
        moBasketball.scoreTypeCpoints = @1;
        moBasketball.scoreTypeDname = @"";
        moBasketball.scoreTypeDpoints = @0;
        moBasketball.scoreTypeEname = @"2";
        moBasketball.scoreTypeEpoints = @2;
        moBasketball.scoreTypeFname = @"1";
        moBasketball.scoreTypeFpoints = @1;
        moBasketball.periodTimeUp = @NO;
        moBasketball.periodTimeUpCum = @NO;
        
        Sport *moFootball = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        moFootball.name = @"🏈 Football 🏈";
        moFootball.periodQuantity = @4;
        moFootball.periodTime = @15;
        moFootball.scoreTypeAname = @"TD";
        moFootball.scoreTypeApoints = @6;
        moFootball.scoreTypeBname = @"FG";
        moFootball.scoreTypeBpoints = @3;
        moFootball.scoreTypeCname = @"PAT";
        moFootball.scoreTypeCpoints = @1;
        moFootball.scoreTypeDname = @"2PC";
        moFootball.scoreTypeDpoints = @2;
        moFootball.scoreTypeEname = @"3";
        moFootball.scoreTypeEpoints = @3;
        moFootball.scoreTypeFname = @"1";
        moFootball.scoreTypeFpoints = @1;
        moFootball.periodTimeUp = @NO;
        moFootball.periodTimeUpCum = @NO;
        
        Sport *moPingPong = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        moPingPong.name = @"🏓 Table Tennis 🏓";
        moPingPong.periodQuantity = @1;
        moPingPong.periodTime = @0;
        moPingPong.scoreTypeAname = @"Point";
        moPingPong.scoreTypeApoints = @1;
        moPingPong.scoreTypeBname = @"";
        moPingPong.scoreTypeBpoints = @0;
        moPingPong.scoreTypeCname = @"";
        moPingPong.scoreTypeCpoints = @0;
        moPingPong.scoreTypeDname = @"";
        moPingPong.scoreTypeDpoints = @0;
        moPingPong.scoreTypeEname = @"Point";
        moPingPong.scoreTypeEpoints = @1;
        moPingPong.scoreTypeFname = @"";
        moPingPong.scoreTypeFpoints = @0;
        moPingPong.periodTimeUp = @NO;
        moPingPong.periodTimeUpCum = @NO;
        
        Sport *moRugby = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        moRugby.name = @"🏉 Rugby 🏉";
        moRugby.periodQuantity = @2;
        moRugby.periodTime = @40;
        moRugby.scoreTypeAname = @"Try";
        moRugby.scoreTypeApoints = @5;
        moRugby.scoreTypeBname = @"Goal Kick";
        moRugby.scoreTypeBpoints = @3;
        moRugby.scoreTypeCname = @"Conv";
        moRugby.scoreTypeCpoints = @2;
        moRugby.scoreTypeDname = @"";
        moRugby.scoreTypeDpoints = @0;
        moRugby.scoreTypeEname = @"3";
        moRugby.scoreTypeEpoints = @3;
        moRugby.scoreTypeFname = @"1";
        moRugby.scoreTypeFpoints = @1;
        moRugby.periodTimeUp = @NO;
        moRugby.periodTimeUpCum = @NO;
        
        Sport *moVolleyball = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        moVolleyball.name = @"🏐 Volleyball 🏐";
        moVolleyball.periodQuantity = @5;
        moVolleyball.periodTime = @0;
        moVolleyball.scoreTypeAname = @"Point";
        moVolleyball.scoreTypeApoints = @1;
        moVolleyball.scoreTypeBname = @"";
        moVolleyball.scoreTypeBpoints = @0;
        moVolleyball.scoreTypeCname = @"";
        moVolleyball.scoreTypeCpoints = @0;
        moVolleyball.scoreTypeDname = @"";
        moVolleyball.scoreTypeDpoints = @0;
        moVolleyball.scoreTypeEname = @"Point";
        moVolleyball.scoreTypeEpoints = @1;
        moVolleyball.scoreTypeFname = @"";
        moVolleyball.scoreTypeFpoints = @0;
        moVolleyball.periodTimeUp = @NO;
        moVolleyball.periodTimeUpCum = @NO;
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
#ifdef DEBUG
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
#endif
            abort();
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    
    Sport *moSoccer = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    moSoccer.name = @"Sport Name";
    moSoccer.periodQuantity = @4;
    moSoccer.periodTime = @15;
    moSoccer.scoreTypeAname = @"Goal";
    moSoccer.scoreTypeApoints = @1;
    moSoccer.scoreTypeBname = @"";
    moSoccer.scoreTypeBpoints = @0;
    moSoccer.scoreTypeCname = @"";
    moSoccer.scoreTypeCpoints = @0;
    moSoccer.scoreTypeDname = @"";
    moSoccer.scoreTypeDpoints = @0;
    moSoccer.periodTimeUp = @NO;
    moSoccer.periodTimeUpCum = @NO;
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
#ifdef DEBUG
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
#endif
        abort();
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    if (self.editing) {
        return [sectionInfo numberOfObjects] + 1;
    } else {
        return [sectionInfo numberOfObjects];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == [[self.fetchedResultsController sections][0] numberOfObjects]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"addCell" forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"sportCell" forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
    }
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [[self.fetchedResultsController sections][0] numberOfObjects]) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    if(editing) {
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[[self.fetchedResultsController sections][0] numberOfObjects] inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
    } else {
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[[self.fetchedResultsController sections][0] numberOfObjects] inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
        // place here anything else to do when the done button is clicked
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if ([[self.fetchedResultsController sections][0] numberOfObjects] > 1) {
        return YES;
    } else {
        if (indexPath.row == [[self.fetchedResultsController sections][0] numberOfObjects]) {
            return YES;
        } else {
            return NO;
        }
    }
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
#ifdef DEBUG
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
#endif
        }
        // Handled in setEditing
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self insertNewObject:self];
    }
}

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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    self.currentSport = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    if ([[segue identifier] isEqualToString:@"showSport"]){
        [[segue destinationViewController] setSportDetail:self.currentSport];
        [[segue destinationViewController] setHasWatch:self.hasWatch];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
#ifdef DEBUG
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
#endif
        abort();
    }
    
    self.currentSport = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"showHome" sender:self];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sport" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
#ifdef DEBUG
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
#endif
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            break;
            
        case NSFetchedResultsChangeMove:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Sport *thisSport = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = thisSport.name;
}

@end
