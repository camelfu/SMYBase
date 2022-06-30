//
//  SMYAlertView.m
//  testConstraint
//
//  Created by jwter on 15/9/8.
//  Copyright (c) 2015年 smyfinancial. All rights reserved.
//

#import "SMYAlertView.h"
#import "UIColor+Custom.h"

#define kColorDefaultVI     [UIColor colorWithHex:0x12C963 alpha:1.0f]

@interface SMYAlertView ()

@property (nonatomic, strong) UIView *container;
@property (nonatomic, copy) void (^handlerBlock)(NSInteger buttonIndex);
@property (nonatomic, copy) BOOL (^buttonBlock)(NSInteger buttonIndex);
@property (nonatomic, strong)NSTimer *countDownTimer;
@property (nonatomic, strong) UIButton *buttonLast;
@property (nonatomic, strong) UIButton *buttonFirst;

@end

@implementation SMYAlertView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = (CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size};
        self.alpha = 1;
        [self setBackgroundColor:[UIColor colorWithHex:0x000000 alpha:0.5]];
        self.hidden = NO;// 不隐藏
        
        // 默认 17号 #333333
        self.titleFont = [UIFont boldSystemFontOfSize:17];
        self.titleColor = [UIColor colorWithHex:0x333333 alpha:1.0];
        // 默认 18号 #12C963
        self.buttonFont = [UIFont systemFontOfSize:18];
        self.buttonColor = kColorDefaultVI;
        self.lastButtonColor = kColorDefaultVI;
        self.countDownTitleColor = [UIColor colorWithHex:0xaaaaaa alpha:1.0];
        self.buttonHeight = 51;
        self.firstButtonColor = kColorDefaultVI;
        self.separatorLineColor = [UIColor colorWithHex:0xe7e7e7 alpha:1];

        // 默认14号
        self.messageFonts = [[NSMutableArray alloc]initWithObjects:
                             [UIFont systemFontOfSize:14], nil];
        
        // 默认#777777
        self.messageColors = [[NSMutableArray alloc]initWithObjects:
                              [UIColor colorWithHex:0x777777 alpha:1.0], nil];
        
        self.messageTextAlignment = NSTextAlignmentCenter;
        
        // 默认白色
        self.alertColor = [UIColor whiteColor];
        self.alertWidth = 280;
        
        self.topMargin = 20;
        self.messageMargin = 15;
        self.customViewMargin = 15;
        self.bottonMargin = 20;
        self.sideMargin = 32;
        
        self.container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.alertWidth, self.alertWidth)];
        [self.container.layer setMasksToBounds:YES];
        [self.container.layer setCornerRadius:5];
        [self addSubview:self.container];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘降下
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    return self;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
 
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{

        CGRect frame = self.container.frame;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat y = (height - frame.size.height - keyboardRect.size.height) /2;
       
        [self.container setFrame:CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height)];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        
        CGRect frame = self.container.frame;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat y = (height - frame.size.height) /2;
        [self.container setFrame:CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height)];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showTitle:(NSString *)title
         messages:(NSArray *)messages
     buttonTitles:(NSArray *)buttonTitles
     handlerBlock:(BOOL (^)(NSInteger))handler {
    [self showTitle:title messages:messages customView:nil buttonTitles:buttonTitles inView:nil handlerBlock:handler];
}

- (void)showTitle:(NSString *)title
         messages:(NSArray *)messages
     buttonTitles:(NSArray *)buttonTitles
           inView:(UIView *)inView
     handlerBlock:(BOOL (^)(NSInteger))handler {
    [self showTitle:title messages:messages customView:nil buttonTitles:buttonTitles inView:inView handlerBlock:handler];
}

- (void)showTitle:(NSString *)title
       customView:(UIView *)customView
     buttonTitles:(NSArray *)buttonTitles
     handlerBlock:(BOOL (^)(NSInteger))handler {
    [self showTitle:title messages:nil customView:customView buttonTitles:buttonTitles inView:nil handlerBlock:handler];
}

- (void)showTitle:(NSString *)title
       customView:(UIView *)customView
     buttonTitles:(NSArray *)buttonTitles
           inView:(UIView *)inView
     handlerBlock:(BOOL (^)(NSInteger))handler {
    [self showTitle:title messages:nil customView:customView buttonTitles:buttonTitles inView:inView handlerBlock:handler];
}

