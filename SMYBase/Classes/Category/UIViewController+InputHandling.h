//
//  UIViewController+InputHandling.h
//  credit
//
//  Created by jwter on 15/7/9.
//  Copyright (c) 2015年 smyfinancial. All rights reserved.
//
//  添加点击手势 || 键盘弹出通知

#import <UIKit/UIKit.h>

@interface UIViewController (InputHandling)<UITextFieldDelegate>

/**
 添加点击手势, 被点击时，结束编辑状态，关闭键盘
 */
- (void)addTapGestureInView:(nullable UIView *)view;

/**
 键盘弹出通知
 */
- (void)addKeyboardNotification;

/**
 键盘添加完成

 @param txt UITextField
 */
- (void)addKeyboardFinish:(nullable UITextField *)txt;

@end
