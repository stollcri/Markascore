//
//  OptionsTableViewController.h
//  Markascore
//
//  Created by Christopher Stoll on 1/12/16.
//  Copyright © 2016 Christopher Stoll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Options.h"

@interface OptionsTableViewController : UITableViewController

@property (strong, nonatomic) Options *optionsDetail;

@property (weak, nonatomic) IBOutlet UITextField *txtTeamA;
@property (weak, nonatomic) IBOutlet UITextField *txtTeamB;

@property (weak, nonatomic) IBOutlet UISwitch *swtchDark;
@property (weak, nonatomic) IBOutlet UISwitch *swtchDim;

@end
