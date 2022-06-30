//
//  SMYBallRefreshHeader.m
//  credit
//
//  Created by ChenYong on 7/30/16.
//  Copyright © 2016 smyfinancial. All rights reserved.
//

#import "SMYBallRefreshHeader.h"

@interface SMYBallRefreshHeader ()

@property (nonatomic, strong) SMYBallAnimationView * ballView;

@end

@implementation SMYBallRefreshHeader

- (void)prepare {
    [super prepare];
    // 设置高度
    self.mj_h = 40;
}

- (void)didMoveToWindow {
    // 重新开始动画，支持iOS 10
    [self.ballView stopAnimation:^{
        if (self.state == MJRefreshStateRefreshing) {
            [self.ballView startAnimation:nil];
            self.ballView.hidden = NO;
        }
    }];
}

- (SMYBallAnimationView *)ballView {
    if (!_ballView) {
        _ballView = [[SMYBallAnimationView alloc] initWithFrame:CGRectMake(0, 0, 100, self.mj_h)];
        [self addSubview:self.ballView];
        self.ballView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _ballView;
}

- (void)placeSubviews {
    [super placeSubviews];
    CGRect bounds = self.bounds;
    self.ballView.center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
}

- (void)stopAnimationWithDelay {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopAnimationWithDelay) object:nil];
    [self.ballView stopAnimation:nil];
    self.ballView.hidden = MJRefreshStateIdle == self.state;
}

- (void)setState:(MJRefreshState)state {
    [super setState:state];
    if (state == MJRefreshStateRefreshing) {
        if (!self.ballView.isAnimating) {
            [self.ballView startAnimation:nil];
        }
        self.ballView.hidden = NO;
    } else {
        if (self.ballView.isAnimating) {
            [self performSelector:@selector(stopAnimationWithDelay) withObject:nil afterDelay:0.3 inModes:@[(__bridge NSString *)kCFRunLoopCommonModes]];
        } else {
            self.ballView.hidden = MJRefreshStateIdle == state;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(ballRefreshHeader:refreshStateDidChange:)]) {
        [self.delegate ballRefreshHeader:self refreshStateDidChange:state];
    }
}

@end
