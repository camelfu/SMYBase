//
//  UITableView+SMYFixBug.m
//  shengbei
//
//  Created by ChenYong on 2019/3/11.
//  Copyright © 2019 smyfinancial. All rights reserved.
//

#import "UITableView+SMYFixBug.h"
#import <objc/runtime.h>

@implementation UITableView (SMYFixBug)

- (void)smy_detectAndFixBlankCell {
    if (!self.window) {
        return;
    }
    // 检测有没有cell显示空白
    BOOL bNeedFix = NO;
    for (UITableViewCell *cell in self.visibleCells) {
        if (!cell.superview) {
            bNeedFix = YES;
            break;
        }
    }
    if (bNeedFix) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(smy_detectAndFixBlankCell) object:nil];
        // 检测到空白cell, 解决方法是重新reloadData
        [self reloadData];
    }
}

- (void)smy_detectAndFixBlankCellWithDelay {
    [self performSelector:@selector(smy_detectAndFixBlankCell) withObject:nil afterDelay:0.1];
    [self performSelector:@selector(smy_detectAndFixBlankCell) withObject:nil afterDelay:3];
}

@end
