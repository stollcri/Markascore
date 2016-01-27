//
//  InterfaceController.m
//  MarkascoreWatch Extension
//
//  Created by Christopher Stoll on 1/18/16.
//  Copyright © 2016 Christopher Stoll. All rights reserved.
//

#import "InterfaceController.h"

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
                                       [self.userDefaults setObject:[reply objectForKey:@"currentSportPeriodTimeUp"] forKey:@"currentSportPeriodTimeUp"];
                                       [self.userDefaults setObject:[reply objectForKey:@"currentSportPeriodTimeUpCum"] forKey:@"currentSportPeriodTimeUpCum"];
                                       
                                       //[self.userDefaults setObject:[reply objectForKey:@"sports"] forKey:@"sports"];
                                       
                                       // reset certain values when the sport changes
                                       if (sportChanged) {
                                           [self.userDefaults setObject:@0 forKey:@"gameTimeElapsed"];
                                           [self updateTimerStatus:TIMER_UPDATE_MODE_RESET];
                                           
                                           [self.userDefaults setObject:@0 forKey:@"gameScoreUs"];
                                           [self.userDefaults setObject:@0 forKey:@"gameScoreThem"];
                                       }
                                       [self validateUI];
                                       [self updateUI];
                                   }
                                   errorHandler:^(NSError *error) {
                                       //catch any errors here
                                       NSLog(@"Watch: ERROR message");
                                   }
         ];
    } else {
        NSLog(@"Session NOT reachable");
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
    
    // if there is no scoring value, then set it to a default value so the user can do something
    if ([self.userDefaults objectForKey:@"currentSportScoreTypeEpoints"] == nil && [self.userDefaults objectForKey:@"currentSportScoreTypeEpoints"] == nil) {
        [self.userDefaults setObject:@1 forKey:@"currentSportScoreTypeEpoints"];
    } else {
        // if there is no primary scoring value, then set it to a default so the user can score
        if ([self.userDefaults objectForKey:@"currentSportScoreTypeEpoints"] == nil) {
            [self.userDefaults setObject:@1 forKey:@"currentSportScoreTypeEname"];
        }
        // if there is a secondary scoring value, then show the secondary scoring buttons
        if ([[self.userDefaults objectForKey:@"currentSportScoreTypeFpoints"] boolValue]) {
            [self.btnUsScoreB setHidden:NO];
            [self.btnThemScoreB setHidden:NO];
        } else {
            [self.btnUsScoreB setHidden:YES];
            [self.btnThemScoreB setHidden:YES];
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
    }
    if ([self.userDefaults objectForKey:@"currentSportScoreTypeFname"] != nil && ![[self.userDefaults objectForKey:@"currentSportScoreTypeFname"] isEqualToString:@""]) {
        [self.btnUsScoreB setTitle:[self.userDefaults objectForKey:@"currentSportScoreTypeFname"]];
        [self.btnThemScoreB setTitle:[self.userDefaults objectForKey:@"currentSportScoreTypeFname"]];
        [self.btnUsScoreB setHidden:NO];
        [self.btnThemScoreB setHidden:NO];
    } else {
        NSLog(@"hide, hide");
        [self.btnUsScoreB setHidden:YES];
        [self.btnThemScoreB setHidden:YES];
    }
}

- (void)updateScoreUs:(NSNumber*)increment {
    NSNumber *newScore = @([[self.userDefaults objectForKey:@"gameScoreUs"] intValue] + [increment intValue]);
    [self.userDefaults setObject:newScore forKey:@"gameScoreUs"];
    [self.labUsScore setText:[[self.userDefaults objectForKey:@"gameScoreUs"] stringValue]];
}

- (void)updateScoreThem:(NSNumber*)increment {
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

- (IBAction)tchUsScoreB {
    [self updateScoreUs:[self.userDefaults objectForKey:@"currentSportScoreTypeFpoints"]];
}

- (IBAction)tchThemScoreA {
    [self updateScoreThem:[self.userDefaults objectForKey:@"currentSportScoreTypeEpoints"]];
}

- (IBAction)tchThemScoreB {
    [self updateScoreThem:[self.userDefaults objectForKey:@"currentSportScoreTypeFpoints"]];
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
}

@end



