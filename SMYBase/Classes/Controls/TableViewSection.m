//
//  TableViewSection.m
//  testSearchBar
//
//  Created by jwter on 15/9/2.
//  Copyright (c) 2015年 smyfinancial. All rights reserved.
//

#import "TableViewSection.h"
#import "UIColor+Custom.h"

@implementation TableViewSection

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.labelSection.tintColor = [UIColor colorWithHex:0x777777 alpha:1.0f];
    self.backgroundColor = [UIColor colorWithHex:0xf5f6f6 alpha:1.0f];
}

@end
