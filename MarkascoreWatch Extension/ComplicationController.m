//
//  ComplicationController.m
//  MarkascoreWatch Extension
//
//  Created by Christopher Stoll on 1/18/16.
//  Copyright © 2016 Christopher Stoll. All rights reserved.
//

#import "ComplicationController.h"

@interface ComplicationController ()

@end

@implementation ComplicationController

#pragma mark - Timeline Configuration

- (void)getSupportedTimeTravelDirectionsForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimeTravelDirections directions))handler {
    handler(CLKComplicationTimeTravelDirectionBackward);
}

- (void)getTimelineStartDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
//    handler(nil);
//    NSLog(@"getTimelineStartDateForComplication");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *gameScoresTimeline = [userDefaults objectForKey:@"gameScoresTimeline"];
    NSDictionary *firstGameScore = [gameScoresTimeline firstObject];
    NSDate *firstScore = [firstGameScore objectForKey:@"datetime"];
    handler(firstScore);
}

- (void)getTimelineEndDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
//    handler(nil);
//    NSLog(@"getTimelineEndDateForComplication");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *gameScoresTimeline = [userDefaults objectForKey:@"gameScoresTimeline"];
    NSDictionary *lastGameScore = [gameScoresTimeline lastObject];
    NSDate *lastScore = [lastGameScore objectForKey:@"datetime"];
    handler(lastScore);
}

- (void)getPrivacyBehaviorForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationPrivacyBehavior privacyBehavior))handler {
    handler(CLKComplicationPrivacyBehaviorShowOnLockScreen);
}

#pragma mark - Timeline Population

- (void)getCurrentTimelineEntryForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimelineEntry * __nullable))handler {
    // Call the handler with the current timeline entry
//    NSLog(@"getCurrentTimelineEntryForComplication");
    handler([self formatComplicationTimelineEntry:complication]);
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication beforeDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries prior to the given date
//     NSLog(@"getTimelineEntriesForComplication beforeDate %@", date);
//    handler(nil);
    
    NSMutableArray *timelineEntries = [[NSMutableArray alloc] init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *gameScoresTimeline = [userDefaults objectForKey:@"gameScoresTimeline"];
    for (NSDictionary *currentGameScore in gameScoresTimeline) {
        NSDate *currentScoreDate = [currentGameScore objectForKey:@"datetime"];
        if ([currentScoreDate compare:date] == NSOrderedAscending) {
            NSString *scoreUs = [[currentGameScore objectForKey:@"scoreUs"] stringValue];
            NSString *scoreThem = [[currentGameScore objectForKey:@"scoreThem"] stringValue];
            CLKComplicationTimelineEntry *timelineEntry = [self formatComplicationTimelineEntry:complication withDate:currentScoreDate andScoreUs:scoreUs andScoreThem:scoreThem];
            [timelineEntries addObject:timelineEntry];
        } else {
            break;
        }
    }
    handler(timelineEntries);
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication afterDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries after to the given date
//    NSLog(@"getTimelineEntriesForComplication afterDate %@", date);
//    handler(nil);
    
    NSMutableArray *timelineEntries = [[NSMutableArray alloc] init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *gameScoresTimeline = [userDefaults objectForKey:@"gameScoresTimeline"];
    for (NSDictionary *currentGameScore in gameScoresTimeline) {
        NSDate *currentScoreDate = [currentGameScore objectForKey:@"datetime"];
        if ([currentScoreDate compare:date] == NSOrderedDescending) {
            NSString *scoreUs = [[currentGameScore objectForKey:@"scoreUs"] stringValue];
            NSString *scoreThem = [[currentGameScore objectForKey:@"scoreThem"] stringValue];
            CLKComplicationTimelineEntry *timelineEntry = [self formatComplicationTimelineEntry:complication withDate:currentScoreDate andScoreUs:scoreUs andScoreThem:scoreThem];
            [timelineEntries addObject:timelineEntry];
        } else {
            break;
        }
    }
    handler(timelineEntries);
}

#pragma mark Update Scheduling

- (void)getNextRequestedUpdateDateWithHandler:(void(^)(NSDate * __nullable updateDate))handler {
    // Call the handler with the date when you would next like to be given the opportunity to update your complication content
    // The complication should be updated after the users uses the app
//    NSLog(@"getNextRequestedUpdateDateWithHandler");
    //
    // TODO
    //
    handler([NSDate dateWithTimeIntervalSinceNow:60*60*24]);
}

#pragma mark - Placeholder Templates

- (void)getPlaceholderTemplateForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTemplate * __nullable complicationTemplate))handler {
    // This method will be called once per supported complication, and the results will be cached
//    NSLog(@"getPlaceholderTemplateForComplication");
    handler(nil);
}

#pragma mark - Timeline Entry Format

