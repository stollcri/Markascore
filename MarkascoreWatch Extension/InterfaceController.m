//
//  InterfaceController.m
//  MarkascoreWatch Extension
//
//  Created by Christopher Stoll on 1/18/16.
//  Copyright © 2016 Christopher Stoll. All rights reserved.
//

#import "InterfaceController.h"
#import "ComplicationController.h"

#define TIMER_UPDATE_MODE_INIT 1
#define TIMER_UPDATE_MODE_START 2
#define TIMER_UPDATE_MODE_STOP 3
#define TIMER_UPDATE_MODE_RESET 4

@interface InterfaceController()

@end


@implementation InterfaceController
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    
    // sett up communication session
    // (should always be supported on the watch)
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    self.undoManager = [[NSUndoManager alloc] init];
    
    // check for UI sanity
    [self validateUI];
    // and update the UI now
    [self updateUI];
    // in case we don't hear back
    [self requestDefaults];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
    [self.userDefaults synchronize];
    [self updateComplicationScore];
}

#pragma mark - Connectivity

- (void)requestDefaults {
    if ([[WCSession defaultSession] isReachable]) {
        NSDictionary *appMessage = [[NSDictionary alloc] initWithObjectsAndKeys:@"SendAppCoreData", @"command", nil];
        //NSLog(@"Sending message...");
        [[WCSession defaultSession] sendMessage:appMessage
                                   replyHandler:^(NSDictionary *reply) {
                                       [self.userDefaults setObject:[reply objectForKey:@"teamA"] forKey:@"teamA"];
                                       [self.userDefaults setObject:[reply objectForKey:@"teamB"] forKey:@"teamB"];
                                       
                                       [self.userDefaults setObject:[reply objectForKey:@"gameSport"] forKey:@"gameSport"];
                                       [self.userDefaults setObject:[reply objectForKey:@"gamePeriod"] forKey:@"gamePeriod"];
                                       /*
                                       [self.userDefaults setObject:[reply objectForKey:@"gameScoreUs"] forKey:@"gameScoreUs"];
                                       [self.userDefaults setObject:[reply objectForKey:@"gameScoreThem"] forKey:@"gameScoreThem"];
                                        */
                                       [self.userDefaults setObject:[reply objectForKey:@"gameTimeCountUp"] forKey:@"gameTimeCountUp"];
                                       [self.userDefaults setObject:[reply objectForKey:@"gameTimeCountUpCum"] forKey:@"gameTimeCountUpCum"];
                                       /*
                                       [self.userDefaults setObject:[reply objectForKey:@"gameTimeElapsed"] forKey:@"gameTimeMinutes"];
                                       [self.userDefaults setObject:[reply objectForKey:@"gameTimeElapsedMinutes"] forKey:@"gameTimeMinutes"];
                                       [self.userDefaults setObject:[reply objectForKey:@"gameTimeElapsedSeconds"] forKey:@"gameTimeSeconds"];
                                       [self.userDefaults setObject:[reply objectForKey:@"gameTimeRunning"] forKey:@"gameTimeRunning"];
                                       [self.userDefaults setObject:[reply objectForKey:@"gameTimeStartedAt"] forKey:@"gameTimeStartedAt"];
                                       [self.userDefaults setObject:[reply objectForKey:@"gameTimeSaveMinutes"] forKey:@"gameTimeSaveMinutes"];
                                       [self.userDefaults setObject:[reply objectForKey:@"gameTimeSaveSeconds"] forKey:@"gameTimeSaveSeconds"];
                                        */
                                       
                                       BOOL sportChanged = NO;
                                       // check if the sport will change, so we can do resets below
                                       if (![[reply objectForKey:@"currentSportName"] isEqualToString:[self.userDefaults objectForKey:@"currentSportName"]]) {
                                           sportChanged = YES;
                                       }
                                       
                                       [self.userDefaults setObject:[reply objectForKey:@"currentSportName"] forKey:@"currentSportName"];
                                       [self.userDefaults setObject:[reply objectForKey:@"currentSportPeriodQuantity"] forKey:@"currentSportPeriodQuantity"];
                                       [self.userDefaults setObject:[reply objectForKey:@"currentSportPeriodTime"] forKey:@"currentSportPeriodTime"];
                                       [self.userDefaults setObject:[reply objectForKey:@"currentSportScoreTypeEname"] forKey:@"currentSportScoreTypeEname"];
                                       [self.userDefaults setObject:[reply objectForKey:@"currentSportScoreTypeEpoints"] forKey:@"currentSportScoreTypeEpoints"];
                                       [self.userDefaults setObject:[reply objectForKey:@"currentSportScoreTypeFname"] forKey:@"currentSportScoreTypeFname"];
                                       [self.userDefaults setObject:[reply objectForKey:@"currentSportScoreTypeFpoints"] forKey:@"currentSportScoreTypeFpoints"];
                                       [self.userDefaults setObject:[reply objectForKey:@"currentSportScoreTypeGname"] forKey:@"currentSportScoreTypeGname"];
                                       [self.userDefaults setObject:[reply objectForKey:@"currentSportScoreTypeGpoints"] forKey:@"currentSportScoreTypeGpoints"];
                                       [self.userDefaults setObject:[reply objectForKey:@"currentSportPeriodTimeUp"] forKey:@"currentSportPeriodTimeUp"];
                                       [self.userDefaults setObject:[reply objectForKey:@"currentSportPeriodTimeUpCum"] forKey:@"currentSportPeriodTimeUpCum"];
                                       
                                       //[self.userDefaults setObject:[reply objectForKey:@"sports"] forKey:@"sports"];
                                       
                                       // reset certain values when the sport changes
                                       if (sportChanged) {
                                           [self.userDefaults setObject:@0 forKey:@"gameTimeElapsed"];
                                           [self updateTimerStatus:TIMER_UPDATE_MODE_RESET];
                                           
                                           [self.userDefaults setObject:@0 forKey:@"gameScoreUs"];
                                           [self.userDefaults setObject:@0 forKey:@"gameScoreThem"];
                                           [self.undoManager removeAllActions];
                                       }
                                       [self validateUI];
                                       [self updateUI];
                                   }
                                   errorHandler:^(NSError *error) {
                                       //catch any errors here
                                       //NSLog(@"Watch: ERROR message");
                                   }
         ];
    } else {
        //NSLog(@"Session NOT reachable");
    }
}

