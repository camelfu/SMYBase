//
//  UINavigationController+SMYUtility.m
//  credit
//
//  Created by ChenYong on 14/09/2017.
//  Copyright © 2017 smyfinancial. All rights reserved.
//

#import "UINavigationController+SMYUtility.h"
#import <objc/runtime.h>

static const char KeyFunctionStartMark[] = "KeyFunctionStartMark";

@implementation UINavigationController (SMYUtility)

- (void)popToPage:(UIViewController *)viewController andPushPage:(UIViewController *)pushViewController animated:(BOOL)bAnimated {
    NSMutableArray *aryViewCtls = [NSMutableArray arrayWithArray:self.viewControllers];
    // 移除之前的页面
    while (aryViewCtls.lastObject != viewController && aryViewCtls.lastObject != viewController.parentViewController) {
        [aryViewCtls removeLastObject];
    }
    // 进入新的功能页面
    if (aryViewCtls.lastObject == viewController || aryViewCtls.lastObject == viewController.parentViewController) {
        // 找到了viewController
        if (pushViewController) {
            pushViewController.hidesBottomBarWhenPushed = YES;
            [aryViewCtls addObject:pushViewController];
        }
        [self setViewControllers:aryViewCtls animated:bAnimated];
    } else {
        if (pushViewController) {
            pushViewController.hidesBottomBarWhenPushed = YES;
            [self pushViewController:pushViewController animated:bAnimated];
        }
    }
}

// + (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        method_exchangeImplementations(class_getInstanceMethod(self, @selector(setViewControllers:)),
//                                       class_getInstanceMethod(self, @selector(markFunction_setViewControllers:)));
//        method_exchangeImplementations(class_getInstanceMethod(self, @selector(setViewControllers:animated:)),
//                                       class_getInstanceMethod(self, @selector(markFunction_setViewControllers:animated:)));
//        method_exchangeImplementations(class_getInstanceMethod(self, @selector(popViewControllerAnimated:)),
//                                       class_getInstanceMethod(self, @selector(markFunction_popViewControllerAnimated:)));
//    });
// }
//
// - (void)checkAndRemoveNotExistingMark {
//    NSMutableDictionary *dicFunctions = objc_getAssociatedObject(self, KeyFunctionStartMark);
//    if (!dicFunctions || ![dicFunctions isKindOfClass:[NSMutableDictionary class]]) {
//        return;
//    }
//    NSMutableArray *aryExistingViewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
//    [aryExistingViewControllers removeObject:self.topViewController];
//    NSMutableArray *aryViewCtls = nil;
//    for (NSString *strKey in dicFunctions.allKeys) {
//        aryViewCtls = [dicFunctions objectForKey:strKey];
//        if (![aryViewCtls isKindOfClass:[NSMutableArray class]] || aryViewCtls.count < 1) {
//            continue;
//        }
//        for (NSInteger i = 0; i < aryViewCtls.count; i++) {
//            if (![aryExistingViewControllers containsObject:[aryViewCtls objectAtIndex:i]]) {
//                [aryViewCtls removeObjectAtIndex:i];
//                i--;
//            }
//        }
//        if (aryViewCtls.count < 1) {
//            [dicFunctions removeObjectForKey:strKey];
//        }
//    }
//    if (dicFunctions.allKeys.count < 1) {
//        objc_setAssociatedObject(self, KeyFunctionStartMark, nil, OBJC_ASSOCIATION_RETAIN);
//    }
// }
//
// - (void)markFunction_setViewControllers:(NSArray *)viewControllers {
//    [self markFunction_setViewControllers:viewControllers];
//    [self checkAndRemoveNotExistingMark];
// }
//
// - (void)markFunction_setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
//    [self markFunction_setViewControllers:viewControllers animated:animated];
//    [self checkAndRemoveNotExistingMark];
// }
//
// - (void)markFunction_popViewControllerAnimated:(BOOL)animated {
//    [self markFunction_popViewControllerAnimated:animated];
//    [self checkAndRemoveNotExistingMark];
// }

- (BOOL)markFunction:(NSString *)functionKey startViewCtl:(UIViewController *)viewCtl {
    if (viewCtl == self || !functionKey) {
        return NO;
    }
    if (!viewCtl) {
        viewCtl = self.topViewController;
        if (!viewCtl) {
            return NO;
        }
    }
    
    NSMutableDictionary *dicFunctions = objc_getAssociatedObject(self, KeyFunctionStartMark);
    if (!dicFunctions || ![dicFunctions isKindOfClass:[NSMutableDictionary class]]) {
        dicFunctions = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, KeyFunctionStartMark, dicFunctions, OBJC_ASSOCIATION_RETAIN);
    }
    NSMutableArray *aryFunctionStart = [dicFunctions objectForKey:functionKey];
    if (!aryFunctionStart || ![aryFunctionStart isKindOfClass:[NSMutableArray class]]) {
        aryFunctionStart = [NSMutableArray array];
        [dicFunctions setObject:aryFunctionStart forKey:functionKey];
    }
    if ([aryFunctionStart containsObject:viewCtl]) {
        [aryFunctionStart removeObject:viewCtl];
    }
    [aryFunctionStart addObject:viewCtl];
    return YES;
}

/**
 找到一个功能最后添加的起始点，并删除
 */
- (UIViewController *)removeFunction:(NSString *)strFunctionName startViewCtl:(UIViewController *)viewCtl {
    NSMutableDictionary *dicFunctions = objc_getAssociatedObject(self, KeyFunctionStartMark);
    if (!dicFunctions || ![dicFunctions isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSMutableArray *array = [dicFunctions objectForKey:strFunctionName];
    if (!array || ![array isKindOfClass:[NSMutableArray class]]) {
        return nil;
    }
    if (!viewCtl) {
        viewCtl = array.lastObject;
    }
    if (viewCtl) {
        [array removeObject:viewCtl];
    }
    return viewCtl;
}

- (BOOL)popFunction:(NSString *)strFunctionName animated:(BOOL)bAnimated {
    UIViewController *viewCtl = [self removeFunction:strFunctionName startViewCtl:nil];
    if (!viewCtl) {
        return NO;
    }
    [self popToViewController:viewCtl animated:bAnimated];
    return YES;
}

@end
