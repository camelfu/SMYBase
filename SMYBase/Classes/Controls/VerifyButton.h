//
//  VerifyButton.h
//  credit
//
//  Created by jwter on 15/7/22.
//  Copyright (c) 2015年 smyfinancial. All rights reserved.
//
// 获取验证码按钮

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VerifyButton;

@protocol VerifyButtonDelegate <NSObject>

- (void)verifyButtonClick:(VerifyButton *)sender;

@end

@interface VerifyButton : UIButton


@property (nonatomic, weak, nullable) id<VerifyButtonDelegate> delegate;

/**
 *  是否 注册时
 */
@property (nonatomic, assign) BOOL registered;

/**
 *  默认 获取验证码
 */
@property (nonatomic, copy) NSString *title;
/**
 *  字体,系统默认
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 *  边框圆角  默认0
 */
@property (nonatomic, assign) double cornerRadius;

/**
 *  倒计时的秒数  默认61
 */
@property (nonatomic, assign) int counter;

/**
 *  例如: (%ds)\n重新发送   %d为显示倒计时的位置
 */
@property (nonatomic, copy) NSString *counterTitleFormat;

/** 保持倒计时的标记,建议使用页面ViewController的名称 */
@property (nonatomic, copy) NSString *holdTag;

/**
 *  倒计时时的背景色
 */
@property (nonatomic, strong) UIColor *counterBackgroundColor;

/**
 *  倒计时字颜色 默认系统黑
 */
@property (nonatomic, strong) UIColor *counterTintColor;

/**
 *  是否获取中
 */
@property (nonatomic, assign) BOOL isVerifyGeting;

/**
 是否在倒计时中
 */
@property (nonatomic, assign) BOOL isCounterGoingOn;

/**
 *  开始倒计时
 */
- (void)startCounter;

/**
 重新开始倒计时
 */
- (void)restartCounter;

/**
 继续之前倒计时，如果已经结束，则不会重新开始
 */
- (void)continueCounter;

/**
 *  停止倒计时
 */
- (void)stopCounter;

- (void)setLeftLineHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
