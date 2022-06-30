//
//  SMYContactPicker.h
//  SMYBase
//
//  Created by ChenYong on 2021/11/19.
//  Copyright © 2021 smyfinancial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMYContactPicker : NSObject

+ (nonnull instancetype)sharedInstance;

- (void)presentInPage:(UIViewController *)page completion:(nullable void(^)(CNContact *__nullable contact))completion;

@end

NS_ASSUME_NONNULL_END
