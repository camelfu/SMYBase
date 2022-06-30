//
//  SMYTextField.m
//  SMYBase
//
//  Created by ChenYong on 2021/7/15.
//  Copyright © 2021 smyfinancial. All rights reserved.
//

#import "SMYTextField.h"

/// NSTextField的虚拟代理类
@interface NSTextFieldDelegateProxy : NSObject <UITextFieldDelegate>

// 真实代理
@property (nonatomic, weak) id<UITextFieldDelegate> realDelegate;

@end

// 要实现UITextFieldDelegate的所有代理方法，并最终将代理方法转给真实的代理对象
@implementation NSTextFieldDelegateProxy

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.realDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.realDelegate textFieldShouldBeginEditing:textField];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.realDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        return [self.realDelegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([self.realDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.realDelegate textFieldShouldEndEditing:textField];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isKindOfClass:[SMYTextField class]]) {
        [(SMYTextField *)textField didEndEditing];
    }
    if ([self.realDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        return [self.realDelegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isKindOfClass:[SMYTextField class]] &&
        ![(SMYTextField *)textField shouldChangeCharactersInRange:range replacementString:string]) {
        return NO;
    }
    if ([self.realDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.realDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if (@available(iOS 13, *)) {
        if ([self.realDelegate respondsToSelector:@selector(textFieldDidChangeSelection:)]) {
            return [self.realDelegate textFieldDidChangeSelection:textField];
        }
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if ([self.realDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [self.realDelegate textFieldShouldClear:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.realDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.realDelegate textFieldShouldReturn:textField];
    }
    return YES;
}

@end


@interface SMYTextField ()

// 虚拟代理
@property (nonatomic, strong) NSTextFieldDelegateProxy *proxyDelegate;

@end


@implementation SMYTextField

- (instancetype)init {
    if (self = [super init]) {
        [self initSettings];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSettings];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self initSettings];
    }
    return self;
}

- (void)initSettings {
    self.maxLength = NSUIntegerMax;
    self.proxyDelegate = [NSTextFieldDelegateProxy new];
    [super setDelegate:self.proxyDelegate];
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate {
    self.proxyDelegate.realDelegate = delegate;
}

- (void)didEndEditing {
}

- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *originString = self.text;// 当前的文本
    // 获取有效的替换文本
    NSUInteger dMaxReplaceLength = self.maxLength - (originString.length - range.length);// 替换文本的最大长度
    NSUInteger dReplaceLength = 0;// 替换文本的长度
    NSMutableString *strReplaced = [NSMutableString string];
    NSUInteger i = self.validateCharacterSet != nil ? [string rangeOfCharacterFromSet:self.validateCharacterSet].location : 0;
    for (; i < string.length && dReplaceLength < dMaxReplaceLength; i++) {
        if (self.validateCharacterSet && ![self.validateCharacterSet characterIsMember:[string characterAtIndex:i]]) {
            continue;// 非有效字符，过滤掉
        }
        [strReplaced appendString:[string substringWithRange:NSMakeRange(i, 1)]];
        dReplaceLength++;
    }
    if (strReplaced.length < 1 && range.length < 1) {
        return NO;
    }
    if ([string isEqualToString:strReplaced]) {
        return YES;
    }
    self.text = [originString stringByReplacingCharactersInRange:range withString:strReplaced];
    // 调整光标位置
    NSUInteger pos = range.location + strReplaced.length;
    dispatch_async(dispatch_get_main_queue(), ^{
        UITextPosition *position = [self positionFromPosition:self.beginningOfDocument offset:pos];
        self.selectedTextRange = [self textRangeFromPosition:position toPosition:position];
    });
    return NO;
}

@end


@implementation SMYVerifyCodeTextField

- (void)initSettings {
    [super initSettings];
    self.maxLength = 8;
    self.validateCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
}

@end


@implementation SMYIDNumberTextField

- (void)initSettings {
    [super initSettings];
    self.maxLength = 18;
    self.validateCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789Xx"];
}

- (void)didEndEditing {
    self.text = self.text.uppercaseString;
}

@end

@implementation SMYPhoneNumberTextField

- (void)initSettings {
    [super initSettings];
    self.maxLength = 11;
    self.validateCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
}

@end

