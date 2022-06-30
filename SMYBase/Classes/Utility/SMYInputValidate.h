//
//  SMYInputValidate.h
//  credit
//
//  Created by jwter on 15/7/9.
//  Copyright (c) 2015年 smyfinancial. All rights reserved.
//
// 字符串较验工具

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMYInputValidate : NSObject

/**  不可含连续四位相同数字的，如：X2222X、8888X； */
+ (BOOL)isValidcon4Number:(NSString *)input;

/** 不可两两连续数字，如：001122、889900； */
+ (BOOL)isValidcon2con:(NSString *)input;

/**  不可三三连续数字，如：222333，777888； */
+ (BOOL)isValidcon3con:(NSString *)input;

/** 不可重复相同的连续三位数字 */
+ (BOOL)isValidcon3l:(NSString *)input;

/** 不可重复相同的连续倒三位数字 */
+ (BOOL)isValidcon3ld:(NSString *)input;

/** 不可与手机号前6位或后6位相同 */
+ (BOOL)isValidPhoneNumber6:(NSString *)phoneNumber pwd:(NSString *)pwd;

/** 其他不可使用的：520520、438438、201314、207374 */
+ (BOOL)isValidOther:(NSString *)input;

/** 不可含连续四位连续数字 */
+ (BOOL)isValidCon4:(NSString *)input;

/** 登录密码和支付密码两者不可以相同 */
+ (BOOL)isValidSame:(NSString *)input1 input2:(NSString *)input2;

/** 检验是否纯数字 */
+ (BOOL)isPureInt:(NSString *)string;

/** 手机号效验 */
+ (BOOL)validateMobile:(nullable NSString *)mobileNum;

/*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidateMobile:(nullable NSString *)mobile;

/*验证邮箱地址是否有效*/
+ (BOOL)isValidateEmail:(nullable NSString *)email;

+ (BOOL)isEmpty:(nullable NSString *)input;

@end

NS_ASSUME_NONNULL_END
