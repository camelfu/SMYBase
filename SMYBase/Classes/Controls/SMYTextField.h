//
//  SMYTextField.h
//  SMYBase
//
//  Created by ChenYong on 2021/7/15.
//  Copyright © 2021 smyfinancial. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 自定义的文本输入框，用于做各种输入限制
@interface SMYTextField : UITextField

// 限制最多输入的字符串长度（utf16），默认无限制
@property (nonatomic, assign) NSUInteger maxLength;
// 可以输入的有效字符
@property (nonatomic, copy) NSCharacterSet *validateCharacterSet;

#pragma mark - 以下方法用于给子类重写，用来实现具体的限制

// 编辑完成了
- (void)didEndEditing;

// 是否接入指定的修改
- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end

// 验证码输入框，默认限制只能输入数字，最多8位
@interface SMYVerifyCodeTextField : SMYTextField

@end

// 身份证号输入框，限制只能输入数字、X和x，最多18位
@interface SMYIDNumberTextField : SMYTextField

@end

@interface SMYPhoneNumberTextField : SMYTextField

@end

NS_ASSUME_NONNULL_END
