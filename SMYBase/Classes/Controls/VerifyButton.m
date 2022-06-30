//
//  VerifyButton.m
//  credit
//
//  Created by jwter on 15/7/22.
//  Copyright (c) 2015年 smyfinancial. All rights reserved.
//

#import "VerifyButton.h"
#import "UIColor+Custom.h"

#define kColorDefaultVI     [UIColor colorWithHex:0x12C963 alpha:1.0f]

@interface VerifyButton ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIColor *tempBackground;
@property (nonatomic, strong) NSTimer *verfyTimer;
@property (nonatomic, assign) int tempCounter;

@end

@implementation VerifyButton

// 保持倒计时的标记
static NSMutableDictionary * holdTagDic;

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self load];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
         [self load];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self load];
    }
    return self;
}

- (void)load {
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, 48)];
    self.lineView.backgroundColor = [UIColor colorWithHex:0xd8d8d8 alpha:1];
    [self addSubview:self.lineView];
    
    self.cornerRadius = 0;
    self.counter = 61;
    self.title = @"获取验证码";
    self.counterTitleFormat = @"(%d)重获验证码";
    self.titleFont = [UIFont systemFontOfSize:14.0f];
    self.tintColor = kColorDefaultVI;
    self.counterTintColor = [UIColor colorWithHex:0xaaaaaa alpha:1];
    self.counterBackgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];

    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.label.numberOfLines = 0;
    self.label.textAlignment = NSTextAlignmentCenter;
    
    self.label.text = self.title;
    self.label.font = self.titleFont;
    self.label.textColor = kColorDefaultVI;
    [self addSubview:self.label];
    
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:self.cornerRadius];
 
    [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setHoldTag:(NSString *)holdTag {
    _holdTag = holdTag;
    
    if (holdTagDic == nil) {
        holdTagDic = [[NSMutableDictionary alloc]init];
    }
    if ([holdTagDic objectForKey:holdTag]) {
        NSDate * date = [holdTagDic objectForKey:holdTag];
        int counter = [NSDate date].timeIntervalSince1970 - date.timeIntervalSince1970;
        if (self.counter - counter > 0) {
            [self counterState];
            self.tempCounter = self.counter - counter;
            [self onlystartCounter];
        }
    }
}

- (void)setRegistered:(BOOL)registered {
    _registered = registered;
    if (_registered) {
        [self.lineView removeFromSuperview];
        self.tintColor = [UIColor colorWithHex:0x2cc958 alpha:0.8];
        self.label.textColor = self.tintColor;
        self.label.textAlignment = NSTextAlignmentRight;
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.label.text = title;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.label.font = _titleFont;
}

- (void)setCornerRadius:(double)cornerRadius {
    _cornerRadius = cornerRadius;
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:_cornerRadius];
}

- (void)setCounterTintColor:(UIColor *)counterTintColor {
    _counterTintColor = counterTintColor;
}

- (void)setIsVerifyGeting:(BOOL)isVerifyGeting {
    _isVerifyGeting = isVerifyGeting;
    if (_isVerifyGeting) {
        self.label.text = @"获取中...";
        [self setEnabled:NO];
    } else {
        self.label.text = @"获取验证码";
        [self setEnabled:YES];
    }
}

- (BOOL)isCounterGoingOn {
    return self.verfyTimer && self.verfyTimer.isValid;
}

- (void)click {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.3;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(verifyButtonClick:)])
            {
                [self.delegate verifyButtonClick:self];
            }
        }];
    }];
}

- (void)onlystartCounter {
    if (self.verfyTimer) {
        [self.verfyTimer invalidate];
    }
    self.verfyTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    [self timerAction];
}

- (void)startCounter {
    [self counterState];
    // 记录开始倒计时的时间点
    if (self.holdTag) {
        NSDate * date = [holdTagDic objectForKey:self.holdTag];
        if (date) {
            int counter = [NSDate date].timeIntervalSince1970 - date.timeIntervalSince1970;
            if (self.counter - counter > 0) {
                self.tempCounter = self.counter - counter;
            }
            else{
                [holdTagDic setObject:[NSDate date] forKey:self.holdTag];
            }
        }
        else {
            [holdTagDic setObject:[NSDate date] forKey:self.holdTag];
        }
    }
    [self onlystartCounter];
}

- (void)restartCounter {
    if (self.holdTag) {
        [holdTagDic removeObjectForKey:self.holdTag];
    }
    [self startCounter];
}

- (void)continueCounter {
    [self counterState];
    // 记录开始倒计时的时间点
    if (self.holdTag) {
        NSDate * date = [holdTagDic objectForKey:self.holdTag];
        if (date) {
            int counter = [NSDate date].timeIntervalSince1970 - date.timeIntervalSince1970;
            if (self.counter - counter > 0) {
                self.tempCounter = self.counter - counter;
            } else {
                [self stopCounter];
                return;
            }
        }
        else {
            [holdTagDic setObject:[NSDate date] forKey:self.holdTag];
        }
    }
    [self onlystartCounter];
}

- (void)stopCounter {
    [self normalState];
    [self.verfyTimer invalidate];
}

- (void)normalState {
    self.tempCounter = self.counter;
    self.userInteractionEnabled = YES;
    self.backgroundColor = _tempBackground;
    self.label.text = self.title;
    self.label.textColor = self.tintColor;
}

- (void)counterState {
    self.tempCounter = self.counter;
    self.userInteractionEnabled = NO;
    self.tempBackground = self.backgroundColor;
    self.backgroundColor = self.counterBackgroundColor;
    self.label.textColor = self.counterTintColor;
}

- (void)dealloc {
    [self.verfyTimer invalidate];
}

- (void)timerAction {
    self.tempCounter --;
    if (self.tempCounter == 0) {
        [self normalState];
        [self.verfyTimer invalidate];
    } else {
        NSString * titlestr = [NSString stringWithFormat:self.counterTitleFormat, self.tempCounter];
        self.label.text = titlestr;
    } 
}

- (void)setLeftLineHeight:(CGFloat)height {
    if (height < 0) {
        return;
    }
    CGRect frame = self.bounds;
    frame.origin.y = (frame.size.height - height) / 2;
    frame.size = CGSizeMake(0.5, height);
    self.lineView.frame = frame;
}

@end
