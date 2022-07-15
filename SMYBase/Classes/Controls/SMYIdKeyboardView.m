//
//  SMYIdKeyboardView.m
//  SMYBusinessBase
//
//  Created by penggongxu on 2021/3/3.
//  Copyright © 2021 smyfinancial. All rights reserved.
//

#import "SMYIdKeyboardView.h"
#import "UIColor+Custom.h"
#import "UIResponder+SMY.h"
#import "UtilityMacro.h"

#define KeyboardNumericKeyWidth ([[UIScreen mainScreen] bounds].size.width) / 3.0
#define KeyboardNumericKeyHeight 54

@interface SMYIdKeyboardView ()

/// 输入完成按钮
@property (nonatomic, strong) UIButton *finishButton;

@end

@implementation SMYIdKeyboardView

+ (instancetype)keyboardView {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 255 + (kIsFullscreen ? 34 : 0))];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHex:0x525252 alpha:1.0f];
        CGFloat topButtonOriginY = 40;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 11, 17, 19)];
        imageView.image = SMY_IMAGE(@"keyicon");
        [self addSubview:imageView];
        
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 6, 5, 100, 30)];
        titleLable.text = @"省呗安全键盘";
        titleLable.textColor = [UIColor colorWithHex:0xaaaaaa alpha:1.0f];
        titleLable.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:titleLable];

        self.finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.finishButton.frame = CGRectMake(kWindowWidth - 70, 0, 70, topButtonOriginY);
        self.finishButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [self.finishButton setTitleColor:[UIColor colorWithHex:0x12C963 alpha:1.0f] forState:UIControlStateNormal];
        [self.finishButton setTitleColor:[UIColor colorWithHex:0xffffff alpha:1.0f] forState:UIControlStateHighlighted];
        [self.finishButton addTarget:self action:@selector(finishButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.finishButton];
        
        [self addSubview:[self addNumericKeyWithTitle:@"1" frame:CGRectMake(0, topButtonOriginY, KeyboardNumericKeyWidth, KeyboardNumericKeyHeight)]];
        [self addSubview:[self addNumericKeyWithTitle:@"2" frame:CGRectMake(KeyboardNumericKeyWidth, topButtonOriginY,
                                                                            KeyboardNumericKeyWidth, KeyboardNumericKeyHeight)]];
        [self addSubview:[self addNumericKeyWithTitle:@"3" frame:CGRectMake(KeyboardNumericKeyWidth * 2, topButtonOriginY,
                                                                            KeyboardNumericKeyWidth, KeyboardNumericKeyHeight)]];
        [self addSubview:[self addNumericKeyWithTitle:@"4" frame:CGRectMake(0, KeyboardNumericKeyHeight + topButtonOriginY,
                                                                            KeyboardNumericKeyWidth, KeyboardNumericKeyHeight)]];
        [self addSubview:[self addNumericKeyWithTitle:@"5" frame:CGRectMake(KeyboardNumericKeyWidth, KeyboardNumericKeyHeight + topButtonOriginY,
                                                                            KeyboardNumericKeyWidth, KeyboardNumericKeyHeight)]];
        [self addSubview:[self addNumericKeyWithTitle:@"6" frame:CGRectMake(KeyboardNumericKeyWidth * 2, KeyboardNumericKeyHeight + topButtonOriginY,
                                                                            KeyboardNumericKeyWidth, KeyboardNumericKeyHeight)]];
        [self addSubview:[self addNumericKeyWithTitle:@"7" frame:CGRectMake(0, KeyboardNumericKeyHeight * 2 + topButtonOriginY,
                                                                            KeyboardNumericKeyWidth, KeyboardNumericKeyHeight)]];
        [self addSubview:[self addNumericKeyWithTitle:@"8" frame:CGRectMake(KeyboardNumericKeyWidth, KeyboardNumericKeyHeight * 2 + topButtonOriginY,
                                                                            KeyboardNumericKeyWidth, KeyboardNumericKeyHeight)]];
        [self addSubview:[self addNumericKeyWithTitle:@"9" frame:CGRectMake(KeyboardNumericKeyWidth * 2, KeyboardNumericKeyHeight * 2 + topButtonOriginY,
                                                                            KeyboardNumericKeyWidth, KeyboardNumericKeyHeight)]];
        [self addSubview:[self addNumericKeyWithTitle:@"X" frame:CGRectMake(0, KeyboardNumericKeyHeight * 3 + topButtonOriginY,
                                                                            KeyboardNumericKeyWidth, KeyboardNumericKeyHeight)]];
        [self addSubview:[self addNumericKeyWithTitle:@"0" frame:CGRectMake(KeyboardNumericKeyWidth, KeyboardNumericKeyHeight * 3 + topButtonOriginY,
                                                                            KeyboardNumericKeyWidth, KeyboardNumericKeyHeight)]];
        [self addSubview:[self addBackspaceKeyWithFrame:CGRectMake(KeyboardNumericKeyWidth * 2, KeyboardNumericKeyHeight * 3 + topButtonOriginY,
                                                                   KeyboardNumericKeyWidth, KeyboardNumericKeyHeight)]];
        
        for (int i = 0; i < 4; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, KeyboardNumericKeyHeight * i + topButtonOriginY, kWindowWidth, 0.5)];
            view.backgroundColor = [UIColor colorWithHex:0x3d3d3d alpha:1.0f];
            [self addSubview:view];
        }
        for (int i = 0; i < 2; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(KeyboardNumericKeyWidth * i + KeyboardNumericKeyWidth, topButtonOriginY, 0.5, 216)];
            view.backgroundColor = [UIColor colorWithHex:0x3d3d3d alpha:1.0f];
            [self addSubview:view];
        }
    }
    return self;
}

