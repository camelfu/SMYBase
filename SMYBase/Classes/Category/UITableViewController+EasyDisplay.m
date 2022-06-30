//
//  UITableViewController+EasyDisplay.m
//  credit
//
//  Created by ChenYong on 13/12/2017.
//  Copyright © 2017 smyfinancial. All rights reserved.
//

#import "UITableViewController+EasyDisplay.h"
#import <objc/runtime.h>

@implementation SectionRowData

- (instancetype)init {
    if (self = [super init]) {
        _rowHeight = -1;
    }
    return self;
}

+ (instancetype)sectionRowDataWithCell:(UITableViewCell *)cell {
    if (!cell) {
        return nil;
    }
    SectionRowData *rowData = [[SectionRowData alloc] init];
    rowData.cell = cell;
    return rowData;
}

+ (instancetype)sectionRowDataWithCell:(UITableViewCell *)cell height:(CGFloat)height {
    SectionRowData *rowData = [self sectionRowDataWithCell:cell];
    rowData.rowHeight = height;
    return rowData;
}

@end

@implementation TableViewSectionData

- (void)addRow:(SectionRowData *)rowData {
    if (!rowData) {
        return;
    }
    if (!self.rowDataArray) {
        self.rowDataArray = [NSMutableArray array];
    }
    [self.rowDataArray addObject:rowData];
}

@end

@implementation UITableViewController (EasyDisplay)

+ (void)enableEasyDisplay {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(numberOfSectionsInTableView:)),
                                       class_getInstanceMethod(self, @selector(easy_numberOfSectionsInTableView:)));
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(tableView:numberOfRowsInSection:)),
                                       class_getInstanceMethod(self, @selector(easy_tableView:numberOfRowsInSection:)));
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(tableView:cellForRowAtIndexPath:)),
                                       class_getInstanceMethod(self, @selector(easy_tableView:cellForRowAtIndexPath:)));
        
        class_replaceMethod(self, @selector(tableView:heightForRowAtIndexPath:),
                            [self instanceMethodForSelector:@selector(easy_tableView:heightForRowAtIndexPath:)], "d@:@@");
        
        class_replaceMethod(self, @selector(tableView:titleForHeaderInSection:),
                            [self instanceMethodForSelector:@selector(easy_tableView:titleForHeaderInSection:)], "@@:@l");
        
        class_replaceMethod(self, @selector(tableView:titleForFooterInSection:),
                            [self instanceMethodForSelector:@selector(easy_tableView:titleForFooterInSection:)], "@@:@l");
        
        class_replaceMethod(self, @selector(tableView:heightForHeaderInSection:),
                            [self instanceMethodForSelector:@selector(easy_tableView:heightForHeaderInSection:)], "d@:@@");
        
        class_replaceMethod(self, @selector(tableView:heightForFooterInSection:),
                            [self instanceMethodForSelector:@selector(easy_tableView:heightForFooterInSection:)], "d@:@@");
        
        class_replaceMethod(self, @selector(tableView:shouldHighlightRowAtIndexPath:),
                            [self instanceMethodForSelector:@selector(easy_tableView:shouldHighlightRowAtIndexPath:)], "B@:@@");
    });
}

- (NSMutableArray *)easySectionDataArray {
    return objc_getAssociatedObject(self, @selector(easySectionDataArray));
}

- (void)setEasySectionDataArray:(NSMutableArray *)sectionDataArray {
    objc_setAssociatedObject(self, @selector(easySectionDataArray), sectionDataArray, OBJC_ASSOCIATION_RETAIN);
}

- (NSInteger)sectionCount {
    return [self easySectionDataArray].count;
}

- (TableViewSectionData *)sectionAtIndex:(NSInteger)index {
    NSArray *array = self.easySectionDataArray;
    if (index >= 0 && index < array.count) {
        return [array objectAtIndex:index];
    }
    return nil;
}

- (BOOL)containsSection:(TableViewSectionData *)sectionData {
    if (!sectionData) {
        return NO;
    }
    return [self.easySectionDataArray containsObject:sectionData];
}

