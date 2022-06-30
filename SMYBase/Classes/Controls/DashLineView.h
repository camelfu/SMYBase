//
//  DashLineView.h
//  shengbei
//
//  Created by ChenYong on 2019/2/14.
//  Copyright © 2019 smyfinancial. All rights reserved.
//
// 一个将dash line作为border的视图

#import <UIKit/UIKit.h>

@interface DashLineView : UIView

@property (nonatomic, strong, nullable) UIColor *dashColor;
@property (nonatomic, assign) CGFloat dashLineWidth;

- (void)setDash:(nullable CGFloat *)dashArray count:(NSUInteger)dashCount;

@end
