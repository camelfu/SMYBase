//
//  ZHPickView.h
//  ZHpickView
//
//  Created by liudianling on 14-11-18.
//  Copyright (c) 2014年 赵恒志. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHPickView;

#define kLevelTreeTitle             @"name"
#define kLevelTreeItems             @"items"


@protocol ZHPickViewDelegate <NSObject>

@optional
- (void)toobarCancelBtnHaveClick:(ZHPickView *)pickView;
- (void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString;
- (void)toobarDonBtnHaveClick:(ZHPickView *)pickView selectorArray:(NSArray *)selectorArray;
- (void)zhPickView:(ZHPickView *)pickView didSelectDate:(NSDate *)date;
- (void)zhPickViewWillRemoveFromSuperview;
@end

@interface ZHPickView : UIView

@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, weak) id<ZHPickViewDelegate> delegate;

@property (nonatomic, assign) BOOL adjustDatePickTitleWithDate;

@property (nonatomic, readonly) NSArray *plistArray;

@property (nonatomic, copy) void(^didSelectArrayHandler)(NSArray *);

/**
 *  通过plistName添加一个pickView
 *
 *  @param plistName          plist文件的名字

 *  @param isHaveNavControler 是否在NavControler之内
 *
 *  @return 带有toolbar的pickview
 */
//-(instancetype)initPickviewWithPlistName:(NSString *)plistName isHaveNavControler:(BOOL)isHaveNavControler;
/**
 *  通过plistName添加一个pickView
 *
 *  @param array              需要显示的数组
 *  @param isHaveNavControler 是否在NavControler之内
 *
 *  @return 带有toolbar的pickview
 */
- (instancetype)initPickviewWithArray:(NSArray *)array isHaveNavControler:(BOOL)isHaveNavControler;

/**
 *  通过时间创建一个DatePicker
 *
 *  @param defaulDate               默认选中时间
 *  @param datePickerMode      模式
 *  @param isHaveNavController 是否在NavControler之内
 *
 *  @return 带有toolbar的datePicker
 */
- (instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavController;

/**
 *  通过plistName添加一个pickView
 *
 *  @param array              需要显示的多级数组,显示项和子项同头部定义的k
 *  @param levelDeep          级别的深度
 *  @return 带有toolbar的pickview
 */
- (instancetype)initPickviewWithLevelArray:(NSArray *)array levelDeep:(int)levelDeep;

- (void)addToolbarButton:(UIButton *)button;

/**
 *  选中行
 */
- (void)selectRow:(NSInteger)row;

/**
 *  移除本控件
 */
- (void)remove;

/**
 *  显示本控件
 */
- (void)show;

/**
 *  设置PickView的颜色
 */
- (void)setPickViewColer:(UIColor *)color;

/**
 *  设置toobar的文字颜色
 */
- (void)setTintColor:(UIColor *)color;

/**
 *  设置toobar的背景颜色
 */
- (void)setToolbarTintColor:(UIColor *)color;

/**
 *  设置选择器title
 */
- (void)setPickerTitle:(NSString *)title font:(UIFont *)font;

/**
 *  设置时间选择器title （只有选择日期用）
 */
- (void)setDatePickerTitle:(NSString *)title;

/**
 *  设置时间选择器当前日期 （只有选择日期用）
 */
- (void)setDatePickerDate:(NSDate *)date;

/**
 *  获取当前行的title
 */
- (NSString *)getTitleFromPickerView:(UIPickerView *)pickerView row:(NSInteger)row component:(NSInteger)component;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
