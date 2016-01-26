//
//  ViewController.m
//  Markascore
//
//  Created by Christopher Stoll on 1/9/16.
//  Copyright © 2016 Christopher Stoll. All rights reserved.
//

#import "MainViewController.h"
//#import <WatchConnectivity/WatchConnectivity.h>
#import "SportsTableViewController.h"
#import "OptionsTableViewController.h"

@interface MainViewController () {
    @private NSUndoManager *undoManager;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Fetch options data
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *optionsEntity = [NSEntityDescription entityForName:@"Options" inManagedObjectContext:context];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:optionsEntity];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetch error:&error];
    if ([fetchedObjects count] == 1) {
        self.currentOptions = [fetchedObjects objectAtIndex:0];
    } else {
        // Fill game entity with dummy data
        Options *moOptions = [NSEntityDescription insertNewObjectForEntityForName:[optionsEntity name] inManagedObjectContext:context];
        moOptions.teamA = @"HOME";
        moOptions.teamB = @"GUEST";
        moOptions.theme = @0;
        moOptions.enableUndo = @1;
        moOptions.preventSleep = @0;
        moOptions.hasWatch = @NO;
        self.currentOptions = moOptions;
    }
    
    /*
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        if (session.paired && session.watchAppInstalled) {
            self.currentOptions.hasWatch = @YES;
            NSLog(@"Watch paired: %d, Watch app installed: %d", session.paired, session.watchAppInstalled);
        }
    }
    */
    
    // Fetch saved game data -- what was the last score time, etc.
    NSEntityDescription *gameEntity = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:context];
    [fetch setEntity:gameEntity];
    error = nil;
    fetchedObjects = [context executeFetchRequest:fetch error:&error];
    
    // Found saved game data
    if ([fetchedObjects count] == 1) {
        self.currentGame = [fetchedObjects objectAtIndex:0];
        //NSLog(@"Game fetched %@", self.currentGame.sportName);
        
            // Fetch sport details for the saved game
            NSEntityDescription *sportEntity = [NSEntityDescription entityForName:@"Sport"  inManagedObjectContext: context];
            [fetch setEntity:sportEntity];
            [fetch setPredicate:[NSPredicate predicateWithFormat:@"name == %@", self.currentGame.sportName]];
            error = nil;
            fetchedObjects = [context executeFetchRequest:fetch error:&error];
        
            if ([fetchedObjects count] == 1) {
                self.currentSport = [fetchedObjects objectAtIndex:0];
                //NSLog(@"Sport fetched %@", self.currentSport.name);
            } else {
                //NSLog(@"Sport NOT fetched");
            }
    // No saved game data (probably first time run)
    } else {
        // Fill game entity with dummy data
        Game *moGame = [NSEntityDescription insertNewObjectForEntityForName:[gameEntity name] inManagedObjectContext:context];
        moGame.sportName = @"Pick Sport";
        moGame.period = @1;
        moGame.scoreUs = @0;
        moGame.scoreThem = @0;
        moGame.timeCountUp = @0;
        moGame.timeCountUpCum = @0;
        moGame.timeElapsed = [NSDate date];
        moGame.timeElapsedMinutes = @0;
        moGame.timeElapsedSeconds = @0;
        moGame.timeRunning = @0;
        moGame.timeStartedAt = [NSDate date];
        moGame.timeSaveMinutes = @0;
        moGame.timeSaveSeconds = @0;
        self.currentGame = moGame;
        //NSLog(@"Game NOT fetched");
    }

//    // If there is a sport selected
//    if (self.currentSport) {
//        // then update the UI to match
//        [self updateUI];
//    }
    
    // TODO: check on this implementation
    NSTimer* timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateTimeFromTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.currentSport) {
        // then update the UI to match
        [self updateUI];
    } else {
        [self performSegueWithIdentifier:@"showSports" sender:self];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showSports"]){
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
        [[segue destinationViewController] setHasWatch:self.currentOptions.hasWatch];
        [self.undoManager removeAllActions];
    } else if ([[segue identifier] isEqualToString:@"showOptions"]){
        OptionsTableViewController *tempVC = [segue destinationViewController];
        [tempVC setOptionsDetail:self.currentOptions];
    }
}

