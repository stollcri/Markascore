//
//  OptionsTableViewController.m
//  Markascore
//
//  Created by Christopher Stoll on 1/12/16.
//  Copyright © 2016 Christopher Stoll. All rights reserved.
//

#import "OptionsTableViewController.h"

@interface OptionsTableViewController ()

@end

@implementation OptionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.txtTeamA setText:self.optionsDetail.teamA];
    [self.txtTeamB setText:self.optionsDetail.teamB];
    
    if ([self.optionsDetail.theme boolValue]) {
        [self.swtchDark setOn:YES];
    } else {
        [self.swtchDark setOn:NO];
    }
    
    if ([self.optionsDetail.preventSleep boolValue]) {
        [self.swtchDim setOn:YES];
    } else {
        [self.swtchDim setOn:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.optionsDetail.teamA = [self.txtTeamA text];
    self.optionsDetail.teamB = [self.txtTeamB text];
    
    if ([self.swtchDark isOn]) {
        self.optionsDetail.theme = @1;
    } else {
        self.optionsDetail.theme = @0;
    }
    
    if ([self.swtchDim isOn]) {
        self.optionsDetail.preventSleep = @YES;
    } else {
        self.optionsDetail.preventSleep = @NO;
    }
    
    [super viewWillDisappear:animated];
}

@end
