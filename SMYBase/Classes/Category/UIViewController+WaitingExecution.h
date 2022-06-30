//
//  UIViewController+WaitingExecution.h
//  shengbei
//
//  Created by ChenYong on 2019/7/15.
//  Copyright © 2019 smyfinancial. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (WaitingExecution)

/** 当前页面是否处于等待执行状态中 */
@property (nonatomic, assign, getter=isWaitingExcution) BOOL waitingExcution;

@end