- (IBAction)unwindFromSportsTableViewController:(UIStoryboardSegue *)segue {
    // If the user has come from the sport selection screen
    if ([segue.sourceViewController isKindOfClass:[SportsTableViewController class]]) {
        SportsTableViewController *sportsTableViewController = segue.sourceViewController;
        // and they changed the sport (touched a sport name rather than hitting back)
        if(sportsTableViewController.currentSport) {
            // set the current sport
            self.currentSport = sportsTableViewController.currentSport;
            // reset the current game
            self.currentGame.sportName = self.currentSport.name;
            self.currentGame.period = @1;
            self.currentGame.scoreUs = @0;
            self.currentGame.scoreThem = @0;
            self.currentGame.timeCountUp = self.currentSport.periodTimeUp;
            self.currentGame.timeCountUpCum = self.currentSport.periodTimeUpCum;
            self.currentGame.timeElapsedSeconds = @0;
            self.currentGame.timeRunning = @0;
            self.currentGame.timeStartedAt = NULL;
            self.currentGame.timeSaveMinutes = @0;
            self.currentGame.timeSaveSeconds = @0;
            [self resetTime];
            [self updateUI];
        }
        
        if (!self.currentSport) {
            [self performSegueWithIdentifier:@"showSports" sender:self];
        }
    }
}

#pragma mark - Private methods

- (void)saveState {
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
#ifdef DEBUG
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
#endif
        abort();
    }
}