#pragma mark - UI methods

- (void)validateUI {
    //
    // if values are (null), then this is probably the first run, so set them to defaults
    //
    
    if ([self.userDefaults objectForKey:@"teamA"] == nil) {
        [self.userDefaults setObject:@"HOME" forKey:@"teamA"];
    }
    if ([self.userDefaults objectForKey:@"teamB"] == nil) {
        [self.userDefaults setObject:@"GUEST" forKey:@"teamB"];
    }
    
    if ([self.userDefaults objectForKey:@"gameScoreUs"] == nil) {
        [self.userDefaults setObject:@0 forKey:@"gameScoreUs"];
    }
    if ([self.userDefaults objectForKey:@"gameScoreThem"] == nil) {
        [self.userDefaults setObject:@0 forKey:@"gameScoreThem"];
    }
    
    if ([self.userDefaults objectForKey:@"gameTimeCountUp"] == nil) {
        [self.userDefaults setObject:@YES forKey:@"gameTimeCountUp"];
    }
    
    // make sure there is a primary score name
    if ([self.userDefaults objectForKey:@"currentSportScoreTypeEname"] == nil) {
        [self.userDefaults setObject:@"Score" forKey:@"currentSportScoreTypeEname"];
    }
    // make sure there is a primary score value
    if ([self.userDefaults objectForKey:@"currentSportScoreTypeEpoints"] == nil) {
        [self.userDefaults setObject:@1 forKey:@"currentSportScoreTypeEpoints"];
    }
    
    // make sure secondary values are consistent
    if ([self.userDefaults objectForKey:@"currentSportScoreTypeFname"] == nil || [[self.userDefaults objectForKey:@"currentSportScoreTypeFname"] isEqualToString:@""] || [self.userDefaults objectForKey:@"currentSportScoreTypeFpoints"] == nil) {
        
        [self.userDefaults setObject:@"" forKey:@"currentSportScoreTypeFname"];
        [self.userDefaults setObject:@0 forKey:@"currentSportScoreTypeFpoints"];
        
        [self.userDefaults setObject:@"" forKey:@"currentSportScoreTypeGname"];
        [self.userDefaults setObject:@0 forKey:@"currentSportScoreTypeGpoints"];
        
    } else {
        // make sure tertiary values are consistent
        if ([self.userDefaults objectForKey:@"currentSportScoreTypeGname"] == nil || [[self.userDefaults objectForKey:@"currentSportScoreTypeGname"] isEqualToString:@""] || [self.userDefaults objectForKey:@"currentSportScoreTypeGpoints"] == nil) {

            [self.userDefaults setObject:@"" forKey:@"currentSportScoreTypeGname"];
            [self.userDefaults setObject:@0 forKey:@"currentSportScoreTypeGpoints"];
        }
    }
    
    [self updateTimerStatus:TIMER_UPDATE_MODE_INIT];
}