#pragma mark - Private Method

/// 添加数字和X
- (UIButton *)addNumericKeyWithTitle:(NSString *)title frame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:27.0f]];
    [button setBackgroundColor:[UIColor colorWithHex:0x525252 alpha:1.0f]];
    [button setTitleColor:[UIColor colorWithHex:0xffffff alpha:1.0f] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHex:0xffffff alpha:1.0f] forState:UIControlStateHighlighted];
    [button setBackgroundImage:SMY_IMAGE(@"keyHighlighted") forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(numberButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

/// 添加删除按钮
- (UIButton *)addBackspaceKeyWithFrame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundColor:[UIColor colorWithHex:0x888888 alpha:1.0f]];
    [button setImage:SMY_IMAGE(@"keydelete") forState:UIControlStateNormal];
    button.adjustsImageWhenHighlighted = NO;
    [button setImage:SMY_IMAGE(@"keydelete") forState:UIControlStateHighlighted];
    [button setBackgroundImage:SMY_IMAGE(@"keyHighlighted") forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(deleteButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - Action

- (void)finishButtonDidClick {
    UIResponder *responder = [UIResponder currentFirstResponder];
    [responder resignFirstResponder];
}

/// 删除按钮点击
- (void)deleteButtonDidClick {
    UITextField *textField = (UITextField *)[UIResponder currentFirstResponder];
    if (![textField isKindOfClass:[UITextField class]]) {
        return;
    }
    if (textField.text.length < 1) {
        return;
    }
    // 不能中断UITextField的delegate的处理逻辑，因此主动询问delegate
    if ([textField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        //开始位置
        UITextPosition *beginning = textField.beginningOfDocument;
        //光标选择区域
        UITextRange *selectedRange = textField.selectedTextRange;
        //选择的实际位置
        const NSInteger location = [textField offsetFromPosition:beginning toPosition:selectedRange.start];
        //选择的长度
        const NSInteger length = [textField offsetFromPosition:selectedRange.start toPosition:selectedRange.end];
        NSRange range = NSMakeRange(location, length);
        if (range.length < 1 && range.location > 0) {
            // 因为是向前删除，因此没有选中任何文本时，删除前一个字符
            range.location -= 1;
            range.length = 1;
        }
        if (![textField.delegate textField:textField shouldChangeCharactersInRange:range replacementString:@""]) {
            return;
        }
    }
    [textField deleteBackward];
}

/// 身份证输入按钮点击
- (void)numberButtonDidClick:(UIButton *)button {
    UITextField *textField = (UITextField *)[UIResponder currentFirstResponder];
    if (![textField isKindOfClass:[UITextField class]]) {
        return;
    }
    NSString *strInput = button.titleLabel.text;
    // 不能中断UITextField的delegate的处理逻辑，因此主动询问delegate
    if ([textField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        //开始位置
        UITextPosition *beginning = textField.beginningOfDocument;
        //光标选择区域
        UITextRange *selectedRange = textField.selectedTextRange;
        //选择的实际位置
        const NSInteger location = [textField offsetFromPosition:beginning toPosition:selectedRange.start];
        //选择的长度
        const NSInteger length = [textField offsetFromPosition:selectedRange.start toPosition:selectedRange.end];
        NSRange range = NSMakeRange(location, length);
        if (![textField.delegate textField:textField shouldChangeCharactersInRange:range replacementString:strInput]) {
            return;
        }
    }
    [textField insertText:strInput];
}

@end
