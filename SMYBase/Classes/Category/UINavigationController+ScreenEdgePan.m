//
//  UINavigationController+ScreenEdgePan.m
//  credit
//
//  Created by ChenYong on 10/01/2018.
//  Copyright © 2018 smyfinancial. All rights reserved.
//

#import "UINavigationController+ScreenEdgePan.h"

@implementation UINavigationController (ScreenEdgePan)

@dynamic enableScreenPan;
- (BOOL)enableScreenPan {
    for (UIScreenEdgePanGestureRecognizer *recognizer in self.view.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
            return recognizer.enabled;
        }
    }
    return NO;
}

- (void)setEnableScreenPan:(BOOL)enableScreenPan {
    for (UIScreenEdgePanGestureRecognizer *recognizer in self.view.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
            recognizer.enabled = enableScreenPan;
            return;
        }
    }
}

@end
