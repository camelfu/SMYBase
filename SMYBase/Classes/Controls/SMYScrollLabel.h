//
//  SMYScrollLabel.h
//  shengbei
//
//  Created by penggongxu on 2019/10/8.
//  Copyright © 2019 smyfinancial. All rights reserved.
//
//  文字滚动控件

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMYScrollLabel : UIView
/** 字体 */
@property (nonatomic, strong) UIFont *contentFont;
/** 内容 */
@property (nonatomic, strong) NSString *content;
/** 字体颜色 */
@property (nonatomic, strong) UIColor *contentColor;

- (void)startScroll;

@end

NS_ASSUME_NONNULL_END
