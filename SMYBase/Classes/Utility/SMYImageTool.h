//
//  SMYImageTool.h
//  shengbei
//
//  Created by 张云飞 on 2019/4/30.
//  Copyright © 2019 smyfinancial. All rights reserved.
//
// 图片工具类，根据指定的颜色创建图片

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface SMYImageTool : NSObject

/**
 *  UIColor转UIImage
 */
+ (nullable UIImage *)createImageWithColor:(UIColor *)color;

/**
 *  UIColor转UIImage
 */
+ (nullable UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  Shadow转UIImage, bUp来决定shadow的方向
 */
+ (nullable UIImage *)createShadowImageWithColor:(UIColor *)color up:(BOOL)bUp size:(CGSize)size;

/**
 *  UIColor转UIImage 渐变色
 */
+ (nullable UIImage *)createImageWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor;

/// 从Gif格式的数据中加载动画
+ (nullable UIImage *)animateImageWithGifData:(nullable NSData *)data;

@end

NS_ASSUME_NONNULL_END

