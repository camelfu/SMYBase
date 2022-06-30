//
//  SMYBallAnimationView.m
//  TestAnimation
//
//  Created by ChenYong on 7/20/16.
//  Copyright © 2016 ChenYong. All rights reserved.
//

#import "SMYBallAnimationView.h"

@interface BallView : UIView

@property (nonatomic, strong) UIColor *ballColor;

@end

@interface SMYBallAnimationView ()

@property (nonatomic, strong) BallView *leftBallView;

@property (nonatomic, strong) BallView *midBallView;

@property (nonatomic, strong) BallView *rightBallView;

@property (nonatomic, assign) BOOL haStartedAnimation;

/** 正在开始 */
@property (nonatomic, assign) BOOL isStartingAnimation;

@end

@implementation SMYBallAnimationView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)initParam {
    self.minBallRadius = 2;
    self.maxBallRadius = 5;
    self.animationDistance = 34;
    self.durationForOneReturn = 2;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (instancetype)init {
    if (self = [super init]) {
        [self initParam];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self initParam];
        [self createBalls];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
                                  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initParam];
        [self createBalls];
    }
    return self;
}

@dynamic isAnimating;
- (BOOL)isAnimating {
    return self.isStartingAnimation | self.haStartedAnimation;
}

- (void)createBalls {
    self.clipsToBounds = YES;
    if (!self.leftBallView) {
        self.leftBallView = [[BallView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        self.leftBallView.backgroundColor = [UIColor clearColor];
        self.leftBallView.ballColor  = [UIColor colorWithRed:91 / 255.0 green:206 / 255.0 blue:137 / 255.0 alpha:1];
        self.leftBallView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:self.leftBallView];
    }
    if (!self.midBallView) {
        self.midBallView = [[BallView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        self.midBallView.backgroundColor = [UIColor clearColor];
        self.midBallView.ballColor   = [UIColor colorWithRed:104 / 255.0 green:155 / 255.0 blue:224 / 255.0 alpha:1];
        self.midBallView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:self.midBallView];
    }
    if (!self.rightBallView) {
        self.rightBallView = [[BallView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        self.rightBallView.backgroundColor = [UIColor clearColor];
        self.rightBallView.ballColor = [UIColor colorWithRed:244 / 255.0 green:137 / 255.0 blue:99 / 255.0 alpha:1];
        self.rightBallView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:self.rightBallView];
    }
    [self resetBallViewsWithAnimation:NO complete:nil];
}

- (void)applicationWillEnterForeground:(NSNotification *)ntf {
    if (self.isAnimating)
        [self startAnimation:nil];
}

- (void)setBallColorsLeft:(UIColor *)leftColor middle:(UIColor *)middleColor right:(UIColor *)rightColor {
    if (!self.leftBallView || !self.midBallView || !self.rightBallView) {
        [self createBalls];
    }
    if (leftColor) {
        self.leftBallView.ballColor = leftColor;
    }
    if (middleColor) {
        self.midBallView.ballColor = middleColor;
    }
    if (rightColor) {
        self.rightBallView.ballColor = rightColor;
    }
}

- (void)transformDotView:(BallView *)ballView withSize:(CGSize)size move:(CGPoint)ptMoveBy {
    CGPoint ptCenter = ballView.center;
    ptCenter = CGPointMake(ptCenter.x + ptMoveBy.x, ptCenter.y + ptMoveBy.y);
    CGRect frame = ballView.frame;
    frame.size = size;
    frame.origin.x = ptCenter.x - frame.size.width / 2;
    frame.origin.y = ptCenter.y - frame.size.height / 2;
    ballView.frame = frame;
}

- (void)resetBallViewsWithAnimation:(BOOL)bAnimate complete:(void(^)())completeHandler {
    void(^resetBallsFrameBlock)() = ^() {
        CGFloat fMidWidth = self.minBallRadius + self.maxBallRadius;
        CGPoint ptCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        CGSize size = CGSizeMake(fMidWidth, fMidWidth);
        if (bAnimate) {
            [UIView animateWithDuration:0.1 animations:^{
                CGPoint ptMove = CGPointMake(ptCenter.x - self.leftBallView.center.x - 0.5 * self.animationDistance,  ptCenter.y - self.leftBallView.center.y);
                [self transformDotView:self.leftBallView  withSize:size move:ptMove];
                ptMove = CGPointMake(ptCenter.x - self.midBallView.center.x,  ptCenter.y - self.midBallView.center.y);
                [self transformDotView:self.midBallView   withSize:size move:ptMove];
                ptMove = CGPointMake(ptCenter.x - self.rightBallView.center.x + 0.5 * self.animationDistance,  ptCenter.y - self.rightBallView.center.y);
                [self transformDotView:self.rightBallView withSize:size move:ptMove];
            } completion:^(BOOL finished) {
                if (completeHandler)
                    completeHandler();
            }];
        } else {
            self.leftBallView.center = ptCenter;
            self.midBallView.center = ptCenter;
            self.rightBallView.center = ptCenter;
            [self transformDotView:self.leftBallView withSize:size move:CGPointMake(-0.5 * self.animationDistance, 0)];
            [self transformDotView:self.midBallView withSize:size move:CGPointMake(0, 0)];
            [self transformDotView:self.rightBallView withSize:size move:CGPointMake(0.5 * self.animationDistance, 0)];
            if (completeHandler)
                completeHandler();
        }
    };
    if (!self.leftBallView || !self.midBallView || !self.rightBallView) {
        [self createBalls];
        resetBallsFrameBlock();
    } else {
        if (self.leftBallView.layer.animationKeys.count < 1 &&
            self.midBallView.layer.animationKeys.count < 1 && self.rightBallView.layer.animationKeys.count < 1) {
            resetBallsFrameBlock();
            return;
        }
        [self.leftBallView.layer removeAllAnimations];
        [self.midBallView.layer removeAllAnimations];
        [self.rightBallView.layer removeAllAnimations];
        // midBallView和rightBallView有新动画在动画结束后开始，所以此时动画有可能没有彻底清除，要延时后再次清除动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.leftBallView.layer.animationKeys.count > 0 ||
                self.midBallView.layer.animationKeys.count > 0 || self.rightBallView.layer.animationKeys.count > 0) {
            }
            [self.leftBallView.layer removeAllAnimations];
            [self.midBallView.layer removeAllAnimations];
            [self.rightBallView.layer removeAllAnimations];
            resetBallsFrameBlock();
        });
    }
}

