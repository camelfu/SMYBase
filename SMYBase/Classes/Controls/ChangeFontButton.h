//
//  ChangeFontButton.h
//  credit
//
//  Created by ChenYong on 8/5/16.
//  Copyright © 2016 smyfinancial. All rights reserved.
//
// 在选中状态改变时能切换字体的按钮

#import <UIKit/UIKit.h>

@interface ChangeFontButton : UIButton// VTMagicViewController顶部类别选择菜单按钮，有两种字体

@property (nonatomic, strong, nullable) UIFont *normalFont;
@property (nonatomic, strong, nullable) UIFont *selectedFont;

@end