- (void)showTitle:(NSString *)title
         messages:(NSArray *)messages
       customView:(UIView *)customView
     buttonTitles:(NSArray *)buttonTitles
           inView:(UIView *)inView
     handlerBlock:(BOOL (^)(NSInteger buttonIndex))handlerBlock {
    [self showTitle:title messages:messages customViews:customView ? @[customView] : nil buttonTitles:buttonTitles
             inView:inView handlerBlock:handlerBlock];
}

- (void)showTitle:(NSString *)title
         messages:(NSArray *)messages
       customViews:(NSArray *)customViews
     buttonTitles:(NSArray *)buttonTitles
           inView:(UIView *)inView
     handlerBlock:(BOOL (^)(NSInteger buttonIndex))handlerBlock {
    if (self.isShowCloseBtn) {
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
        [self.container addSubview:closeBtn];
        [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    self.messages = messages;
    self.buttonTitles = buttonTitles;
    self.buttonBlock = handlerBlock;
    CGFloat top = self.topMargin;
    CGFloat textWidth = self.alertWidth - self.sideMargin * 2;
    self.container.backgroundColor = self.alertColor;
    
    // 添加标题
    if (title) {
        CGFloat height = [self boundingRect:title font:self.titleFont];
        UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(self.sideMargin, top, textWidth, height)];
        titlelabel.font = self.titleFont;
        titlelabel.textColor = self.titleColor;
        titlelabel.textAlignment = NSTextAlignmentCenter;
        titlelabel.text = title;
        titlelabel.numberOfLines = 0;
        [self.container addSubview:titlelabel];
        top += height;
    }
    
    // 添加消息文本
    for (int i=0; i<messages.count; i++) {
        top += self.messageMargin;
        
        UIFont * font = [UIFont systemFontOfSize:14];
        UIColor * color = [UIColor colorWithHex:0x777777 alpha:1.0];
        if (self.messageFonts.count > i) {
            font = [self.messageFonts objectAtIndex:i];
        }
        if (self.messageColors.count > i) {
            color = [self.messageColors objectAtIndex:i];
        }
        
        id message = [messages objectAtIndex:i];
        CGFloat height = 0;
        if ([message isKindOfClass:[NSMutableAttributedString class]]) {
            height = [self AttributedboundingRect:message];
        }
        else{
            height = [self boundingRect:message font:font];
        }
        
        UILabel * messagelabel = [[UILabel alloc]initWithFrame:CGRectMake(self.sideMargin, top, textWidth, height)];
        messagelabel.font = font;
        messagelabel.numberOfLines = 0;
        messagelabel.textColor = color;
        messagelabel.textAlignment = self.messageTextAlignment;
        if ([message isKindOfClass:[NSMutableAttributedString class]]) {
            messagelabel.attributedText = message;
        }
        else{
            messagelabel.text = message;
        }
        [self.container addSubview:messagelabel];
        top += height;
    }
    
    for (UIView *customView in customViews) {
        top += self.customViewMargin;
        CGFloat customHeight = customView.frame.size.height;
        // 添加自定义控件
        UIView * customContainer = [[UIView alloc]initWithFrame:CGRectMake(self.sideMargin, top, textWidth, customHeight)];
        [customContainer addSubview:customView];
        CGRect frame = customView.frame;
        frame.origin.x = (textWidth - frame.size.width) / 2;
        customView.frame = frame;
        // 外面加个容器,保证边距，不符合规则的显示截取
        [self.container addSubview:customContainer];
        top += customHeight;
    }
    
//    if (customView) {
//        top += self.customViewMargin;
//        CGFloat customHeight = customView.frame.size.height;
//        // 添加自定义控件
//        UIView * customContainer = [[UIView alloc]initWithFrame:CGRectMake(self.sideMargin, top, textWidth, customHeight)];
//        [customContainer addSubview:customView];
//        CGRect frame = customView.frame;
//        frame.origin.x = (textWidth - frame.size.width) / 2;
//        customView.frame = frame;
//        // 外面加个容器,保证边距，不符合规则的显示截取
//        [self.container addSubview:customContainer];
//        top += customHeight;
//    }
    
    top += self.bottonMargin;
    // 添加按钮
    if (buttonTitles.count == 0) {
        // 无自定义按钮，左上角添加关闭按钮
        UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        btnClose.tag = -1;
        [btnClose setFrame:CGRectMake(10, 10, 30, 30)];
        [btnClose setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [btnClose addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.container addSubview:btnClose];
    } else {
        // 有自定义按钮添加按钮区域分割线
        UIView *split = [[UIView alloc]initWithFrame:CGRectMake(0, top, self.alertWidth, 0.5)];
        split.backgroundColor = self.separatorLineColor;
        [self.container addSubview:split];
    }
    
    if (buttonTitles.count > 0 && buttonTitles.count < 3 && !self.forceDisplayButtonVertically) {
        for (int i = 0; i < buttonTitles.count; i++) {
            NSString * buttonTitle = [buttonTitles objectAtIndex:i];
            CGFloat width = self.alertWidth /buttonTitles.count;
            CGFloat x = i*width;
            UIButton * button =  [[UIButton alloc]initWithFrame:CGRectMake(x, top, width, self.buttonHeight)];
            [button setTitle:buttonTitle forState:UIControlStateNormal];
            // 最后一个按钮
            if (i == (buttonTitles.count-1)) {
                self.buttonLast = button;
                
                [button setTitleColor:self.lastButtonColor forState:UIControlStateNormal];
                if (self.buttonCountDownTime != 0 && SMYAlertCountDownLastButton == self.countDownType) {
                    [button setTitleColor:self.countDownTitleColor forState:UIControlStateNormal];
                    [button setTitle:[NSString stringWithFormat:@"%@(%is)",buttonTitle,self.buttonCountDownTime] forState:UIControlStateDisabled];
                    [button setEnabled:NO];
                    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownTimerInvoke)
                                                                         userInfo:nil repeats:YES];
                }
            } else if (i == 0) {
                self.buttonFirst = button;
                [button setTitleColor:self.firstButtonColor forState:UIControlStateNormal];
                if (0 != self.buttonCountDownTime && SMYAlertCountDownFirstButton == self.countDownType) {
                    [button setTitleColor:self.countDownTitleColor forState:UIControlStateNormal];
                    [button setTitle:[NSString stringWithFormat:@"%@(%is)",buttonTitle,self.buttonCountDownTime] forState:UIControlStateDisabled];
                    [button setEnabled:NO];
                    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownTimerInvoke)
                                                                         userInfo:nil repeats:YES];
                }
            } else {
                if (i == 1 && self.secondButtonColor) {
                    [button setTitleColor:self.secondButtonColor forState:UIControlStateNormal];
                } else {
                    [button setTitleColor:self.buttonColor forState:UIControlStateNormal];
                }
            }
            [button.titleLabel setFont:self.buttonFont];
            button.tag = i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.container addSubview:button];
            if (i > 0) {
                // 分割线
                UIView *split = [[UIView alloc]initWithFrame:CGRectMake(width, top, 0.5, self.buttonHeight)];
                split.backgroundColor = self.separatorLineColor;
                [self.container addSubview:split];
            }
        }
        
        top += self.buttonHeight;// button的高度
    } else {
        for (int i = 0; i<buttonTitles.count; i++) {
            NSString * buttonTitle = [buttonTitles objectAtIndex:i];
            
            UIButton * button =  [[UIButton alloc]initWithFrame:CGRectMake(0, top, self.alertWidth, self.buttonHeight)];
            [button setTitle:buttonTitle forState:UIControlStateNormal];
            if (i == (buttonTitles.count-1)) {
                [button setTitleColor:self.lastButtonColor forState:UIControlStateNormal];
                self.buttonLast = button;
                
                if (self.buttonCountDownTime != 0 && SMYAlertCountDownLastButton == self.countDownType) {
                    [button setTitleColor:self.countDownTitleColor forState:UIControlStateNormal];
                    [button setTitle:[NSString stringWithFormat:@"%@(%is)",buttonTitle,self.buttonCountDownTime] forState:UIControlStateDisabled];
                    [button setEnabled:NO];
                    
                    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownTimerInvoke) userInfo:nil repeats:YES];
                }
            } else if (i == 0) {
                self.buttonFirst = button;
                [button setTitleColor:self.firstButtonColor forState:UIControlStateNormal];
                if (0 != self.buttonCountDownTime && SMYAlertCountDownFirstButton == self.countDownType) {
                    [button setTitleColor:self.countDownTitleColor forState:UIControlStateNormal];
                    [button setTitle:[NSString stringWithFormat:@"%@(%is)",buttonTitle,self.buttonCountDownTime] forState:UIControlStateDisabled];
                    [button setEnabled:NO];
                    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownTimerInvoke)
                                                                         userInfo:nil repeats:YES];
                }
            } else {
                if (i == 1 && self.secondButtonColor) {
                    [button setTitleColor:self.secondButtonColor forState:UIControlStateNormal];
                } else {
                    [button setTitleColor:self.buttonColor forState:UIControlStateNormal];
                }
            }
            [button.titleLabel setFont:self.buttonFont];
            button.tag = i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.container addSubview:button];
            if (i > 0) {
                // 分割线
                UIView *split = [[UIView alloc]initWithFrame:CGRectMake(0, top, self.alertWidth, 0.5)];
                split.backgroundColor = self.separatorLineColor;
                [self.container addSubview:split];
            }
            top += self.buttonHeight;// button的高度
        }
    }
    if (!inView) {
        inView = [UIApplication sharedApplication].keyWindow;
    }
    CGFloat width = inView.bounds.size.width;
    CGFloat height = inView.bounds.size.height;
    CGFloat x = (width-self.alertWidth) /2;
    CGFloat y = 0;
    if (self.isShowInBottom) {
        y = inView.bounds.size.height - top;
    } else {
        y = (height - top) / 2;
    }
    [self.container setFrame:CGRectMake(x, y, self.alertWidth, top)];
    
    if (self.orientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.container.transform = CGAffineTransformMakeRotation(M_PI);
    }
    else if (self.orientation == UIInterfaceOrientationLandscapeLeft) {
        self.container.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    else if (self.orientation == UIInterfaceOrientationLandscapeRight) {
        self.container.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
    
    [inView addSubview:self];
    [self bringSubviewToFront:inView];
    
    self.container.transform = CGAffineTransformScale(self.container.transform,0.8f, 0.8f);
    self.container.layer.opacity = 0.01;
    [UIView animateWithDuration:0.1f animations:^{
        self.container.transform = CGAffineTransformScale(self.container.transform,1.0f/0.8, 1.0f/0.8);
        // CGAffineTransformIdentity;
        self.container.layer.opacity = 1.0;
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.completeBlock) {
                self.completeBlock();
            }
        }
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview && self.didDissappearWithoutUserClickHandler) {
        self.didDissappearWithoutUserClickHandler();
    }
}

