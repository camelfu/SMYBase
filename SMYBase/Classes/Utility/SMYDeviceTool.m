//
//  SMYDeviceTool.m
//  credit
//
//  Created by jwter on 15/7/6.
//  Copyright (c) 2015年 smyfinancial. All rights reserved.
//

#import "SMYDeviceTool.h"
#import <sys/utsname.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <mach/mach_init.h>
#import <mach/mach_host.h>
#import <mach/task_info.h>
#import <mach/task.h>
#import "UtilityMacro.h"

const char delayBlockKey;

@implementation SMYDeviceTool

+ (instancetype)shareInstance {
    static SMYDeviceTool *utilityTool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        utilityTool = [[SMYDeviceTool alloc] init];
    });
    return utilityTool;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.reachability = [Reachability reachabilityForInternetConnection];
        [self.reachability startNotifier];
        [self reachStatusChange];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachStatusChange) name:kReachabilityChangedNotification object:nil];
    }
    return self;
}

- (void)reachStatusChange {
    if ([self.reachability currentReachabilityStatus] == NotReachable) {
        self.LANIPAddress = @"0.0.0.0";
    } else {
        [SMYDeviceTool getLANIPAddressWithCompletion:^(NSString *IPAddress) {
            self.LANIPAddress = IPAddress;
        }];
    }
}

+ (NSString *)getMachineName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";// 移动,联通
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";// 联通
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";// 电信
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";// 移动,联通
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";// 移动,电信,联通
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,3"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"] || [platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if ([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if ([platform isEqualToString:@"iPhone11,4"] || [platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    if ([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    if ([platform isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
    if ([platform isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
    if ([platform isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
    if ([platform isEqualToString:@"iPhone13,1"]) return @"iPhone 12 Mini";
    if ([platform isEqualToString:@"iPhone13,2"]) return @"iPhone 12";
    if ([platform isEqualToString:@"iPhone13,3"]) return @"iPhone 12 Pro";
    if ([platform isEqualToString:@"iPhone13,4"]) return @"iPhone 12 Pro Max";

    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";// Wifi
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";// GSM
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";// CDMA
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";// 32nm
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad Mini 3";
    
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad Mini 4 (WiFi)";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad Mini 4 (LTE)";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad6,3"])   return @"iPad Pro 9.7";
    if ([platform isEqualToString:@"iPad6,4"])   return @"iPad Pro 9.7";
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro 12.9";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro 12.9";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    NSLog(@"%@", [@"getMachineName接口需要添加支持新的设备:\n" stringByAppendingString:platform]);
    return platform;
}

+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if ( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

+ (void)getLANIPAddressWithCompletion:(void (^)(NSString *IPAddress))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *IP = [self getIPAddress];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(IP);
            }
        });
    });
}

+ (void)getWANIPAddressWithCompletion:(void(^)(NSString *IPAddress))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:@"http://ifconfig.me/ip"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:8.0];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                              delegate:nil delegateQueue:nil];
        NSURLSessionDataTask * task =
        [session dataTaskWithRequest:request
                   completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable urlResponse, NSError * _Nullable error)
         {
             NSString *IP = @"0.0.0.0";
             if (error) {
                 NSLog(@"Failed to get WAN IP Address!\n%@", error);
             } else {
                 NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 IP = responseStr;
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 completion(IP);
             });
         }];
        [task resume];
    });
}

+ (NSString *)getComProvider {
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    //        cn http://en.wikipedia.org/wiki/Mobile_country_code
    //        460   00	China Mobile	China Mobile	Operational
    //        460	01	China Unicom	China Unicom	Operational
    //        460	02	China Mobile	China Mobile	Not operational
    //        460	03	China Telecom	China Telecom	Operational
    //        460	05	China Telecom	China Telecom	Not operational
    //        460	06	China Unicom	China Unicom	Not operational
    //        460	07	China Mobile	China Mobile	Not operational
    //        460	20	China Tietong	China Tietong	Operational	GSM-R
    //  apn
    if (carrier) {
        // 无法获取接入点，只能用运营商，默认为net方式，not support wap type
        if ([carrier.mobileNetworkCode isEqualToString:@"00"] || [carrier.mobileNetworkCode isEqualToString:@"02"]) {// 移动
            return @"中国移动";// @"cmnet";
        } else if ([carrier.mobileNetworkCode isEqualToString:@"01"] || [carrier.mobileNetworkCode isEqualToString:@"06"]) {// 联通
            return @"中国联通";// @"3gnet";
        } else if ([carrier.mobileNetworkCode isEqualToString:@"03"] || [carrier.mobileNetworkCode isEqualToString:@"05"]) {// 电信
           return @"中国电信";// @"ctnet";
        }
    }
    return @"";
}

+ (double)currentUsedMemory {
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount);
    if (KERN_SUCCESS != kernReturn) {
        return 0;
    }
    return taskInfo.resident_size / (k1024 * k1024);
}

- (NSString *)getNetworkType {
    if ([self.reachability currentReachabilityStatus] == ReachableViaWiFi) {
        return @"wifi";
    } else if ([_reachability currentReachabilityStatus] == ReachableViaWWAN) {
        CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
        // telephonyInfo.currentRadioAccessTechnology
        //    CTRadioAccessTechnologyGPRS - 2G
        //    CTRadioAccessTechnologyEdge - 2G (sometimes called 2.5G)
        //    CTRadioAccessTechnologyWCDMA - 3G
        //    CTRadioAccessTechnologyHSDPA - 3G (sometimes called 3.5G)
        //    CTRadioAccessTechnologyHSUPA - 3G
        //    CTRadioAccessTechnologyCDMA1x - 2G
        //    CTRadioAccessTechnologyCDMAEVDORev0 - 3G
        //    CTRadioAccessTechnologyCDMAEVDORevA - 3G
        //    CTRadioAccessTechnologyCDMAEVDORevB - 3G
        //    CTRadioAccessTechnologyeHRPD - 3G (or 3.5 - eHRPD is to allow migration from CDMA EVDO to LTE)
        //    CTRadioAccessTechnologyLTE - 4G (allowed to be called 4G by the ITU as mentioend above)
        
        if ([telephonyInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS]||
           [telephonyInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge]||
           [telephonyInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
           return @"2g";
        } else if ([telephonyInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyWCDMA]||
                 [telephonyInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSDPA]||
                 [telephonyInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSUPA]||
                 [telephonyInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]||
                 [telephonyInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]||
                 [telephonyInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]||
                 [telephonyInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyeHRPD]) {
            return @"3g";
        } else if ([telephonyInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
            return @"4g";
        } else {
            if (@available(iOS 14.1, *)) {
                if ([telephonyInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyNR] ||
                    [telephonyInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyNRNSA]) {
                    return @"5g";
                }
            }
        }
    }
    return nil;
}

@end