- (void)updateUI {
    [self.labUs setText:[self.userDefaults objectForKey:@"teamA"]];
    [self.labThem setText:[self.userDefaults objectForKey:@"teamB"]];
    [self.labUsScore setText:[[self.userDefaults objectForKey:@"gameScoreUs"] stringValue]];
    [self.labThemScore setText:[[self.userDefaults objectForKey:@"gameScoreThem"] stringValue]];
    
    if ([self.userDefaults objectForKey:@"currentSportScoreTypeEname"] != nil) {
        [self.btnUsScoreA setTitle:[self.userDefaults objectForKey:@"currentSportScoreTypeEname"]];
        [self.btnThemScoreA setTitle:[self.userDefaults objectForKey:@"currentSportScoreTypeEname"]];
        
        [self.btnUsScoreAAlt setTitle:[self.userDefaults objectForKey:@"currentSportScoreTypeEname"]];
        [self.btnThemScoreAAlt setTitle:[self.userDefaults objectForKey:@"currentSportScoreTypeEname"]];
    }
    
    if ([self.userDefaults objectForKey:@"currentSportScoreTypeFname"] != nil && ![[self.userDefaults objectForKey:@"currentSportScoreTypeFname"] isEqualToString:@""]) {
        [self.grp1 setHidden:YES];
        [self.btnUndoA setHidden:YES];
        
        if ([self.userDefaults objectForKey:@"currentSportScoreTypeGname"] != nil && ![[self.userDefaults objectForKey:@"currentSportScoreTypeGname"] isEqualToString:@""]) {
            
            [self.btnUsScoreC setTitle:[self.userDefaults objectForKey:@"currentSportScoreTypeFname"]];
            [self.btnUsScoreD setTitle:[self.userDefaults objectForKey:@"currentSportScoreTypeGname"]];
            [self.btnThemScoreC setTitle:[self.userDefaults objectForKey:@"currentSportScoreTypeFname"]];
            [self.btnThemScoreD setTitle:[self.userDefaults objectForKey:@"currentSportScoreTypeGname"]];
            
            [self.btnUsScoreA setHidden:YES];
            [self.btnThemScoreA setHidden:YES];
            [self.grp0 setHidden:YES];
            
            [self.btnUsScoreAAlt setHidden:NO];
            [self.btnThemScoreAAlt setHidden:NO];
            [self.grp0Alt setHidden:NO];
            
            [self.btnUsScoreB setHidden:YES];
            [self.btnUndoB setHidden:YES];
            [self.btnThemScoreB setHidden:YES];
            [self.grp2 setHidden:YES];
            
            [self.btnUsScoreC setHidden:NO];
            [self.btnUsScoreD setHidden:NO];
            [self.btnThemScoreC setHidden:NO];
            [self.btnThemScoreD setHidden:NO];
            [self.grp3 setHidden:NO];
        } else {
            [self.btnUsScoreB setTitle:[self.userDefaults objectForKey:@"currentSportScoreTypeFname"]];
            [self.btnThemScoreB setTitle:[self.userDefaults objectForKey:@"currentSportScoreTypeFname"]];
            
            [self.btnUsScoreA setHidden:NO];
            [self.btnThemScoreA setHidden:NO];
            [self.grp0 setHidden:NO];
            
            [self.btnUsScoreAAlt setHidden:YES];
            [self.btnThemScoreAAlt setHidden:YES];
            [self.grp0Alt setHidden:YES];
            
            [self.btnUsScoreB setHidden:NO];
            [self.btnUndoB setHidden:NO];
            [self.btnThemScoreB setHidden:NO];
            [self.grp2 setHidden:NO];
            
            [self.btnUsScoreC setHidden:YES];
            [self.btnUsScoreD setHidden:YES];
            [self.btnThemScoreC setHidden:YES];
            [self.btnThemScoreD setHidden:YES];
            [self.grp3 setHidden:YES];
        }
    } else {
        [self.btnUsScoreA setHidden:NO];
        [self.btnThemScoreA setHidden:NO];
        [self.grp0 setHidden:NO];
        
        [self.btnUsScoreAAlt setHidden:YES];
        [self.btnThemScoreAAlt setHidden:YES];
        [self.grp0Alt setHidden:YES];
        
        [self.btnUndoA setHidden:NO];
        [self.grp1 setHidden:NO];
        
        [self.btnUsScoreB setHidden:YES];
        [self.btnUndoB setHidden:YES];
        [self.btnThemScoreB setHidden:YES];
        [self.grp2 setHidden:YES];
        
        [self.btnUsScoreC setHidden:YES];
        [self.btnUsScoreD setHidden:YES];
        [self.btnThemScoreC setHidden:YES];
        [self.btnThemScoreD setHidden:YES];
        [self.grp3 setHidden:YES];
    }
}

