//
//  SMYPlateView.m
//  SMYBusinessBase
//
//  Created by penggongxu on 2020/12/29.
//  Copyright © 2020 smyfinancial. All rights reserved.
//

#import "SMYPlateView.h"
#import "SMYPlateInputView.h"

@interface SMYPlateView () 

/** 背景 */
@property (nonatomic, strong) UIView *backgroundView;
/** title */
@property (nonatomic, strong) UILabel *titleLabel;
/** 内容视图 */
@property (nonatomic, strong) UIView *contentView;
/** 车牌输入框 */
@property (nonatomic, strong) SMYPlateInputView *plateInputView;
/** 车牌 */
@property (nonatomic, copy) NSString *plateNum;
/** 标题 */
@property (nonatomic, strong) NSString *title;

@end

@implementation SMYPlateView

#pragma mark - Public Method

+ (instancetype)initWithTitle:(nullable NSString *)title {
    SMYPlateView *inputView = [[self alloc] init];
    inputView.title = title;
    return inputView;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}

- (void)show {
    [self removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.alpha = 1;
        self.contentView.frame = CGRectMake(0, kWindowHeight - 380, kWindowWidth, 380);
        [self.plateInputView activeInput];
    } completion:nil];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        [self.plateInputView resignInput];
        self.backgroundView.alpha = 0.001;
        self.contentView.frame = CGRectMake(0, kWindowHeight, kWindowWidth, 380);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)setNum:(NSString *)plateNum {
    self.plateNum = plateNum;
    [self.plateInputView setPlateNum:plateNum];
}

#pragma mark - Private Method

- (void)setupUI {
    self.frame = CGRectMake(0, 0, kWindowWidth, kWindowHeight);
    // 背景
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
    self.backgroundView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.6];
    [self addSubview:self.backgroundView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.backgroundView addGestureRecognizer:tap];
    // 内容视图
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight, kWindowWidth, kIsFullscreen ? 415 : 380)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    // title
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kWindowWidth - 250) * 0.5, 20, 250, 20)];
    self.titleLabel.textColor = [UIColor colorWithHex:0x111111 alpha:1];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"请输入车牌号";
    self.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    [self.contentView addSubview:self.titleLabel];
    
    self.plateInputView = [[SMYPlateInputView alloc] initWithFrame:CGRectMake(0, 80, kWindowWidth, 45)];
    [self.plateInputView setDelegate:(id<SMYPlateInputViewDelegate>)self];
    [self.contentView addSubview:self.plateInputView];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)hideKeyboard {
    if (self.inputCompleted) {
        self.inputCompleted(NO, self.plateNum);
    }
    [self hide];
}

#pragma mark - SMYPlateInputViewDelegate

- (void)plateInputView:(SMYPlateInputView *)inputView textDidChange:(NSString *)text {
    self.plateNum = text;
}

- (void)plateInputView:(SMYPlateInputView *)inputView textInputDidEnd:(NSString *)text {
    self.plateNum = text;
    if (self.inputCompleted) {
        self.inputCompleted(YES, self.plateNum);
    }
    [self hide];
}

@end
