//
//  ChangeFontButton.m
//  credit
//
//  Created by ChenYong on 8/5/16.
//  Copyright © 2016 smyfinancial. All rights reserved.
//

#import "ChangeFontButton.h"

@implementation ChangeFontButton

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (self.isSelected) {
        if (self.selectedFont && self.titleLabel.font != self.selectedFont) {
            self.titleLabel.font = self.selectedFont;
        }
    } else {
        if (self.normalFont && self.titleLabel.font != self.normalFont) {
            self.titleLabel.font = self.normalFont;
        }
    }
}

@end

