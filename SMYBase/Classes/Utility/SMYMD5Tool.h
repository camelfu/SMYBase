//
//  SMYMD5Tool.h
//  shengbei
//
//  Created by ChenYong on 2019/5/9.
//  Copyright © 2019 smyfinancial. All rights reserved.
//
// Hash算法工具

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMYMD5Tool : NSObject

/**
 生成指定字符串的md5编码
 */
+ (NSString *)md5WithString:(NSString *)string;

/**
 生成指定数据的hmac sha256签名数据
 */
+ (NSData *)hmacSha256DataWithData:(NSData *)data key:(NSString *)key;

/**
 生成指定字符串的Hmac-SHA256签名数据的十六进制编码（小写）
 */
+ (NSString *)hmacSha256ForString:(NSString *)string withKey:(NSString *)key;

/**
 生成指定字符串的SHA256哈希的十六进制编码（大写），这个接口的具体实现有些问题，为了兼容之前保存的数据，所以要保留，以后不要继续使用
 */
+ (NSString *)sha256ForString:(NSString *)string;

/**
 生成指定字符串的SHA256哈希的十六进制编码（大写），这个是正确的实现，用于替换sha256ForString这个接口
 */
+ (NSString *)sha256WithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
