//
//  AppDelegate.m
//  Markascore
//
//  Created by Christopher Stoll on 1/9/16.
//  Copyright © 2016 Christopher Stoll. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    MainViewController *controller = (MainViewController *)navigationController.topViewController;
    controller.managedObjectContext = self.managedObjectContext;
    
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "org.christopherstoll.Markascore" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Markascore" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Markascore.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Watch connectivity

- (NSDictionary *)prepareDataforWatch {
    NSMutableDictionary *watchData = [[NSMutableDictionary alloc] init];

    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSError *error = nil;
    NSArray *fetchedObjects = nil;
    
    NSEntityDescription *optionsEntity = [NSEntityDescription entityForName:@"Options" inManagedObjectContext:context];
    [fetch setEntity:optionsEntity];
    error = nil;
    fetchedObjects = [context executeFetchRequest:fetch error:&error];
    if ([fetchedObjects count] > 0) {
        Options *moOptions = fetchedObjects[0];
        [watchData setObject:moOptions.teamA forKey:@"teamA"];
        [watchData setObject:moOptions.teamB forKey:@"teamB"];
    } else {
        //
        // No data is saved, the iOS app hasn't been used
        // The watch app should use its defaults, so return nil
        //
        return nil;
    }

    NSEntityDescription *gameEntity = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:context];
    [fetch setEntity:gameEntity];
    error = nil;
    fetchedObjects = [context executeFetchRequest:fetch error:&error];
    if ([fetchedObjects count] > 0) {
        Game *moGame = fetchedObjects[0];
        [watchData setObject:moGame.sportName forKey:@"gameSport"];
        [watchData setObject:moGame.period forKey:@"gamePeriod"];
        /*
        [watchData setObject:moGame.scoreUs forKey:@"gameScoreUs"];
        [watchData setObject:moGame.scoreThem forKey:@"gameScoreThem"];
         */
        [watchData setObject:moGame.timeCountUp forKey:@"gameTimeCountUp"];
        [watchData setObject:moGame.timeCountUpCum forKey:@"gameTimeCountUpCum"];
        /*
        [watchData setObject:moGame.timeElapsed forKey:@"gameTimeElapsed"];
        [watchData setObject:moGame.timeElapsedMinutes forKey:@"gameTimeElapsedMinutes"];
        [watchData setObject:moGame.timeElapsedSeconds forKey:@"gameTimeElapsedSeconds"];
        [watchData setObject:moGame.timeRunning forKey:@"gameTimeRunning"];
        [watchData setObject:moGame.timeStartedAt forKey:@"gameTimeStartedAt"];
        [watchData setObject:moGame.timeSaveMinutes forKey:@"gameTimeSaveMinutes"];
        [watchData setObject:moGame.timeSaveSeconds forKey:@"gameTimeSaveSeconds"];
         */
    }

    NSEntityDescription *sportsEntity = [NSEntityDescription entityForName:@"Sport" inManagedObjectContext:context];
    [fetch setEntity:sportsEntity];
    error = nil;
    fetchedObjects = [context executeFetchRequest:fetch error:&error];
    Sport *moSport;
    //NSMutableArray *sportsList = [[NSMutableArray alloc] init];
    if ([fetchedObjects count] > 0) {
        for (moSport in fetchedObjects) {
            /*
            NSMutableDictionary *currentSport = [[NSMutableDictionary alloc] init];
            [currentSport setObject:moSport.name forKey:@"name"];
            [currentSport setObject:moSport.periodQuantity forKey:@"periodQuantity"];
            [currentSport setObject:moSport.periodTime forKey:@"periodTime"];
            [currentSport setObject:moSport.scoreTypeEname forKey:@"scoreTypeEname"];
            [currentSport setObject:moSport.scoreTypeEpoints forKey:@"scoreTypeEpoints"];
            [currentSport setObject:moSport.scoreTypeFname forKey:@"scoreTypeFname"];
            [currentSport setObject:moSport.scoreTypeFpoints forKey:@"scoreTypeFpoints"];
            [currentSport setObject:moSport.scoreTypeGname forKey:@"scoreTypeGname"];
            [currentSport setObject:moSport.scoreTypeGpoints forKey:@"scoreTypeGpoints"];
            [currentSport setObject:moSport.periodTimeUp forKey:@"periodTimeUp"];
            [currentSport setObject:moSport.periodTimeUpCum forKey:@"periodTimeUpCum"];
            [sportsList addObject:currentSport];
             */
            
            if ([moSport.name isEqualToString:[watchData objectForKey:@"gameSport"]]) {
                [watchData setObject:moSport.name forKey:@"currentSportName"];
                [watchData setObject:moSport.periodQuantity forKey:@"currentSportPeriodQuantity"];
                [watchData setObject:moSport.periodTime forKey:@"currentSportPeriodTime"];
                [watchData setObject:moSport.scoreTypeEname forKey:@"currentSportScoreTypeEname"];
                [watchData setObject:moSport.scoreTypeEpoints forKey:@"currentSportScoreTypeEpoints"];
                [watchData setObject:moSport.scoreTypeFname forKey:@"currentSportScoreTypeFname"];
                [watchData setObject:moSport.scoreTypeFpoints forKey:@"currentSportScoreTypeFpoints"];
                [watchData setObject:moSport.scoreTypeGname forKey:@"currentSportScoreTypeGname"];
                [watchData setObject:moSport.scoreTypeGpoints forKey:@"currentSportScoreTypeGpoints"];
                [watchData setObject:moSport.periodTimeUp forKey:@"currentSportPeriodTimeUp"];
                [watchData setObject:moSport.periodTimeUpCum forKey:@"currentSportPeriodTimeUpCum"];
            }
        }
    }
    //NSArray *sports = [sportsList copy];
    //[watchData setObject:sports forKey:@"sports"];

    
    return watchData;
}

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler {
    NSString *commandValue = [message objectForKey:@"command"];
    
    if ([commandValue isEqualToString:@"SendAppCoreData"]) {
        NSDictionary *appCoreData = [self prepareDataforWatch];
        if (appCoreData) {
            replyHandler(appCoreData);
        }
    }
    
    //    //Use this to update the UI instantaneously (otherwise, takes a little while)
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [self.counterData addObject:counterValue];
    //        [self.mainTableView reloadData];
    //    });
}

@end
