//
//  SMYHUDTool.h
//  shengbei
//
//  Created by 张云飞 on 2019/4/30.
//  Copyright © 2019 smyfinancial. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "SMYProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMYHUDTool : NSObject

/**
 *  转狗头加文字
 */
+ (nullable SMYProgressHUD *)showLoadingHUDWithTitle:(nullable NSString *)text inView:(nullable UIView *)inview;

/**
 *  转狗头
 */
+ (nullable SMYProgressHUD *)showLoadingHUDInView:(nullable UIView *)view;

/**
 *  取消等待提示
 */
+ (void)hideHUD:(nullable SMYProgressHUD *)hud;

/**
 *  取消指定视图中的等待提示
 *
 *  @param view 目标页面
 */
+ (void)hideHUDInView:(nullable UIView *)view;

/**
 *  显示纯文本，并且维持delay秒后自动关闭
 *
 *  @param text  文本
 *  @param view  目标页面
 *  @param delay 延迟关闭时间
 *  @param block 提示结束
 */
+ (nullable SMYProgressHUD *)showTextHUD:(nullable NSString *)text inView:(nullable UIView *)view
                           maintainTime:(NSTimeInterval)delay block:(nullable void(^)())block;

+ (nullable SMYProgressHUD *)showTextHUD:(nullable NSString *)text inView:(nullable UIView *)view maintainTime:(NSTimeInterval)delay;

+ (nullable SMYProgressHUD *)showDetailTextHUD:(nullable NSString *)text inView:(nullable UIView *)view
                                 maintainTime:(NSTimeInterval)delay block:(nullable void(^)())block;

+ (nullable SMYProgressHUD *)showDetailTextHUD:(nullable NSString *)text inView:(nullable UIView *)view maintainTime:(NSTimeInterval)delay;

/**
 带假进度条的等待动画
 @param text 显示文字
 @param duration 显示时间
 @param inview 目标页面
 */
+ (nullable SMYProgressHUD *)showProgressHUDWithTitle:(nullable NSString *)text duration:(CGFloat)duration inView:(nullable UIView *)inview;

/**
 关闭假进度条的等待动画
 */
+ (void)hideProgressHUD:(nullable void(^)())complete;

@end

NS_ASSUME_NONNULL_END

