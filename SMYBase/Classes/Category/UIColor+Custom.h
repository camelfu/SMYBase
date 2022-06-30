//
//  UIColor+Custom.h
//  YDHomeWork
//
//  Created by zyf on 15/7/9.
//  Copyright (c) 2015年 张 云 飞. All rights reserved.
//
//  16进制色值

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Custom)

/**
 设置颜色

 @param color 16进制色值
 @param alpha 透明度
 @return UIColor
 */
+ (UIColor *)colorWithHex:(int)color alpha:(float)alpha;

@end

NS_ASSUME_NONNULL_END
