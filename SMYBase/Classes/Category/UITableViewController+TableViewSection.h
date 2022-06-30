//
//  UITableViewController+TableViewSection.h
//  testSearchBar
//
//  Created by jwter on 15/9/2.
//  Copyright (c) 2015年 smyfinancial. All rights reserved.
//
//  设置tableview组标题

#import <UIKit/UIKit.h>

@interface UITableViewController (TableViewSection)

/**
 设置tableview组标题

 @param sectionTitles 组标题数组
 */
- (void)setTableViewSectionTitle:(nullable NSArray *)sectionTitles;

@end
