//
//  SMYStringTool.h
//  shengbei
//
//  Created by 张云飞 on 2019/5/5.
//  Copyright © 2019 smyfinancial. All rights reserved.
//
// 字符串工具类

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMYStringTool : NSObject

/// 将一个数字字符串转换成适合显示的字符串，就是将多余的小数及小数尾部的0去除
/// @param count 小数部分的最大位数
+ (nullable NSString *)displayStringForNumberString:(nullable NSString *)numberString decimal:(NSUInteger)count;

/**
 * UILabel富文本设置;
 * 第一个参数为UILabel字符串
 * 后面参数依次为：将要设置的(子字符串)str1,(字体)font1,(颜色)color1, str2,font2,color2, str3.....nil;
 */
+ (nullable NSMutableAttributedString *)setLabelStringAtrributedStringsFontsColors:(NSString *)labelString objects:(nullable id)objects,...;

/**
 * textField动态输入344格式;
 * 第一个参数为： 当前textField
 * 第二个参数为： 动态输入的str
 */
+ (void)phoneNumberFormat:(nullable UITextField *)textField str:(nullable NSString *)str;

/**
 *  str转344格式
 */
+ (nullable NSString *)phoneNumberFormatWithString:(nullable NSString *)str;

/**
 * 电话号码转 XXX****XXXX格式
 */
+ (nullable NSString *)phoneNumberCiphertextFormatterWithNum:(nullable NSString *)str;

/**
 * 电话号码转 XXX **** XXXX格式
 */
+ (nullable NSString *)phoneNumberCiphertextSpaceFormatterWithNum:(nullable NSString *)str;

/**
 * 卡号转444...格式
 *
 * @param str 银行卡号
 */
+ (nullable NSString *)cardNumberFormatWithString:(nullable NSString *)str;

/// 对银行卡卡号进行脱敏
+ (nullable NSString *)cardNumberByHideSensitivePart:(nullable NSString *)cardNumber;

/// 对姓名进行脱敏
+ (nullable NSString *)nameByHideSensitivePart:(nullable NSString *)name;

/**
 * 身份证号脱敏
 *
 * @param str 18位身份证号
 */
+ (nullable NSString *)idNumberCiphertextSpaceFormatterWithNum:(nullable NSString *)str;

/**
 *  是否是有效的身份证号码
 *
 *  @param value 身份证号
 *
 *  @return 是否有效
 */
+ (BOOL)validateIDCardNumber:(nullable NSString *)value;

/**
 *  格式化金额字符串（1,000,000.00）
 *
 *  @param amount 金额
 *
 *  @return 格式化字符串
 */
+ (nonnull NSString *)formateAmount:(CGFloat)amount;

+ (nonnull NSAttributedString *)formateAttributedAmount:(CGFloat)amount;

+ (nonnull NSAttributedString *)formateAttributedAmount:(CGFloat)amount smallFontSize:(CGFloat)fontSize;

/**
 *  测量文字宽度
 *
 *  @param text     文字
 *  @param fontSize 字体大小
 *
 *  @return 宽度
 */
+ (CGFloat)getTextWidth:(nullable NSString *)text fontSize:(CGFloat)fontSize;

/**
 根据类型隐藏敏感信息字段
 @param type 1:手机  2:身份证  3:邮箱  4:普通账号
 */
+ (nullable NSString *)hideSensitive:(nullable NSString *)sensitive type:(int)type;

/**
 *  校验密码长度
 */
+ (int)checkPasswordStrength:(nullable NSString *)password;

/// 为url字符串添加参数
/// @param string url字符串
/// @param param value
/// @param key key
+ (nullable NSString *)appendingForString:(nullable NSString *)string withParam:(nullable NSString *)param key:(nullable NSString *)key;

@end

NS_ASSUME_NONNULL_END

