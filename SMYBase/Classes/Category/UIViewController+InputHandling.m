//
//  UIViewController+InputHandling.m
//  credit
//
//  Created by jwter on 15/7/9.
//  Copyright (c) 2015年 smyfinancial. All rights reserved.
//

#import "UIViewController+InputHandling.h"
#import <objc/runtime.h>

const char textFieldKey;

@implementation UIViewController (InputHandling)

- (void)addTapGestureInView:(UIView *)view {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesturedDetected)];
    [view addGestureRecognizer:tapGesture];
}

- (void)tapGesturedDetected {
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

/** 当用户按下return键或者按回车键，keyboard消失 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

/** 键盘弹出通知 */
- (void)addKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputHandling_keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputHandling_keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

/** 键盘添加完成 */
- (void)addKeyboardFinish:(UITextField *)txt {
    if (txt) {
        objc_setAssociatedObject(self, &textFieldKey, txt, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowWidth, 40)];
    topView.backgroundColor = [UIColor colorWithHex:0xffffff alpha:1];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kWindowWidth - 70, 0, 70, 40);
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHex:0x12C963 alpha:1.0f] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHex:0xffffff alpha:1.0f] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnFinishClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btn];
    [txt setInputAccessoryView:topView];
}

- (void)btnFinishClick {
    UITextField *txt = objc_getAssociatedObject(self, &textFieldKey);
    [txt resignFirstResponder];
}

#pragma mark - UIKeyboardNotification

- (void)inputHandling_keyboardWillShow:(NSNotification *)note {
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect btnFrame = self.view.frame;
    btnFrame.origin.y =  - 140;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDelegate:self];
    self.view.frame = btnFrame;
    [UIView commitAnimations];
}

- (void)inputHandling_keyboardWillHide:(NSNotification *)note {
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect btnFrame = self.view.frame;
    btnFrame.origin.y = 0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    self.view.frame = btnFrame;
    [UIView commitAnimations];
}

@end
