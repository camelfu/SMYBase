//
//  UITextField+Additions.m
//  shengbei
//
//  Created by 张云飞 on 2019/5/9.
//  Copyright © 2019 smyfinancial. All rights reserved.
//

#import "UITextField+Additions.h"
#import <objc/runtime.h>

static const char *privacyKey = "privacyKey";

@implementation UITextField (Additions)

+ (void)load {
    SEL originalSel = @selector(canPerformAction:withSender:);
    SEL newSel = @selector(smy_canPerformAction:withSender:);
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    IMP impOriginal = method_getImplementation(originalMethod);
    IMP impNew = method_getImplementation(newMethod);
    if (class_addMethod(self, originalSel, impNew, method_getTypeEncoding(newMethod))) {
        class_replaceMethod(self, newSel, impOriginal, method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

- (BOOL)isPrivacy {
    return [objc_getAssociatedObject(self, privacyKey) boolValue];
}

- (void)setPrivacy:(BOOL)privacy {
    objc_setAssociatedObject(self, privacyKey, [NSNumber numberWithBool:privacy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isDisableMenu {
    return [objc_getAssociatedObject(self, @selector(isDisableMenu)) boolValue];
}

- (void)setDisableMenu:(BOOL)disableMenu {
    if (disableMenu) {
        objc_setAssociatedObject(self,  @selector(isDisableMenu), @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        objc_setAssociatedObject(self,  @selector(isDisableMenu), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (BOOL)smy_canPerformAction:(SEL)action withSender:(id)sender {
    if (self.isDisableMenu) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        if(menuController) {
            menuController.menuVisible = NO;
        }
        return NO;
    }
    if (self.isPrivacy) {
        if (action == @selector(cut:)) {
            return NO;
        }
        if (action == @selector(copy:)) {
            return NO;
        }
    }
    return [self smy_canPerformAction:action withSender:sender];
}

@end
