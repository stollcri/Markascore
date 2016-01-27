//
//  SportTableViewController.m
//  Markascore
//
//  Created by Christopher Stoll on 1/11/16.
//  Copyright © 2016 Christopher Stoll. All rights reserved.
//

#import "SportTableViewController.h"

@interface SportTableViewController ()

@end

@implementation SportTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Update the user interface for the detail item.
    if (self.sportDetail) {
        [self.txtSportName setText:self.sportDetail.name];
        //[self.sportDetail becomeFirstResponder];
        
        [self.txtPeriodNumber setText:[self.sportDetail.periodQuantity stringValue]];
        [self.txtPeriodMinutes setText:[self.sportDetail.periodTime stringValue]];
        
        if ([self.sportDetail.periodTimeUp boolValue]) {
            [self.swtchCountUp setOn:YES];
            
            [self.swtchCountCum setEnabled:YES];
            if ([self.sportDetail.periodTimeUpCum boolValue]) {
                [self.swtchCountCum setOn:YES];
            } else {
                [self.swtchCountCum setOn:NO];
            }
        } else {
            [self.swtchCountUp setOn:NO];
            [self.swtchCountCum setOn:NO];
            [self.swtchCountCum setEnabled:NO];
        }

        [self.txtScoreAname setText:self.sportDetail.scoreTypeAname];
        [self.txtScoreApoints setText:[self.sportDetail.scoreTypeApoints stringValue]];
        
        [self.txtScoreBname setText:self.sportDetail.scoreTypeBname];
        [self.txtScoreBpoints setText:[self.sportDetail.scoreTypeBpoints stringValue]];
        
        [self.txtScoreCname setText:self.sportDetail.scoreTypeCname];
        [self.txtScoreCpoints setText:[self.sportDetail.scoreTypeCpoints stringValue]];
        
        [self.txtScoreDname setText:self.sportDetail.scoreTypeDname];
        [self.txtScoreDpoints setText:[self.sportDetail.scoreTypeDpoints stringValue]];
        
        if (self.hasWatch) {
            [self.txtScoreEname setText:self.sportDetail.scoreTypeEname];
            [self.txtScoreEpoints setText:[self.sportDetail.scoreTypeEpoints stringValue]];
            
            [self.txtScoreFname setText:self.sportDetail.scoreTypeFname];
            [self.txtScoreFpoints setText:[self.sportDetail.scoreTypeFpoints stringValue]];
            
            [self.txtScoreGname setText:self.sportDetail.scoreTypeGname];
            [self.txtScoreGpoints setText:[self.sportDetail.scoreTypeGpoints stringValue]];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self saveSportDetails];
    [super viewWillDisappear:animated];
}

- (void)saveSportDetails {
    if (self.sportDetail) {
        // Make sure the sport has a name
        if ([[self.txtSportName text] length]) {
            self.sportDetail.name = [self.txtSportName text];
        } else {
            self.sportDetail.name = @"Sport Name";
        }
        
        self.sportDetail.periodQuantity = [NSNumber numberWithInt:[[self.txtPeriodNumber text] intValue]];
        self.sportDetail.periodTime = [NSNumber numberWithInt:[[self.txtPeriodMinutes text] intValue]];
        
        if ([self.swtchCountUp isOn]) {
            self.sportDetail.periodTimeUp = @YES;
        } else {
            self.sportDetail.periodTimeUp = @NO;
        }
        
        if ([self.swtchCountCum isOn]) {
            self.sportDetail.periodTimeUpCum = @YES;
        } else {
            self.sportDetail.periodTimeUpCum = @NO;
        }
        
        self.sportDetail.scoreTypeAname = [self.txtScoreAname text];
        self.sportDetail.scoreTypeApoints = [NSNumber numberWithInt:[[self.txtScoreApoints text] intValue]];
        
        self.sportDetail.scoreTypeBname = [self.txtScoreBname text];
        self.sportDetail.scoreTypeBpoints = [NSNumber numberWithInt:[[self.txtScoreBpoints text] intValue]];
        
        self.sportDetail.scoreTypeCname = [self.txtScoreCname text];
        self.sportDetail.scoreTypeCpoints = [NSNumber numberWithInt:[[self.txtScoreCpoints text] intValue]];
        
        self.sportDetail.scoreTypeDname = [self.txtScoreDname text];
        self.sportDetail.scoreTypeDpoints = [NSNumber numberWithInt:[[self.txtScoreDpoints text] intValue]];
        
        self.sportDetail.scoreTypeEname = [self.txtScoreEname text];
        self.sportDetail.scoreTypeEpoints = [NSNumber numberWithInt:[[self.txtScoreEpoints text] intValue]];
        
        self.sportDetail.scoreTypeFname = [self.txtScoreFname text];
        self.sportDetail.scoreTypeFpoints = [NSNumber numberWithInt:[[self.txtScoreFpoints text] intValue]];
        
        self.sportDetail.scoreTypeGname = [self.txtScoreGname text];
        self.sportDetail.scoreTypeGpoints = [NSNumber numberWithInt:[[self.txtScoreGpoints text] intValue]];
        
        // Make sure there is one way to score (because no text, no button)
        if (![[self.txtScoreAname text] length] && ![[self.txtScoreBname text] length] && ![[self.txtScoreCname text] length] && ![[self.txtScoreDname text] length]) {
            self.sportDetail.scoreTypeAname = @"Point";
            
            // Make sure there is a point value for the only button
            if (![[self.txtScoreApoints text] intValue]) {
                self.sportDetail.scoreTypeApoints = @1;
            }
        }
    }
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)countUpEnable:(id)sender {
    if ([self.swtchCountUp isOn]) {
        [self.swtchCountCum setEnabled:YES];
    } else {
        [self.swtchCountCum setOn:NO];
        [self.swtchCountCum setEnabled:NO];
    }

}

@end
