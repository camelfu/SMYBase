//
//  NSString+Additions.m
//  credit
//
//  Created by 张云飞 on 15/9/8.
//  Copyright (c) 2015年 smyfinancial. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (CGSize)sizeWithMyFont:(UIFont *)font size:(CGSize)size {
    CGRect textRect = [self boundingRectWithSize:size
                                         options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    return textRect.size;
}

- (BOOL)includeChinese {
    for(int i=0; i< [self length];i++) {
        int a =[self characterAtIndex:i];
        if ( a >0x4e00 && a <0x9fff) {
            return YES;
        }
    }
    return NO;
}

- (NSUInteger)wordsCount {
    NSUInteger cnt = 0;
    NSRange range;
    for(int i = 0; i < self.length; i += range.length) {
        range = [self rangeOfComposedCharacterSequenceAtIndex:i];
        cnt++;
    }
    return cnt;
}

- (BOOL)isPureNumber {
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (NSString *)encodeURIComponent {
    NSString *encodeString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                   kCFAllocatorDefault,
                                                                                                   (CFStringRef)self,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8));
    return encodeString;
}

@end
