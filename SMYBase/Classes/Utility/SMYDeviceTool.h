//
//  SMYDeviceTool.h
//  credit
//
//  Created by jwter on 15/7/6.
//  Copyright (c) 2015年 smyfinancial. All rights reserved.
//
//  工具类，获取设备的相关信息（与业务无关）

#import <Foundation/Foundation.h>
#import "Reachability.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMYDeviceTool : NSObject

@property (nonatomic, strong, nullable) Reachability *reachability;

/**
 *  内网IP,初始化有可能为 0.0.0.0 检测网络状态变更会自动重新获取
 */
@property (nonatomic, copy, nullable) NSString *LANIPAddress;

+ (instancetype)shareInstance;

/**
 手机型号
 */
+ (nullable NSString *)getMachineName;

/**
 ip地址
 */
+ (nullable NSString *)getIPAddress;

/**
 运营商
 */
+ (NSString *)getComProvider;

/// 当前使用的内存大小（单位为MB）
+ (double)currentUsedMemory;

/**
 网络类型
 */
- (nullable NSString *)getNetworkType;

@end

NS_ASSUME_NONNULL_END
