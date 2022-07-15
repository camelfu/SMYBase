//
//  ZHPickView.m
//  ZHpickView
//
//  Created by liudianling on 14-11-18.
//  Copyright (c) 2014年 赵恒志. All rights reserved.
//

#import "ZHPickView.h"
#import "UIColor+Custom.h"
#import "UtilityMacro.h"

#define kColorDefaultVI     [UIColor colorWithHex:0x12C963 alpha:1.0f]
#define ZHToobarHeight  40

@interface ZHPickView ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, copy)NSString *plistName;
@property (nonatomic, strong)NSArray *plistArray;
@property (nonatomic, assign)BOOL isLevelArray;
@property (nonatomic, assign)BOOL isLevelString;
@property (nonatomic, assign)BOOL isLevelDic;
@property (nonatomic, strong)NSDictionary *levelTwoDic;
@property (nonatomic, strong)UIToolbar *toolbar;
@property (nonatomic, strong)UIPickerView *pickerView;
@property (nonatomic, assign)NSDate *defaulDate;
@property (nonatomic, assign)BOOL isHaveNavControler;
@property (nonatomic, assign)NSInteger pickeviewHeight;

@property (nonatomic, assign)int levelDeep;
@property (nonatomic, strong)NSMutableDictionary *levelDictionary;
@end

@implementation ZHPickView

- (NSArray *)plistArray {
    if (_plistArray==nil) {
        _plistArray=[[NSArray alloc] init];
    }
    return _plistArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
  
    }
    return self;
}

- (instancetype)initPickviewWithPlistName:(NSString *)plistName isHaveNavControler:(BOOL)isHaveNavControler {
    
    self=[super init];
    if (self) {
        _plistName=plistName;
        self.plistArray=[self getPlistArrayByplistName:plistName];
        [self setUpPickView];
        [self setFrameWith:isHaveNavControler];
        [self setUpToolBar];
    }
    return self;
}
- (instancetype)initPickviewWithArray:(NSArray *)array isHaveNavControler:(BOOL)isHaveNavControler {
    self=[super init];
    if (self) {
        self.plistArray=array;
        [self setArrayClass:array];
        [self setUpPickView];
        [self setFrameWith:isHaveNavControler];
        [self setUpToolBar];
    }
    return self;
}

- (instancetype)initDatePickWithDate:(NSDate *)defaulDate datePickerMode:(UIDatePickerMode)datePickerMode isHaveNavControler:(BOOL)isHaveNavControler {
    
    self=[super init];
    if (self) {
        _defaulDate=defaulDate;
        [self setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode];
        [self setFrameWith:isHaveNavControler];
        [self setUpToolBar];
    }
    return self;
}

- (instancetype)initPickviewWithLevelArray:(NSArray *)array levelDeep:(int)levelDeep
{
    self=[super init];
    if (self) {
        self.plistArray=array;
        self.levelDeep = levelDeep;
        
        [self setArrayClass:array];
        [self setUpPickView];
        [self setFrameWith:NO];
        [self setUpToolBar];
        
        self.levelDictionary = [NSMutableDictionary dictionary];
        NSMutableArray *deepArray = [[NSMutableArray alloc]init];
        for(int i=0;i<levelDeep;i++) {
            
            NSMutableArray *itemArray = [[NSMutableArray alloc]initWithArray:deepArray];
            NSArray *items = [self getLevelsArray:array deepArray:itemArray];
            if (items) {
                [self.levelDictionary setObject:items forKey:[NSString stringWithFormat:@"%i",i]];
            }
            [deepArray addObject:@0];
        }
    }
    return self;
}

- (void)selectRow:(NSInteger)row {
    if (row < 0 || row >= self.plistArray.count) {
        return;
    }
    [self.pickerView selectRow:row inComponent:0 animated:NO];
}

- (NSArray *)getLevelsArray:(NSArray *)array deepArray:(NSMutableArray *)deepArray {
    if (deepArray.count == 0) {
        return array;
    }
    else {
        if (deepArray) {
            NSInteger row = [[deepArray objectAtIndex:0] integerValue];
            if (array.count > row) {
                NSArray * items = [[array objectAtIndex:row] objectForKey:kLevelTreeItems];
                [deepArray removeObjectAtIndex:0];
                return [self getLevelsArray:items deepArray:deepArray];
            }
        }
        return nil;
    }
}

- (NSArray *)getPlistArrayByplistName:(NSString *)plistName {
    
    NSString *path= [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray * array=[[NSArray alloc] initWithContentsOfFile:path];
    [self setArrayClass:array];
    return array;
}

- (void)setArrayClass:(NSArray *)array {
    for (id levelTwo in array) {
        
        if ([levelTwo isKindOfClass:[NSArray class]]) {
            _isLevelArray=YES;
            _isLevelString=NO;
            _isLevelDic=NO;
        } else if ([levelTwo isKindOfClass:[NSString class]]) {
            _isLevelString=YES;
            _isLevelArray=NO;
            _isLevelDic=NO;
            
        } else if ([levelTwo isKindOfClass:[NSDictionary class]])
        {
            _isLevelDic=YES;
            _isLevelString=NO;
            _isLevelArray=NO;
        }
    }
}

- (void)setFrameWith:(BOOL)isHaveNavControler {
    //适配7.1.1
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [[UIScreen mainScreen] bounds].size.height - ZHToobarHeight - _pickeviewHeight)];
    view.backgroundColor = [UIColor colorWithHex:0xffffff alpha:0.01];
    view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *frontgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touched:)];
    frontgesture.numberOfTapsRequired = 1;
    [view addGestureRecognizer:frontgesture];
    
    [self addSubview:view];

    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

