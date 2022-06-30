//
//  SMYStringTool.m
//  shengbei
//
//  Created by 张云飞 on 2019/5/5.
//  Copyright © 2019 smyfinancial. All rights reserved.
//

#import "SMYStringTool.h"

@implementation SMYStringTool

+ (NSString *)displayStringForNumberString:(NSString *)numberString decimal:(NSUInteger)count {
    if (numberString.length < 1 || [numberString hasPrefix:@"."]) {
        return numberString;
    }
    NSArray *array = [numberString componentsSeparatedByString:@"."];
    if (array.count != 2) {
        return numberString;
    }
    NSString *strDecimalPart = array.lastObject;// 小数部分
    if (strDecimalPart.length > count) {// 限制小数部分的长度
        strDecimalPart = [strDecimalPart substringToIndex:count];
    }
    // 去除小数尾部的0
    while ([strDecimalPart hasSuffix:@"0"]) {
        strDecimalPart = [strDecimalPart substringWithRange:NSMakeRange(0, strDecimalPart.length - 1)];
    }
    NSString *strIntegerPart = array.firstObject;// 整数部分
    if (strDecimalPart.length < 1) {
        return strIntegerPart;
    }
    return [strIntegerPart stringByAppendingFormat:@".%@", strDecimalPart];
}

/**
 * UILabel富文本设置;
 * 第一个参数为UILabel字符串
 * 后面参数依次为：将要设置的(子字符串)str1,(字体)font1,(颜色)color1, str2,font2,color2, str3.....nil;
 */
+ (NSMutableAttributedString *)setLabelStringAtrributedStringsFontsColors:(NSString *)labelString objects:(id)objects,...{
    // LabelString 不能为nil
    if (!labelString) {
        return nil;
    }
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:labelString];
    
    int index = 0;// 记录函数参数索引；
    id eachObject;
    va_list argumentList;// 函数参数链表
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:3];// 保存参数
    
    if (objects) {
        [mutableArray addObject:objects];
        index++;
        va_start(argumentList,objects);
        while((eachObject = va_arg(argumentList, id))) {
            
            // 每一次重新设置一组参数时候 要移除之前的；
            if (index%3 == 0) {
                [mutableArray removeAllObjects];
            }
            [mutableArray addObject:eachObject];
            
            // 每一次完成一组参数遍历后要设置
            if (index%3 == 2) {
                NSString *subString = [mutableArray objectAtIndex:0];
                UIFont *font = [mutableArray objectAtIndex:1];
                UIColor *color = [mutableArray objectAtIndex:2];
                
                [attributeString addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                font,
                                                NSFontAttributeName,
                                                color,
                                                NSForegroundColorAttributeName,
                                                nil,nil]
                                         range:[labelString rangeOfString:subString]];
            }
            index ++;
        }
        va_end(argumentList);
    }
    
    return attributeString;
}

+ (void)phoneNumberFormat:(UITextField *)textField str:(NSString *)str {
    if (str.length == 4 ) {
        textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
    } else if (str.length == 9) {
        textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
    }
}

+ (NSString *)phoneNumberFormatWithString:(NSString *)str {
    if (str.length < 1) {
        return nil;
    }
    NSMutableString *string = [[NSMutableString alloc] initWithString:str];
    if (string.length > 3) {
        [string insertString:@" " atIndex:3];
    }
    if (string.length > 8) {
        [string insertString:@" " atIndex:8];
    }
    return string;
}

