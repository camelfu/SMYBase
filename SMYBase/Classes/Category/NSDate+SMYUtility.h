//
//  NSDate+SMYUtility.h
//  shengbei
//
//  Created by ChenYong on 2019/7/4.
//  Copyright © 2019 smyfinancial. All rights reserved.
//
// 日期扩展

#import <Foundation/Foundation.h>

@interface NSDate (SMYUtility)

/**
 日期是一个月中的哪一天
 */
- (NSInteger)day;

/**
 日期是一个周中的哪一天，返回值是1到7
 */
- (NSInteger)weekDay;

/**
 日期是哪一月，返回值是1到12
 */
- (NSInteger)month;

/**
 日期是哪一年
 */
- (NSInteger)year;

/// 日期是一天中哪小时
- (NSInteger)hour;
/// 日期是哪分钟
- (NSInteger)minute;
/// 日期是哪秒
- (NSInteger)seconds;

@end