- (void)updateUI {
    if ([self.currentOptions.preventSleep boolValue]) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    } else {
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }
    
    if ([self.currentOptions.theme intValue] == 1) {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        [[self view] setBackgroundColor:[UIColor blackColor]];
        [self.labTime setTextColor:[UIColor whiteColor]];
        [self.labUs setTextColor:[UIColor whiteColor]];
        [self.labUsScore setTextColor:[UIColor whiteColor]];
        [self.labThem setTextColor:[UIColor whiteColor]];
        [self.labThemScore setTextColor:[UIColor whiteColor]];
    } else {
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        [[self view] setBackgroundColor:[UIColor whiteColor]];
        [self.labTime setTextColor:[UIColor blackColor]];
        [self.labUs setTextColor:[UIColor blackColor]];
        [self.labUsScore setTextColor:[UIColor blackColor]];
        [self.labThem setTextColor:[UIColor blackColor]];
        [self.labThemScore setTextColor:[UIColor blackColor]];
    }
    
    [self.btnSport setTitle:self.currentSport.name forState:UIControlStateNormal];
    
    if ([self.currentSport.periodQuantity  isEqual:@1]) {
        [self.btnPeriodOne setHidden:NO];
        [self.btnPeriodTwo setHidden:YES];
        [self.btnPeriodThree setHidden:YES];
        [self.btnPeriodFour setHidden:YES];
    } else if ([self.currentSport.periodQuantity isEqual:@2]) {
        [self.btnPeriodOne setHidden:NO];
        [self.btnPeriodTwo setHidden:NO];
        [self.btnPeriodThree setHidden:YES];
        [self.btnPeriodFour setHidden:YES];
    } else if ([self.currentSport.periodQuantity isEqual:@3]) {
        [self.btnPeriodOne setHidden:NO];
        [self.btnPeriodTwo setHidden:NO];
        [self.btnPeriodThree setHidden:NO];
        [self.btnPeriodFour setHidden:YES];
    } else if ([self.currentSport.periodQuantity isEqual:@4]) {
        [self.btnPeriodOne setHidden:NO];
        [self.btnPeriodTwo setHidden:NO];
        [self.btnPeriodThree setHidden:NO];
        [self.btnPeriodFour setHidden:NO];
    } else {
        [self.btnPeriodOne setHidden:NO];
        [self.btnPeriodTwo setHidden:YES];
        [self.btnPeriodThree setHidden:YES];
        [self.btnPeriodFour setHidden:YES];
    }
    
    if ([self.currentGame.period  isEqual:@1]) {
        [self.btnPeriodOne setTitle:@"◉" forState:UIControlStateNormal];
        [self.btnPeriodTwo setTitle:@"◎" forState:UIControlStateNormal];
        [self.btnPeriodThree setTitle:@"◎" forState:UIControlStateNormal];
        [self.btnPeriodFour setTitle:@"◎" forState:UIControlStateNormal];
    } else if ([self.currentGame.period isEqual:@2]) {
        [self.btnPeriodOne setTitle:@"◎" forState:UIControlStateNormal];
        [self.btnPeriodTwo setTitle:@"◉" forState:UIControlStateNormal];
        [self.btnPeriodThree setTitle:@"◎" forState:UIControlStateNormal];
        [self.btnPeriodFour setTitle:@"◎" forState:UIControlStateNormal];
    } else if ([self.currentGame.period isEqual:@3]) {
        [self.btnPeriodOne setTitle:@"◎" forState:UIControlStateNormal];
        [self.btnPeriodTwo setTitle:@"◎" forState:UIControlStateNormal];
        [self.btnPeriodThree setTitle:@"◉" forState:UIControlStateNormal];
        [self.btnPeriodFour setTitle:@"◎" forState:UIControlStateNormal];
    } else if ([self.currentGame.period isEqual:@4]) {
        [self.btnPeriodOne setTitle:@"◎" forState:UIControlStateNormal];
        [self.btnPeriodTwo setTitle:@"◎" forState:UIControlStateNormal];
        [self.btnPeriodThree setTitle:@"◎" forState:UIControlStateNormal];
        [self.btnPeriodFour setTitle:@"◉" forState:UIControlStateNormal];
    } else {
        [self.btnPeriodOne setTitle:@"◉" forState:UIControlStateNormal];
        [self.btnPeriodTwo setTitle:@"◎" forState:UIControlStateNormal];
        [self.btnPeriodThree setTitle:@"◎" forState:UIControlStateNormal];
        [self.btnPeriodFour setTitle:@"◎" forState:UIControlStateNormal];
    }
    
    self.currentGame.timeCountUp = self.currentSport.periodTimeUp;
    self.currentGame.timeCountUpCum = self.currentSport.periodTimeUpCum;
    
    if ([self.currentSport.periodTime intValue] > 0) {
        if ([self.currentGame.timeRunning boolValue]) {
            [self.btnTimeForward setTitle:@"◼︎" forState:UIControlStateNormal];
        } else {
            [self.btnTimeForward setTitle:@"▶︎" forState:UIControlStateNormal];
        }
        //[self.btnTimeBack setHidden:YES];
        [self.btnTimeBack setTitle:@"◀︎" forState:UIControlStateNormal];
    } else {
        [self.btnTimeBack setHidden:NO];
        [self.btnTimeForward setTitle:@"▲" forState:UIControlStateNormal];
        [self.btnTimeBack setTitle:@"▼" forState:UIControlStateNormal];
    }
    
    [self.labUs setText:self.currentOptions.teamA];
    [self.labThem setText:self.currentOptions.teamB];
    
    if (self.currentSport.scoreTypeAname) {
        [self.btnUsScoreA setTitle:self.currentSport.scoreTypeAname forState:UIControlStateNormal];
        [self.btnThemScoreA setTitle:self.currentSport.scoreTypeAname forState:UIControlStateNormal];
    } else {
        [self.btnUsScoreA setHidden:YES];
        [self.btnThemScoreA setHidden:YES];
    }
    
    if (self.currentSport.scoreTypeAname) {
        [self.btnUsScoreB setTitle:self.currentSport.scoreTypeBname forState:UIControlStateNormal];
        [self.btnThemScoreB setTitle:self.currentSport.scoreTypeBname forState:UIControlStateNormal];
    } else {
        [self.btnUsScoreB setHidden:YES];
        [self.btnThemScoreB setHidden:YES];
    }
    
    if (self.currentSport.scoreTypeAname) {
        [self.btnUsScoreC setTitle:self.currentSport.scoreTypeCname forState:UIControlStateNormal];
        [self.btnThemScoreC setTitle:self.currentSport.scoreTypeCname forState:UIControlStateNormal];
    } else {
        [self.btnUsScoreC setHidden:YES];
        [self.btnThemScoreC setHidden:YES];
    }
    
    if (self.currentSport.scoreTypeAname) {
        [self.btnUsScoreD setTitle:self.currentSport.scoreTypeDname forState:UIControlStateNormal];
        [self.btnThemScoreD setTitle:self.currentSport.scoreTypeDname forState:UIControlStateNormal];
    } else {
        [self.btnUsScoreD setHidden:YES];
        [self.btnThemScoreD setHidden:YES];
    }
    
    [self updateTime];
    [self updateScoreUs:@0];
    [self updateScoreThem:@0];
}

- (void)updatePlayPause {
    if ([self.currentGame.timeRunning boolValue]) {
        self.currentGame.timeRunning = @NO;
        self.currentGame.timeSaveMinutes = self.currentGame.timeElapsedMinutes;
        self.currentGame.timeSaveSeconds = self.currentGame.timeElapsedSeconds;
        [self.btnTimeForward setTitle:@"▶︎" forState:UIControlStateNormal];
    } else {
        self.currentGame.timeRunning = @YES;
        self.currentGame.timeStartedAt = [NSDate date];
        [self.btnTimeForward setTitle:@"◼︎" forState:UIControlStateNormal];
    }
}