+ (NSString *)phoneNumberCiphertextFormatterWithNum:(NSString *)str {
    if (str.length < 1) {
        return nil;
    }
    NSString *string = [[NSString alloc] initWithString:str];
    if (string.length >= 10) {
        string = [str stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    return string;
}

+ (NSString *)phoneNumberCiphertextSpaceFormatterWithNum:(NSString *)str {
    NSString *string = [self phoneNumberFormatWithString:str];
    if (string.length >= 12) {
        string = [string stringByReplacingCharactersInRange:NSMakeRange(4, 4) withString:@"****"];
    }
    return string;
}

+ (NSString *)cardNumberFormatWithString:(NSString *)str {
    NSMutableString *cardId = str.mutableCopy;
    if (cardId.length > 4) {
        [cardId insertString:@" " atIndex:4];
    }
    if (cardId.length > 9) {
        [cardId insertString:@" " atIndex:9];
    }
    if (cardId.length > 14) {
        [cardId insertString:@" " atIndex:14];
    }
    if (cardId.length > 19) {
        [cardId insertString:@" " atIndex:cardId.length - 4];
    }
    return cardId;
}

+ (NSString *)cardNumberByHideSensitivePart:(NSString *)cardNumber {
    if (cardNumber.length <= 8) {
        return cardNumber;
    }
    NSMutableString *result = [NSMutableString stringWithCapacity:cardNumber.length];
    [result appendString:[cardNumber substringToIndex:4]];
    for(int i = 4; i < cardNumber.length - 4 ; i++) {
        if (![[cardNumber substringWithRange:NSMakeRange(i, 1)] isEqualToString:@" "]) {
            [result appendString:@"*"];
        } else {
            [result appendString:@" "];
        }
    }
    [result appendString:[cardNumber substringFromIndex:cardNumber.length - 4]];
    return result;
}

+ (NSString *)nameByHideSensitivePart:(NSString *)name {
    if (name.length < 1) {
        return name;
    }
    __block NSString *strStart = nil;
    __block NSString *strEnd = nil;
    __block NSInteger count = 0;
    [name enumerateSubstringsInRange:NSMakeRange(0, name.length) options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        if (0 == count) {
            strStart = substring;
        } else {
            strEnd = substring;
        }
        count++;
    }];
    if (count < 2) {
        return name;
    } else if (2 == count) {
        return [strStart stringByAppendingString:@"*"];
    }
    NSMutableString *string = [strStart mutableCopy];
    for (int i = 1; i < count - 1; i++) {
        [string appendString:@"*"];
    }
    if (strEnd) {
        [string appendString:strEnd];
    }
    return string;
}

+ (NSString *)idNumberCiphertextSpaceFormatterWithNum:(NSString *)str {
    NSString *idNo = str.mutableCopy;
    if (idNo.length == 15) {
        idNo = [idNo stringByReplacingCharactersInRange:NSMakeRange(6, 6) withString:@"******"];
    } else if (idNo.length == 18) {
        idNo = [idNo stringByReplacingCharactersInRange:NSMakeRange(6, 8) withString:@"********"];
    } else {
        idNo = nil;
    }
    return idNo;
}

/*
 * 身份证15位编码规则：dddddd yymmdd xx p
 * dddddd：6位地区编码
 * yymmdd: 出生年(两位年)月日，如：910215
 * xx: 顺序编码，系统产生，无法确定
 * p: 性别，奇数为男，偶数为女
 *
 * 身份证18位编码规则：dddddd yyyymmdd xxx y
 * dddddd：6位地区编码
 * yyyymmdd: 出生年(四位年)月日，如：19910215
 * xxx：顺序编码，系统产生，无法确定，奇数为男，偶数为女
 * y: 校验码，该位数值可通过前17位计算获得
 *
 * 前17位号码加权因子为 Wi = [ 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 ]
 * 验证位 Y = [ 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2 ]
 * 如果验证码恰好是10，为了保证身份证是十八位，那么第十八位将用X来代替
 * 校验位计算公式：Y_P = mod( ∑(Ai×Wi),11 )
 * i为身份证号码1...17 位; Y_P为校验码Y所在校验码数组位置
 */
+ (BOOL)validateIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    int length =0;
    if (!value) {
        return NO;
    } else {
        length = (int)value.length;
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41",@"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO;
    for (NSString *areaCode in areasArray) {
        
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    int year =0;
    switch (length) {
            
        case 15:
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:
                                     @"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];// 测试出生日期的合法性
                
            } else {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:
                                     @"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];// 测试出生日期的合法性
                
            }
            
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            if (numberofMatch >0) {
                return YES;
            } else {
                return NO;
            }
            
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:
                                     @"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];// 测试出生日期的合法性
                
            } else {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:
                                     @"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];// 测试出生日期的合法性
                
            }
            
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if (numberofMatch >0) {
                // 求校验码
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                
                int Y = S %11;
                
                NSString *M =@"F";
                
                NSString *JYM =@"10X98765432";
                
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                } else {
                    return NO;
                }
            } else {
                return NO;
            }
        default:
            return false;
    }
}

+ (NSString *)formateAmount:(CGFloat)amount {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.00;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:amount]];
    return formattedNumberString;
}

+ (NSAttributedString *)formateAttributedAmount:(CGFloat)amount {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.00;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:amount]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:formattedNumberString];
    UIFont *font = [UIFont fontWithName:@"DINMittelschrift" size:20];
    if (font) {
        [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(attributedString.length - 3, 3)];
    }
    return attributedString;
}

+ (NSAttributedString *)formateAttributedAmount:(CGFloat)amount smallFontSize:(CGFloat)fontSize {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,##0.00;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:amount]];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:formattedNumberString];
    UIFont *font = [UIFont fontWithName:@"DINMittelschrift" size:fontSize];
    if (font) {
        [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(attributedString.length - 3, 3)];
    }
    return attributedString;
}

