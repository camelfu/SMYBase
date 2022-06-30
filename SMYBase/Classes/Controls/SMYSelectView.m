//
//  SMYSelectView.m
//  shengbei
//
//  Created by Clancey on 2020/2/20.
//  Copyright © 2020 smyfinancial. All rights reserved.
//

#import "SMYSelectView.h"

static CGFloat kCellHeight = 45;

@interface SMYSelectViewCell : UITableViewCell

/** 内容  */
@property (nonatomic, strong) UILabel *contentLabel;
/** 底部横线  */
@property (nonatomic, strong) UIView *lineView;
/** 勾选视图  */
@property (nonatomic, strong) UIImageView *selectedImageView;


- (void)setBottomLineHidden:(BOOL)isHidden;

- (void)displayContent:(NSString *)content selected:(BOOL)bSelected;

@end

@implementation SMYSelectViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 15, kWindowWidth - 62, 14)];
        self.contentLabel.font = [UIFont systemFontOfSize:15];
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        self.contentLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:self.contentLabel];
        self.selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWindowWidth - 36, 14, 16, 16)];
        self.selectedImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.selectedImageView];
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(16, 44, kWindowWidth -16, 0.5)];
        [self.lineView setBackgroundColor:[UIColor colorWithHex:0xd8d8d8 alpha:1.0f]];
        [self.contentView addSubview:self.lineView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setBottomLineHidden:(BOOL)isHidden {
    self.lineView.hidden = isHidden;
}

- (void)displayContent:(NSString *)content selected:(BOOL)bSelected {
    self.contentLabel.text = content;
    if (bSelected) {
        self.contentLabel.textColor = [UIColor colorWithHex:0x12C963 alpha:1.0f];
        self.selectedImageView.image = SMY_IMAGE(@"commonSelected");
    } else {
        self.contentLabel.textColor = [UIColor colorWithHex:0x333333 alpha:1.0f];
        self.selectedImageView.image = nil;
    }
}

@end

@interface SMYSelectView () <UITableViewDelegate, UITableViewDataSource>

/** 数据数组 */
@property (nonatomic, copy, readwrite) NSArray *dataArray;
/** 勾选数据 */
@property (nonatomic, strong) NSMutableArray *selectedArray;
/** 背景视图  */
@property (nonatomic, strong) UIView *backgroundView;
/** 内容视图  */
@property (nonatomic, strong) UIView *contentView;
/** 显示数据的tableView */
@property (nonatomic, strong) UITableView *tableView;
/** 标题  */
@property (nonatomic, strong) UILabel *titleLabel;
/** 之前选择的indexPath  */
@property (nonatomic, strong) NSIndexPath *preSelectedIndexPath;
/** 内容视图显示时的Y值  */
@property (nonatomic, assign) CGFloat contentY;
/** title  */
@property (nonatomic, copy) NSString *title;

@end

@implementation SMYSelectView

#pragma mark - Public

- (instancetype)initWithArray:(NSArray *)array title:(NSString *)title {
    if (self = [super init]) {
        self.dataArray = array;
        self.selectedArray = [NSMutableArray array];
        self.title = title;
        [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 添加勾选情况，默认没有勾选
            [self.selectedArray addObject:@(0)];
        }];
        [self setupUI];
    }
    return self;
}

/// 显示视图
- (void)show {
    [self removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.alpha = 1;
        self.contentView.frame = CGRectMake(0, self.contentY, kWindowWidth, kWindowHeight - self.contentY);
    }];
}

/// 隐藏视图
- (void)remove {
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, kWindowHeight, kWindowWidth, kWindowHeight - self.contentY);
    } completion:^(BOOL finished) {
        self.backgroundView.alpha = 0.001;
        [self removeFromSuperview];
    }];
}

#pragma mark - Private

- (void)setupUI {
    // 默认设置
    self.frame = (CGRect) {{0.f, 0.f}, [UIScreen mainScreen].bounds.size};
    self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.backgroundView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.6];
    [self addSubview:self.backgroundView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)];
    [self.backgroundView addGestureRecognizer:tap];
    // 内容视图
    CGFloat contentHeight = kWindowHeight * 455 / 812;
    CGFloat tempHeight = self.dataArray.count * kCellHeight + 60 + kIndicatorHeight;
    if (tempHeight < [UIScreen mainScreen].bounds.size.height - 100) {
        contentHeight = tempHeight;
    }
    self.contentY = kWindowHeight - contentHeight;
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kWindowHeight, kWindowWidth, contentHeight)];
    self.contentView.backgroundColor = [UIColor colorWithHex:0xf7f7f7 alpha:1];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.contentView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.contentView.layer.mask = maskLayer;
    self.contentView.layer.masksToBounds = NO;
    [self addSubview:self.contentView];
    // 取消按钮
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(11, 10, 40, 40)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton setTitleColor:[UIColor colorWithHex:0xaaaaaa alpha:1]
                       forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancelButton];
    // title
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 21, kWindowWidth - 120, 18)];
    self.titleLabel.font = [UIFont fontWithName:kFontPingFangMedium size:17];
    self.titleLabel.textColor = [UIColor colorWithHex:0x111111 alpha:1];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    if (self.title) {
        self.titleLabel.text = self.title;
    }
    [self.contentView addSubview:self.titleLabel];
    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, kWindowWidth, contentHeight - 60) style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.contentView addSubview:self.tableView];
    [self.tableView reloadData];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"reuseCell";
    SMYSelectViewCell *selectCiewCell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!selectCiewCell) {
        selectCiewCell = [[SMYSelectViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    NSInteger row = indexPath.row;
    if (row < self.dataArray.count && row < self.selectedArray.count) {
        [selectCiewCell displayContent:self.dataArray[row]
                              selected:[self.selectedArray[row] boolValue]];
        [selectCiewCell setBottomLineHidden:row == self.dataArray.count - 1];
    }
    return selectCiewCell;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (!self.preSelectedIndexPath) {// 第一次点击
        self.preSelectedIndexPath = indexPath;
        if (row < self.selectedArray.count) {
            [self.selectedArray replaceObjectAtIndex:row withObject:@(1)];
            [tableView reloadData];
            if (self.selectCompleted) {
                self.selectCompleted(self.dataArray[row]);
            } else if (self.delegate && [self.delegate respondsToSelector:@selector(selectView:didSelectString:)]) {
                [self.delegate selectView:self didSelectString:self.dataArray[row]];
            }
            [self remove];
        }
        return;
    }
    NSInteger preRow = self.preSelectedIndexPath.row;
    self.preSelectedIndexPath = indexPath;
    if (preRow < self.selectedArray.count && row < self.selectedArray.count) {
        [self.selectedArray replaceObjectAtIndex:preRow withObject:@(0)];
        [self.selectedArray replaceObjectAtIndex:row withObject:@(1)];
        [tableView reloadData];
        if (self.selectCompleted) {
            self.selectCompleted(self.dataArray[row]);
        } else if (self.delegate && [self.delegate respondsToSelector:@selector(selectView:didSelectString:)]) {
            [self.delegate selectView:self didSelectString:self.dataArray[row]];
        }
        [self remove];
    }
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
