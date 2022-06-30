//
//  UITableViewController+EasyDisplay.h
//  credit
//
//  Created by ChenYong on 13/12/2017.
//  Copyright © 2017 smyfinancial. All rights reserved.
//
// 封装UITableViewController的dataSource和部分delegate，简化数据的管理和使用

#import <UIKit/UIKit.h>

@interface SectionRowData : NSObject

@property (nonatomic, strong) UITableViewCell *cell;
/** 默认是负数，表示要继承section和tableView的属性 */
@property (nonatomic, assign) CGFloat rowHeight;
/** 默认是nil, 表示要继承section和tableView的属性 */
@property (nonatomic, strong) NSNumber *canBeSelected;
/** 用于动态调整cell的高度 */
@property (nonatomic, strong) CGFloat(^fetchRowHeightHandler)(void);

+ (instancetype)sectionRowDataWithCell:(UITableViewCell *)cell;
+ (instancetype)sectionRowDataWithCell:(UITableViewCell *)cell height:(CGFloat)height;

@end

@interface TableViewSectionData : NSObject

/** 用于已经创建好的cell */
@property (nonatomic, strong) NSMutableArray <SectionRowData *>*rowDataArray;

/** 用于需要动态创建的cell */
@property (nonatomic, strong) NSMutableArray  *sectionDisplayObjectsArray;
@property (nonatomic, copy)   NSString        *cellReuseIdentifier;
@property (nonatomic, strong) Class           cellClass;
/** 自定义cell的创建方式 */
@property (nonatomic, strong) UITableViewCell *(^getTableViewCellHandler)(NSInteger row);
/** 自定义cell的数据显示 */
@property (nonatomic, strong) void(^displayCellHandler)(UITableViewCell *cell, id displayObject);

@property (nonatomic, copy)   NSString        *headerTitle;
@property (nonatomic, copy)   NSString        *footerTitle;

/** 默认是nil, 表示要继承tableView的属性 */
@property (nonatomic, strong) NSNumber *canBeSelected;
/** 默认是负数，表示要继承tableView的属性 */
@property (nonatomic, assign) CGFloat rowHeight;
/** 默认是负数，表示要继承tableView的属性 */
@property (nonatomic, assign) CGFloat sectionHeaderHeight;
/** 默认是负数，表示要继承tableView的属性 */
@property (nonatomic, assign) CGFloat sectionFooterHeight;

- (void)addRow:(SectionRowData *)rowData;

@end

@interface UITableViewController (EasyDisplay)

@property (nonatomic, readonly) NSInteger sectionCount;

+ (void)enableEasyDisplay;

- (TableViewSectionData *)sectionAtIndex:(NSInteger)index;
- (BOOL)containsSection:(TableViewSectionData *)sectionData;
- (void)addSection:(TableViewSectionData *)sectionData;
- (void)removeSection:(TableViewSectionData *)sectionData;
- (void)insertSection:(TableViewSectionData *)sectionData atIndex:(NSInteger)index;

@end