- (void)updateComplicationScore {
    //NSLog(@"updateComplicationScore");
    CLKComplicationServer *complicationServer = [CLKComplicationServer sharedInstance];
    for (CLKComplication *complication in complicationServer.activeComplications) {
        [complicationServer reloadTimelineForComplication:complication];
    }
}

- (void)undoScoreUs:(NSNumber*)increment {
    if ([[self.userDefaults objectForKey:@"gameScoreUs"] intValue] >= [increment intValue]) {
        NSNumber *newScore = @([[self.userDefaults objectForKey:@"gameScoreUs"] intValue] - [increment intValue]);
        [self.userDefaults setObject:newScore forKey:@"gameScoreUs"];
        [self.labUsScore setText:[[self.userDefaults objectForKey:@"gameScoreUs"] stringValue]];
    }
}

- (void)updateScoreUs:(NSNumber*)increment {
    [self.undoManager registerUndoWithTarget:self selector:@selector(undoScoreUs:) object:increment];
    NSNumber *newScore = @([[self.userDefaults objectForKey:@"gameScoreUs"] intValue] + [increment intValue]);
    [self.userDefaults setObject:newScore forKey:@"gameScoreUs"];
    [self.labUsScore setText:[[self.userDefaults objectForKey:@"gameScoreUs"] stringValue]];
}

- (void)undoScoreThem:(NSNumber*)increment {
    if ([[self.userDefaults objectForKey:@"gameScoreThem"] intValue] >= [increment intValue]) {
        NSNumber *newScore = @([[self.userDefaults objectForKey:@"gameScoreThem"] intValue] - [increment intValue]);
        [self.userDefaults setObject:newScore forKey:@"gameScoreThem"];
        [self.labThemScore setText:[[self.userDefaults objectForKey:@"gameScoreThem"] stringValue]];
    }
}

- (void)updateScoreThem:(NSNumber*)increment {
    [self.undoManager registerUndoWithTarget:self selector:@selector(undoScoreThem:) object:increment];
    NSNumber *newScore = @([[self.userDefaults objectForKey:@"gameScoreThem"] intValue] + [increment intValue]);
    [self.userDefaults setObject:newScore forKey:@"gameScoreThem"];
    [self.labThemScore setText:[[self.userDefaults objectForKey:@"gameScoreThem"] stringValue]];
}

