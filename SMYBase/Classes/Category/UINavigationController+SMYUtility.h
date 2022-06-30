//
//  UINavigationController+SMYUtility.h
//  credit
//
//  Created by ChenYong on 14/09/2017.
//  Copyright © 2017 smyfinancial. All rights reserved.
//
// 用于标记一个功能在UINavigationController的起始页面，方便在该功能结束后退回到该起始页面

#import <UIKit/UIKit.h>

#define kSMYRealPopToVC(vc) ((vc).parentViewController != (vc).navigationController? (vc).parentViewController : (vc))

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (SMYUtility)

/**
 推出在popViewController之上的所有页面，然后push进入pushViewController
 */
- (void)popToPage:(nullable UIViewController *)viewController andPushPage:(nullable UIViewController *)pushViewController animated:(BOOL)bAnimated;

/**
 标记一个功能在UINavigationController的起始页面

 @param strFunctionName 功能名称
 @param viewCtl 传nil则取UINavigationController的topViewController
 @return 是否标记成功
 */
- (BOOL)markFunction:(nullable NSString *)strFunctionName startViewCtl:(nullable UIViewController *)viewCtl;

/**
 退回到之前标记的一个功能在UINavigationController的起始页面

 @param strFunctionName 功能名称
 @param bAnimated 是否使用动画
 @return 是否成功
 */
- (BOOL)popFunction:(NSString *)strFunctionName animated:(BOOL)bAnimated;

@end

NS_ASSUME_NONNULL_END
