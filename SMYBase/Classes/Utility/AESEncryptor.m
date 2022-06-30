//
//  AESEncryptor.m
//  credit
//
//  Created by zhaojian on 16/2/25.
//  Copyright © 2016年 smyfinancial. All rights reserved.
//

#import "AESEncryptor.h"
#import <CommonCrypto/CommonCryptor.h>

static char * const AES256IV = "smycbciv20160225";// iv向量

@implementation AESEncryptor

+ (NSData *)encryptData:(NSData *)content withKey:(NSString *)strKey {
    if (content.length < 1 || strKey.length < 1) {
        return nil;
    }
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [strKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [content length];
    
    // See the doc: For block ciphers, the output size will always be less than or
    // equal to the input size plus the size of one block.
    // That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          AES256IV /* initialization vector (optional) */,
                                          [content bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        // the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); // free the buffer;
    return nil;
}

+ (NSData *)decryptData:(NSData *)content withKey:(NSString *)strKey {
    if (content.length < 1 || strKey.length < 1) {
        return nil;
    }
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [strKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [content length];
    
    // See the doc: For block ciphers, the output size will always be less than or
    // equal to the input size plus the size of one block.
    // That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          AES256IV /* initialization vector (optional) */,
                                          [content bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        // the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); // free the buffer;
    return nil;
}

@end
