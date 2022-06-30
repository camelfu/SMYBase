//
//  SMYImageTool.m
//  shengbei
//
//  Created by 张云飞 on 2019/4/30.
//  Copyright © 2019 smyfinancial. All rights reserved.
//

#import "SMYImageTool.h"

@implementation SMYImageTool

+ (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *generateImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return generateImage;
}

+ (UIImage *)createShadowImageWithColor:(UIColor *)color up:(BOOL)bUp size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextSetShadowWithColor(context, CGSizeMake(0, bUp? -1 : 1), size.height, color.CGColor);
    UIRectFill(CGRectMake(0, bUp? (size.height + 1) : (-size.height - 1), size.width, size.height));
    UIImage *generateImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return generateImage;
}

+ (UIImage *)createImageWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    // 创建CGContextRef
    CGRect rect = CGRectMake(0.0f, 0.0f, kWindowWidth, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 创建CGMutablePathRef
    CGMutablePathRef path = CGPathCreateMutable();
    
    // 绘制Path
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPathCloseSubpath(path);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = @[(__bridge id) startColor.CGColor, (__bridge id) endColor.CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    // 具体方向可根据需求修改
    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMidY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMidY(pathRect));
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    // 注意释放CGMutablePathRef
    CGPathRelease(path);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)animateImageWithGifData:(NSData *)data {
    float fDuration = 0.f;
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, nil);
    NSInteger count = CGImageSourceGetCount(source);
    NSMutableArray *arrayImages = [NSMutableArray arrayWithCapacity:count];
    for (NSInteger i = 0; i < count; i++) {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, nil);
        if (image) {
            [arrayImages addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            fDuration += [self frameDurationAtIndex:i source:source];
            CGImageRelease(image);
        }
    }
    CFRelease(source);
    return [UIImage animatedImageWithImages:arrayImages duration:fDuration];
}

/// 获取Gif图片中指定帧的时长
+ (float)frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    if (!cfFrameProperties) {
        return frameDuration;
    }
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp != nil) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    } else {
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp != nil) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}
@end
