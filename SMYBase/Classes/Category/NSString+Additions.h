//
//  NSString+Additions.h
//  credit
//
//  Created by 张云飞 on 15/9/8.
//  Copyright (c) 2015年 smyfinancial. All rights reserved.
//
//  字符串处理

#import <UIKit/UIKit.h>

@interface NSString (Additions)

/**
 动态返回字符串的宽/高

 @param font 字体大小
 @param size 固定宽/高
 @return CGSize
 */
- (CGSize)sizeWithMyFont:(nonnull UIFont *)font size:(CGSize)size;

/**
 是否包含汉字

 @return YES || NO
 */
- (BOOL)includeChinese;

/**
 字符长度

 @return int
 */
- (NSUInteger)wordsCount;

/**
 是否纯数字
 */
- (BOOL)isPureNumber;

- (NSString *)encodeURIComponent;

@end
