//
//  SMYContactPicker.m
//  SMYBase
//
//  Created by ChenYong on 2021/11/19.
//  Copyright © 2021 smyfinancial. All rights reserved.
//

#import "SMYContactPicker.h"
#import <ContactsUI/ContactsUI.h>
#import "SMYHUDTool.h"

@interface SMYContactPicker () <CNContactPickerDelegate>

@property(nonatomic, copy) void(^completion)(CNContact *__nullable);

@end

@implementation SMYContactPicker

+ (instancetype)sharedInstance {
    static SMYContactPicker *sharedInstacne = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstacne = [[SMYContactPicker alloc] init];
    });
    return sharedInstacne;
}

- (void)presentInPage:(UIViewController *)page completion:(nullable void(^)(CNContact *__nullable contact))completion {
    if (!page) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        CNContactPickerViewController *picker = [[CNContactPickerViewController alloc] init];
        picker.delegate = self;
        picker.displayedPropertyKeys = @[CNContactPhoneNumbersKey,
                                         CNContactEmailAddressesKey,
                                         CNContactPostalAddressesKey];
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        SMYProgressHUD *hud = [SMYHUDTool showLoadingHUDInView:page.view.window];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.completion = completion;
            [page presentViewController:picker animated:YES completion:^{
                [SMYHUDTool hideHUD:hud];
            }];
        });
    });
}

#pragma mark - CNContactPickerDelegate

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.completion) {
            self.completion(nil);
        }
        self.completion = nil;
    }];
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.completion) {
            self.completion(contact);
        }
        self.completion = nil;
    }];
}

@end
