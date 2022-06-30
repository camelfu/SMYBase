//
//  SMYAlertView.h
//  testConstraint
//
//  Created by jwter on 15/9/8.
//  Copyright (c) 2015年 smyfinancial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SMYAlertCountDownType) {
    SMYAlertNoCountDown,
    SMYAlertCountDownFirstButton,
    SMYAlertCountDownLastButton
};

@interface SMYAlertView : UIView

@property (nonatomic, readonly) UIView *container;
/** 是否强制竖向排列按钮 */
@property (nonatomic, assign) BOOL forceDisplayButtonVertically;

/** 默认 17号 #333333 */
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;

/** 默认 18号 #12C963 */
@property (nonatomic, strong) UIFont *buttonFont;
/** 默认 51 */
@property (nonatomic, assign) CGFloat buttonHeight;
/** 按钮标题,默认空 */
@property (nonatomic, strong) NSArray *buttonTitles;
@property (nonatomic, strong) UIColor *buttonColor;
/** 第一个按钮的颜色 */
@property (nonatomic, strong) UIColor *firstButtonColor;
/** 第二个按钮的颜色 */
@property (nonatomic, strong) UIColor *secondButtonColor;
/** 最后一个按钮的颜色 */
@property (nonatomic, strong) UIColor *lastButtonColor;

/** 倒计时类型 */
@property (nonatomic, assign) SMYAlertCountDownType countDownType;
/** 按钮的倒计时时长 */
@property (nonatomic, assign) int buttonCountDownTime;
/** 按钮的倒计时标题颜色 */
@property (nonatomic, strong) UIColor *countDownTitleColor;

/** 消息,默认空 */
@property (nonatomic, strong, nullable) NSArray *messages;
/** 默认14号 */
@property (nonatomic, strong) NSMutableArray *messageFonts;
/** 默认#777777 */
@property (nonatomic, strong) NSMutableArray *messageColors;
@property (nonatomic, assign) NSTextAlignment messageTextAlignment;

/** 默认 白色 */
@property (nonatomic, strong) UIColor *alertColor;
/** 默认 280 */
@property (nonatomic, assign) CGFloat alertWidth;
/** 默认 20 */
@property (nonatomic, assign) CGFloat topMargin;
/** 默认 15 */
@property (nonatomic, assign) CGFloat messageMargin;
/** 默认 20 */
@property (nonatomic, assign) CGFloat bottonMargin;
/** 默认32 文字对于两边的边距 */
@property (nonatomic, assign) CGFloat sideMargin;
/** 默认 15 自定义控件上边距 */
@property (nonatomic, assign) CGFloat customViewMargin;
/** 朝向，默认正面竖屏 */
@property (nonatomic, assign) UIInterfaceOrientation orientation;
@property (nonatomic, copy, nullable) dispatch_block_t didDissappearWithoutUserClickHandler;
/** 显示右上角关闭按钮（默认不显示） */
@property (nonatomic, assign, getter=isShowCloseBtn) BOOL showCloseBtn;
/** 分隔线的颜色 */
@property (nonatomic, strong) UIColor *separatorLineColor;
/** alert从视图消失之后的回调 */
@property (nonatomic, copy, nullable) void (^completeBlock)();
/** 是否在底部显示 */
@property (nonatomic, assign, getter=isShowInBottom) BOOL showInBottom;
/**
 在keyWindow上显示文字alert

 @param title 提示标题
 @param messages 提示信息
 @param buttonTitles 自定义按钮标题
 @param handler 按钮点击回调，返回YES表示点击按钮后alert需要从superview上remove
 */
- (void)showTitle:(nullable NSString *)title
         messages:(nullable NSArray *)messages
     buttonTitles:(nullable NSArray *)buttonTitles
     handlerBlock:(nullable BOOL (^)(NSInteger buttonIndex))handler;

/**
 在指定view上显示文字alert

 @param title 提示标题
 @param messages 提示信息
 @param buttonTitles 自定义按钮标题
 @param inView 指定的view，不传view即在keyWindow上显示
 @param handler 按钮点击回调，返回YES表示点击按钮后alert需要从superview上remove
 */
- (void)showTitle:(nullable NSString *)title
         messages:(nullable NSArray *)messages
     buttonTitles:(nullable NSArray *)buttonTitles
           inView:(nullable UIView *)inView
     handlerBlock:(nullable BOOL (^)(NSInteger buttonIndex))handler;

/**
 在keyWindow上显示自定义view alert

 @param title 提示标题
 @param customView 自定义view
 @param buttonTitles 自定义按钮标题
 @param handler 按钮点击回调，返回YES表示点击按钮后alert需要从superview上remove
 */
- (void)showTitle:(nullable NSString *)title
       customView:(nullable UIView *)customView
     buttonTitles:(nullable NSArray *)buttonTitles
     handlerBlock:(nullable BOOL (^)(NSInteger buttonIndex))handler;

/**
 在指定view上显示自定义view alert
 
 @param title 提示标题
 @param customView 自定义view
 @param buttonTitles 自定义按钮标题
 @param inView 指定的view，不传view即在keyWindow上显示
 @param handler 按钮点击回调，返回YES表示点击按钮后alert需要从superview上remove
 */
- (void)showTitle:(nullable NSString *)title
       customView:(nullable UIView *)customView
     buttonTitles:(nullable NSArray *)buttonTitles
           inView:(nullable UIView *)inView
     handlerBlock:(nullable BOOL (^)(NSInteger buttonIndex))handler;

/**
 在指定view上显示自定义文字与view alert
 
 @param title 提示标题
 @param messages 提示信息
 @param customView 自定义view
 @param buttonTitles 自定义按钮标题
 @param inView 指定的viewv，不传view即在keyWindow上显示
 @param handler 按钮点击回调，返回YES表示点击按钮后alert需要从superview上remove
 */
- (void)showTitle:(nullable NSString *)title
         messages:(nullable NSArray *)messages
       customView:(nullable UIView *)customView
     buttonTitles:(nullable NSArray *)buttonTitles
           inView:(nullable UIView *)inView
     handlerBlock:(nullable BOOL (^)(NSInteger buttonIndex))handler;

/**
在指定view上显示自定义文字与view alert

@param title 提示标题
@param messages 提示信息
@param customViews 自定义view数组
@param buttonTitles 自定义按钮标题
@param inView 指定的viewv，不传view即在keyWindow上显示
@param handler 按钮点击回调，返回YES表示点击按钮后alert需要从superview上remove
*/
- (void)showTitle:(nullable NSString *)title
         messages:(nullable NSArray *)messages
      customViews:(nullable NSArray *)customViews
     buttonTitles:(nullable NSArray *)buttonTitles
           inView:(nullable UIView *)inView
     handlerBlock:(nullable BOOL (^)(NSInteger buttonIndex))handler;

- (void)hide;

- (CGFloat)getCustomWidth;

@end

NS_ASSUME_NONNULL_END
