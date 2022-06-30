//
//  UINavigationController+SMYStatusStyle.m
//  SMYBase
//
//  Created by ChenYong on 2021/9/26.
//  Copyright © 2021 smyfinancial. All rights reserved.
//

#import <objc/runtime.h>

void SmyExchangeClassInstanceMethod(Class cls, SEL originalSel, SEL newSel) {
    Method originalMethod = class_getInstanceMethod(cls, originalSel);
    Method newMethod = class_getInstanceMethod(cls, newSel);
    IMP impOriginal = method_getImplementation(originalMethod);
    IMP impNew = method_getImplementation(newMethod);
    if (class_addMethod(cls, originalSel, impNew, method_getTypeEncoding(newMethod))) {
        class_replaceMethod(cls, newSel, impOriginal, method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

@implementation UINavigationController (SMYStatusBarStyle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SmyExchangeClassInstanceMethod(self, @selector(childViewControllerForStatusBarStyle),
                               @selector(smyStatusBarStyle_childViewControllerForStatusBarStyle));
    });
}

- (UIViewController *)smyStatusBarStyle_childViewControllerForStatusBarStyle {
    if (self.visibleViewController) {
        return self.visibleViewController;
    }
    return [self smyStatusBarStyle_childViewControllerForStatusBarStyle];
}

@end


@implementation UIViewController (SMYStatusBarStyle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SmyExchangeClassInstanceMethod(self, @selector(preferredStatusBarStyle), @selector(smyStatusBarStyle_preferredStatusBarStyle));
    });
}

#pragma mark - setter & getter
- (UIStatusBarStyle)smyStatusBarStyle_preferredStatusBarStyle {
    if (self.navigationController) {
        return self.navigationController.navigationBar.barStyle == UIBarStyleDefault ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
    }
    return [self smyStatusBarStyle_preferredStatusBarStyle];
}

@end
