//
//  NSURL+SMY.m
//  credit
//
//  Created by ChenYong on 06/12/2017.
//  Copyright © 2017 smyfinancial. All rights reserved.
//

#import "NSURL+SMY.h"
#import <objc/runtime.h>

@implementation NSURL (SMY)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getClassMethod(self, @selector(URLWithString:)),
                                       class_getClassMethod(self, @selector(smy_URLWithString:)));
    });
}

/// 主要是在URL初始化失败时自动尝试进行PercentEncoding然后再初始化, 解决资源位中配置的链接有时候有非法字符的问题
+ (instancetype)smy_URLWithString:(NSString *)URLString {
    NSURL *url = [self smy_URLWithString:URLString];
    if (!url && URLString.length > 0) {
        NSCharacterSet *allowedCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"`#%^{}[]|\"<> \\"].invertedSet;
        URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        url = [self smy_URLWithString:URLString];
    }
    return url;
}

- (NSDictionary *)queryDictionary {
    NSMutableDictionary *dicQuery = [NSMutableDictionary dictionary];
    NSArray *aryQueries = [self.query componentsSeparatedByString:@"&"];
    for (NSString *string in aryQueries) {
        NSArray *ary = [string componentsSeparatedByString:@"="];
        if (ary.count == 2) {
            [dicQuery setObject:ary.lastObject forKey:[ary.firstObject lowercaseString]];
        } else {
            [dicQuery setObject:@"" forKey:string];
        }
    }
    return dicQuery;
}

@end
