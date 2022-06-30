//
//  SMYBallAnimationView.h
//  TestAnimation
//
//  Created by ChenYong on 7/20/16.
//  Copyright © 2016 ChenYong. All rights reserved.
//
// 展示三个小球转动的动画的视图控件

#import <UIKit/UIKit.h>

@interface SMYBallAnimationView : UIView

@property (nonatomic, assign) CGFloat maxBallRadius;

@property (nonatomic, assign) CGFloat minBallRadius;

@property (nonatomic, assign) CGFloat animationDistance;

@property (nonatomic, assign) CGFloat durationForOneReturn;

@property (nonatomic, readonly) BOOL isAnimating;

- (void)setBallColorsLeft:(nullable UIColor *)leftColor middle:(nullable UIColor *)middleColor right:(nullable UIColor *)rightColor;

- (void)startAnimation:(nullable void(^)())completeHandler;

- (void)stopAnimation:(nullable void(^)())completeHandler;

@end
