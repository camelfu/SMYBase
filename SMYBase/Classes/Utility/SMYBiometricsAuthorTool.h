//
//  SMYBiometricsAuthorTool.h
//  SMYBase
//
//  Created by fugui on 2022/2/8.
//  Copyright © 2022 smyfinancial. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 设备生物特征识别支持状态
typedef NS_ENUM(NSInteger, SMYBiometricsSupportedStatus) {
    /// 生物特征识别不支持
    SMYBiometricsUnsupported = 0,
    /// 支持touchID
    SMYBiometricsTouchIDSupported = 1 << 0,
    /// 支持faceID
    SMYBiometricsFaceIDSupported = 1 << 1,
};

@interface SMYBiometricsAuthorTool : NSObject
/// 生物特征验证支持状态
+ (SMYBiometricsSupportedStatus)biometricsSupportedStatus;

@end

NS_ASSUME_NONNULL_END
