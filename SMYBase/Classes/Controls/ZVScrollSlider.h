//
//  ZVScrollSider.h
//  scrllSlider
//
//  Created by 子为 on 15/12/25.
//  Copyright © 2015年 wealthBank. All rights reserved.
//
//  试算标尺

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZVScrollSlider;

@protocol ZVScrollSliderDelegate <NSObject>

- (void)ZVScrollSlider:(ZVScrollSlider *)slider ValueChange:(int )value;

@optional
- (void)ZVScrollSliderDidDelete:(ZVScrollSlider *)slider;
- (void)ZVScrollSliderDidTouch:(ZVScrollSlider *)slider;

@end

@interface ZVScrollSlider : UIView
@property (nonatomic, copy ) NSString *title;
@property (nonatomic, copy, readonly) NSString *unit;
@property (nonatomic, assign, readonly) int minValue;
@property (nonatomic, assign, readonly) int maxValue;
@property (nonatomic, assign, readonly) int step;
@property (nonatomic, weak) id<ZVScrollSliderDelegate> delegate;
@property (nonatomic, assign) float realValue;
@property (nonatomic, strong) UITextField *valueTF;

- (void)setRealValue:(float)realValue Animated:(BOOL)animated;

- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title MinValue:(int)minValue MaxValue:(int)maxValue Step:(int)step Unit:(NSString *)unit;

+ (CGFloat)heightWithBoundingWidth:(CGFloat )width Title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END

