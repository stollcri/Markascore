//
//  ViewController.h
//  Markascore
//
//  Created by Christopher Stoll on 1/9/16.
//  Copyright © 2016 Christopher Stoll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Options.h"
#import "Sport.h"
#import "Game.h"

@interface MainViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) Options *currentOptions;
@property (strong, nonatomic) Sport *currentSport;
@property (strong, nonatomic) Game *currentGame;

@property BOOL periodChanged;

@property (weak, nonatomic) IBOutlet UIButton *btnSport;

@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UIButton *btnPeriodOne;
@property (weak, nonatomic) IBOutlet UIButton *btnPeriodTwo;
@property (weak, nonatomic) IBOutlet UIButton *btnPeriodThree;
@property (weak, nonatomic) IBOutlet UIButton *btnPeriodFour;
@property (weak, nonatomic) IBOutlet UIButton *btnTimeForward;
@property (weak, nonatomic) IBOutlet UIButton *btnTimeBack;

@property (weak, nonatomic) IBOutlet UILabel *labUs;
@property (weak, nonatomic) IBOutlet UILabel *labUsScore;
@property (weak, nonatomic) IBOutlet UIButton *btnUsScoreA;
@property (weak, nonatomic) IBOutlet UIButton *btnUsScoreB;
@property (weak, nonatomic) IBOutlet UIButton *btnUsScoreC;
@property (weak, nonatomic) IBOutlet UIButton *btnUsScoreD;

@property (weak, nonatomic) IBOutlet UILabel *labThem;
@property (weak, nonatomic) IBOutlet UILabel *labThemScore;
@property (weak, nonatomic) IBOutlet UIButton *btnThemScoreA;
@property (weak, nonatomic) IBOutlet UIButton *btnThemScoreB;
@property (weak, nonatomic) IBOutlet UIButton *btnThemScoreC;
@property (weak, nonatomic) IBOutlet UIButton *btnThemScoreD;

@property (weak, nonatomic) IBOutlet UIButton *btnUndo;

- (IBAction)doShare:(id)sender;
- (IBAction)tchSport:(id)sender;

- (IBAction)tchPeriodOne:(id)sender;
- (IBAction)tchPeriodTwo:(id)sender;
- (IBAction)tchPeriodThree:(id)sender;
- (IBAction)tchPeriodFour:(id)sender;
- (IBAction)tchTimeForward:(id)sender;
- (IBAction)tchTimeBack:(id)sender;

- (IBAction)tchUsScoreA:(id)sender;
- (IBAction)tchUsScoreB:(id)sender;
- (IBAction)tchUsScoreC:(id)sender;
- (IBAction)tchUsScoreD:(id)sender;

- (IBAction)tchThemScoreA:(id)sender;
- (IBAction)tchThemScoreB:(id)sender;
- (IBAction)tchThemScoreC:(id)sender;
- (IBAction)tchThemScoreD:(id)sender;

- (IBAction)tchUndo:(id)sender;

@end

