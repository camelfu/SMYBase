//
//  SMYMediator.h
//  shengbei
//
//  Created by ChenYong on 2019/4/10.
//  Copyright © 2019 smyfinancial. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMediatorParam(obj) (obj == nil? (id)[NSNull null] : (id)obj)

@interface SMYMediator : NSObject

/**
 根据targetClassName指定的类，创建其实例，并使用params传入的参数来执行selectorName实例方法

 @param selectorName 实例方法的名称
 @param targetClassName 目标类名称
 @param params 执行实例方法时传入的参数
 @param shouldCacheTarget 是否缓存创建的实例对象
 @return 执行实例方法得到的返回值
 */
+ (nullable id)performSelector:(nullable NSString *)selectorName onTarget:(nullable NSString *)targetClassName
                    withParams:(nullable NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget;

/**
 释放之前缓存的实例对象

 @param targetClassName 实例对象的类名称
 */
+ (void)releaseCachedTargetWithClassName:(nullable NSString *)targetClassName;

/**
 根据targetClassName指定的类，并使用param作为参数来执行selectorName类方法

 @param selectorName 类方法的名称
 @param targetClassName 目标类名称
 @param params 执行类方法时传入的参数, !!!!!!!!注意：参数只支持对象类型
 @return 执行类方法得到的返回值
 */
+ (nullable id)performClassSelector:(nullable NSString *)selectorName
                           onTarget:(nullable NSString *)targetClassName withParams:(nullable NSArray *)params;

#pragma mark - 给子类重写的方法

/// 指定的类不存在
+ (void)respondToClassNotExist:(nullable NSString *)className;

/// 指定的类没有指定的实例方法
+ (void)respondToClass:(nullable NSString *)className hasNoInstanceMethod:(nullable NSString *)selectorName;

/// 指定的类没有指定的类方法
+ (void)respondToClass:(nullable NSString *)className hasNoClassMethod:(nullable NSString *)selectorName;

@end

