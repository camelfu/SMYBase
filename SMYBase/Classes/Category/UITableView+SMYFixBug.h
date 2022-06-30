//
//  UITableView+SMYFixBug.h
//  shengbei
//
//  Created by ChenYong on 2019/3/11.
//  Copyright © 2019 smyfinancial. All rights reserved.
//
// 主要是为了解决偶发性的首页、首页理财及管卡页面tableView的部分cell显示空白的问题，调试发现这些cell没有被添加到tableView上，其superview为nil，具体原因还未找出
// 这个category是一个临时的解决文案

#import <UIKit/UIKit.h>

@interface UITableView (SMYFixBug)

/**
 立即检测空白cell并修复
 */
- (void)smy_detectAndFixBlankCell;

/**
 延时检测空白cell并修复
 */
- (void)smy_detectAndFixBlankCellWithDelay;

@end

