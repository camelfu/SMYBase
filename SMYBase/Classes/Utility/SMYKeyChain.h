//
//  SMYKeyChain.h
//  credit
//
//  Created by 张云飞 on 15/8/24.
//  Copyright (c) 2015年 smyfinancial. All rights reserved.
//
// KeyChain工具

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMYKeyChain : NSObject

+ (void)saveObject:(id<NSCoding>)object forKey:(NSString *)key;

+ (id)loadObjectForKey:(NSString *)key;

+ (void)deleteObjectForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
