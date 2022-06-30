//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  UIScrollView+Extension.m
//  MJRefreshExample
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import "UIScrollView+MJExtension.h"
#import <objc/runtime.h>

#define SYSTEM_VERSION_GREATER_NOT_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability-new"

@implementation UIScrollView (MJExtension)

- (UIEdgeInsets)mj_inset
{
    if (@available(iOS 11.0, *)) {
        return self.adjustedContentInset;
    }
    return self.contentInset;
}

- (void)setMj_insetT:(CGFloat)mj_insetT
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = mj_insetT;
    if (@available(iOS 11.0, *)) {
        inset.top -= (self.adjustedContentInset.top - self.contentInset.top);
    }
    self.contentInset = inset;
}

- (CGFloat)mj_insetT
{
    return self.mj_inset.top;
}

- (void)setMj_insetB:(CGFloat)mj_insetB
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = mj_insetB;
    if (@available(iOS 11.0, *)) {
        inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom);
    }
    self.contentInset = inset;
}

- (CGFloat)mj_insetB
{
    return self.mj_inset.bottom;
}

- (void)setMj_insetL:(CGFloat)mj_insetL
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = mj_insetL;
    if (@available(iOS 11.0, *)) {
        inset.left -= (self.adjustedContentInset.left - self.contentInset.left);
    }
    self.contentInset = inset;
}

- (CGFloat)mj_insetL
{
    return self.mj_inset.left;
}

- (void)setMj_insetR:(CGFloat)mj_insetR
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = mj_insetR;
    if (@available(iOS 11.0, *)) {
        inset.right -= (self.adjustedContentInset.right - self.contentInset.right);
    }
    self.contentInset = inset;
}

- (CGFloat)mj_insetR
{
    return self.mj_inset.right;
}

- (void)setMj_offsetX:(CGFloat)mj_offsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = mj_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)mj_offsetX
{
    return self.contentOffset.x;
}

- (void)setMj_offsetY:(CGFloat)mj_offsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = mj_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)mj_offsetY
{
    return self.contentOffset.y;
}

- (void)setMj_contentW:(CGFloat)mj_contentW
{
    CGSize size = self.contentSize;
    size.width = mj_contentW;
    self.contentSize = size;
}

- (CGFloat)mj_contentW
{
    return self.contentSize.width;
}

- (void)setMj_contentH:(CGFloat)mj_contentH
{
    CGSize size = self.contentSize;
    size.height = mj_contentH;
    self.contentSize = size;
}

- (CGFloat)mj_contentH
{
    return self.contentSize.height;
}
@end
#pragma clang diagnostic pop