- (void)touched:(id)sender {
    [self remove];
}

- (void)setUpPickView {
    UIPickerView *pickView=[[UIPickerView alloc] init];
    pickView.backgroundColor=[UIColor whiteColor];
    _pickerView=pickView;
    pickView.delegate=self;
    pickView.dataSource=self;
    pickView.frame=CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - pickView.frame.size.height, [[UIScreen mainScreen] bounds].size.width, pickView.frame.size.height);
    _pickeviewHeight=pickView.frame.size.height;
    [self addSubview:pickView];
}

- (void)setUpDatePickerWithdatePickerMode:(UIDatePickerMode)datePickerMode {
    UIDatePicker *datePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, 200)];
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    datePicker.datePickerMode = datePickerMode;
    if (@available(iOS 13.4, *)) {
        datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    datePicker.backgroundColor=[UIColor whiteColor];
    if (_defaulDate) {
        [datePicker setDate:_defaulDate];
    }
    _datePicker=datePicker;
    datePicker.frame=CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - datePicker.frame.size.height, [[UIScreen mainScreen] bounds].size.width, datePicker.frame.size.height);
    _pickeviewHeight=datePicker.frame.size.height;
    [self addSubview:datePicker];
}

- (void)setUpToolBar {
    _toolbar=[self setToolbarStyle];
    [self setToolbarWithPickViewFrame];
    [self addSubview:_toolbar];
}

- (void)addToolbarButton:(UIButton *)button {
    button.center = CGPointMake(CGRectGetMidX(_toolbar.bounds), CGRectGetMidY(_toolbar.bounds) + 5);
    [_toolbar addSubview:button];
}

- (UIToolbar *)setToolbarStyle {
    UIColor *colrAppVI = [UIColor colorWithHex:0x12C963 alpha:1.0f];
    UIToolbar *toolbar=[[UIToolbar alloc] init];
    toolbar.backgroundColor = [UIColor whiteColor];
    toolbar.barTintColor = [UIColor whiteColor];
    toolbar.tintColor = colrAppVI;
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithTitle:@"    取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    [leftItem setTitleTextAttributes:@{NSForegroundColorAttributeName:colrAppVI,
                                       NSFontAttributeName:[UIFont systemFontOfSize:15.0]} forState:UIControlStateNormal];

    UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithTitle:@"确定    " style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];


    [rightItem setTitleTextAttributes:@{NSForegroundColorAttributeName:colrAppVI,
                                        NSFontAttributeName:[UIFont systemFontOfSize:15.0]} forState:UIControlStateNormal];

    toolbar.items=@[leftItem,centerSpace,rightItem];
    return toolbar;
}

- (void)setToolbarWithPickViewFrame {
    _toolbar.frame=CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - ZHToobarHeight - _pickeviewHeight,[UIScreen mainScreen].bounds.size.width, ZHToobarHeight);
}

- (void)setPickerTitle:(NSString *)title font:(UIFont *)font {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, kWindowWidth, ZHToobarHeight)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.text = title;
    titleLabel.font = font;
    titleLabel.textColor = [UIColor colorWithHex:0x555555 alpha:1];
    [_toolbar addSubview:titleLabel];
}

- (void)setDatePickerTitle:(NSString *)title {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, kWindowWidth, ZHToobarHeight)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    titleLabel.textColor = [UIColor colorWithHex:0x555555 alpha:1];
    [_toolbar addSubview:titleLabel];
}

- (void)setDatePickerDate:(NSDate *)date {
    if (date) {
        _datePicker.date = date;
    }
}

- (NSString *)getTitleFromPickerView:(UIPickerView *)pickerView row:(NSInteger)row component:(NSInteger)component
{
    return [self pickerView:pickerView titleForRow:row forComponent:component];
}

#pragma mark piackView 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    NSInteger component = 0;
    if (_isLevelArray) {
        component=_plistArray.count;
    } else if (_isLevelString) {
        component=1;
    } else if (_isLevelDic) {
        component = self.levelDeep;
    }
    return component;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *rowArray=[[NSArray alloc] init];
    if (_isLevelArray) {
        rowArray=_plistArray[component];
    } else if (_isLevelString) {
        rowArray=_plistArray;
    } else if (_isLevelDic) {
        rowArray = [self.levelDictionary objectForKey:[NSString stringWithFormat:@"%li",(long)component]];
    }
    return rowArray.count;
}

