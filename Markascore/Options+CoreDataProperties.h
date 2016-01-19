//
//  Options+CoreDataProperties.h
//  Markascore
//
//  Created by Christopher Stoll on 1/14/16.
//  Copyright © 2016 Christopher Stoll. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Options.h"

NS_ASSUME_NONNULL_BEGIN

@interface Options (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *teamA;
@property (nullable, nonatomic, retain) NSString *teamB;
@property (nullable, nonatomic, retain) NSNumber *theme;
@property (nullable, nonatomic, retain) NSNumber *preventSleep;
@property (nullable, nonatomic, retain) NSNumber *enableUndo;

@end

NS_ASSUME_NONNULL_END
