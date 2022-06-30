//
//  SMYScrollLabel.m
//  shengbei
//
//  Created by penggongxu on 2019/10/8.
//  Copyright © 2019 smyfinancial. All rights reserved.
//

#import "SMYScrollLabel.h"

@interface SMYScrollLabel()
 
@property (nonatomic, strong) UIScrollView *scrollView;
/** 内容显示label */
@property (nonatomic, strong) UILabel *contentLabel;
/** 定时器 */
@property (nonatomic, strong) NSTimer *scrollTimer;

@end

@implementation SMYScrollLabel

@dynamic contentFont, contentColor, content;

- (instancetype)init {
    if (self = [super init]) {
        [self loadUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self loadUI];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    [self startScroll];
}

#pragma mark - Private Method

- (void)loadUI {
    self.backgroundColor = [UIColor clearColor];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.scrollEnabled = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self addSubview:self.scrollView];
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAXFLOAT, 20)];
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.font = [UIFont systemFontOfSize:13];
    self.contentLabel.numberOfLines = 1;
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:_contentLabel];
    self.clipsToBounds = YES;
}

/**
 更新UI
 */
- (void)updateUI {
    CGRect contentRect = [self.content boundingRectWithSize:CGSizeMake(MAXFLOAT, 30)
                                                    options:NSStringDrawingTruncatesLastVisibleLine |
                                                            NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:self.contentFont}
                                                    context:nil];
    self.scrollView.contentSize = CGSizeMake(contentRect.size.width, 0);
    CGRect frame = self.bounds;
    self.scrollView.frame = frame;
    frame.size.width = contentRect.size.width;
    self.contentLabel.frame = frame;
    [self startScroll];
}


- (void)startScroll {
    CGFloat scrollWidth = self.scrollView.contentSize.width;
    CGFloat viewWidth = self.bounds.size.width;
    if (scrollWidth < viewWidth) {// 显示区域比内容区域大,不需要滚动
        return;
    }
    [self.scrollView.layer removeAllAnimations];
    WEAKSELF;
    [UIView animateWithDuration:2.5 delay:1 options:UIViewAnimationOptionCurveLinear animations:^{
        [weakSelf.scrollView setContentOffset:CGPointMake(scrollWidth - viewWidth, 0)];
    } completion:^(BOOL finished) {
        if (finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.scrollView setContentOffset:CGPointMake(0, 0)];
                [weakSelf startScroll];
            });
        }
    }];
}

#pragma mark - Setters

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self.scrollView setFrame:self.bounds];
    [self.contentLabel setFrame:CGRectMake(0, 0, MAXFLOAT, frame.size.height)];
}

- (void)setContent:(NSString *)content {
    self.contentLabel.text = content;
    [self updateUI];
}

- (void)setContentFont:(UIFont *)contentFont {
    self.contentLabel.font = contentFont;
    [self updateUI];
}

- (void)setContentColor:(UIColor *)contentColor {
    self.contentLabel.textColor = contentColor;
    [self updateUI];
}

- (NSString *)content {
    return self.contentLabel.text;
}

- (UIColor *)contentColor {
    return self.contentLabel.textColor;
}

- (UIFont *)contentFont {
    return self.contentLabel.font;
}

@end
