//
//  SMYNotReachableView.m
//  credit
//
//  Created by zhaojian on 2016/12/1.
//  Copyright © 2016年 smyfinancial. All rights reserved.
//

#import "SMYNotReachableView.h"
#import "UIColor+Custom.h"
#import "UtilityMacro.h"

@interface SMYNotReachableView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelSubTitle;
@property (nonatomic, strong) UIButton *btnReload;
    
@end

@implementation SMYNotReachableView
    
- (void)btnReloadDidClicked {
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadDidClicked)]) {
        [self.delegate reloadDidClicked];
    }
}
    
/**
 *  初始化UI
 */
- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kWindowWidth-132)/2, 114, 120, 120)];
    self.imageView.image = [UIImage imageNamed:@"notReachable"];
    
    self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake((kWindowWidth-220)/2, 249, 220, 17)];
    self.labelTitle.numberOfLines = 1;
    self.labelTitle.textColor = [UIColor colorWithHex:0x333333 alpha:1.0f];
    self.labelTitle.font = [UIFont systemFontOfSize:17];
    self.labelTitle.textAlignment = NSTextAlignmentCenter;
    self.labelTitle.text = @"数据加载失败";
    
    self.labelSubTitle = [[UILabel alloc] initWithFrame:CGRectMake((kWindowWidth-220)/2, 281, 220, 14)];
    self.labelSubTitle.numberOfLines = 1;
    self.labelSubTitle.textColor = [UIColor colorWithHex:0x777777 alpha:1.0f];
    self.labelSubTitle.font = [UIFont systemFontOfSize:14];
    self.labelSubTitle.textAlignment = NSTextAlignmentCenter;
    self.labelSubTitle.text = @"网络或者服务器延迟，请稍后再试";
    
    self.btnReload = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnReload.frame = CGRectMake((kWindowWidth-150)/2, 330, 150, 48);
    self.btnReload.backgroundColor = [UIColor colorWithHex:0x12C963 alpha:1.0f];
    self.btnReload.titleLabel.font = [UIFont systemFontOfSize:17];
    self.btnReload.layer.cornerRadius = 2.0f;
    [self.btnReload setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnReload setTitle:@"重新加载" forState:UIControlStateNormal];
    [self.btnReload addTarget:self action:@selector(btnReloadDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.imageView];
    [self addSubview:self.labelTitle];
    [self addSubview:self.labelSubTitle];
    [self addSubview:self.btnReload];
}
    
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

@end
