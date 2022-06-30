//
//  SMYPlateSingleInputLabel.m
//  SMYBusinessBase
//
//  Created by penggongxu on 2020/12/28.
//  Copyright © 2020 smyfinancial. All rights reserved.
//

#import "SMYPlateSingleInputLabel.h"
#import "SMYBase/SMYImageTool.h"

@interface SMYPlateSingleInputLabel ()

/** 英文数字键盘的确认按钮 */
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation SMYPlateSingleInputLabel

#pragma mark - Public Method

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.adjustsFontSizeToFitWidth = YES;
        self.textAlignment = NSTextAlignmentCenter;
        self.inputViewType = SMYPlateInputViewTypeChineseCharactor;
    }
    return self;
}

- (void)done {
    [self resignFirstResponder];
    self.layer.borderColor = [UIColor colorWithHex:0xe7e7e7 alpha:1.0f].CGColor;
}

- (BOOL)becomeFirstResponder {
    self.layer.borderColor = [UIColor colorWithHex:0x12C963 alpha:1.0f].CGColor;
    return [super becomeFirstResponder];
}

#pragma mark - Private Method

- (UIView *)inputView {
    if (!_inputView) {
        _inputView = [self inputViewWithType:self.inputViewType];
    }
    return _inputView;
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (UIView *)inputViewWithType:(SMYPlateInputViewType)type {
    switch (type) {
        case SMYPlateInputViewTypeChineseCharactor :
            return [self chineseCharactorKeyboardView];
            break;
        case SMYPlateInputViewTypeLetters :
            return [self lettersKeyboardView];
            break;
        default :
            return [self otherKeyboardView];
            break;
    }
}

/// 字母键盘
- (UIView *)lettersKeyboardView {
    return [self keyboardViewWithLettersType:YES];
}

/// 字母数字键盘
- (UIView *)otherKeyboardView {
    return [self keyboardViewWithLettersType:NO];
}

/// 省份键盘
- (UIView *)chineseCharactorKeyboardView {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat originX = 11;
    CGFloat originY = 10;
    CGFloat margin = 5;
    CGFloat buttonWidth = (screenWidth - 22 - 45) / 10;
    CGFloat buttonHeight = 50;
    UIView *bgView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 230)];
    bgView.backgroundColor = [UIColor colorWithHex:0xf5f6f6 alpha:1.0f];
    // 第一排10个
    NSArray *line1 = @[@"京", @"津", @"渝", @"沪", @"冀", @"晋", @"辽", @"吉", @"黑", @"苏"];
    for (int i = 0; i < line1.count; i++) {
        CGRect rect = CGRectMake(originX + (buttonWidth + margin) * i, originY, buttonWidth, buttonHeight);
        UIButton *button = [self buttonWithTitle:line1[i] frame:rect action:@selector(defaultButtonAction:)];
        [bgView addSubview:button];
    }
    // 第二排10个
    NSArray *line2 = @[@"浙", @"皖", @"闽", @"赣", @"鲁", @"豫", @"鄂", @"湘", @"粤", @"琼"];
    for (int i = 0; i < line2.count; i++) {
        CGRect rect = CGRectMake(originX + (buttonWidth + margin) * i, originY + buttonHeight + margin, buttonWidth, buttonHeight);
        UIButton *button = [self buttonWithTitle:line2[i] frame:rect action:@selector(defaultButtonAction:)];
        [bgView addSubview:button];
    }
    // 第三排10个
    NSArray *line3 = @[@"川", @"贵", @"云", @"陕", @"甘", @"青", @"蒙", @"桂", @"宁", @"新"];
    for (int i = 0; i < line3.count; i++) {
        CGRect rect = CGRectMake(originX + (buttonWidth + margin) * i, originY + (buttonHeight + margin) * 2, buttonWidth, buttonHeight);
        UIButton *button = [self buttonWithTitle:line3[i] frame:rect action:@selector(defaultButtonAction:)];
        [bgView addSubview:button];
    }
    // 第四排1个
    CGRect rect = CGRectMake(originX, originY + (buttonHeight + margin) * 3, buttonWidth, buttonHeight);
    UIButton *button = [self buttonWithTitle:@"藏" frame:rect action:@selector(defaultButtonAction:)];
    [bgView addSubview:button];
    // 删除
    buttonWidth = buttonWidth * 2 + margin;
    rect = CGRectMake(screenWidth - buttonWidth * 2 - margin -originX,
                              originY + (buttonHeight + margin) * 3 ,
                              buttonWidth, 50);
    UIButton *button1 = [self buttonWithTitle:@"" frame:rect action:@selector(deleteButtonAction:)];
    [button1 setImage:SMY_IMAGE(@"deletePlate") forState:UIControlStateNormal];
    [bgView addSubview:button1];
    // 确定
    rect = CGRectMake(screenWidth - buttonWidth - originX,
                       originY + (buttonHeight + margin) * 3 ,
                       buttonWidth, 50);
    UIButton *button2 = [self buttonWithTitle:@"确定" frame:rect action:@selector(confirmButtonAction:)];
    [button2 setTitleColor:[UIColor colorWithHex:0xe7e7e7 alpha:1.0f] forState:UIControlStateDisabled];
    [button2 setBackgroundImage:[SMYImageTool createImageWithColor:[UIColor colorWithHex:0x999999 alpha:1.0f]] forState:UIControlStateDisabled];
    button2.enabled = NO;
    [bgView addSubview:button2];
    return bgView;
}

