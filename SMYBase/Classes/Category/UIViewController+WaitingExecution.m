//
//  UIViewController+WaitingExecution.m
//  shengbei
//
//  Created by ChenYong on 2019/7/15.
//  Copyright © 2019 smyfinancial. All rights reserved.
//
// 用于标记页面是否正在等待执行一个动作或者过程的状态当中

#import "UIViewController+WaitingExecution.h"
#import <objc/runtime.h>

@implementation UIViewController (WaitingExecution)

- (BOOL)isWaitingExcution {
    return [objc_getAssociatedObject(self, @selector(isWaitingExcution)) boolValue];
}

- (void)setWaitingExcution:(BOOL)waitingExcution {
    objc_setAssociatedObject(self, @selector(isWaitingExcution), @(waitingExcution), OBJC_ASSOCIATION_ASSIGN);
}

@end
