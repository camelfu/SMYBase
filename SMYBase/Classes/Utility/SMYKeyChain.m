//
//  SMYKeyChain.m
//  credit
//
//  Created by 张云飞 on 15/8/24.
//  Copyright (c) 2015年 smyfinancial. All rights reserved.
//

#import "SMYKeyChain.h"

@implementation SMYKeyChain

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock, (__bridge id)kSecAttrAccessible, nil];
}

+ (void)saveObject:(id<NSCoding>)object forKey:(NSString *)key {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Get search dictionary
        NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
        // Delete old item before add new item
        SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
        // Add new object to search dictionary(Attention:the data format)
        [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:object] forKey:(__bridge_transfer id)kSecValueData];
        // Add item to keychain with the search dictionary
        SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
    });
}

+ (id)loadObjectForKey:(NSString *)key {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    // Configure the search setting
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    OSStatus status = SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData);
    if (noErr == status) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", key, e);
        } @finally {
        }
    }
    return ret;
}

+ (void)deleteObjectForKey:(NSString *)key {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

@end