- (void)addSection:(TableViewSectionData *)sectionData {
    if (!sectionData) {
        return;
    }
    if (!self.easySectionDataArray) {
        self.easySectionDataArray = [NSMutableArray array];
    }
    NSMutableArray *arraySections = self.easySectionDataArray;
    if ([arraySections containsObject:sectionData]) {
        if (sectionData == arraySections.lastObject) {
            return;
        }
        [arraySections removeObject:sectionData];
    }
    [arraySections addObject:sectionData];
}

- (void)removeSection:(TableViewSectionData *)sectionData {
    if (sectionData) {
        [self.easySectionDataArray removeObject:sectionData];
    }
}

- (void)insertSection:(TableViewSectionData *)sectionData atIndex:(NSInteger)index {
    if (!sectionData) {
        return;
    }
    if (!self.easySectionDataArray) {
        self.easySectionDataArray = [NSMutableArray array];
    }
    NSMutableArray *arraySections = self.easySectionDataArray;
    if (arraySections.count < 1) {
        [arraySections addObject:sectionData];
        return;
    }
    if (index < 0) {
        index = 0;
    } else if (index >= arraySections.count) {
        index = self.easySectionDataArray.count - 1;
    }
    [arraySections insertObject:sectionData atIndex:index];
}

- (NSInteger)easy_numberOfSectionsInTableView:(UITableView *)tableView {
    NSMutableArray *arySectionDataArray = self.easySectionDataArray;
    if (arySectionDataArray) {
        return arySectionDataArray.count;
    }
    return [self easy_numberOfSectionsInTableView:tableView];
}

- (NSInteger)easy_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *arySectionDataArray = self.easySectionDataArray;
    if (arySectionDataArray) {
        if (section >= 0 && section < arySectionDataArray.count) {
            TableViewSectionData *sectionData = [arySectionDataArray objectAtIndex:section];
            if (sectionData.rowDataArray) {
                return sectionData.rowDataArray.count;
            } else if (sectionData.sectionDisplayObjectsArray) {
                return sectionData.sectionDisplayObjectsArray.count;
            }
        }
        return 0;
    }
    return [self easy_tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)easy_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSMutableArray *arySectionDataArray = self.easySectionDataArray;
    if (arySectionDataArray && section >= 0 && section < arySectionDataArray.count) {
        TableViewSectionData *sectionData = [arySectionDataArray objectAtIndex:section];
        if ([sectionData isKindOfClass:[TableViewSectionData class]]) {
            NSInteger row = indexPath.row;
            if (sectionData.rowDataArray) {
                if (row >= 0 && row < sectionData.rowDataArray.count) {
                    SectionRowData *rowData = [sectionData.rowDataArray objectAtIndex:row];
                    if ([rowData isKindOfClass:[SectionRowData class]] && rowData.cell) {
                        cell = rowData.cell;
                    }
                }
            } else if (sectionData.sectionDisplayObjectsArray) {
                if (row >= 0 && row < sectionData.sectionDisplayObjectsArray.count) {
                    if (sectionData.cellReuseIdentifier.length > 0) {
                        cell = [tableView dequeueReusableCellWithIdentifier:sectionData.cellReuseIdentifier];
                    } else if (sectionData.getTableViewCellHandler) {
                        cell = sectionData.getTableViewCellHandler(row);
                    }
                    if (cell && sectionData.displayCellHandler) {
                        sectionData.displayCellHandler(cell, [sectionData.sectionDisplayObjectsArray objectAtIndex:row]);
                    }
                }
            }
        }
    }
    if (!cell) {
        cell = [self easy_tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    return cell;
}

- (CGFloat)easy_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSMutableArray *arySectionDataArray = self.easySectionDataArray;
    if (arySectionDataArray && section >= 0 && section < arySectionDataArray.count) {
        TableViewSectionData *sectionData = [arySectionDataArray objectAtIndex:section];
        if ([sectionData isKindOfClass:[TableViewSectionData class]]) {
            NSInteger row = indexPath.row;
            if (sectionData.rowDataArray) {
                if (row >= 0 && row < sectionData.rowDataArray.count) {
                    SectionRowData *rowData = [sectionData.rowDataArray objectAtIndex:row];
                    if ([rowData isKindOfClass:[SectionRowData class]]) {
                        if (rowData.fetchRowHeightHandler) {
                            return rowData.fetchRowHeightHandler();
                        } else if (rowData.rowHeight >= 0) {
                            return rowData.rowHeight;
                        }
                    }
                    if (sectionData.rowHeight >= 0) {
                        return sectionData.rowHeight;
                    }
                } else {
                    return 0;
                }
            } else if (sectionData.sectionDisplayObjectsArray) {
                if (row >= 0 && row < sectionData.sectionDisplayObjectsArray.count && sectionData.rowHeight >= 0) {
                    return sectionData.rowHeight;
                } else {
                    return 0;
                }
            }
        }
    }
    return UITableViewAutomaticDimension;
}

