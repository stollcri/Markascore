//
//  SportTableViewController.h
//  Markascore
//
//  Created by Christopher Stoll on 1/11/16.
//  Copyright © 2016 Christopher Stoll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sport.h"

@interface SportTableViewController : UITableViewController

@property (strong, nonatomic) Sport *sportDetail;
@property (strong, nonatomic) NSNumber *hasWatch;

@property (weak, nonatomic) IBOutlet UITextField *txtSportName;

@property (weak, nonatomic) IBOutlet UITextField *txtPeriodNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtPeriodMinutes;
@property (weak, nonatomic) IBOutlet UISwitch *swtchCountUp;
@property (weak, nonatomic) IBOutlet UISwitch *swtchCountCum;

@property (weak, nonatomic) IBOutlet UITextField *txtScoreAname;
@property (weak, nonatomic) IBOutlet UITextField *txtScoreApoints;

@property (weak, nonatomic) IBOutlet UITextField *txtScoreBname;
@property (weak, nonatomic) IBOutlet UITextField *txtScoreBpoints;

@property (weak, nonatomic) IBOutlet UITextField *txtScoreCname;
@property (weak, nonatomic) IBOutlet UITextField *txtScoreCpoints;

@property (weak, nonatomic) IBOutlet UITextField *txtScoreDname;
@property (weak, nonatomic) IBOutlet UITextField *txtScoreDpoints;

@property (weak, nonatomic) IBOutlet UITextField *txtScoreEname;
@property (weak, nonatomic) IBOutlet UITextField *txtScoreEpoints;

@property (weak, nonatomic) IBOutlet UITextField *txtScoreFname;
@property (weak, nonatomic) IBOutlet UITextField *txtScoreFpoints;

@property (weak, nonatomic) IBOutlet UITextField *txtScoreGname;
@property (weak, nonatomic) IBOutlet UITextField *txtScoreGpoints;

- (IBAction)countUpEnable:(id)sender;

@end