#define TransformDotViewWithKeyframes(dotView) \
        {\
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.09 animations:^{\
                [self transformDotView:dotView withSize:CGSizeMake(fMinWidth, fMinWidth) move:CGPointMake(0.25 * fDistance, 0)];\
            }];\
            [UIView addKeyframeWithRelativeStartTime:0.09 relativeDuration:0.17 animations:^{\
                [self transformDotView:dotView withSize:CGSizeMake(fMaxWidth, fMaxWidth) move:CGPointMake(0.50 * fDistance, 0)];\
            }];\
            [UIView addKeyframeWithRelativeStartTime:0.26 relativeDuration:0.22 animations:^{\
                [self transformDotView:dotView withSize:CGSizeMake(fMidWidth, fMidWidth) move:CGPointMake(0.25 * fDistance, 0)];\
            }];\
            [UIView addKeyframeWithRelativeStartTime:0.48 relativeDuration:0.26 animations:^{\
                [self transformDotView:dotView withSize:CGSizeMake(fMinWidth, fMinWidth) move:CGPointMake(-0.25 * fDistance, 0)];\
            }];\
            [UIView addKeyframeWithRelativeStartTime:0.74 relativeDuration:0.21 animations:^{\
                [self transformDotView:dotView withSize:CGSizeMake(fMaxWidth, fMaxWidth) move:CGPointMake(-0.50 * fDistance, 0)];\
            }];\
            [UIView addKeyframeWithRelativeStartTime:0.95 relativeDuration:0.05 animations:^{\
                [self transformDotView:dotView withSize:CGSizeMake(fMidWidth, fMidWidth) move:CGPointMake(-0.25 * fDistance, 0)];\
            }];\
        }

