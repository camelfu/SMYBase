//
//  ContantMacro.h
//  credit
//
//  Created by jwter on 15/7/1.
//  Copyright (c) 2015年 smyfinancial. All rights reserved.
//
//  通用宏定义

#ifndef credit_ContantMacro_h
#define credit_ContantMacro_h

//image
#define SMY_IMAGE(name) [UIImage imageNamed:name]
#define SMY_Font(fontSize) [UIFont systemFontOfSize:fontSize]

// 字体样式
#define kFontPingFangRegular         @"PingFang-SC-Regular"
#define kFontPingFangMedium          @"PingFang-SC-Medium"
#define kFontPingFangSemibold       @"PingFang-SC-Semibold"
#define kFontPingFangBold          @"PingFang-SC-Bold"

//weak引用self
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define SMY_WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define FunctionString  [NSString stringWithFormat:@"%s",__PRETTY_FUNCTION__]

#define IS_IOS10_ABOVE ([[[UIDevice currentDevice] systemVersion] floatValue]>=10.0?YES:NO)
#define IS_IOS11_ABOVE ([[[UIDevice currentDevice] systemVersion] floatValue]>=11.0?YES:NO)

//iPhone4 & iPhone4s
#define IS_IPHONE4_SERIAL (fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)480) < DBL_EPSILON)
//iPhone5 & iPhone5c & iPhone5s & iPhone SE
#define IS_IPHONE5_SERIAL (fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)568) < DBL_EPSILON)
//iPhone6 & iPhone6s & iPhone7 & iPhone8
#define IS_IPHONE6_SERIAL (fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)667) < DBL_EPSILON)
//iPhone6 plus & iPhone6s plus & iPhone7 plus & iPhone8 Plus
#define IS_IPHONE6PLUS_SERIAL (fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)736) < DBL_EPSILON)
//iPhoneX
#define IS_IPHONEX (fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)812) < DBL_EPSILON)
//iPhoneXR
#define IS_IPHONEXR (fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)896) < DBL_EPSILON && fabs((double)[UIScreen mainScreen].scale - 2) < DBL_EPSILON)
//iPhoneM
#define IS_IPHONEXMAX (fabs((double)[[UIScreen mainScreen] bounds].size.height-(double)896) < DBL_EPSILON && fabs((double)[UIScreen mainScreen].scale - 3) < DBL_EPSILON)


/************* ui *************/

#define kIsFullscreen       ([[UIApplication sharedApplication] statusBarFrame].size.height >= 44)

#define kStatusBarHeight    [[UIApplication sharedApplication] statusBarFrame].size.height
#define kStatusBarWidth     [[UIApplication sharedApplication] statusBarFrame].size.width

#define kNavigationHeight   ([UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height)
#define kTabbarHight        49.0f
#define kIndicatorHeight    (kIsFullscreen ? 34.f : 0.f)

#define kWindowWidth        ([[UIScreen mainScreen] bounds].size.width)
#define kWindowHeight       ([[UIScreen mainScreen] bounds].size.height)
#define SMYWidth(size)      (kWindowWidth/375.0 * size)

/*********** 类型判断 ************/
#define kIsString(value)   [(value) isKindOfClass:[NSString class]]
#define kIsNumber(value)   [(value) isKindOfClass:[NSNumber class]]
#define kIsDictionary(value)   [(value) isKindOfClass:[NSDictionary class]]

#define kMakeSureStringValue(value)     (kIsString(value) ? (NSString *)value : nil)
#define kMakeSureNumberValue(value)     (kIsNumber(value) ? (NSNumber *)value : nil)
#define kMakeSureDictionaryValue(value)     (kIsDictionary(value) ? (NSDictionary *)value : nil)

#define kAppShortVersion    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//登录密码允许输入的字符
#define ALPHANUM            @"-/\"\\,.?:;()$&@'!{}#%^*+=_|~<>¥£€•[]ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

// 检测是否越狱
#define HasJailBreak()      ([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Applications/"] ||         \
                             [[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"] ||     \
                             [[NSFileManager defaultManager] fileExistsAtPath:@"/bin/bash"] ||                   \
                             [[NSFileManager defaultManager] fileExistsAtPath:@"/usr/sbin/sshd"] ||              \
                             getenv("DYLD_INSERT_LIBRARIES"))

// 定位功能是否开启
#define LocationAvailable   ([CLLocationManager locationServicesEnabled] &&\
                             [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied && \
                             [CLLocationManager authorizationStatus] != kCLAuthorizationStatusRestricted)

#define kNotZero(value)             ((value) != 0)
#define kIsZero(value)              ((value) == 0)
#define kBiggerThanZero(value)      ((value) > 0)

#define k1024                1024.0

#define kMakesureNotNil(param) (param == nil ? @"" : param)

#endif