- (void)updateTime {
    if ([self.currentSport.periodTime intValue] > 0) {
        if ([self.currentGame.timeCountUp boolValue]) {
            if ([self.currentGame.timeRunning boolValue] || self.periodChanged) {
                NSTimeInterval timeDiff = [[NSDate date] timeIntervalSinceDate:self.currentGame.timeStartedAt];
                self.currentGame.timeElapsedMinutes = @([self.currentGame.timeSaveMinutes intValue] + floor(timeDiff/60));
                self.currentGame.timeElapsedSeconds = @([self.currentGame.timeSaveSeconds intValue] + round(timeDiff - floor(timeDiff / 60) * 60));
                self.periodChanged = NO;
            }
            
            if ([self.currentGame.timeElapsedSeconds intValue] >= 60) {
                self.currentGame.timeElapsedMinutes = @([self.currentGame.timeElapsedMinutes intValue] + 1);
                self.currentGame.timeElapsedSeconds = @([self.currentGame.timeElapsedSeconds intValue] - 60);
            }
        } else {
            if ([self.currentGame.timeRunning boolValue]) {
                if (([self.currentGame.timeElapsedMinutes intValue] > 0) || ([self.currentGame.timeElapsedSeconds intValue] > 0)) {
                    NSTimeInterval timeDiff = [[NSDate date] timeIntervalSinceDate:self.currentGame.timeStartedAt];
                    NSNumber *cumMinutes = @([self.currentGame.timeSaveMinutes intValue] + floor(timeDiff/60));
                    NSNumber *cumSeconds = @([self.currentGame.timeSaveSeconds intValue] + round(timeDiff - floor(timeDiff / 60) * 60));
                    
                    if ([cumSeconds intValue] > 60) {
                        cumMinutes = @([cumMinutes intValue] + 1);
                        cumSeconds = @([cumSeconds intValue] - 60);
                    }
                    
                    self.currentGame.timeElapsedSeconds = @(60 - [cumSeconds intValue]);
                    if ([self.currentGame.timeElapsedSeconds intValue] == 59) {
                        self.currentGame.timeElapsedMinutes = @([self.currentGame.timeElapsedMinutes intValue] - 1);
                    } else if ([self.currentGame.timeElapsedSeconds intValue] == 60) {
                        self.currentGame.timeElapsedSeconds = @0;
                    }
                }
            }
        }
        
        [self.labTime setText:[NSString stringWithFormat:@"%.2d:%.2d", [self.currentGame.timeElapsedMinutes intValue], [self.currentGame.timeElapsedSeconds intValue]]];
    } else {
        [self.labTime setText:[NSString stringWithFormat:@"%@", self.currentGame.timeElapsedMinutes]];
    }
    [self saveState];
}

- (void)updateTimeFromTimer:(id)caller {
    if ([self.currentGame.timeRunning boolValue]) {
        [self updateTime];
    }
}

- (void)resetTime {
    if ([self.currentGame.timeCountUp boolValue]) {
        if ([self.currentGame.timeCountUpCum boolValue]) {
            self.currentGame.timeElapsedMinutes = @0;
            self.currentGame.timeElapsedSeconds = @0;
            self.currentGame.timeStartedAt = [NSDate date];
            self.currentGame.timeSaveMinutes = @([self.currentSport.periodTime intValue] * ([self.currentGame.period intValue] - 1));
            self.currentGame.timeSaveSeconds = @0;
            self.periodChanged = YES;
        } else {
            self.currentGame.timeElapsedMinutes = @0;
            self.currentGame.timeElapsedSeconds = @0;
            self.currentGame.timeStartedAt = [NSDate date];
            self.currentGame.timeSaveMinutes = @0;
            self.currentGame.timeSaveSeconds = @0;
        }
    } else {
        self.currentGame.timeElapsedMinutes = self.currentSport.periodTime;
        self.currentGame.timeElapsedSeconds = @0;
        self.currentGame.timeStartedAt = [NSDate date];
        self.currentGame.timeSaveMinutes = @0;
        self.currentGame.timeSaveSeconds = @0;
    }
}