- (void)startAnimation:(void(^)())completeHandler {
    if (self.isStartingAnimation) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            while (self.isStartingAnimation) {
                usleep(90000);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completeHandler) {
                    completeHandler();
                }
            });
        });
        return;
    }
    self.isStartingAnimation = YES;
    [self resetBallViewsWithAnimation:NO complete:^{
        self.haStartedAnimation = YES;
        self.isStartingAnimation = NO;
        CGFloat fMinWidth = self.minBallRadius * 2;
        CGFloat fMaxWidth = self.maxBallRadius * 2;
        CGFloat fMidWidth = self.minBallRadius + self.maxBallRadius;
        CGFloat fDistance = self.animationDistance;
        // Left
        UIViewKeyframeAnimationOptions options = UIViewKeyframeAnimationOptionRepeat | UIViewKeyframeAnimationOptionCalculationModeLinear;
        [UIView animateKeyframesWithDuration:self.durationForOneReturn delay:0 options:options animations:^{
            TransformDotViewWithKeyframes(self.leftBallView);
        } completion:nil];
        // Mid
        [UIView animateKeyframesWithDuration:0.333333 * self.durationForOneReturn delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
                [self transformDotView:self.midBallView withSize:CGSizeMake(fMaxWidth, fMaxWidth) move:CGPointMake(-0.25 * fDistance, 0)];
            }];
            [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
                [self transformDotView:self.midBallView withSize:CGSizeMake(fMidWidth, fMidWidth) move:CGPointMake(-0.25 * fDistance, 0)];
            }];
        } completion:^(BOOL finished) {
            if (!self.haStartedAnimation)
                return;
            [UIView animateKeyframesWithDuration:self.durationForOneReturn delay:0 options:options animations:^{
                TransformDotViewWithKeyframes(self.midBallView);
            } completion:nil];
        }];
        // Right
        [UIView animateKeyframesWithDuration:0.666666 * self.durationForOneReturn delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.25 animations:^{
                [self transformDotView:self.rightBallView withSize:CGSizeMake(fMinWidth, fMinWidth) move:CGPointMake(-0.25 * fDistance, 0)];
            }];
            [UIView addKeyframeWithRelativeStartTime:0.25 relativeDuration:0.5 animations:^{
                [self transformDotView:self.rightBallView withSize:CGSizeMake(fMaxWidth, fMaxWidth) move:CGPointMake(-0.5 * fDistance, 0)];
            }];
            [UIView addKeyframeWithRelativeStartTime:0.75 relativeDuration:0.25 animations:^{
                [self transformDotView:self.rightBallView withSize:CGSizeMake(fMidWidth, fMidWidth) move:CGPointMake(-0.25 * fDistance, 0)];
            }];
        } completion:^(BOOL finished) {
            if (!self.haStartedAnimation)
                return;
            [UIView animateKeyframesWithDuration:self.durationForOneReturn delay:0 options:options animations:^{
                TransformDotViewWithKeyframes(self.rightBallView);
            } completion:nil];
        }];
        if (completeHandler)
            completeHandler();
    }];
}

- (void)stopAnimation:(void(^)())completeHandler {
    if (self.isStartingAnimation) {// 动画正在开始，等待其完成
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            while (self.isStartingAnimation) {
                usleep(100000);
            }
            self.haStartedAnimation = NO;
            [self resetBallViewsWithAnimation:NO complete:^{
                if (completeHandler)
                    completeHandler();
            }];
        });
        return;
    }
    self.haStartedAnimation = NO;
    [self resetBallViewsWithAnimation:NO complete:^{
        if (completeHandler)
            completeHandler();
    }];
}

@end

@implementation BallView

- (void)drawRect:(CGRect)rect {
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    [self.ballColor setFill];
    [bezierPath fill];
}

@end
