//
//  SMYSelectView.h
//  shengbei
//
//  Created by Clancey on 2020/2/20.
//  Copyright © 2020 smyfinancial. All rights reserved.
//
//  类似pickerView的选择视图(单行选择视图)

#import <UIKit/UIKit.h>

@class SMYSelectView;

@protocol SMYSelectViewDelegate <NSObject>

@optional

- (void)selectView:(SMYSelectView *)selectView didSelectString:(NSString *)resultString;

@end

@interface SMYSelectView : UIView

/** 数据数组 */
@property (nonatomic, copy, readonly) NSArray *dataArray;
/** 代理  */
@property (nonatomic, assign) id<SMYSelectViewDelegate> delegate;
/** 选择完成回调（代理或此回调二选一实现） */
@property (nonatomic, strong) void (^selectCompleted)(NSString *result);

- (instancetype)initWithArray:(NSArray *)array title:(NSString *)title;

- (void)show;

- (void)remove;

@end