- (void)hide {
    [self removeFromSuperview];
}

- (void)countDownTimerInvoke {
    self.buttonCountDownTime --;
    if (0 == self.buttonCountDownTime) {
        if (SMYAlertCountDownLastButton == self.countDownType) {
            [self.buttonLast setEnabled:YES];
            [self.buttonLast setTitleColor:self.lastButtonColor forState:UIControlStateNormal];
            [self.buttonLast setTitle:[self.buttonTitles lastObject] forState:UIControlStateNormal];
        } else {
            [self.buttonFirst setEnabled:YES];
            [self.buttonFirst setTitleColor:self.firstButtonColor forState:UIControlStateNormal];
            [self.buttonFirst setTitle:[self.buttonTitles firstObject] forState:UIControlStateNormal];
        }
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
    else {
        if (SMYAlertCountDownLastButton == self.countDownType) {
            NSString *title = [NSString stringWithFormat:@"%@(%is)", [self.buttonTitles lastObject], self.buttonCountDownTime];
            [self.buttonLast setTitle:title forState:UIControlStateDisabled];
        } else {
            NSString *title = [NSString stringWithFormat:@"%@(%is)", [self.buttonTitles firstObject], self.buttonCountDownTime];
            [self.buttonFirst setTitle:title forState:UIControlStateDisabled];
        }
    }
}

- (void)buttonClick:(id)sender {
    UIButton * button = (UIButton *)(sender);
    if (self.countDownTimer) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
//    if (self.handlerBlock) {
//        self.handlerBlock(button.tag);
//    }
    if (self.buttonBlock) {
        if (self.buttonBlock(button.tag)) {
            self.didDissappearWithoutUserClickHandler = nil;
            [UIView animateWithDuration:0.1 animations:^{
                self.container.layer.opacity = 0.01;
                self.layer.opacity = 0.01;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        }
    } else {
        self.didDissappearWithoutUserClickHandler = nil;
        [UIView animateWithDuration:0.1 animations:^{
            self.container.layer.opacity = 0.01;
            self.layer.opacity = 0.01;
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (CGFloat)boundingRect:(NSString *)text font:(UIFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(self.alertWidth-self.sideMargin*2, MAXFLOAT)
                                     options:option
                                  attributes:attributes
                                     context:nil];
    return rect.size.height;
}

- (CGFloat)AttributedboundingRect:(NSMutableAttributedString *)text {
    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(self.alertWidth-self.sideMargin*2, MAXFLOAT)
                                     options:option
                                     context:nil];
    return rect.size.height;
}

- (CGFloat)getCustomWidth {
    return self.alertWidth - self.sideMargin *2;
}

@end
