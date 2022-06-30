//
//  SMYMD5Tool.m
//  shengbei
//
//  Created by ChenYong on 2019/5/9.
//  Copyright © 2019 smyfinancial. All rights reserved.
//

#import "SMYMD5Tool.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation SMYMD5Tool

+ (NSString *)md5WithString:(NSString *)string {
    const char *input = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);

    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

+ (NSData *)hmacSha256DataWithData:(NSData *)data key:(NSString *)key {
    if (data.length < 1 || key.length < 1) {
        return nil;
    }
    NSData *keys = [key dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, [keys bytes], keys.length, [data bytes], data.length, result);
    return [NSData dataWithBytes:result length:CC_SHA256_DIGEST_LENGTH];
}

+ (NSString *)hmacSha256ForString:(NSString *)string withKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = string.UTF8String;
    unsigned char buffer[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, keyData, strlen(keyData), strData, strlen(strData), buffer);
    NSMutableString *strM = [NSMutableString string];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [strM appendFormat:@"%02x", buffer[i]];
    }
    return [strM copy];
}

+ (NSString *)sha256ForString:(NSString *)string {
    NSData *inData = [string dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(inData.bytes, (CC_LONG)inData.length, digest);
    NSData *outData = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash = [outData description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}

+ (NSString *)sha256WithString:(NSString *)string {
    const char *input = [string UTF8String];
    uint8_t result[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(input, (CC_LONG)strlen(input), result);
    NSString *const format = @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X"
    @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X";
    return [[NSString stringWithFormat:format,
             result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15],
             result[16], result[17], result[18], result[19], result[20], result[21], result[22], result[23],
             result[24], result[25], result[26], result[27], result[28], result[29], result[30], result[31]] uppercaseString];
}

@end
