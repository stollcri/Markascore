//
//  Game+CoreDataProperties.h
//  Markascore
//
//  Created by Christopher Stoll on 1/11/16.
//  Copyright © 2016 Christopher Stoll. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Game.h"

NS_ASSUME_NONNULL_BEGIN

@interface Game (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *sportName;
@property (nullable, nonatomic, retain) NSNumber *period;
@property (nullable, nonatomic, retain) NSNumber *scoreUs;
@property (nullable, nonatomic, retain) NSNumber *scoreThem;
@property (nullable, nonatomic, retain) NSDate *timeElapsed;
@property (nullable, nonatomic, retain) NSNumber *timeElapsedMinutes;
@property (nullable, nonatomic, retain) NSNumber *timeElapsedSeconds;
@property (nullable, nonatomic, retain) NSNumber *timeRunning;
@property (nullable, nonatomic, retain) NSDate *timeStartedAt;
@property (nullable, nonatomic, retain) NSNumber *timeSaveMinutes;
@property (nullable, nonatomic, retain) NSNumber *timeSaveSeconds;
@property (nullable, nonatomic, retain) NSNumber *timeCountUp;
@property (nullable, nonatomic, retain) NSNumber *timeCountUpCum;

@end

NS_ASSUME_NONNULL_END
