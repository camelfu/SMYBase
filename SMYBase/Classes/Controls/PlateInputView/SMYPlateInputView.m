//
//  SMYPlateInputView.m
//  SMYBusinessBase
//
//  Created by penggongxu on 2020/12/28.
//  Copyright © 2020 smyfinancial. All rights reserved.
//

#import "SMYPlateInputView.h"
#import "SMYPlateSingleInputLabel.h"

@interface SMYPlateInputView ()

@property (strong, nonatomic) NSMutableArray *labelArray;
/** 当前正在输入的输入框 */
@property (strong, nonatomic) SMYPlateSingleInputLabel *lastLabel;

@end

@implementation SMYPlateInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatSubViewsWithFrame:frame];
    }
    return self;
}

- (void)activeInput {
    if (self.lastLabel) {
        [self.lastLabel becomeFirstResponder];
    }
}

- (void)resignInput {
    [self endEditing:YES];
}

- (void)setPlateNum:(NSString *)plateNum {
    if (plateNum.length == 0) {
        self.lastLabel = self.labelArray.firstObject;
        return;
    }
    for (int i = 0; i < plateNum.length; i++) {
        if (i < self.labelArray.count) {
            SMYPlateSingleInputLabel *label = (SMYPlateSingleInputLabel *)self.labelArray[i];
            label.text = [plateNum substringWithRange:NSMakeRange(i, 1)];
        }
    }
    if (plateNum.length < self.labelArray.count) {
        self.lastLabel = self.labelArray[plateNum.length];
    } else {
        self.lastLabel = self.labelArray.lastObject;
    }
}

#pragma mark - Private Method

- (void)creatSubViewsWithFrame:(CGRect)frame {
    NSInteger count = 8;
    CGFloat space = 5.0f;
    CGFloat separateWidth = 12;
    CGFloat leading = 12;
    CGFloat totalSpace = (count - 1) * space + separateWidth + leading * 2;
    CGFloat width = (frame.size.width - totalSpace) / count;
    CGFloat height = frame.size.height;
    for (NSInteger i = 0; i < count; i ++) {
        CGRect frame = CGRectMake(leading + (width + space) * i + ((i > 1) ? separateWidth : 0), 0, width, height);
        SMYPlateSingleInputLabel *textLabel = [[SMYPlateSingleInputLabel alloc] initWithFrame:frame];
        if (i == 1) {
            textLabel.inputViewType = SMYPlateInputViewTypeLetters;
        } else if (i > 1) {
            textLabel.inputViewType = SMYPlateInputViewTypeOther;
        }
        textLabel.tag = i;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.layer.borderWidth = 1;
        textLabel.layer.cornerRadius = 2;
        textLabel.layer.borderColor = [UIColor colorWithHex:0xe7e7e7 alpha:1.0f].CGColor;
        textLabel.textColor = [UIColor colorWithHex:0x333333 alpha:1.0f];
        UITapGestureRecognizer *tapLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabelClick:)];
        textLabel.userInteractionEnabled = YES;
        tapLabel.numberOfTapsRequired = 1;
        tapLabel.delaysTouchesBegan = YES;
        [textLabel addGestureRecognizer:tapLabel];
        if (i == 7) {
            textLabel.newEnergy = YES;
            textLabel.canSubmit = YES;
        } else {
            textLabel.canSubmit = NO;
        }
        textLabel.delegate = (id <SMYPlateSingleInputLabelDelegate>)self;
        [self.labelArray addObject:textLabel];
        [self addSubview:textLabel];
    }
    CGRect rect = CGRectMake(width * 2 + space + leading, 0, separateWidth + space, height);
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"·";
    [self addSubview:label];
}

- (void)nextInputLabelFromInputLabel:(SMYPlateSingleInputLabel *)label {
    if (label.tag + 1 < self.labelArray.count) {
        self.lastLabel.layer.borderColor = [UIColor colorWithHex:0xe7e7e7 alpha:1.0f].CGColor;
        self.lastLabel = self.labelArray[label.tag + 1];
        [self.lastLabel becomeFirstResponder];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(plateInputView:textDidChange:)]) {
        NSMutableString *string = [NSMutableString stringWithString:@""];
        for (SMYPlateSingleInputLabel *label in self.labelArray) {
            if (label.text) {
                [string appendString:label.text];
            } else {
                break;
            }
        }
        [self.delegate plateInputView:self textDidChange:string];
    }
}

- (void)deleteCharactorAtInputLabel:(SMYPlateSingleInputLabel *)label {
    if (label.tag == self.labelArray.count - 1 && label.text.length) {
        label.text = @"";
    } else {
        if (label.tag - 1 >= 0 && label.tag - 1 < self.labelArray.count) {
            self.lastLabel.layer.borderColor = [UIColor colorWithHex:0xe7e7e7 alpha:1.0f].CGColor;
            self.lastLabel = self.labelArray[label.tag - 1];
            [self.lastLabel becomeFirstResponder];
        }
        self.lastLabel.text = @"";
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(plateInputView:textDidChange:)]) {
        NSMutableString *string = [NSMutableString stringWithString:@""];
        for (SMYPlateSingleInputLabel *label in self.labelArray) {
            if (label.text) {
                [string appendString:label.text];
            } else {
                break;
            }
        }
        [self.delegate plateInputView:self textDidChange:string];
    }
}

- (void)confirmButtonDidClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(plateInputView:textDidChange:)]) {
        NSMutableString *string = [NSMutableString stringWithString:@""];
        for (SMYPlateSingleInputLabel *label in self.labelArray) {
            if (label.text) {
                [string appendString:label.text];
            } else {
                break;
            }
        }
        [self.delegate plateInputView:self textInputDidEnd:string];
    }
}

#pragma mark - Action

- (void)tapLabelClick:(UITapGestureRecognizer *)tap {
    [self.lastLabel becomeFirstResponder];
}

#pragma mark - SMYPlateSingleInputLabelDelegate

- (void)didSelectedSingleInputLabel:(SMYPlateSingleInputLabel *)label buttonType:(SMYPlateInputButtonType)buttonType {
    if (SMYPlateInputButtonTypeDefault == buttonType) {
        [self nextInputLabelFromInputLabel:label];
    } else if (SMYPlateInputButtonTypeDelete == buttonType) {
        [self deleteCharactorAtInputLabel:label];
    } else {
        [self confirmButtonDidClick];
    }
}

#pragma mark - getters and setters

- (NSMutableArray *)labelArray {
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

@end