- (void)resetPeriod:(NSNumber*)period {
    self.currentGame.period = period;
//    if ([period boolValue]) {
//        if ([self.currentGame.timeCountUp boolValue] && [self.currentGame.timeCountUpCum boolValue]) {
//            self.currentGame.timeElapsedMinutes = @0;
//            self.currentGame.timeElapsedSeconds = @0;
//            self.currentGame.timeStartedAt = [NSDate date];
//            self.currentGame.timeSaveMinutes = @([self.currentSport.periodTime intValue] * ([period intValue] - 1));
//            self.currentGame.timeSaveSeconds = @0;
//            self.periodChanged = YES;
//        } else {
//            [self resetTime];
//        }
//    }
    [self resetTime];
    [self updateUI];
}

- (void)undoScoreUs:(NSNumber*)increment {
    self.currentGame.scoreUs = @([self.currentGame.scoreUs intValue] - [increment intValue]);
    [self.labUsScore setText:[self.currentGame.scoreUs stringValue]];
    [self saveState];
}

- (void)updateScoreUs:(NSNumber*)increment {
    [self.undoManager registerUndoWithTarget:self selector:@selector(undoScoreUs:) object:increment];
    self.currentGame.scoreUs = @([self.currentGame.scoreUs intValue] + [increment intValue]);
    [self.labUsScore setText:[self.currentGame.scoreUs stringValue]];
    [self saveState];
}

- (void)undoScoreThem:(NSNumber*)increment {
    self.currentGame.scoreThem = @([self.currentGame.scoreThem intValue] - [increment intValue]);
    [self.labThemScore setText:[self.currentGame.scoreThem stringValue]];
    [self saveState];
}

- (void)updateScoreThem:(NSNumber*)increment {
    [self.undoManager registerUndoWithTarget:self selector:@selector(undoScoreThem:) object:increment];
    self.currentGame.scoreThem = @([self.currentGame.scoreThem intValue] + [increment intValue]);
    [self.labThemScore setText:[self.currentGame.scoreThem stringValue]];
    [self saveState];
}

#pragma mark - UI actions

