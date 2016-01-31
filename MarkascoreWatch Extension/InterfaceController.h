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
@property (strong, nonatomic) NSUndoManager *undoManager;
@property (nonatomic) BOOL timerRunning;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTimer *tmrMain;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *labUs;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *labThem;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *labUsScore;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *labThemScore;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnUsScoreA;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnThemScoreA;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnUndoA;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnUsScoreAAlt;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnThemScoreAAlt;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnUndoAAlt;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnUsScoreB;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnUndoB;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnThemScoreB;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnUsScoreC;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnUsScoreD;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnThemScoreC;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *btnThemScoreD;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *grp2;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *grp3;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *grp1;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *grp0;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *grp0Alt;

- (IBAction)tchUsScoreA;
- (IBAction)tchThemScoreA;
- (IBAction)tchUndoA;

- (IBAction)tchUsScoreAAlt;
- (IBAction)tchThemScoreAAlt;
- (IBAction)tchUndoAAlt;

- (IBAction)tchUsScoreB;
- (IBAction)tchUndoB;
- (IBAction)tchThemScoreB;

- (IBAction)tchUsScoreC;
- (IBAction)tchUsScoreD;
- (IBAction)tchThemScoreC;
- (IBAction)tchThemScoreD;

- (IBAction)tchPlay;
- (IBAction)tchPause;
- (IBAction)tchRestart;
- (IBAction)tchReset;

@end
