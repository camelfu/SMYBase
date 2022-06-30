//
//  SMYPlateInputView.h
//  SMYBusinessBase
//
//  Created by penggongxu on 2020/12/28.
//  Copyright © 2020 smyfinancial. All rights reserved.
//
//  车牌输入视图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SMYPlateInputView;
@protocol SMYPlateInputViewDelegate <NSObject>

- (void)plateInputView:(SMYPlateInputView *)inputView textDidChange:(NSString *)text;

- (void)plateInputView:(SMYPlateInputView *)inputView textInputDidEnd:(NSString *)text;

@end

@interface SMYPlateInputView : UIView

@property (nonatomic, weak, nullable) id<SMYPlateInputViewDelegate> delegate;

- (void)activeInput;

- (void)resignInput;

- (void)setPlateNum:(nullable NSString *)plateNum;

@end

NS_ASSUME_NONNULL_END


