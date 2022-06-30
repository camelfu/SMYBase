//
//  SMYPlateSingleInputLabel.h
//  SMYBusinessBase
//
//  Created by penggongxu on 2020/12/28.
//  Copyright © 2020 smyfinancial. All rights reserved.
//
//  车牌输入视图的单个label视图

#import <UIKit/UIKit.h>

/** inputLabel的键盘类型 */
typedef NS_ENUM(NSUInteger, SMYPlateInputViewType) {
    SMYPlateInputViewTypeChineseCharactor = 1,  // 输入类型为汉字
    SMYPlateInputViewTypeLetters,  // 输入类型为字母
    SMYPlateInputViewTypeOther, // 输入类型为字母和数字
};

typedef NS_ENUM(NSUInteger, SMYPlateInputButtonType) {
    SMYPlateInputButtonTypeDefault = 1,  // 默认类型（汉字、英文、数字）
    SMYPlateInputButtonTypeDelete,  // 删除按钮
    SMYPlateInputButtonTypeConfirm, // 确认按钮
};

@class SMYPlateSingleInputLabel;
@protocol SMYPlateSingleInputLabelDelegate <NSObject>

- (void)didSelectedSingleInputLabel:(SMYPlateSingleInputLabel *)label
                         buttonType:(SMYPlateInputButtonType)buttonType;

@end

@interface SMYPlateSingleInputLabel : UILabel

/** 输入键盘 */
@property (nonatomic, strong) UIView *inputView;
/** 键盘输入类型 */
@property (assign, nonatomic) SMYPlateInputViewType inputViewType;

@property (weak, nonatomic) id <SMYPlateSingleInputLabelDelegate> delegate;
/** 是否新能源标识 */
@property (nonatomic, assign, getter=isNewEnergy) BOOL newEnergy;
/** 是否可提交 */
@property (nonatomic, assign) BOOL canSubmit;

/// 结束输入
- (void)done;

@end


