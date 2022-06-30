//
//  UINavigationController+SafeTransition.h
//
//  Created by hanamichi on 16/1/4.
//  Copyright © 2016年 hanamichi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "UIViewController+MaryPopin.h"

@interface UINavigationController () <UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL viewTransitionInProgress;

@end

@implementation UINavigationController (SafeTransition)

+ (void)exchangeMethod:(SEL)originalSel withMethod:(SEL)newSel {
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    IMP impOriginal = method_getImplementation(originalMethod);
    IMP impNew = method_getImplementation(newMethod);
    method_setImplementation(originalMethod, impNew);
    method_setImplementation(newMethod, impOriginal);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeMethod:@selector(pushViewController:animated:)     withMethod:@selector(safePushViewController:animated:)];
        [self exchangeMethod:@selector(popViewControllerAnimated:)       withMethod:@selector(safePopViewControllerAnimated:)];
        [self exchangeMethod:@selector(popToRootViewControllerAnimated:) withMethod:@selector(safePopToRootViewControllerAnimated:)];
        [self exchangeMethod:@selector(popToViewController:animated:)    withMethod:@selector(safePopToViewController:animated:)];
        [self exchangeMethod:@selector(setViewControllers:animated:)     withMethod:@selector(safeSetViewControllers:animated:)];
        
//        method_exchangeImplementations(class_getInstanceMethod(self, @selector(pushViewController:animated:)),
//                                       class_getInstanceMethod(self, @selector(safePushViewController:animated:)));
//        
//        method_exchangeImplementations(class_getInstanceMethod(self, @selector(popViewControllerAnimated:)),
//                                       class_getInstanceMethod(self, @selector(safePopViewControllerAnimated:)));
//        
//        method_exchangeImplementations(class_getInstanceMethod(self, @selector(popToRootViewControllerAnimated:)),
//                                       class_getInstanceMethod(self, @selector(safePopToRootViewControllerAnimated:)));
//        
//        method_exchangeImplementations(class_getInstanceMethod(self, @selector(popToViewController:animated:)),
//                                       class_getInstanceMethod(self, @selector(safePopToViewController:animated:)));
//        
//        method_exchangeImplementations(class_getInstanceMethod(self, @selector(setViewControllers:animated:)),
//                                       class_getInstanceMethod(self, @selector(safeSetViewControllers:animated:)));
    });
}

#pragma mark - setter & getter
- (void)setViewTransitionInProgress:(BOOL)property {
    NSNumber *number = [NSNumber numberWithBool:property];
    objc_setAssociatedObject(self, @selector(viewTransitionInProgress), number, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)viewTransitionInProgress {
    NSNumber *number = objc_getAssociatedObject(self, @selector(viewTransitionInProgress));
    return [number boolValue];
}

#pragma mark - Intercept Pop, Push, PopToRootVC
- (NSArray *)safePopToRootViewControllerAnimated:(BOOL)animated {
    if (self.viewTransitionInProgress) {
        return nil;
    }
    if (animated) {
        self.viewTransitionInProgress = YES;
    }
    NSArray *viewControllers = [self safePopToRootViewControllerAnimated:animated];
    if (viewControllers.count == 0) {
        self.viewTransitionInProgress = NO;
    }
    return viewControllers;
}

- (NSArray *)safePopToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewTransitionInProgress || viewController.navigationController != self) {
        return nil;
    }
    if (animated) {
        self.viewTransitionInProgress = YES;
    }
    NSArray *viewControllers = [self safePopToViewController:viewController animated:animated];
    if (viewControllers.count == 0) {
        self.viewTransitionInProgress = NO;
    }
    return viewControllers;
}

- (UIViewController *)safePopViewControllerAnimated:(BOOL)animated {
    if (self.viewTransitionInProgress) {
        return nil;
    }
    if (animated) {
        self.viewTransitionInProgress = YES;
    }
    UIViewController *viewController = [self safePopViewControllerAnimated:animated];
    if (viewController == nil) {
        self.viewTransitionInProgress = NO;
    }
    return viewController;
}

- (void)safePushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!viewController || self.viewTransitionInProgress || self.presentedPopinViewController) {
        return;
    }
    if (viewController == self.topViewController || viewController == self) {
        return;
    }
    [self safePushViewController:viewController animated:animated];
    if (animated) {
        self.viewTransitionInProgress = YES;
    }
}

- (void)safeSetViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    if (self.viewTransitionInProgress) {
        return;
    }
    if (animated && viewControllers.count > 0 && viewControllers.lastObject != self.topViewController) {
        self.viewTransitionInProgress = YES;
    }
    [self safeSetViewControllers:viewControllers animated:animated];
}

@end

@implementation UIViewController (SafeTransitionLock)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewDidAppear:)),
                                       class_getInstanceMethod(self, @selector(safeTransition_viewDidAppear:)));
    });
}

- (void)safeTransition_viewDidAppear:(BOOL)animated {
    self.navigationController.viewTransitionInProgress = NO;
    [self safeTransition_viewDidAppear:animated];
}

@end