- (UIView *)keyboardViewWithLettersType:(BOOL)lettersType {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat originX = 11;
    CGFloat originY = 10;
    CGFloat margin = 5;
    CGFloat buttonWidth = (screenWidth - 22 - 45) / 10;
    CGFloat buttonHeight = 50;
    UIView *bgView = [[UIView  alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 230)];
    bgView.backgroundColor = [UIColor colorWithHex:0xeeeeee alpha:1.0f];
    // 第一排10个
    NSArray *line1 = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0"];
    for (int i = 0; i < line1.count; i++) {
        CGRect rect = CGRectMake(originX + (buttonWidth + margin) * i, originY, buttonWidth, buttonHeight);
        UIButton *button = [self buttonWithTitle:line1[i] frame:rect action:@selector(defaultButtonAction:)];
        if (lettersType) {
            button.enabled = NO;
        }
        [bgView addSubview:button];
    }
    // 第二排10个
    NSArray *line2 = @[@"Q", @"W", @"E", @"R", @"T", @"Y", @"U", @"I", @"O", @"P"];
    for (int i = 0; i < line2.count; i++) {
        CGRect rect = CGRectMake(originX + (buttonWidth + margin) * i, originY + buttonHeight + margin, buttonWidth, buttonHeight);
        UIButton *button = [self buttonWithTitle:line2[i] frame:rect action:@selector(defaultButtonAction:)];
        if ([line2[i] isEqualToString:@"O"] || [line2[i] isEqualToString:@"I"] ) {
            button.enabled = NO;
        }
        [bgView addSubview:button];
    }
    // 第三排10个
    NSArray *line3 = @[@"A", @"S", @"D", @"F", @"G", @"H", @"J", @"K", @"L", @"M"];
    for (int i = 0; i < line3.count; i++) {
        CGRect rect = CGRectMake(originX + (buttonWidth + margin) * i,
                                 originY + (buttonHeight + margin) * 2,
                                 buttonWidth,
                                 buttonHeight);
        UIButton *button = [self buttonWithTitle:line3[i] frame:rect action:@selector(defaultButtonAction:)];
        [bgView addSubview:button];
    }
    // 第四排6个
    NSArray *line4 = @[@"Z", @"X", @"C", @"V", @"B", @"N"];
    for (int i = 0; i < line4.count; i++) {
        CGRect rect = CGRectMake(originX + (buttonWidth + margin) * i, originY + (buttonHeight + margin) * 3, buttonWidth, buttonHeight);
        UIButton *button = [self buttonWithTitle:line4[i] frame:rect action:@selector(defaultButtonAction:)];
        [bgView addSubview:button];
    }
    buttonWidth = buttonWidth * 2 + margin;
    // 删除
    CGRect rect = CGRectMake(screenWidth - buttonWidth * 2 - margin -originX,
                              originY + (buttonHeight + margin) * 3 ,
                              buttonWidth, 50);
    UIButton *button1 = [self buttonWithTitle:@"" frame:rect action:@selector(deleteButtonAction:)];
    [button1 setImage:SMY_IMAGE(@"deletePlate") forState:UIControlStateNormal];
    [bgView addSubview:button1];
    // 确定
    rect = CGRectMake(screenWidth - buttonWidth - originX,
                       originY + (buttonHeight + margin) * 3 ,
                       buttonWidth, 50);
    UIButton *button2 = [self buttonWithTitle:@"确定" frame:rect action:@selector(confirmButtonAction:)];
    [button2 setTitleColor:[UIColor colorWithHex:0xe7e7e7 alpha:1.0f] forState:UIControlStateDisabled];
    [button2 setBackgroundImage:[SMYImageTool createImageWithColor:[UIColor colorWithHex:0x999999 alpha:1.0f]] forState:UIControlStateDisabled];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 setBackgroundImage:[SMYImageTool createImageWithColor:[UIColor colorWithHex:0x12C963 alpha:1.0f]] forState:UIControlStateNormal];
    button2.enabled = self.canSubmit;
    [bgView addSubview:button2];
    return bgView;
}

/// 创建按钮
- (UIButton *)buttonWithTitle:(NSString *)title frame:(CGRect)frame action:(SEL)action {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor colorWithHex:0xe7e7e7 alpha:1.0f] forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor colorWithHex:0x333333 alpha:1.0f] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 2;
    button.backgroundColor = [UIColor whiteColor];
    button.clipsToBounds = YES;
    return button;
}

#pragma mark - Action

- (void)defaultButtonAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedSingleInputLabel:buttonType:)]) {
        self.text = button.titleLabel.text;
        [self.delegate didSelectedSingleInputLabel:self buttonType:SMYPlateInputButtonTypeDefault];
    }
}

- (void)deleteButtonAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedSingleInputLabel:buttonType:)]) {
        [self.delegate didSelectedSingleInputLabel:self buttonType:SMYPlateInputButtonTypeDelete];
    }
}

- (void)confirmButtonAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedSingleInputLabel:buttonType:)]) {
        [self.delegate didSelectedSingleInputLabel:self buttonType:SMYPlateInputButtonTypeConfirm];
    }
}

#pragma mark - setters and getters

- (void)setText:(NSString *)text {
    if (self.isNewEnergy && !text.length) {
        text = @" 新能源 ";
        self.textColor = [UIColor colorWithHex:0x999999 alpha:1.0f];
    } else {
        self.textColor = [UIColor colorWithHex:0x333333 alpha:1.0f];
    }
    [super setText:text];
}

- (NSString *)text {
    NSString *text = [super text];
    if ([text isEqualToString:@" 新能源 "]) {
        text = @"";
    }
    return text;
}

- (void)setNewEnergy:(BOOL)newEnergy {
    _newEnergy = newEnergy;
    [self setText:@""];
}

@end
