//
//  SMYPageControl.m
//  shengbei
//
//  Created by ChenYong on 2019/8/20.
//  Copyright © 2019 smyfinancial. All rights reserved.
//

#import "SMYPageControl.h"

static CGFloat const SMYPageDotDistance = 9.0f;

@interface SMYPageControl ()

/** 当前页对应的长条视图 */
@property (nonatomic, strong) UIView *viewCurrentPageDot;

@end

@implementation SMYPageControl

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    if (numberOfPages < 0 || numberOfPages == _numberOfPages) {
        return;
    }
    _numberOfPages = numberOfPages;
    [self setUpPageDots];
    if (self.currentPage >= numberOfPages) {
        self.currentPage = 0;
    }
    self.viewCurrentPageDot.hidden = numberOfPages <= 1;
}

- (void)setCurrentPage:(NSInteger)currentPage {
    if (_currentPage == currentPage || currentPage < 0 || currentPage > self.numberOfPages - 1) {
        return;
    }
    _currentPage = currentPage;
    CGRect frame = [self frameOfDotAtIndex:currentPage];
    frame.origin.x = CGRectGetMinX(frame);
    frame.origin.y = CGRectGetMidY(frame) - self.currentDotSize.height / 2;
    frame.size = self.currentDotSize;
    self.viewCurrentPageDot.frame = frame;
}

- (void)setDotSize:(CGSize)dotSize {
    if (dotSize.width < 1 || dotSize.height < 1 || CGSizeEqualToSize(dotSize, _dotSize)) {
        return;
    }
    _dotSize = dotSize;
    [self adjustDots];
}

- (void)setCurrentDotSize:(CGSize)currentDotSize {
    if (currentDotSize.width < 1 || currentDotSize.height < 1 || CGSizeEqualToSize(currentDotSize, _currentDotSize)) {
        return;
    }
    _currentDotSize = currentDotSize;
    CGRect frame = [self frameOfDotAtIndex:self.currentPage];
    frame.origin.x = CGRectGetMinX(frame);
    frame.origin.y = CGRectGetMidY(frame) - currentDotSize.height / 2;
    frame.size = currentDotSize;
    self.viewCurrentPageDot.layer.cornerRadius = self.currentDotSize.height / 2;
    
    [self.viewCurrentPageDot.layer removeAllAnimations];
    [UIView animateWithDuration:0.2 animations:^{
        self.viewCurrentPageDot.frame = frame;
    } completion:^(BOOL finished) {
        self.viewCurrentPageDot.frame = frame;
    }];
}

- (UIView *)viewCurrentPageDot {
    if (!_viewCurrentPageDot) {
        CGRect frame = [self frameOfDotAtIndex:self.currentPage];
        frame.origin.x = CGRectGetMinX(frame);
        frame.origin.y = CGRectGetMidY(frame) - self.currentDotSize.height / 2;
        frame.size = self.currentDotSize;
        _viewCurrentPageDot = [[UIView alloc] initWithFrame:frame];
        if (self.currentPageIndicatorTintColor) {
            _viewCurrentPageDot.backgroundColor = self.currentPageIndicatorTintColor;
        } else {
            _viewCurrentPageDot.backgroundColor = [UIColor colorWithHex:0x12c963 alpha:1];
        }
        _viewCurrentPageDot.layer.cornerRadius = self.currentDotSize.height / 2;
        _viewCurrentPageDot.layer.masksToBounds = YES;
        [self addSubview:_viewCurrentPageDot];
    }
    return _viewCurrentPageDot;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _dotSize = CGSizeMake(4.5, 4.5);
        _currentDotSize = CGSizeMake(13, 4.5);
        _pageIndicatorTintColor = [UIColor colorWithHex:0xe7e7e7 alpha:1];
        _currentPageIndicatorTintColor = [UIColor colorWithHex:0x12c963 alpha:1];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self adjustDots];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self adjustDots];
}

/**
 创建所有的页面对应的圆点视图
 */
- (void)setUpPageDots {
    NSMutableArray <UIView *>*aryExistingSubViews = [self.subviews mutableCopy];
    [aryExistingSubViews removeObject:self.viewCurrentPageDot];
    NSInteger i = 0;
    // 配置各页面对应的小圆点
    for (; i <= self.numberOfPages; i++) {
        UIView *viewDot = nil;
        CGRect frame = [self frameOfDotAtIndex:i];
        if (i < aryExistingSubViews.count) {
            // 使用旧的
            viewDot = [aryExistingSubViews objectAtIndex:i];
            viewDot.frame = frame;
        } else {
            // 创建新的
            viewDot = [[UIView alloc] initWithFrame:frame];
            viewDot.layer.masksToBounds = YES;
            [self addSubview:viewDot];
        }
        viewDot.layer.cornerRadius = self.dotSize.height / 2;
        viewDot.backgroundColor = self.pageIndicatorTintColor;
        viewDot.hidden = self.numberOfPages <= 1;
    }
    // 删除多余的
    for (; i < aryExistingSubViews.count; i++) {
        [aryExistingSubViews[i] removeFromSuperview];
    }
    // 设置当前页的长条形圆点
    self.viewCurrentPageDot.backgroundColor = self.currentPageIndicatorTintColor;
    CGRect frame = [self frameOfDotAtIndex:self.currentPage];
    frame.origin.x = CGRectGetMinX(frame);
    frame.origin.y = CGRectGetMidY(frame) - self.currentDotSize.height / 2;
    frame.size = self.currentDotSize;
    self.viewCurrentPageDot.frame = frame;
    [self.viewCurrentPageDot removeFromSuperview];
    [self addSubview:self.viewCurrentPageDot];
}

/**
 调整所有的页面对应的圆点视图
 */
- (void)adjustDots {
    // 配置各页面对应的小圆点
    NSMutableArray <UIView *>*aryExistingSubViews = [self.subviews mutableCopy];
    [aryExistingSubViews removeObject:self.viewCurrentPageDot];
    NSInteger i = 0;
    for (; i <= self.numberOfPages && i < aryExistingSubViews.count; i++) {
        UIView *viewDot = [aryExistingSubViews objectAtIndex:i];
        viewDot.hidden = self.numberOfPages <= 1;
        CGRect frame = [self frameOfDotAtIndex:i];
        viewDot.frame = frame;
        viewDot.layer.cornerRadius = self.dotSize.height / 2;
        viewDot.layer.masksToBounds = YES;
        viewDot.backgroundColor = self.pageIndicatorTintColor;
    }
    // 设置当前页的长条形圆点
    self.viewCurrentPageDot.backgroundColor = self.currentPageIndicatorTintColor;
    CGRect frame = [self frameOfDotAtIndex:self.currentPage];
    frame.origin.x = CGRectGetMinX(frame);
    frame.origin.y = CGRectGetMidY(frame) - self.currentDotSize.height / 2;
    frame.size = self.currentDotSize;
    self.viewCurrentPageDot.frame = frame;
}

/**
 获取指定页面对应的圆点视图当前应该使用的frame
 */
- (CGRect)frameOfDotAtIndex:(NSInteger)index {
    if (index < 0 || index > self.numberOfPages) {
        return CGRectZero;
    }
    CGRect bounds = self.bounds;
    CGRect frame = CGRectMake(0, 0, self.dotSize.width, self.dotSize.height);
    frame.origin.x = CGRectGetMidX(self.bounds) + (index - self.numberOfPages / 2.0) * SMYPageDotDistance - self.dotSize.width / 2;
    frame.origin.y = CGRectGetMidY(bounds) - self.dotSize.height / 2;
    return frame;
}

@end
