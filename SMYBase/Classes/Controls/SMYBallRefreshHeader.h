//
//  SMYBallRefreshHeader.h
//  credit
//
//  Created by ChenYong on 7/30/16.
//  Copyright © 2016 smyfinancial. All rights reserved.
//
// 显示三个小球转动动画的下拉刷新控件

#import "MJRefresh.h"
#import "SMYBallAnimationView.h"

NS_ASSUME_NONNULL_BEGIN

@class SMYBallRefreshHeader;
@protocol SMYBallRefreshHeaderDelegate <NSObject>

- (void)ballRefreshHeader:(SMYBallRefreshHeader *)header refreshStateDidChange:(MJRefreshState)state;

@end

@interface SMYBallRefreshHeader : MJRefreshHeader

@property (nonatomic, weak, nullable) id<SMYBallRefreshHeaderDelegate> delegate;

@property (nonatomic, readonly) SMYBallAnimationView *ballView;

@end

NS_ASSUME_NONNULL_END
