//
//  SMYInputValidate.m
//  credit
//
//  Created by jwter on 15/7/9.
//  Copyright (c) 2015年 smyfinancial. All rights reserved.
//

#import "SMYInputValidate.h"

@implementation SMYInputValidate

/**  不可含连续四位相同数字的，如：X2222X、8888X； */
+ (BOOL)isValidcon4Number:(NSString *)input {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([0-9])\\1{3}" options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSTextCheckingResult *result = [regex firstMatchInString:input options:0 range:NSMakeRange(0, [input length])];
    if (result) {
        return YES;
    }
    return NO;
}

/** 不可两两连续数字，如：001122、889900； */
+ (BOOL)isValidcon2con:(NSString *)input {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(?:(\\d)\\1)+$" options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSTextCheckingResult *result = [regex firstMatchInString:input options:0 range:NSMakeRange(0, [input length])];
    if (result) {
        return YES;
    }
    return NO;
}

/**  不可三三连续数字，如：222333，777888； */
+ (BOOL)isValidcon3con:(NSString *)input {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(\\d)\\1{2}(\\d)\\2{2}$" options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSTextCheckingResult *result = [regex firstMatchInString:input options:0 range:NSMakeRange(0, [input length])];
    if (result) {
        return YES;
    }
    return NO;
}

/** 不可重复相同的连续三位数字 */
+ (BOOL)isValidcon3l:(NSString *)input {
    NSString * str1 = [input substringToIndex:3];
    NSString * str2 = [input substringWithRange:NSMakeRange(str1.length, input.length)];
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"890|901|^(?:(?!0[02-9]|1[013-9]|2[0-24-9]|3[0-35-9]|4[0-46-9]|5[0-57-9]|6[0-689]|7[0-79]|8[0-8]|9[0-9])[a-z\\d])+$" options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSTextCheckingResult *result1 = [regex firstMatchInString:str1 options:0 range:NSMakeRange(0, [str1 length])];
    NSTextCheckingResult *result2 = [regex firstMatchInString:str2 options:0 range:NSMakeRange(0, [str2 length])];
    if (result1 && result2 && [str1 isEqualToString:str2]) {
        return YES;
    }
    return NO;
}

/** 不可重复相同的连续倒三位数字 */
+ (BOOL)isValidcon3ld:(NSString *)input {
    NSString * str1 = [input substringToIndex:3];
    NSString * str2 = [input substringWithRange:NSMakeRange(str1.length, input.length)];
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"890|901|^(?:(?!0[02-9]|1[013-9]|2[0-24-9]|3[0-35-9]|4[0-46-9]|5[0-57-9]|6[0-689]|7[0-79]|8[0-8]|9[0-9])[a-z\\d])+$" options:NSRegularExpressionCaseInsensitive error:&error];
    
    
    NSTextCheckingResult *result2 = [regex firstMatchInString:str2 options:0 range:NSMakeRange(0, [str2 length])];
    
    
    NSMutableString * mbs = [[NSMutableString alloc]init];
    for (int i = (int)str2.length; i >=0; i--) {
        char indexChar = [str2 characterAtIndex:i];
        [mbs appendString:[NSString stringWithFormat:@"%c", indexChar]];
    }
    
    str2 = mbs;

    NSTextCheckingResult *result1 = [regex firstMatchInString:str1 options:0 range:NSMakeRange(0, [str1 length])];
    
    if (result1 && result2 && [str1 isEqualToString:str2]) {
        return YES;
    }
    return NO;
}

/** 不可与手机号前6位或后6位相同 */
+ (BOOL)isValidPhoneNumber6:(NSString *)phoneNumber pwd:(NSString *)pwd {
    NSString * fsix = [phoneNumber substringToIndex:6];
    NSString * bsix = [phoneNumber substringWithRange:NSMakeRange(phoneNumber.length -6, phoneNumber.length)];
    
    if ([pwd isEqualToString:fsix] || [pwd isEqualToString:bsix]) {
        return YES;
    }
    return NO;
}

/** 其他不可使用的：520520、438438、201314、207374 */
+ (BOOL)isValidOther:(NSString *)input {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"520520|438438|201314|207374" options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSTextCheckingResult *result = [regex firstMatchInString:input options:0 range:NSMakeRange(0, [input length])];
    if (result) {
        return YES;
    }
    return NO;
}

/** 不可含连续四位连续数字 */
+ (BOOL)isValidCon4:(NSString *)input {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"0123|1234|2345|3456|4567|5678|6789|7890|8901|9012|3210|4321|5432|6543|7654|8765|9876|0987|1098|2109" options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSTextCheckingResult *result = [regex firstMatchInString:input options:0 range:NSMakeRange(0, [input length])];
    if (result) {
        return YES;
    }
    return NO;
}

/** 登录密码和支付密码两者不可以相同 */
+ (BOOL)isValidSame:(NSString *)input1 input2:(NSString *)input2 {
    return [input1 isEqualToString:input2];
}

/** 是否为纯数字 */
+ (BOOL)isPureInt:(NSString *)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (BOOL)validateMobile:(NSString *)mobileNum {
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidateMobile:(NSString *)mobile {
    // 手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

/*验证邮箱地址是否有效*/
+ (BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w+)+)";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isEmpty:(NSString *)input {
    if (!input) {
        return true;
    } else {
        // A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        // Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [input stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

@end
