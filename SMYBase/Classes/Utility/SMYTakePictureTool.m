//
//  SMYTakePictureTool.m
//  credit
//
//  Created by ChenYong on 2018/5/22.
//  Copyright © 2018 smyfinancial. All rights reserved.
//

#import "SMYTakePictureTool.h"
#import <UIKit/UIKit.h>
@interface SMYTakePictureTool () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) void(^didFinishTakePictureHandler)(BOOL bCancelled, UIImage *image, NSDictionary *imageInfo);

@end

@implementation SMYTakePictureTool

+ (instancetype)shareInstance {
    static SMYTakePictureTool *shareInstacne = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstacne = [[SMYTakePictureTool alloc] init];
    });
    return shareInstacne;
}

- (void)presentTakeViewCtlInPage:(UIViewController *)viewCtl
                    setupHandler:(void(^)(UIImagePickerController *))setupHandler
                presentedHandler:(dispatch_block_t)presentedHandler
                 completeHandler:(void(^)(BOOL bCancelled, UIImage *image, NSDictionary *imageInfo))finishHandler {
    if (!viewCtl) {
        return;
    }
    self.didFinishTakePictureHandler = finishHandler;
    UIImagePickerController *pickCtl = [[UIImagePickerController alloc] init];
    pickCtl.allowsEditing = NO;
    if (self.fromPhotoLibrary) {
        pickCtl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        pickCtl.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    pickCtl.modalPresentationStyle = UIModalPresentationFullScreen;
    if (setupHandler) {
        setupHandler(pickCtl);
    }
    pickCtl.delegate = self;
    
    [viewCtl presentViewController:pickCtl animated:YES completion:presentedHandler];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (self.didFinishTakePictureHandler) {
        self.didFinishTakePictureHandler(NO, image, info);
        self.didFinishTakePictureHandler = nil;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.didFinishTakePictureHandler) {
            self.didFinishTakePictureHandler(YES, nil, nil);
            self.didFinishTakePictureHandler = nil;
        }
    }];
}

@end
