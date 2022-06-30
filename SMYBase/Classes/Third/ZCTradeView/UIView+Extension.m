//
//  UIView+Extension.m
//  01-黑酷
//
//  Created by apple on 14-6-27.
//  Copyright (c) 2014年 heima. All rights reserved.
//

// 最大的尺寸
#define ZCMAXSize CGSizeMake(MAXFLOAT, MAXFLOAT)

// 快速实例
#define Object(Class) [[Class alloc] init];

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setZc_width:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)zc_width
{
    return self.frame.size.width;
}

- (void)setZc_height:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)zc_height
{
    return self.frame.size.height;
}

- (void)setZc_size:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)zc_size
{
    return self.frame.size;
}

- (void)setZc_centerX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)zc_centerX
{
    return self.center.x;
}

- (void)setZc_centerY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)zc_centerY
{
    return self.center.y;
}

/** 水平居中 */
- (void)alignHorizontal
{
    self.x = (self.superview.zc_width - self.zc_width) * 0.5;
}

/** 垂直居中 */
- (void)alignVertical
{
    self.y = (self.superview.zc_height - self.zc_height) * 0.5;
}

@end
