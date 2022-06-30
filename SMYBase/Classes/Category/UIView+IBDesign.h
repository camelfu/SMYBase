//
//  UIView+IBDesign.h
//  credit
//
//  Created by ChenYong on 19/09/2017.
//  Copyright © 2017 smyfinancial. All rights reserved.
//
// 主是为了方便在storyboard中直接对相关属性进行可视化设置操作

#import <UIKit/UIKit.h>

/** IB_DESIGNABLE */
@interface UIView (IBDesign)

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign, nullable) IBInspectable UIColor *borderColor;

@end
