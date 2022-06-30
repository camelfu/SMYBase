//
//  UIColor+Custom.m
//  YDHomeWork
//
//  Created by zyf on 15/7/9.
//  Copyright (c) 2015年 张 云 飞. All rights reserved.
//

#import "UIColor+Custom.h"

@implementation UIColor (Custom)

+ (UIColor *)colorWithHex:(int)color alpha:(float)alpha {
    return [UIColor colorWithRed:((Byte)(color >> 16)) / 255.0f
                           green:((Byte)(color >> 8)) / 255.0f
                            blue:((Byte)color) / 255.0f alpha:alpha];
}

@end
