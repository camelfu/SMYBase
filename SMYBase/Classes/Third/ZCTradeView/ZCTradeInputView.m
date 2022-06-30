//
//  ZCTradeInputView.m
//  直销银行
//
//  Created by 塔利班 on 15/4/30.
//  Copyright (c) 2015年 联创智融. All rights reserved.
//

// 快速生成颜色
#define ZCColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

typedef enum {
    ZCTradeInputViewButtonTypeWithCancle = 10000,
    ZCTradeInputViewButtonTypeWithOk = 20000,
}ZCTradeInputViewButtonType;

#import "ZCTradeInputView.h"
#import "NSString+Extension.h"

@interface ZCTradeInputView ()
/** 数字数组 */
@property (nonatomic, strong) NSMutableArray *nums;
/** 确定按钮 */
@property (nonatomic, weak) UIButton *okBtn;
/** 取消按钮 */
@property (nonatomic, weak) UIButton *cancelBtn;
/** 忘记密码按钮 */
@property (nonatomic, weak) UIButton *forgetPassword;

@end

@implementation ZCTradeInputView

#pragma mark - Public

- (void)clearInput {
    [self.nums removeAllObjects];
    [self setNeedsDisplay];
}

#pragma mark - LazyLoad

- (NSMutableArray *)nums
{
    if (_nums == nil) {
        _nums = [NSMutableArray array];
    }
    return _nums;
}

#pragma mark - LifeCircle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        /** 注册keyboard通知 */
        [self setupKeyboardNote];
        /** 添加子控件 */
        [self setupSubViews];
    }
    return self;
}

/** 添加子控件 */
- (void)setupSubViews
{
    /** 取消按钮 */
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cancelBtn];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    self.cancelBtn = cancelBtn;
    [self.cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelBtn.tag = ZCTradeInputViewButtonTypeWithCancle;
    
    UIButton *forgetPassword = [UIButton buttonWithType:UIButtonTypeSystem];
    [forgetPassword.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [forgetPassword setTitleColor:[UIColor colorWithHex:0x6189ab alpha:1.0f] forState:UIControlStateNormal];
    [forgetPassword setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [self addSubview:forgetPassword];
    self.forgetPassword = forgetPassword;
    [self.forgetPassword addTarget:self action:@selector(btnForgetPasswordClicked) forControlEvents:UIControlEventTouchUpInside];
}

/** 注册keyboard通知 */
- (void)setupKeyboardNote
{
    // 删除通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delete) name:ZCTradeKeyboardDeleteButtonClick object:nil];
    
    // 数字通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(number:) name:ZCTradeKeyboardNumberButtonClick object:nil];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.cancelBtn.zc_width = 20;
    self.cancelBtn.zc_height = 20;
    self.cancelBtn.x = 12;
    self.cancelBtn.y = 12;
    
    self.forgetPassword.zc_width = 80;
    self.forgetPassword.zc_height = 25;
    self.forgetPassword.x = self.frame.size.width - 100;
}

#pragma mark - Private

// 删除
- (void)delete
{
    [self.nums removeLastObject];
    
//    NSLog(@"delete nums %@ ",self.nums);

    [self setNeedsDisplay];
}

// 数字
- (void)number:(NSNotification *)note
{
    NSDictionary *userInfo = note.userInfo;
    NSString *numObj = userInfo[ZCTradeKeyboardNumberKey];
    [self.nums addObject:numObj];
    if ([self.nums count] > ZCTradeInputViewNumCount)
        return;
    [self setNeedsDisplay];
}

// 按钮点击
- (void)btnClick:(UIButton *)btn
{
    if (btn.tag == ZCTradeInputViewButtonTypeWithCancle) {  // 取消按钮点击
        if ([self.delegate respondsToSelector:@selector(tradeInputView:cancleBtnClick:)]) {
            [self.delegate tradeInputView:self cancleBtnClick:btn];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:ZCTradeInputViewCancleButtonClick object:self];
    }
}

/**
 *  忘记密码点击
 */
- (void)btnForgetPasswordClicked {
    [[NSNotificationCenter defaultCenter] postNotificationName:ZCTradeInputViewForgetPasswordClick object:self];
}

- (UIImage*)createImageWithColor:(UIColor*)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)drawRect:(CGRect)rect
{
    // 画图
    UIImage *bg = [self createImageWithColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
    UIImage *field = [UIImage imageNamed:@"trade.bundle/password_in"];
    
    [bg drawInRect:rect];
    
    CGFloat x = ZCScreenWidth * 0.11 * 0.5;
    CGFloat y = ZCScreenWidth * 0.40625 * 0.5;
    CGFloat w = ZCScreenWidth * 0.71;;
    CGFloat h = ZCScreenWidth * 0.121875;
    [field drawInRect:CGRectMake(x, y, w, h)];
    self.forgetPassword.y = y+h+10;
    
    // 画字
    NSString *title = @"请输入省呗交易密码";
    
    //CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:ZCScreenWidth * 0.053125] andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:17.0] andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat titleW = size.width;
    CGFloat titleH = size.height;
    CGFloat titleX = (self.zc_width - titleW) * 0.5;
    CGFloat titleY = ZCScreenWidth * 0.05;
    CGRect titleRect = CGRectMake(titleX, titleY, titleW, titleH);
    
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
//    attr[NSFontAttributeName] = [UIFont systemFontOfSize:ZCScreenWidth * 0.053125];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:17.0];
    attr[NSForegroundColorAttributeName] = ZCColor(51, 51, 51);
    
    [title drawInRect:titleRect withAttributes:attr];
    
    // 画点
    UIImage *pointImage = [UIImage imageNamed:@"trade.bundle/yuan"];
    CGFloat pointW = ZCScreenWidth * 0.03;
    CGFloat pointH = pointW;
    CGFloat pointY = ZCScreenWidth * 0.25;
    CGFloat pointX;
    CGFloat margin = ZCScreenWidth * 0.054;
    CGFloat padding = ZCScreenWidth * 0.0445;
    for (int i = 0; i < self.nums.count; i++) {
        pointX = margin + padding + i * (pointW + 2 * padding);
        [pointImage drawInRect:CGRectMake(pointX, pointY, pointW, pointH)];
    }
    
    // ok按钮状态
    BOOL statue = NO;
    if (self.nums.count == ZCTradeInputViewNumCount) {
        statue = YES;
    } else {
        statue = NO;
    }
    self.okBtn.enabled = statue;
    
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:5.0f];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
