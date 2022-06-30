//
//  TextFieldInputObserver.h
//  TestWatch
//
//  Created by jwter on 16/1/7.
//  Copyright © 2016年 smyfinancial. All rights reserved.
//
// 监控UITextField的输入

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TextFieldInputObserver : NSObject

/**
 增加监控UITextField的开始输入事件，txt会持有block，要注意，避免循环引用
 */
+ (void)addTextField:(nullable UITextField *)txt didStartInputHandler:(nullable void(^)())block;

/**
 开始监控
 */
+ (void)startObserveTextField:(nullable UITextField *)txt;

/**
 移除对UITextField的监控
 */
+ (void)removeTextField:(nullable UITextField *)txt;

@end