- (IBAction)doShare:(id)sender {
    NSString *textToShare = [[NSString alloc] initWithFormat:@"%@ %@ - %@ %@", self.labUs.text, self.currentGame.scoreUs, self.currentGame.scoreThem, self.labThem.text];
    NSArray *activityItems = @[textToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    // TODO: Fix for iPad
    //activityVC.popoverPresentationController.sourceView = self.popoverAnchor;
    [self presentViewController:activityVC animated:TRUE completion:nil];
}

- (IBAction)tchSport:(id)sender {
    // handled by segue
}

- (IBAction)tchPeriodOne:(id)sender {
    [self resetPeriod:@1];
}

- (IBAction)tchPeriodTwo:(id)sender {
    [self resetPeriod:@2];
}

- (IBAction)tchPeriodThree:(id)sender {
    [self resetPeriod:@3];
}

- (IBAction)tchPeriodFour:(id)sender {
    [self resetPeriod:@4];
}

- (IBAction)tchTimeForward:(id)sender {
    if ([self.currentSport.periodTime intValue] > 0) {
        [self updatePlayPause];
    } else {
        self.currentGame.timeElapsedMinutes = @([self.currentGame.timeElapsedMinutes intValue] + 1);
    }
    [self updateTime];
}

- (IBAction)tchTimeBack:(id)sender {
    if ([self.currentSport.periodTime intValue] > 0) {
        [self resetTime];
    } else {
        if ([self.currentGame.timeElapsedMinutes intValue] > 0) {
            self.currentGame.timeElapsedMinutes = @([self.currentGame.timeElapsedMinutes intValue] - 1);
        }
    }
    [self updateTime];
}

- (IBAction)tchUsScoreA:(id)sender {
    [self updateScoreUs:self.currentSport.scoreTypeApoints];
}

- (IBAction)tchUsScoreB:(id)sender {
    [self updateScoreUs:self.currentSport.scoreTypeBpoints];
}

- (IBAction)tchUsScoreC:(id)sender {
    [self updateScoreUs:self.currentSport.scoreTypeCpoints];
}

- (IBAction)tchUsScoreD:(id)sender {
    [self updateScoreUs:self.currentSport.scoreTypeDpoints];
}

- (IBAction)tchThemScoreA:(id)sender {
    [self updateScoreThem:self.currentSport.scoreTypeApoints];
}

- (IBAction)tchThemScoreB:(id)sender {
    [self updateScoreThem:self.currentSport.scoreTypeBpoints];
}

- (IBAction)tchThemScoreC:(id)sender {
    [self updateScoreThem:self.currentSport.scoreTypeCpoints];
}

- (IBAction)tchThemScoreD:(id)sender {
    [self updateScoreThem:self.currentSport.scoreTypeDpoints];
}

- (IBAction)tchUndo:(id)sender {
    if ([self.undoManager canUndo]) {
        [self.undoManager undo];
    }
}

//#pragma mark - WatchKit
//
//- (NSDictionary *)prepareDataforWatch {
//    NSMutableDictionary *watchData = [[NSMutableDictionary alloc] init];
//    
//    [watchData setObject:self.currentOptions.teamA forKey:@"teamA"];
//    [watchData setObject:self.currentOptions.teamB forKey:@"teamB"];
//    
//    [watchData setObject:self.currentGame.sportName forKey:@"gameSport"];
//    [watchData setObject:self.currentGame.period forKey:@"gamePeriod"];
//    [watchData setObject:self.currentGame.scoreUs forKey:@"gameScoreUs"];
//    [watchData setObject:self.currentGame.scoreThem forKey:@"gameScoreThem"];
//    [watchData setObject:self.currentGame.timeCountUp forKey:@"gameTimeCountUp"];
//    [watchData setObject:self.currentGame.timeCountUpCum forKey:@"gameTimeCountUpCum"];
//    [watchData setObject:self.currentGame.timeElapsedMinutes forKey:@"gametimeElapsedMinutes"];
//    [watchData setObject:self.currentGame.timeElapsedSeconds forKey:@"gametimeElapsedSeconds"];
//    [watchData setObject:self.currentGame.timeRunning forKey:@"gameTimeRunning"];
//    [watchData setObject:self.currentGame.timeStartedAt forKey:@"gameTimeStartedAt"];
//    [watchData setObject:self.currentGame.timeSaveMinutes forKey:@"gameTimeSaveMinutes"];
//    [watchData setObject:self.currentGame.timeSaveSeconds forKey:@"gameTimeSaveSeconds"];
//    
//    NSManagedObjectContext *context = [self managedObjectContext];
//    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
//    NSEntityDescription *sportsEntity = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:context];
//    [fetch setEntity:sportsEntity];
//    NSError *error = nil;
//    NSArray *fetchedObjects = [context executeFetchRequest:fetch error:&error];
//    Sport *moSport;
//    NSMutableArray *sportsList = [[NSMutableArray alloc] init];
//    if ([fetchedObjects count] > 0) {
//        for (moSport in fetchedObjects) {
//            NSMutableDictionary *currentGame = [[NSMutableDictionary alloc] init];
//            [currentGame setObject:moSport.name forKey:@"name"];
//            [currentGame setObject:moSport.periodQuantity forKey:@"periodQuantity"];
//            [currentGame setObject:moSport.periodTime forKey:@"periodTime"];
//            [currentGame setObject:moSport.scoreTypeEname forKey:@"scoreTypeEname"];
//            [currentGame setObject:moSport.scoreTypeEpoints forKey:@"scoreTypeEpoints"];
//            [currentGame setObject:moSport.scoreTypeFname forKey:@"scoreTypeFname"];
//            [currentGame setObject:moSport.scoreTypeFpoints forKey:@"scoreTypeFpoints"];
//            [currentGame setObject:moSport.periodTimeUp forKey:@"periodTimeUp"];
//            [currentGame setObject:moSport.periodTimeUpCum forKey:@"periodTimeUpCum"];
//            [sportsList addObject:currentGame];
//        }
//    } else {
//        NSLog(@"Error reading sports");
//    }
//    NSArray *sports = [sportsList copy];
//    [watchData setObject:sports forKey:@"sports"];
//    
//    return watchData;
//}
//
//- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler {
//    NSLog(@"iPhone: didReceiveMessage");
//    
//    NSString *commandValue = [message objectForKey:@"command"];
//    if ([commandValue isEqualToString:@"SendAppCoreData"]) {
////        NSDictionary *appCoreData = [self prepareDataforWatch];
////        replyHandler(appCoreData);
//    }
//    
////    //Use this to update the UI instantaneously (otherwise, takes a little while)
////    dispatch_async(dispatch_get_main_queue(), ^{
////        [self.counterData addObject:counterValue];
////        [self.mainTableView reloadData];
////    });
//}

@end