- (NSString *)easy_tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSMutableArray *arySectionDataArray = self.easySectionDataArray;
    if (arySectionDataArray && section >= 0 && section < arySectionDataArray.count) {
        TableViewSectionData *sectionData = [arySectionDataArray objectAtIndex:section];
        if ([sectionData isKindOfClass:[TableViewSectionData class]]) {
            return sectionData.headerTitle;
        }
    }
    return nil;
}

- (NSString *)easy_tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSMutableArray *arySectionDataArray = self.easySectionDataArray;
    if (arySectionDataArray && section >= 0 && section < arySectionDataArray.count) {
        TableViewSectionData *sectionData = [arySectionDataArray objectAtIndex:section];
        if ([sectionData isKindOfClass:[TableViewSectionData class]]) {
            return sectionData.footerTitle;
        }
    }
    return nil;
}

- (CGFloat)easy_tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSMutableArray *arySectionDataArray = self.easySectionDataArray;
    if (arySectionDataArray && section >= 0 && section < arySectionDataArray.count) {
        TableViewSectionData *sectionData = [arySectionDataArray objectAtIndex:section];
        if ([sectionData isKindOfClass:[TableViewSectionData class]] && sectionData.sectionHeaderHeight >= 0) {
            return sectionData.sectionHeaderHeight;
        }
    }
    return 0.01;
}

- (CGFloat)easy_tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSMutableArray *arySectionDataArray = self.easySectionDataArray;
    if (arySectionDataArray && section >= 0 && section < arySectionDataArray.count) {
        TableViewSectionData *sectionData = [arySectionDataArray objectAtIndex:section];
        if ([sectionData isKindOfClass:[TableViewSectionData class]] && sectionData.sectionFooterHeight >= 0) {
            return sectionData.sectionFooterHeight;
        }
    }
    return 0.01;
}

- (BOOL)easy_tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!tableView.allowsSelection) {
        return NO;
    }
    NSInteger section = indexPath.section;
    NSMutableArray *arySectionDataArray = self.easySectionDataArray;
    if (arySectionDataArray && section >= 0 && section < arySectionDataArray.count) {
        TableViewSectionData *sectionData = [arySectionDataArray objectAtIndex:section];
        if ([sectionData isKindOfClass:[TableViewSectionData class]]) {
            NSInteger row = indexPath.row;
            if (sectionData.rowDataArray) {
                if (row >= 0 && row < sectionData.rowDataArray.count) {
                    SectionRowData *rowData = [sectionData.rowDataArray objectAtIndex:row];
                    if ([rowData isKindOfClass:[SectionRowData class]] && rowData.canBeSelected) {
                        return [rowData.canBeSelected boolValue];
                    } else if (sectionData.canBeSelected) {
                        return [sectionData.canBeSelected boolValue];
                    }
                } else {
                    return NO;
                }
            } else if (sectionData.sectionDisplayObjectsArray) {
                if (row >= 0 && row < sectionData.sectionDisplayObjectsArray.count) {
                    if (sectionData.canBeSelected) {
                        return [sectionData.canBeSelected boolValue];
                    }
                } else {
                    return NO;
                }
            }
        }
    }
    return YES;
}

@end
