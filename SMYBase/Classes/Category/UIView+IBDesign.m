//
//  UIView+IBDesign.m
//  credit
//
//  Created by ChenYong on 19/09/2017.
//  Copyright © 2017 smyfinancial. All rights reserved.
//

#import "UIView+IBDesign.h"

@implementation UIView (IBDesign)

@dynamic cornerRadius, borderWidth, borderColor;

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = fabs(radius) > 0.1;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

@end