#pragma mark UIPickerViewdelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *rowTitle=nil;
    if (_isLevelArray) {
        rowTitle=_plistArray[component][row];
    } else if (_isLevelString) {
        rowTitle=_plistArray[row];
    } else if (_isLevelDic) {
       NSArray *items = [self.levelDictionary objectForKey:[NSString stringWithFormat:@"%li",(long)component]];
        if (items && items.count > row) {
            rowTitle = [[items objectAtIndex:row] objectForKey:kLevelTreeTitle];
        }
    }
    return rowTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    if (_isLevelString) {
   
    } else if (_isLevelArray) {
        
    } else if (_isLevelDic) {
        //纪录每一行显示的子项集合
        NSMutableArray * deepArray = [[NSMutableArray alloc]init];
        for (int i =0; i<=component; i++) {
            [deepArray addObject:[NSNumber numberWithInteger:
                                  [pickerView selectedRowInComponent:i]]];
        }
        //重续加载后面的子项
        for (NSUInteger i = (component+1); i<self.levelDeep; i++) {
            NSMutableArray * itemArray = [[NSMutableArray alloc]initWithArray:deepArray];
            NSArray * items = [self getLevelsArray:self.plistArray deepArray:itemArray];
            if (items) {
                [self.levelDictionary setObject:items forKey:[NSString stringWithFormat:@"%lu",(unsigned long)i]];
                [pickerView reloadComponent:i];
                [pickerView selectRow:0 inComponent:i animated:YES];
                //解决子项级别不统一的问题,item可能为空
                if (items && items.count > 0) {
                    //纪录当前选择的子项索引，用于下级选择器加载子项列表
                    [deepArray addObject:@0];
                }
            }
        }
    }
}

- (void)remove {
    [self removeFromSuperview];
}
- (void)show {    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)cancelClick {
    [self remove];
    if ([self.delegate respondsToSelector:@selector(toobarCancelBtnHaveClick:)]) {
        [self.delegate toobarCancelBtnHaveClick:self];
    }
}

- (void)doneClick {
    NSMutableArray *selectorArray = [[NSMutableArray alloc]init];
    NSString * resultString = @"";
    if (_pickerView) {
        if (_isLevelString) {
            NSInteger row = [_pickerView selectedRowInComponent:0];
            resultString= _plistArray[row];
            [selectorArray addObject:resultString];
        } else if (_isLevelArray) {
            
            for (int i=0; i<_plistArray.count;i++) {
                 NSInteger row = [_pickerView selectedRowInComponent:i];
                resultString=[NSString stringWithFormat:@"%@%@",resultString,_plistArray[i][row]];
                [selectorArray addObject:_plistArray[i][row]];
            }
        } else if (_isLevelDic) {
            for (NSInteger i=0; i<self.levelDeep; i++) {
                NSInteger row = [_pickerView selectedRowInComponent:i];
                NSArray *componentArray = [self.levelDictionary objectForKey:[NSString stringWithFormat:@"%ld",(long)i]];
                
                if(componentArray && componentArray.count > 0) {
                    NSString * componentTitle = [[componentArray objectAtIndex:row] objectForKey:kLevelTreeTitle];
                    [selectorArray addObject:componentTitle];
                    
                    resultString=[NSString stringWithFormat:@"%@%@",resultString,componentTitle];
                } 
            }
       }
        
    } else if (_datePicker) {
        if ([self.delegate respondsToSelector:@selector(zhPickView:didSelectDate:)]) {
            [self.delegate zhPickView:self didSelectDate:_datePicker.date];
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *str = [formatter stringFromDate:_datePicker.date];
        resultString = str;
    }
    if ([self.delegate respondsToSelector:@selector(toobarDonBtnHaveClick:resultString:)]) {
        [self.delegate toobarDonBtnHaveClick:self resultString:resultString];
    }
    if ([self.delegate respondsToSelector:@selector(toobarDonBtnHaveClick:selectorArray:)]) {
        [self.delegate toobarDonBtnHaveClick:self selectorArray:selectorArray];
    }
    if (self.didSelectArrayHandler) {
        self.didSelectArrayHandler(selectorArray);
    }
    [self removeFromSuperview];
}
/**
 *  设置PickView的颜色
 */
- (void)setPickViewColer:(UIColor *)color {
    _pickerView.backgroundColor=color;
}
/**
 *  设置toobar的文字颜色
 */
- (void)setTintColor:(UIColor *)color {
    
    _toolbar.tintColor=color;
}
/**
 *  设置toobar的背景颜色
 */
- (void)setToolbarTintColor:(UIColor *)color {
    
    _toolbar.barTintColor=color;
}
- (void)dealloc {
    
    //NSLog(@"销毁了");
}

- (void)removeFromSuperview {
    if (self.delegate && [self.delegate respondsToSelector:@selector(zhPickViewWillRemoveFromSuperview)]) {
        [self.delegate zhPickViewWillRemoveFromSuperview];
    }
    [super removeFromSuperview];
}
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