- (CLKComplicationTimelineEntry*)formatComplicationTimelineEntry:(CLKComplication*)complication {
    NSDate *dateNow = [NSDate date];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *scoreUs = [[userDefaults objectForKey:@"gameScoreUs"] stringValue];
    NSString *scoreThem =[[userDefaults objectForKey:@"gameScoreThem"] stringValue];
    return [self formatComplicationTimelineEntry:complication withDate:dateNow andScoreUs:scoreUs andScoreThem:scoreThem];
}

- (CLKComplicationTimelineEntry*)formatComplicationTimelineEntry:(CLKComplication*)complication withDate:(NSDate*)date andScoreUs:(NSString*)scoreUs andScoreThem:(NSString*)scoreThem {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *nameUs = [userDefaults objectForKey:@"teamA"];
    NSString *nameThem = [userDefaults objectForKey:@"teamB"];
    
    //CLKComplicationTemplate *modularTemplate = nil;
    CLKComplicationTimelineEntry *timelineEntry = [[CLKComplicationTimelineEntry alloc] init];
    BOOL timelineEntryDefined = NO;
    switch (complication.family) {
        case CLKComplicationFamilyCircularSmall:
            //
            break;
        case CLKComplicationFamilyModularSmall:
            //
            break;
        case CLKComplicationFamilyModularLarge: {
            NSString *tmpNameUs = [[NSString alloc] init];
            NSString *tmpNameThem = [[NSString alloc] init];
            if ([nameUs length] > 10) {
                tmpNameUs = [nameUs substringWithRange:[nameUs rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 10)]];
            } else {
                tmpNameUs = nameUs;
            }
            if ([nameThem length] > 10) {
                tmpNameThem = [nameThem substringWithRange:[nameThem rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 10)]];
            } else {
                tmpNameThem = nameThem;
            }
            
            NSString *textUs = [NSString stringWithFormat:@"%@ - %@", tmpNameUs, scoreUs];
            NSString *textThem = [NSString stringWithFormat:@"%@ - %@", tmpNameThem, scoreThem];
            
            CLKComplicationTemplateModularLargeStandardBody *modularTemplate = [[CLKComplicationTemplateModularLargeStandardBody alloc] init];
            modularTemplate.headerTextProvider = [CLKSimpleTextProvider textProviderWithText:@"Markascore"];
            modularTemplate.body1TextProvider = [CLKSimpleTextProvider textProviderWithText:textUs];
            modularTemplate.body2TextProvider = [CLKSimpleTextProvider textProviderWithText:textThem];
            
            timelineEntry.date = date;
            timelineEntry.complicationTemplate = modularTemplate;
            timelineEntryDefined = YES;
            break;
        }
        case CLKComplicationFamilyUtilitarianSmall: {
            NSString *textScores = [[NSString alloc] init];
            if ([scoreUs length] > 1 && [scoreThem length] > 1) {
                if ([scoreUs length] > 2 && [scoreThem length] > 2) {
                    textScores = [NSString stringWithFormat:@"%@ - %@", scoreUs, scoreThem];
                } else {
                    textScores = [NSString stringWithFormat:@"%@ %@ - %@", [nameUs substringWithRange:[nameUs rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 1)]], scoreUs, scoreThem];
                }
            } else {
                textScores = [NSString stringWithFormat:@"%@ %@ - %@ %@", [nameUs substringWithRange:[nameUs rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 1)]], scoreUs, scoreThem, [nameThem substringWithRange:[nameThem rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 1)]]];
            }
            
            CLKComplicationTemplateUtilitarianSmallFlat *modularTemplate = [[CLKComplicationTemplateUtilitarianSmallFlat alloc] init];
            modularTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:textScores];
            
            timelineEntry.date = date;
            timelineEntry.complicationTemplate = modularTemplate;
            timelineEntryDefined = YES;
            break;
        }
        case CLKComplicationFamilyUtilitarianLarge: {
            NSString *tmpNameUs = [[NSString alloc] init];
            NSString *tmpNameThem = [[NSString alloc] init];
            if ([nameUs length] > 8) {
                tmpNameUs = [nameUs substringWithRange:[nameUs rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 8)]];
            } else {
                tmpNameUs = nameUs;
            }
            if ([nameThem length] > 8) {
                tmpNameThem = [nameThem substringWithRange:[nameThem rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 8)]];
            } else {
                tmpNameThem = nameThem;
            }
            NSString *textScores = [NSString stringWithFormat:@"%@ %@ - %@ %@", tmpNameUs, scoreUs, scoreThem, tmpNameThem];
            
            CLKComplicationTemplateUtilitarianLargeFlat *modularTemplate = [[CLKComplicationTemplateUtilitarianLargeFlat alloc] init];
            modularTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:textScores];
            
            timelineEntry.date = date;
            timelineEntry.complicationTemplate = modularTemplate;
            timelineEntryDefined = YES;
            break;
        }
        default:
            break;
    }
    
    if (timelineEntryDefined) {
        return timelineEntry;
    } else {
        return nil;
    }
}

@end
