//
//  NSDate+SMYUtility.m
//  shengbei
//
//  Created by ChenYong on 2019/7/4.
//  Copyright © 2019 smyfinancial. All rights reserved.
//

#import "NSDate+SMYUtility.h"

@implementation NSDate (SMYUtility)

- (NSInteger)day {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitDay;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:self];
    return dateComponents.day;
}

- (NSInteger)weekDay {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitWeekday;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:self];
    return dateComponents.weekday;
}

- (NSInteger)month {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitMonth;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:self];
    return dateComponents.month;
}

- (NSInteger)year {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitYear;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:self];
    return dateComponents.year;
}

- (NSInteger)hour {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitHour;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:self];
    return dateComponents.hour;
}

- (NSInteger)minute {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitMinute;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:self];
    return dateComponents.minute;
}

- (NSInteger)seconds {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitSecond;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:self];
    return dateComponents.second;
}

@end
