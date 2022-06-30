//
//  ZCTradeView.h
//  直销银行
//
//  Created by 塔利班 on 15/4/30.
//  Copyright (c) 2015年 联创智融. All rights reserved.
//  交易密码视图\负责整个项目的交易密码输入



#import <UIKit/UIKit.h>

@class ZCTradeView;

@protocol ZCTradeViewDelegate <NSObject>

@optional

/** 点击取消按钮 */
- (void)tradeView:(ZCTradeView *)tradeInputView cancleBtnClick:(UIButton *)cancleBtnClick;

@required
- (void)btnForgetPasswordDidClicked;

@end

@interface ZCTradeView : UIView

// 密码
@property (nonatomic, copy) NSString *password;

/** 响应者 */
@property (nonatomic, readonly) UITextField *responder;

@property (nonatomic, weak) id<ZCTradeViewDelegate> delegate;

/** 完成的回调block */
@property (nonatomic, copy) void (^finish) (NSString *passWord);

/** 取消的回调block */
@property (nonatomic, copy) dispatch_block_t didCancelledHandler;

/** 点击忘记密码的回调block */
@property (nonatomic, copy) dispatch_block_t didClickForgetHandler;

/** 快速创建 */
+ (instancetype)tradeView;

/** 弹出 */
- (void)showInView:(UIView *)view;

/** 键盘退下 */
- (void)hidenKeyboard;

/// 输入字符
- (void)inputString:(NSString *)string;

/// 清空当前的所有输入
- (void)clearInput;

// 给子类重写：告诉外面，已经完成了输入，主要是要调用完成的回调——finish
- (void)finishInput;

@end
