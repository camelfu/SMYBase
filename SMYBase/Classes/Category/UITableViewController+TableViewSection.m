//
//  UITableViewController+TableViewSection.m
//  testSearchBar
//
//  Created by jwter on 15/9/2.
//  Copyright (c) 2015年 smyfinancial. All rights reserved.
//

#import "UITableViewController+TableViewSection.h"
#import "TableViewSection.h"
#import <objc/runtime.h>

@implementation UITableViewController (TableViewSection)

const char sectionStringArrayKey;

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,16,0,0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,16,0,16)];
    }
}

- (void)setTableViewSectionTitle:(NSArray *)sectionTitles {
    if (sectionTitles) {
        objc_setAssociatedObject(self, &sectionStringArrayKey, sectionTitles, OBJC_ASSOCIATION_COPY);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSMutableArray * sections = objc_getAssociatedObject(self, &sectionStringArrayKey);
    if (sections.count > section) {
        id sectionObj = [sections objectAtIndex:section];
        if ([sectionObj isKindOfClass:[NSString class]]) {
            TableViewSection * sectionView = (TableViewSection *)[[[NSBundle mainBundle] loadNibNamed:@"TableViewSection" owner:nil options:nil]objectAtIndex:0];
            [sectionView.labelSection setText:sectionObj];
            return sectionView;
        } else if ([sectionObj isKindOfClass:[NSMutableAttributedString class]]) {
            TableViewSection * sectionView = (TableViewSection *)[[[NSBundle mainBundle] loadNibNamed:@"TableViewSection" owner:nil options:nil]objectAtIndex:0];
            [sectionView.labelSection setAttributedText:sectionObj];
            return sectionView;
        } else {
            return sectionObj;
        }
    } else {
       return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSMutableArray * sections = objc_getAssociatedObject(self, &sectionStringArrayKey);
    if (sections.count > section) {
        return 30;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,16,0,16)];
    }
}

@end
