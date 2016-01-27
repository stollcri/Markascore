//
//  InterfaceController.h
//  MarkascoreWatch Extension
//
//  Created by Christopher Stoll on 1/18/16.
//  Copyright © 2016 Christopher Stoll. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <WatchConnectivity/WatchConnectivity.h>

@interface InterfaceController : WKInterfaceController <WCSessionDelegate>

@property (strong, nonatomic) NSUserDefaults *userDefaults;
@property (nonatomic) BOOL timerRunning;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTimer *tmrMain;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *labUs;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *labThem;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *labUsScore;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *labThemScore;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnUsScoreA;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnUsScoreB;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnThemScoreA;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnThemScoreB;

- (IBAction)tchUsScoreA;
- (IBAction)tchUsScoreB;
- (IBAction)tchThemScoreA;
- (IBAction)tchThemScoreB;

- (IBAction)tchPlay;
- (IBAction)tchPause;
- (IBAction)tchRestart;
- (IBAction)tchReset;

@end