+ (CGFloat)getTextWidth:(NSString *)text fontSize:(CGFloat)fontSize {
    if (text.length < 1) {
        return 0;
    }
    // 测量文本宽高
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontSize] forKey:NSFontAttributeName];
    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:option attributes:attributes context:nil];
    return rect.size.width;
}

+ (NSString *)hideSensitive:(NSString *)sensitive type:(int)type {
    // 手机
    if (type == 1) {
        if (sensitive.length >= 3) {
            NSString * subString = [sensitive substringToIndex:3];
            if ([subString isEqualToString:@"+86"] ||
                [subString isEqualToString:@"-86"] ||
                [subString isEqualToString:@"86+"]) {
                
                sensitive = [sensitive substringFromIndex:3];
            }
        }
        sensitive = [sensitive stringByReplacingOccurrencesOfString:@"-" withString:@""];
        // ios系统电话号码自带的格式化空格
        sensitive = [sensitive stringByReplacingOccurrencesOfString:@" " withString:@""];
        // ascii中的空格
        sensitive = [sensitive stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (sensitive.length == 11) {
            // 前三后四位
            return [sensitive stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
    }
    // 身份证
    else if (type == 2) {
        sensitive = [sensitive stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (sensitive.length > 7) {
            NSMutableString * hideSymbol = [[NSMutableString alloc]init];
            for(int i=0;i<sensitive.length - 7 ;i++) {
                [hideSymbol appendString:@"*"];
            }
            // 前三后四位
            return [sensitive stringByReplacingCharactersInRange:NSMakeRange(3, sensitive.length-7) withString:hideSymbol];
        }
    }
    // 邮箱
    else if (type == 3) {
        sensitive = [sensitive stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (sensitive.length > 6) {
            NSMutableString * hideSymbol = [[NSMutableString alloc]init];
            for(int i=0;i<sensitive.length - 6 ;i++) {
                [hideSymbol appendString:@"*"];
            }
            // 前三后三位
            return [sensitive stringByReplacingCharactersInRange:NSMakeRange(3, sensitive.length-6) withString:hideSymbol];
        }
    }
    // 一般账号
    else if (type == 4) {
        if (sensitive.length > 2) {
            NSMutableString * hideSymbol = [[NSMutableString alloc]init];
            for(int i=0;i<sensitive.length - 2 ;i++) {
                [hideSymbol appendString:@"*"];
            }
            // 前二位
            return [sensitive stringByReplacingCharactersInRange:NSMakeRange(2, sensitive.length-2) withString:hideSymbol];
        }
    }
    
    return sensitive;
}

+ (int)checkPasswordStrength:(NSString*)password {
    // 数字条件
    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    // 符合数字条件的有几个字节
    NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:password
                                                                       options:NSMatchingReportProgress
                                                                         range:NSMakeRange(0, password.length)];
    
    // 英文字条件
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    // 符合英文字条件的有几个字节
    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:password
                                                                             options:NSMatchingReportProgress
                                                                               range:NSMakeRange(0, password.length)];
    
    // 字符条件 特殊字符个数
    NSUInteger tSymbolMatchCount = password.length-tNumMatchCount-tLetterMatchCount;
    if (tNumMatchCount == password.length
        || tLetterMatchCount == password.length
        || tSymbolMatchCount == password.length) {
        // 只有1种
        return 1;
    } else if (tNumMatchCount + tLetterMatchCount == password.length
               || tNumMatchCount + tSymbolMatchCount == password.length
               || tLetterMatchCount + tSymbolMatchCount == password.length) {
        // 包含2种
        return 2;
    } else if (tNumMatchCount + tLetterMatchCount + tSymbolMatchCount == password.length) {
        // 包含3种
        return 3;
    } else {
        return 3;
    }
}


+ (NSString *)appendingForString:(NSString *)string withParam:(NSString *)param key:(NSString *)key {
    NSMutableString *str = [NSMutableString stringWithString:string];
    if (param.length < 1) {
        return str;
    }
    NSString *strToAppend = param;
    if (key.length > 0) {
        strToAppend = [key stringByAppendingFormat:@"=%@", param];
    }
    strToAppend = [strToAppend stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if ([str rangeOfString:@"?"].location == NSNotFound) {// 没有任何参数
        return [str stringByAppendingFormat:@"?%@", strToAppend];
    } else {
        return [str stringByAppendingFormat:@"&%@", strToAppend];
    }
}

@end
