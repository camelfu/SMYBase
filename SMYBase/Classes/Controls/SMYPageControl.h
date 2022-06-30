//
//  SMYPageControl.h
//  shengbei
//
//  Created by ChenYong on 2019/8/20.
//  Copyright © 2019 smyfinancial. All rights reserved.
//
// 类似UIPageControl的、指示所有页面数量及当前页面位置的控件

#import <UIKit/UIKit.h>

@interface SMYPageControl : UIControl

/** 所有页面圆点的大小 */
@property (nonatomic, assign) CGSize dotSize;
/** 当前页的长条形圆点的大小 */
@property (nonatomic, assign) CGSize currentDotSize;
/** 页面总数量 */
@property (nonatomic, assign) NSInteger numberOfPages;
/** 当前页面的位置 */
@property (nonatomic, assign) NSInteger currentPage;
/** 所有页面圆点的颜色 */
@property (nonatomic, strong, nullable) UIColor *pageIndicatorTintColor;
/** 当前页的长条形圆点的颜色 */
@property (nonatomic, strong, nullable) UIColor *currentPageIndicatorTintColor;

@end
