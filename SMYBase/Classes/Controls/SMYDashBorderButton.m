//
//  SMYDashBorderButton.m
//  credit
//
//  Created by ChenYong on 22/01/2018.
//  Copyright © 2018 smyfinancial. All rights reserved.
//

#import "SMYDashBorderButton.h"

@implementation SMYDashBorderButton

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    rect = CGRectInset(self.bounds, 1, 1);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.height / 2];
    path.lineWidth = 1;
    CGFloat dash[] = {3, 3};
    [path setLineDash:dash count:2 phase:0];
    if (self.dashBorderColor) {
        [self.dashBorderColor setStroke];
    } else {
        [[UIColor colorWithHex:0x999999 alpha:1] setStroke];
    }
    [path stroke];
}

@end
