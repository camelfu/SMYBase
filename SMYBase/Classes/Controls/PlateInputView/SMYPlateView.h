//
//  SMYPlateView.h
//  SMYBusinessBase
//
//  Created by penggongxu on 2020/12/29.
//  Copyright © 2020 smyfinancial. All rights reserved.
//
//  车牌视图

#import <UIKit/UIKit.h>

@interface SMYPlateView : UIView

/** 输入结束回调  isConfirmClicked : 是否是点击了确定按钮 */
@property (nonatomic, copy) void (^ _Nullable inputCompleted)(BOOL isConfirmClicked, NSString * _Nullable plateNum);

- (void)show;

- (void)hide;

/// 设置键盘回显
- (void)setNum:(nullable NSString *)plateNum;

/// 初始化键盘
/// @param title 标题
+ (nonnull instancetype)initWithTitle:(nullable NSString *)title;

@end


