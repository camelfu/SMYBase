//
//  UIView+Dot.m
//  credit
//
//  Created by 张云飞 on 16/3/19.
//  Copyright © 2016年 smyfinancial. All rights reserved.
//

#import "UIView+Dot.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>

static const char * dotKey;
#define UIVIEW_DOT_DEFAULT_TEXT_COLOR [UIColor whiteColor]
#define UIVIEW_DOT_DEFAULT_RADIUS 8.0f

@implementation UIView_DotView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHex:0xff6565 alpha:1];
        self.textColor = UIVIEW_DOT_DEFAULT_TEXT_COLOR;
        self.font = [UIFont systemFontOfSize:9.0];
        self.textAlignment = NSTextAlignmentCenter;
        self.hidden = YES;
        self.clipsToBounds = YES;
    }
    return self;
}

@end

@implementation UIView (Dot)

- (UIView_DotView *)dotView {
    return objc_getAssociatedObject(self, &dotKey);
}

- (void)setDotView:(UIView_DotView *)dotView {
    objc_setAssociatedObject(self, &dotKey, dotView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)createDotView {
    if (!self.dotView) {
        UIView_DotView * dotView = [[UIView_DotView alloc] init];
        [self addSubview:(self.dotView = dotView)];
    }
}

- (void)showDot {
    CGPoint tmpPoint = CGPointMake(self.bounds.size.width, 0);
    [self showDot:tmpPoint radius:UIVIEW_DOT_DEFAULT_RADIUS / 2];
}

- (void)showDot:(NSString *)text {
    CGPoint tmpPoint = CGPointMake(self.bounds.size.width, 0);
    [self showDot:tmpPoint text:text];
}

- (void)showDot:(CGPoint)point text:(NSString *)text {
    if (text == nil || [text length] == 0) {
        [self showDot];
    } else {
        [self createDotView];
        self.dotView.text = text;
        self.dotView.hidden = NO;
        CGSize size = [self.dotView sizeThatFits:CGSizeMake(CGFLOAT_MAX, UIVIEW_DOT_DEFAULT_RADIUS * 2)];
        self.dotView.layer.cornerRadius = UIVIEW_DOT_DEFAULT_RADIUS;
        self.dotView.frame = CGRectMake(0, 0, size.width > 14.0 ? size.width + 3.0 : UIVIEW_DOT_DEFAULT_RADIUS * 2, UIVIEW_DOT_DEFAULT_RADIUS * 2);
        self.dotView.center = point;
    }
}

- (void)showDot:(CGPoint)point radius:(CGFloat)radius {
    [self createDotView];
    self.dotView.text = @"";
    self.dotView.hidden = NO;
    self.dotView.layer.cornerRadius = radius;
    self.dotView.frame = CGRectMake(point.x, point.y, radius * 2.0, radius * 2.0);
}

- (void)showDot:(CGPoint)point radius:(CGFloat)radius text:(NSString *)text font:(UIFont *)font {
    if (text == nil || [text length] == 0) {
        return;
    }
    [self createDotView];
    self.dotView.text = text;
    self.dotView.textAlignment = NSTextAlignmentCenter;
    self.dotView.hidden = NO;
    self.dotView.center = point;
    self.dotView.font = font != nil ? font : [UIFont systemFontOfSize:9.0];
    self.dotView.layer.cornerRadius = radius;
    CGSize size = [self.dotView sizeThatFits:CGSizeMake(CGFLOAT_MAX, UIVIEW_DOT_DEFAULT_RADIUS * 2)];
    size.width += 3;
    self.dotView.frame = CGRectMake(point.x, point.y, size.width > radius * 2 ? size.width : radius * 2, radius * 2.0);
}

- (void)showDotWithNumber:(NSInteger)number point:(CGPoint)point radius:(CGFloat)radius font:(UIFont *)font {
    if (number <= 0) {
        [self hideDot];
    } else {
        NSString *text = number > 99 ? @"99+" : [NSString stringWithFormat:@"%ld", (long)number];
        [self showDot:point radius:radius text:text font:font];
    }
}

- (void)hideDot {
    if ([self dotView]) {
        [self dotView].hidden = YES;
    }
}

@end
