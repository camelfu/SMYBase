//
//  SMYTakePictureTool.h
//  credit
//
//  Created by ChenYong on 2018/5/22.
//  Copyright © 2018 smyfinancial. All rights reserved.
//
// 从相册选择一张照片或者用摄像头拍摄
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SMYTakePictureTool : NSObject

/** 是否是从相册中选取，NO:从摄像头拍摄 */
@property (nonatomic, assign) BOOL fromPhotoLibrary;

+ (nonnull instancetype)shareInstance;

- (void)presentTakeViewCtlInPage:(nullable UIViewController *)viewCtl
                    setupHandler:(nullable void(^)(UIImagePickerController *__nullable))setupHandler
                presentedHandler:(nullable dispatch_block_t)presentedHandler
                 completeHandler:(nullable void(^)(BOOL bCancelled, UIImage *__nullable image, NSDictionary *__nullable imageInfo))finishHandler;

@end
