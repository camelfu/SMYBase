//
//  UITableViewCell+Gesture.m
//  credit
//
//  Created by 张云飞 on 15/11/14.
//  Copyright © 2015年 smyfinancial. All rights reserved.
//

#import "UITableViewCell+Gesture.h"

@implementation UITableViewCell (Gesture)

- (void)tapInvoke:(UITapGestureRecognizer *)recognizer {
    [self.contentView endEditing:YES];
}

- (void)addTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInvoke:)];
    [self.contentView addGestureRecognizer:tap];
}

@end
