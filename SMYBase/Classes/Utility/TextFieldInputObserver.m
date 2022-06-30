//
//  TextFieldInputObserver.m
//  TestWatch
//
//  Created by jwter on 16/1/7.
//  Copyright © 2016年 smyfinancial. All rights reserved.
//

#import "TextFieldInputObserver.h"
#import <objc/runtime.h>

@implementation TextFieldInputObserver

const char *ObserveTextFieldStartInputKey   = "ObserveTextFieldStartInputKey";
const char *ObserveTextFieldInputKey        = "ObserveTextFieldInputKey";

+ (instancetype)sharedInstance {
    static TextFieldInputObserver *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TextFieldInputObserver alloc] init];
    });
    return sharedInstance;
}

+ (void)addTextField:(UITextField *)txt didStartInputHandler:(void(^)())block {
    if (!txt || !block) {
        return;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self.sharedInstance
                                             selector:@selector(txtVerifyTextChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:txt];
    objc_setAssociatedObject(txt, ObserveTextFieldStartInputKey, block, OBJC_ASSOCIATION_COPY);
    [TextFieldInputObserver startObserveTextField:txt];
}

+ (void)startObserveTextField:(UITextField *)txt {
    if (!txt) {
        return;
    }
    objc_setAssociatedObject(txt, ObserveTextFieldInputKey, @(YES), OBJC_ASSOCIATION_RETAIN);
}

+ (void)removeTextField:(UITextField *)txt {
    if (!txt) {
        return;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self.sharedInstance name:UITextFieldTextDidChangeNotification object:txt];
}

- (void)txtVerifyTextChange:(NSNotification *)notify {
    UITextField * txt = notify.object;
    if (!txt) {
        return;
    }
    NSNumber *validate = objc_getAssociatedObject(txt, ObserveTextFieldInputKey);
    if ([validate boolValue]) {
        void(^block)() = objc_getAssociatedObject(txt, ObserveTextFieldStartInputKey);
        if (block) {
            block();
        }
    }
    objc_setAssociatedObject(txt, ObserveTextFieldInputKey, @(NO), OBJC_ASSOCIATION_RETAIN);
}

@end
