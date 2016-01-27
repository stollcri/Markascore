//
//  Sport+CoreDataProperties.h
//  Markascore
//
//  Created by Christopher Stoll on 1/10/16.
//  Copyright © 2016 Christopher Stoll. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Sport.h"

NS_ASSUME_NONNULL_BEGIN

@interface Sport (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *periodQuantity;
@property (nullable, nonatomic, retain) NSNumber *periodTime;
@property (nullable, nonatomic, retain) NSString *scoreTypeAname;
@property (nullable, nonatomic, retain) NSNumber *scoreTypeApoints;
@property (nullable, nonatomic, retain) NSString *scoreTypeBname;
@property (nullable, nonatomic, retain) NSString *scoreTypeCname;
@property (nullable, nonatomic, retain) NSString *scoreTypeDname;
@property (nullable, nonatomic, retain) NSString *scoreTypeEname;
@property (nullable, nonatomic, retain) NSString *scoreTypeFname;
@property (nullable, nonatomic, retain) NSString *scoreTypeGname;
@property (nullable, nonatomic, retain) NSNumber *scoreTypeBpoints;
@property (nullable, nonatomic, retain) NSNumber *scoreTypeCpoints;
@property (nullable, nonatomic, retain) NSNumber *scoreTypeDpoints;
@property (nullable, nonatomic, retain) NSNumber *scoreTypeEpoints;
@property (nullable, nonatomic, retain) NSNumber *scoreTypeFpoints;
@property (nullable, nonatomic, retain) NSNumber *scoreTypeGpoints;
@property (nullable, nonatomic, retain) NSNumber *periodTimeUp;
@property (nullable, nonatomic, retain) NSNumber *periodTimeUpCum;

@end

NS_ASSUME_NONNULL_END
