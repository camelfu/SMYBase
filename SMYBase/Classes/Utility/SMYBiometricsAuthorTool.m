//
//  SMYBiometricsAuthorTool.m
//  SMYBase
//
//  Created by fugui on 2022/2/8.
//  Copyright © 2022 smyfinancial. All rights reserved.
//

#import "SMYBiometricsAuthorTool.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation SMYBiometricsAuthorTool

/// 生物特征验证支持状态
+ (SMYBiometricsSupportedStatus)biometricsSupportedStatus {
    NSError *error = nil;
    LAContext *context = [[LAContext alloc] init];
    BOOL gBiometricsAvailable = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (@available(iOS 11.0, *)) {// iOS11开始支持faceID
        if (context.biometryType == LABiometryTypeTouchID) {
            return SMYBiometricsTouchIDSupported;
        } else if (context.biometryType == LABiometryTypeFaceID) {
            return SMYBiometricsFaceIDSupported;
        } else {
            return SMYBiometricsUnsupported;
        }
    } else {
        // 若支持生物识别，只会有touchID
        if (gBiometricsAvailable) {
            return SMYBiometricsTouchIDSupported;
        } else {
            if (error.code == LAErrorTouchIDNotAvailable) {
                return SMYBiometricsUnsupported;
            } else {
                return SMYBiometricsTouchIDSupported;
            }
        }
    }
}


@end
