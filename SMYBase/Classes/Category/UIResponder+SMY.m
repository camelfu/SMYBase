//
//  UIResponder+SMY.m
//  SMYBase
//
//  Created by ChenYong on 2021/7/27.
//  Copyright © 2021 smyfinancial. All rights reserved.
//

#import "UIResponder+SMY.h"

static __weak UIResponder *gCurrentFirstResponder;

@implementation UIResponder (SMY)

+ (UIResponder *)currentFirstResponder {
    [[UIApplication sharedApplication] sendAction:@selector(smyFindCurrentFirstResponder) to:nil from:nil forEvent:nil];
    return gCurrentFirstResponder;
}

- (void)smyFindCurrentFirstResponder {
    gCurrentFirstResponder = self;
}

@end
