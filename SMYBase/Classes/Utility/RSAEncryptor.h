//
//  RSAEncryptor.h
//  credit
//
//  Created by zhaojian on 15/8/25.
//  Copyright (c) 2015年 smyfinancial. All rights reserved.
//
//  RSA算法加密器

#import <Foundation/Foundation.h>

@interface RSAEncryptor : NSObject

/**
 *  使用指定的公匙加密字符串
 *
 *  @param pubKey 公匙的内容
 */
+ (nullable NSString *)encryptString:(nullable NSString *)str withPublicKey:(nullable NSString *)pubKey;

/**
 使用指定的私钥对字符串进行解密
 */
+ (nullable NSString *)decryptString:(nullable NSString *)string withPrivateKey:(nullable NSString *)privateKey;

/**
 根据指定的公钥文件初始化一个实例
 */
- (nullable instancetype)initWithPublicKeyFile:(nullable NSString *)keyFile;

/**
 *  对二进制数据加密
 *
 *  @param content 数据源
 *
 *  @return 经过RSA加密后的密文
 */
- (nullable NSData *)encryptData:(nullable NSData *)content;

/**
 *  对字符串加密
 *
 *  @param content 源字符串
 *
 *  @return 经过RSA加密后的密文
 */
- (nullable NSData *)encryptString:(nullable NSString *)content;

@end
