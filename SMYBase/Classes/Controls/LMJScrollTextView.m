//
//  LMJScrollTextView2.m
//  LMJScrollText
//
//  Created by MajorLi on 15/5/4.
//  Copyright (c) 2015年 iOS开发者公会. All rights reserved.
//
//  iOS开发者公会-技术1群 QQ群号：87440292
//  iOS开发者公会-技术2群 QQ群号：232702419
//  iOS开发者公会-议事区  QQ群号：413102158
//


#import "LMJScrollTextView.h"

#define ScrollTime 0.7f

@implementation LMJScrollTextView
{    
    NSInteger _index;
    
    BOOL _needStop;
}

- (id)init {
    self = [super init];
    if (self) {
        
        self.clipsToBounds = YES;
        
        _index = 0;
        _needStop = NO;
        
        _textDataArr = @[@"您好"];
        _textFont    = [UIFont systemFontOfSize:12];
        _textColor   = [UIColor blackColor];
        _scrollLabel = nil;
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20);
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        
        _index = 0;
        _needStop = NO;
        
        _textDataArr = @[@"您好"];
        _textFont    = [UIFont systemFontOfSize:12];
        _textColor   = [UIColor blackColor];
        _scrollLabel = nil;
    }
    return self;
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    _scrollLabel.font = textFont;
}
- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    _scrollLabel.textColor = textColor;
}

- (NSInteger)currentIndex {
    return _index;
}

- (void)createScrollLabel {
    _scrollLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    _scrollLabel.text          = @"";
//    _scrollLabel.textAlignment = NSTextAlignmentLeft;
    _scrollLabel.textColor     = _textColor;
    _scrollLabel.font          = _textFont;
    [self addSubview:_scrollLabel];
}

- (void)startScrollBottomToTop {
    if (_scrollLabel == nil) {
        [self createScrollLabel];
    }
    _index = 0;
    [self performSelector:@selector(enableScroll) withObject:nil afterDelay:ScrollTime / 2];
    [self performSelector:@selector(scrollBottomToTop) withObject:nil afterDelay:ScrollTime];
}

- (void)startScrollTopToBottom {
    if (_scrollLabel == nil) {
        [self createScrollLabel];
    }
    _index = 0;
    [self performSelector:@selector(enableScroll) withObject:nil afterDelay:ScrollTime / 2];
    [self performSelector:@selector(scrollTopToBottom) withObject:nil afterDelay:ScrollTime];
}

- (void)enableScroll {
    self->_needStop = NO;
}

- (void)stop {
    _needStop = YES;
    [_scrollLabel.layer removeAllAnimations];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollBottomToTop) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollTopToBottom) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(enableScroll) object:nil];
}

- (void)setTextAligment:(NSTextAlignment)aligment {
    if (_scrollLabel == nil) {
        [self createScrollLabel];
    }
    _scrollLabel.textAlignment = aligment;
}

- (void)scrollBottomToTop {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollBottomToTop) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollTopToBottom) object:nil];
    if (self->_needStop) {
        return;
    }
    
    if (![self isCurrentViewControllerVisible:[self viewController]]) {  // 处于非当前页面
        self.scrollLabel.frame = CGRectMake(0, 0, self.scrollLabel.frame.size.width, self.scrollLabel.frame.size.height);
        [self performSelector:@selector(scrollBottomToTop) withObject:nil afterDelay:ScrollTime*3];
        
    } else {                                                               // 处于当前页面
        
        if ([self.delegate respondsToSelector:@selector(scrollTextView:currentTextIndex:)]) { // 代理回调
            [self.delegate scrollTextView:self currentTextIndex:_index];
        }
        
        _scrollLabel.frame = CGRectMake(0, self.frame.size.height, _scrollLabel.frame.size.width, _scrollLabel.frame.size.height);
        NSString *string = _textDataArr[_index];
        if ([string isKindOfClass:[NSString class]]) {
            _scrollLabel.text  = string;
        } else if ([string isKindOfClass:[NSAttributedString class]]) {
            _scrollLabel.attributedText = (NSAttributedString *)string;
        }
        if (_textDataArr.count <= 1) {
            self.scrollLabel.frame = CGRectMake(0, 0, self.scrollLabel.frame.size.width, self.scrollLabel.frame.size.height);
            return;
        }
        [UIView animateWithDuration:ScrollTime animations:^{
            
            self.scrollLabel.frame = CGRectMake(0, 0, self.scrollLabel.frame.size.width, self.scrollLabel.frame.size.height);
            
        } completion:^(BOOL finished) {
            if (self->_needStop) {
                return;
            }
            [UIView animateWithDuration:ScrollTime delay:ScrollTime options:0 animations:^{
                
                self.scrollLabel.frame = CGRectMake(0, -self.frame.size.height, self.scrollLabel.frame.size.width, self.scrollLabel.frame.size.height);
                
            } completion:^(BOOL finished) {
                if (self->_needStop) {
                    return;
                }
                self->_index ++;
                if (self->_index == self.textDataArr.count) {
                    self->_index = 0;
                }
                [self performSelector:@selector(scrollBottomToTop) withObject:nil afterDelay:0.05];
            }];
        }];
    }
}

- (void)scrollTopToBottom {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollBottomToTop) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollTopToBottom) object:nil];
    if (self->_needStop) {
        return;
    }
    
    if (![self isCurrentViewControllerVisible:[self viewController]]) { // 处于非当前页面
        
        [self performSelector:@selector(scrollTopToBottom) withObject:nil afterDelay:ScrollTime*3];
        
    } else {                                                              // 处于当前页面
    
        if ([self.delegate respondsToSelector:@selector(scrollTextView:currentTextIndex:)]) { // 代理回调
            [self.delegate scrollTextView:self currentTextIndex:_index];
        }
        
        _scrollLabel.frame = CGRectMake(0, -self.frame.size.height, _scrollLabel.frame.size.width, _scrollLabel.frame.size.height);
        NSString *string = _textDataArr[_index];
        if ([string isKindOfClass:[NSString class]]) {
            _scrollLabel.text  = string;
        } else if ([string isKindOfClass:[NSAttributedString class]]) {
            _scrollLabel.attributedText = (NSAttributedString *)string;
        }
        if (_textDataArr.count <= 1) {
            self.scrollLabel.frame = CGRectMake(0, 0, self.scrollLabel.frame.size.width, self.scrollLabel.frame.size.height);
            return;
        }
        [UIView animateWithDuration:ScrollTime animations:^{
            
            self.scrollLabel.frame = CGRectMake(0, 0, self.scrollLabel.frame.size.width, self.scrollLabel.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            if (self->_needStop) {
                return;
            }
            
            [UIView animateWithDuration:ScrollTime delay:ScrollTime options:0 animations:^{
                
                self.scrollLabel.frame = CGRectMake(0, self.frame.size.height, self.scrollLabel.frame.size.width, self.scrollLabel.frame.size.height);
                
            } completion:^(BOOL finished) {
                if (self->_needStop) {
                    return;
                }
                
                self->_index ++;
                if (self->_index == self.textDataArr.count) {
                    self->_index = 0;
                }
                
                [self performSelector:@selector(scrollTopToBottom) withObject:nil afterDelay:0.05];
            }];
        }];
    }
}

- (BOOL)isCurrentViewControllerVisible:(UIViewController *)viewController {
    return (viewController.isViewLoaded && viewController.view.window && [UIApplication sharedApplication].applicationState == UIApplicationStateActive);
}

- (UIViewController *)viewController {
    for (UIView * next = [self superview]; next; next = next.superview) {
        UIResponder * nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
