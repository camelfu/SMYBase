//
//  AESEncryptor.h
//  credit
//
//  Created by zhaojian on 16/2/25.
//  Copyright © 2016年 smyfinancial. All rights reserved.
//
//  AES算法加密器


#import <Foundation/Foundation.h>

@interface AESEncryptor : NSObject

/**
 *  对二进制数据加密
 *
 *  @param content 数据源
 *
 *  @return 经过AES加密后的密文
 */
+ (nullable NSData *)encryptData:(nullable NSData *)content withKey:(nullable NSString *)strKey;

/**
 *  对二进制数据解密
 *
 *  @param content 数据源
 *
 *  @return 经过AES解密后的原文
 */
+ (nullable NSData *)decryptData:(nullable NSData *)content withKey:(nullable NSString *)strKey;

@end
