//
//  DashLineView.m
//  shengbei
//
//  Created by ChenYong on 2019/2/14.
//  Copyright © 2019 smyfinancial. All rights reserved.
//

#import "DashLineView.h"

@interface DashLineView ()

@property (nonatomic, strong) UIBezierPath *dashPath;

@end

@implementation DashLineView

- (void)setDash:(CGFloat *)dashArray count:(NSUInteger)dashCount {
    [self.dashPath setLineDash:dashArray count:dashCount phase:0];
}

- (CGFloat)dashLineWidth {
    return self.dashPath.lineWidth;
}

- (void)setDashLineWidth:(CGFloat)dashLineWidth {
    self.dashPath.lineWidth = dashLineWidth;
    [self setNeedsDisplay];
}

- (UIBezierPath *)dashPath {
    if (!_dashPath) {
        _dashPath = [UIBezierPath bezierPath];
    }
    return _dashPath;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.dashPath removeAllPoints];
    CGRect bounds = self.bounds;
    [self.dashPath moveToPoint:CGPointMake(CGRectGetMinX(bounds), CGRectGetMidY(bounds))];
    [self.dashPath addLineToPoint:CGPointMake(CGRectGetMaxX(bounds), CGRectGetMidY(bounds))];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [self.dashColor setStroke];
    [self.dashPath stroke];
}

@end
