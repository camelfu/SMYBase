//
//  UIView+Dot.h
//  credit
//
//  Created by 张云飞 on 16/3/19.
//  Copyright © 2016年 smyfinancial. All rights reserved.
//
//  view红点提示

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface UIView_DotView : UILabel
@end

@interface UIView (Dot)

@property (nonatomic, strong, readonly, nullable) UIView_DotView * dotView;

/**
 默认红点
 */
- (void)showDot;

/**
 默认文字红点

 @param text 红点中文字
 */
- (void)showDot:(nullable NSString *)text;

/**
 红点坐标

 @param point 坐标
 @param text 文字
 */
- (void)showDot:(CGPoint)point text:(nullable NSString *)text;

/**
 红点坐标和大小

 @param point 坐标
 @param radius 大小
 */
- (void)showDot:(CGPoint)point radius:(CGFloat)radius;

/**
 红点坐标 && 大小 && 文字

 @param point 坐标
 @param radius 大小
 @param text 文字
 */
- (void)showDot:(CGPoint)point radius:(CGFloat)radius text:(nullable NSString *)text font:(nullable UIFont *)font;

/**
 数字红点(最大显示两位数)

 @param number 数字
 */
- (void)showDotWithNumber:(NSInteger)number point:(CGPoint)point radius:(CGFloat)radius font:(nullable UIFont *)font;

/**
 隐藏红点
 */
- (void)hideDot;

@end
