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
    handler(CLKComplicationTimeTravelDirectionForward|CLKComplicationTimeTravelDirectionBackward);
}

- (void)getTimelineStartDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler(nil);
}

- (void)getTimelineEndDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler(nil);
}

- (void)getPrivacyBehaviorForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationPrivacyBehavior privacyBehavior))handler {
    handler(CLKComplicationPrivacyBehaviorShowOnLockScreen);
}

#pragma mark - Timeline Population

- (void)getCurrentTimelineEntryForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimelineEntry * __nullable))handler {
    // Call the handler with the current timeline entry
    //handler(nil);
    NSLog(@"getCurrentTimelineEntryForComplication");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *nameUs = [userDefaults objectForKey:@"teamA"];
    NSString *nameThem = [userDefaults objectForKey:@"teamB"];
    NSString *scoreUs = [[userDefaults objectForKey:@"gameScoreUs"] stringValue];
    NSString *scoreThem =[[userDefaults objectForKey:@"gameScoreThem"] stringValue];
    
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
            NSString *textUs = [NSString stringWithFormat:@"%@ - %@", nameUs, scoreUs];
            NSString *textThem = [NSString stringWithFormat:@"%@ - %@", nameThem, scoreThem];
            //NSLog(@"ML textUs:   %@", textUs);
            //NSLog(@"ML textThem: %@", textThem);
            
            CLKComplicationTemplateModularLargeStandardBody *modularTemplate = [[CLKComplicationTemplateModularLargeStandardBody alloc] init];
            modularTemplate.headerTextProvider = [CLKSimpleTextProvider textProviderWithText:@"Markascore"];
            modularTemplate.body1TextProvider = [CLKSimpleTextProvider textProviderWithText:textUs];
            modularTemplate.body2TextProvider = [CLKSimpleTextProvider textProviderWithText:textThem];
            
            timelineEntry.date = [NSDate date];
            timelineEntry.complicationTemplate = modularTemplate;
            timelineEntryDefined = YES;
            break;
        }
        case CLKComplicationFamilyUtilitarianSmall: {
            NSString *textScores = [NSString stringWithFormat:@"%@ %@ - %@ %@", [nameUs substringWithRange:[nameUs rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 1)]], scoreUs, scoreThem, [nameThem substringWithRange:[nameThem rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 1)]]];
            //NSLog(@"US textUs: %@", textScores);
            
            CLKComplicationTemplateUtilitarianSmallFlat *modularTemplate = [[CLKComplicationTemplateUtilitarianSmallFlat alloc] init];
            modularTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:textScores];
            
            timelineEntry.date = [NSDate date];
            timelineEntry.complicationTemplate = modularTemplate;
            timelineEntryDefined = YES;
            break;
        }
        case CLKComplicationFamilyUtilitarianLarge: {
            NSString *textScores = [NSString stringWithFormat:@"%@ %@ - %@ %@", nameUs, scoreUs, scoreThem, nameThem];
            //NSLog(@"UL textUs: %@", textScores);
            
            CLKComplicationTemplateUtilitarianLargeFlat *modularTemplate = [[CLKComplicationTemplateUtilitarianLargeFlat alloc] init];
            modularTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:textScores];
            
            timelineEntry.date = [NSDate date];
            timelineEntry.complicationTemplate = modularTemplate;
            timelineEntryDefined = YES;
            break;
        }
        default:
            break;
    }
    
    if (timelineEntryDefined) {
        handler(timelineEntry);
    } else {
        handler(nil);
    }
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication beforeDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries prior to the given date
    handler(nil);
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication afterDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries after to the given date
    handler(nil);
}

#pragma mark Update Scheduling

- (void)getNextRequestedUpdateDateWithHandler:(void(^)(NSDate * __nullable updateDate))handler {
    // Call the handler with the date when you would next like to be given the opportunity to update your complication content
    //handler(nil);
    
    handler([NSDate dateWithTimeIntervalSinceNow:60*15]);
    //handler([NSDate dateWithTimeIntervalSinceNow:60*60]);
}

#pragma mark - Placeholder Templates

- (void)getPlaceholderTemplateForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTemplate * __nullable complicationTemplate))handler {
    // This method will be called once per supported complication, and the results will be cached
    handler(nil);
    NSLog(@"getPlaceholderTemplateForComplication");
    /*
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *nameUs = [userDefaults objectForKey:@"teamA"];
    NSString *nameThem = [userDefaults objectForKey:@"teamB"];
    NSString *scoreUs = [[userDefaults objectForKey:@"gameScoreUs"] stringValue];
    NSString *scoreThem =[[userDefaults objectForKey:@"gameScoreThem"] stringValue];
    
    CLKComplicationTemplate *template = nil;
    switch (complication.family) {
        case CLKComplicationFamilyCircularSmall:
            //
            break;
        case CLKComplicationFamilyModularSmall:
            //
            break;
        case CLKComplicationFamilyModularLarge: {
            NSString *textUs = [NSString stringWithFormat:@"%@ -|- %@", nameUs, scoreUs];
            NSString *textThem = [NSString stringWithFormat:@"%@ -|- %@", nameThem, scoreThem];
            NSLog(@"ML textUs:   %@", textUs);
            NSLog(@"ML textThem: %@", textThem);
            
            CLKComplicationTemplateModularLargeStandardBody *modularTemplate = [[CLKComplicationTemplateModularLargeStandardBody alloc] init];
            modularTemplate.headerTextProvider = [CLKSimpleTextProvider textProviderWithText:@"Markascore"];
            modularTemplate.body1TextProvider = [CLKSimpleTextProvider textProviderWithText:textUs];
            modularTemplate.body2TextProvider = [CLKSimpleTextProvider textProviderWithText:textThem];
            break;
        }
        case CLKComplicationFamilyUtilitarianSmall: {
            NSString *textScores = [NSString stringWithFormat:@"%@ -|- %@", scoreUs, scoreThem];
            NSLog(@"US textUs: %@", textScores);
            
            CLKComplicationTemplateUtilitarianSmallFlat *modularTemplate = [[CLKComplicationTemplateUtilitarianSmallFlat alloc] init];
            modularTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:textScores];
            break;
        }
        case CLKComplicationFamilyUtilitarianLarge: {
            NSString *textScores = [NSString stringWithFormat:@"%@ -|- %@", scoreUs, scoreThem];
            NSLog(@"US textUs: %@", textScores);
            
            CLKComplicationTemplateUtilitarianLargeFlat *modularTemplate = [[CLKComplicationTemplateUtilitarianLargeFlat alloc] init];
            modularTemplate.textProvider = [CLKSimpleTextProvider textProviderWithText:textScores];
            break;
        }
        default:
            break;
    }
    handler(template);
    */
}

@end
