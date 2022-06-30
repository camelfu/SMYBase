//
//  SMYMediator.m
//  shengbei
//
//  Created by ChenYong on 2019/4/10.
//  Copyright © 2019 smyfinancial. All rights reserved.
//

#import "SMYMediator.h"

@implementation SMYMediator

+ (id)performSelector:(NSString *)selectorName onTarget:(NSString *)targetClassName withParams:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget {
    if (targetClassName.length < 1 || selectorName.length < 1) {
        return nil;
    }
    // generate target
    NSObject *target = self.cachedTarget[targetClassName];
    if (target == nil) {
        Class targetClass = NSClassFromString(targetClassName);
        if (!targetClass) {
            [self respondToClassNotExist:targetClassName];
            return nil;
        }
        target = [[targetClass alloc] init];
    }
    if (target == nil) {
        NSLog(@"创建类实例失败：%@", targetClassName);
        return nil;
    }
    
    if (shouldCacheTarget) {
        self.cachedTarget[targetClassName] = target;
    }
    
    // generate action
    SEL action = NSSelectorFromString(selectorName);
    if (![target respondsToSelector:action]) {
        [self respondToClass:targetClassName hasNoInstanceMethod:selectorName];
        return nil;
    }
    return [self safePerformAction:action target:target param:params];
}

+ (void)releaseCachedTargetWithClassName:(NSString *)targetClassName {
    if (targetClassName.length < 1) {
        return;
    }
    [self.cachedTarget removeObjectForKey:targetClassName];
}

+ (id)performClassSelector:(NSString *)selectorName onTarget:(NSString *)targetClassName withParams:(NSArray *)params {
    if (targetClassName.length < 1 || selectorName.length < 1) {
        return nil;
    }
    Class targetClass = NSClassFromString(targetClassName);
    if (!targetClass) {
        [self respondToClassNotExist:targetClassName];
        return nil;
    }
    SEL action = NSSelectorFromString(selectorName);
    if (![targetClass respondsToSelector:action]) {
        [self respondToClass:targetClassName hasNoClassMethod:selectorName];
        return nil;
    }
    return [self safePerformAction:action onTarget:targetClass withParams:params];
}

+ (void)respondToClassNotExist:(NSString *)className {
    NSLog(@"找不到类：%@", className);
}

+ (void)respondToClass:(NSString *)className hasNoInstanceMethod:(NSString *)selectorName {
    NSLog(@"类%@不响应实例方法：%@", className, selectorName);
}

+ (void)respondToClass:(NSString *)className hasNoClassMethod:(NSString *)selectorName {
    NSLog(@"类%@不响应类方法：%@", className, selectorName);
}

#pragma mark - private methods
+ (NSMutableDictionary *)cachedTarget {
    static NSMutableDictionary *sCachedTargetsDictionary = nil;
    if (sCachedTargetsDictionary == nil) {
        sCachedTargetsDictionary = [[NSMutableDictionary alloc] init];
    }
    return sCachedTargetsDictionary;
}

+ (id)safePerformAction:(SEL)action target:(id)target param:(id)param {
    NSMethodSignature *methodSig = [target methodSignatureForSelector:action];
    if (methodSig == nil) {
        return nil;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    [invocation setTarget:target];
    [invocation setSelector:action];
    if (methodSig.numberOfArguments > 2 && param) {
        [invocation setArgument:&param atIndex:2];
    }
    // 获取返回值
    const char* retType = [methodSig methodReturnType];
    if (strcmp(retType, @encode(void)) == 0) {
        [invocation invoke];
        return nil;
    }
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    if (strcmp(retType, @encode(BOOL)) == 0) {
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:param];
#pragma clang diagnostic pop
}

+ (id)safePerformAction:(SEL)action onTarget:(id)target withParams:(NSArray *)params {
    NSMethodSignature *methodSig = [target methodSignatureForSelector:action];
    if (methodSig == nil) {
        return nil;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    [invocation setTarget:target];
    [invocation setSelector:action];
    NSInteger index = 2;
    for (id param in params) {
        if (methodSig.numberOfArguments <= index) {
            break;
        }
        if (param != [NSNull null]) {
            id object = param;
            [invocation setArgument:&object atIndex:index];
        }
        index++;
    }
    [invocation invoke];
    // 获取返回值
    const char* retType = [methodSig methodReturnType];
    if (strcmp(retType, @encode(void)) == 0) {
        return nil;
    }
    if (strcmp(retType, @encode(id)) == 0) {
        __autoreleasing id result = nil;
        [invocation getReturnValue:&result];
        return result;
    }
    if (strcmp(retType, @encode(typeof ([NSObject class]))) == 0) {
        __autoreleasing Class result = nil;
        [invocation getReturnValue:&result];
        return result;
    }
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    if (strcmp(retType, @encode(BOOL)) == 0) {
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    if (strcmp(retType, @encode(int)) == 0) {
        int result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    if (strcmp(retType, @encode(bool)) == 0) {
        bool result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    if (strcmp(retType, @encode(float)) == 0) {
        float result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    if (strcmp(retType, @encode(double)) == 0) {
        double result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    if (strcmp(retType, @encode(char)) == 0) {
        char result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    return nil;
}

@end
