//
//  RSAEncryptor.m
//  credit
//
//  Created by zhaojian on 15/8/25.
//  Copyright (c) 2015年 smyfinancial. All rights reserved.
//

#import "RSAEncryptor.h"
#import "GTMBase64.h"

// system base64 converter
static NSString *base64_encode_data(NSData *data) {
    data = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

static NSData *base64_decode(NSString *str) {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

@interface RSAEncryptor () {
    SecKeyRef _publicKey;
    SecCertificateRef _certificate;
    SecPolicyRef _policy;
    SecTrustRef _trust;
    size_t _maxPlainLen;
    size_t _keyLenInBytes;
}

@end

@implementation RSAEncryptor

+ (NSString *)encryptString:(NSString *)str withPublicKey:(NSString *)pubKey {
    NSData *data = [RSAEncryptor encryptData:[str dataUsingEncoding:NSUTF8StringEncoding] publicKey:pubKey];
    NSString *ret = base64_encode_data(data);
    return ret;
}

+ (NSString *)decryptString:(NSString *)string withPrivateKey:(NSString *)privateKey {
    if (!string || !privateKey) {
        return nil;
    }
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = [self decryptData:data withPrivateKey:privateKey];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (instancetype)initWithPublicKeyFile:(NSString *)publicKeyPath {
    if (self = [super init]) {
        if (publicKeyPath == nil) {
            NSLog(@"Can not find pub.der");
            return nil;
        }
        
        NSData *publicKeyFileContent = [NSData dataWithContentsOfFile:publicKeyPath];
        if (publicKeyFileContent == nil) {
            NSLog(@"Can not read from pub.der");
            return nil;
        }
        
        _certificate = SecCertificateCreateWithData(kCFAllocatorDefault, ( __bridge CFDataRef)publicKeyFileContent);
        if (_certificate == nil) {
            NSLog(@"Can not read certificate from pub.der");
            return nil;
        }
        
        _policy = SecPolicyCreateBasicX509();
        OSStatus returnCode = SecTrustCreateWithCertificates(_certificate, _policy, &_trust);
        if (returnCode != 0) {
            NSLog(@"SecTrustCreateWithCertificates fail. Error Code: %d", (int)returnCode);
            return nil;
        }
        
        SecTrustResultType trustResultType;
        returnCode = SecTrustEvaluate(_trust, &trustResultType);
        if (returnCode != 0) {
            NSLog(@"SecTrustEvaluate fail. Error Code: %d", (int)returnCode);
            return nil;
        }
        
        _publicKey = SecTrustCopyPublicKey(_trust);
        if (_publicKey == nil) {
            NSLog(@"SecTrustCopyPublicKey fail");
            return nil;
        }
        _maxPlainLen = SecKeyGetBlockSize(_publicKey) - 12;
        _keyLenInBytes = SecKeyGetBlockSize(_publicKey);
        if (@available(iOS 10.0, *)) {
            NSDictionary *dic = (__bridge_transfer NSDictionary *)SecKeyCopyAttributes(_publicKey);
            NSNumber *number = [dic objectForKey:(__bridge NSString *)kSecAttrKeySizeInBits];
            if ([number isKindOfClass:[NSNumber class]]) {
                _keyLenInBytes = [number integerValue] / 8;
            }
        }
    }
    
    return self;
}

- (NSData *)encryptData:(NSData *)content {
    size_t plainLen = [content length];
    if (plainLen > _maxPlainLen) {
        NSLog(@"content(%ld) is too long, must < %ld", plainLen, _maxPlainLen);
        return nil;
    }
    
    void *plain = malloc(plainLen);
    [content getBytes:plain length:plainLen];
    
    size_t cipherLen = _keyLenInBytes;// 密文的长度应该等于当前密钥的长度
    void *cipher = malloc(cipherLen);
    
    OSStatus returnCode = SecKeyEncrypt(_publicKey, kSecPaddingPKCS1, plain,
                                        plainLen, cipher, &cipherLen);
    NSData *result = nil;
    if (returnCode != 0) {
        NSLog(@"SecKeyEncrypt fail. Error Code: %d", (int)returnCode);
    } else {
        result = [NSData dataWithBytes:cipher length:cipherLen];
    }
    free(plain);
    free(cipher);
    return result;
}

- (NSData *)encryptString:(NSString *)content {
    return [self encryptData:[content dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)dealloc {
    CFRelease(_certificate);
    CFRelease(_trust);
    CFRelease(_policy);
    CFRelease(_publicKey);
}

+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey {
    if (!data || !pubKey) {
        return nil;
    }
    SecKeyRef keyRef = [RSAEncryptor secKeyRefFromPublicKey:pubKey];
    if (!keyRef) {
        return nil;
    }
    return [RSAEncryptor encryptData:data withKeyRef:keyRef];
}

+ (SecKeyRef)secKeyRefFromPublicKey:(NSString *)key {
    NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
    if (spos.location != NSNotFound && epos.location != NSNotFound) {
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    NSData *data = base64_decode(key);
    data = [RSAEncryptor stripPublicKeyHeader:data];
    if (!data) {
        return nil;
    }
    
    NSString *tag = @"SMYRSA_PubKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old  same tag
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKey);
    
    [publicKey setObject:data forKey:(__bridge id)kSecValueData];
    [publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
     kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
     kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != nil) {
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [publicKey removeObjectForKey:(__bridge id)kSecValueData];
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
    if (status != noErr) {
        return nil;
    }
    return keyRef;
}

+ (NSData *)encryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef {
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for (int idx = 0; idx < srclen; idx += src_block_size) {
        size_t data_len = srclen - idx;
        if (data_len > src_block_size) {
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyEncrypt(keyRef,
                               kSecPaddingPKCS1,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", (int)status);
            ret = nil;
            break;
        } else {
            [ret appendBytes:outbuf length:outlen];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

+ (NSData *)stripPublicKeyHeader:(NSData *)d_key {
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx	 = 0;
    
    if (c_key[idx++] != 0x30) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    
    idx += 15;
    
    if (c_key[idx++] != 0x03) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    if (c_key[idx++] != '\0') return(nil);
    
    return([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

+ (NSData *)decryptData:(NSData *)data withPrivateKey:(NSString *)privateKey {
    if (!data || !privateKey) {
        return nil;
    }
    SecKeyRef keyRef = [self secKeyRefFromPrivateKey:privateKey];
    if (!keyRef) {
        return nil;
    }
    return [self decryptData:data withSecKeyRef:keyRef];
}

+ (NSData *)decryptData:(NSData *)data withSecKeyRef:(SecKeyRef)keyRef {
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    UInt8 *outbuf = malloc(block_size);
    size_t src_block_size = block_size;
    
    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
        
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyDecrypt(keyRef,
                               kSecPaddingNone,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            ret = nil;
            break;
        } else {
            //the actual decrypted data is in the middle, locate it!
            int idxFirstZero = -1;
            int idxNextZero = (int)outlen;
            for ( int i = 0; i < outlen; i++ ) {
                if ( outbuf[i] == 0 ) {
                    if ( idxFirstZero < 0 ) {
                        idxFirstZero = i;
                    } else {
                        idxNextZero = i;
                        break;
                    }
                }
            }
            
            [ret appendBytes:&outbuf[idxFirstZero+1] length:idxNextZero-idxFirstZero-1];
        }
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

+ (SecKeyRef)secKeyRefFromPrivateKey:(NSString *)key {
    NSRange spos = [key rangeOfString:@"-----BEGIN RSA PRIVATE KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END RSA PRIVATE KEY-----"];
    if (spos.location != NSNotFound && epos.location != NSNotFound) {
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e - s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
    
    // This will be base64 encoded, decode it.
    NSData *data = [[NSData alloc] initWithBase64EncodedString:key options:NSDataBase64DecodingIgnoreUnknownCharacters];
    data = [self stripPrivateKeyHeader:data];
    if (!data) {
        return nil;
    }
    
    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PrivKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *privateKey = [[NSMutableDictionary alloc] init];
    [privateKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [privateKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)privateKey);
    
    // Add persistent version of the key to system keychain
    [privateKey setObject:data forKey:(__bridge id)kSecValueData];
    [privateKey setObject:(__bridge id) kSecAttrKeyClassPrivate forKey:(__bridge id)kSecAttrKeyClass];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnPersistentRef];
    
    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)privateKey, &persistKey);
    if (persistKey != nil) {
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }
    
    [privateKey removeObjectForKey:(__bridge id)kSecValueData];
    [privateKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [privateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [privateKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)privateKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}

+ (NSData *)stripPrivateKeyHeader:(NSData *)d_key {
    // Skip ASN.1 private key header
    if (d_key == nil) return(nil);
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx     = 22; //magic byte at offset 22
    
    if (0x04 != c_key[idx++]) return nil;
    
    //calculate length of the key
    unsigned int c_len = c_key[idx++];
    int det = c_len & 0x80;
    if (!det) {
        c_len = c_len & 0x7f;
    } else {
        int byteCount = c_len & 0x7f;
        if (byteCount + idx > len) {
            //rsa length field longer than buffer
            return nil;
        }
        unsigned int accum = 0;
        unsigned char *ptr = &c_key[idx];
        idx += byteCount;
        while (byteCount) {
            accum = (accum << 8) + *ptr;
            ptr++;
            byteCount--;
        }
        c_len = accum;
    }
    
    // Now make a new NSData from this buffer
    return [d_key subdataWithRange:NSMakeRange(idx, c_len)];
}

@end