- (void)updateTimerStatus:(int)mode {
    int gameTimeInSecs = ([[self.userDefaults objectForKey:@"currentSportPeriodTime"] intValue] * 60) + 1;
    int elapsedTime = [[self.userDefaults objectForKey:@"gameTimeElapsed"] intValue];
    BOOL countUp = [[self.userDefaults objectForKey:@"gameTimeCountUp"] boolValue];
    NSDate *timeStarted = [self.userDefaults objectForKey:@"gameTimeStartedAt"];
    NSTimeInterval timeLeft;
    NSDate *timeEnded;
    
    // init display
    if (mode == TIMER_UPDATE_MODE_INIT) {
        if (countUp) {
            timeLeft = elapsedTime;
        } else {
            timeLeft = gameTimeInSecs - elapsedTime;
        }
        timeEnded = [NSDate dateWithTimeIntervalSinceNow:timeLeft];
        [self.tmrMain setDate:timeEnded];
        
    // reset
    } else if (mode == TIMER_UPDATE_MODE_RESET) {
        if (countUp) {
            timeLeft = 0;
        } else {
            timeLeft = gameTimeInSecs;
        }
        timeEnded = [NSDate dateWithTimeIntervalSinceNow:timeLeft];
        [self.tmrMain setDate:timeEnded];
        
        [self.userDefaults setObject:[NSDate date] forKey:@"gameTimeStartedAt"];
        [self.userDefaults setObject:@0 forKey:@"gameTimeElapsed"];
        
    // stop
    } else if (mode == TIMER_UPDATE_MODE_STOP) {
        // only stop if started
        if (self.timerRunning) {
            elapsedTime += [[NSDate date] timeIntervalSinceDate:timeStarted];
            [self.tmrMain stop];
            
            [self.userDefaults setObject:@(elapsedTime) forKey:@"gameTimeElapsed"];
            self.timerRunning = NO;
        }
        
    // start
    } else if (mode == TIMER_UPDATE_MODE_START) {
        // only start if stopped
        if (!self.timerRunning) {
            if (countUp) {
                timeLeft = elapsedTime;
            } else {
                timeLeft = gameTimeInSecs - elapsedTime;
            }
            timeEnded = [NSDate dateWithTimeIntervalSinceNow:timeLeft];
            [self.tmrMain setDate:timeEnded];
            [self.tmrMain start];
            
            [self.userDefaults setObject:[NSDate date] forKey:@"gameTimeStartedAt"];
            self.timerRunning = YES;
        }
    }
    
    if (self.timerRunning) {
        [self.userDefaults setObject:@YES forKey:@"gameTimeRunning"];
    } else {
        [self.userDefaults setObject:@NO forKey:@"gameTimeRunning"];
    }
}

#pragma mark - UI Actions

- (IBAction)tchUsScoreA {
    [self updateScoreUs:[self.userDefaults objectForKey:@"currentSportScoreTypeEpoints"]];
}

- (IBAction)tchThemScoreA {
    [self updateScoreThem:[self.userDefaults objectForKey:@"currentSportScoreTypeEpoints"]];
}

- (IBAction)tchUndoA {
    if ([self.undoManager canUndo]) {
        [self.undoManager undo];
    }
}

- (IBAction)tchUsScoreAAlt {
    [self updateScoreUs:[self.userDefaults objectForKey:@"currentSportScoreTypeEpoints"]];
}

- (IBAction)tchThemScoreAAlt {
    [self updateScoreThem:[self.userDefaults objectForKey:@"currentSportScoreTypeEpoints"]];
}

- (IBAction)tchUndoAAlt {
    if ([self.undoManager canUndo]) {
        [self.undoManager undo];
    }
}

- (IBAction)tchUsScoreB {
    [self updateScoreUs:[self.userDefaults objectForKey:@"currentSportScoreTypeFpoints"]];
}

- (IBAction)tchThemScoreB {
    [self updateScoreThem:[self.userDefaults objectForKey:@"currentSportScoreTypeFpoints"]];
}

- (IBAction)tchUndoB {
    if ([self.undoManager canUndo]) {
        [self.undoManager undo];
    }
}

- (IBAction)tchUsScoreC {
    [self updateScoreUs:[self.userDefaults objectForKey:@"currentSportScoreTypeFpoints"]];
}

- (IBAction)tchThemScoreC {
    [self updateScoreThem:[self.userDefaults objectForKey:@"currentSportScoreTypeFpoints"]];
}

- (IBAction)tchUsScoreD {
    [self updateScoreUs:[self.userDefaults objectForKey:@"currentSportScoreTypeGpoints"]];
}

- (IBAction)tchThemScoreD {
    [self updateScoreThem:[self.userDefaults objectForKey:@"currentSportScoreTypeGpoints"]];
}

- (IBAction)tchPlay {
    [self updateTimerStatus:TIMER_UPDATE_MODE_START];
}

- (IBAction)tchPause {
    [self updateTimerStatus:TIMER_UPDATE_MODE_STOP];
}

- (IBAction)tchRestart {
    [self updateTimerStatus:TIMER_UPDATE_MODE_RESET];
}

- (IBAction)tchReset {
    NSNumber *newScore = @0;
    
    [self.userDefaults setObject:newScore forKey:@"gameScoreUs"];
    [self.labUsScore setText:[[self.userDefaults objectForKey:@"gameScoreUs"] stringValue]];

    [self.userDefaults setObject:newScore forKey:@"gameScoreThem"];
    [self.labThemScore setText:[[self.userDefaults objectForKey:@"gameScoreThem"] stringValue]];
    
    [self requestDefaults];
}

@end



