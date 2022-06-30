//
//  UITextField+Additions.h
//  shengbei
//
//  Created by 张云飞 on 2019/5/9.
//  Copyright © 2019 smyfinancial. All rights reserved.
//
//  禁止拷贝 复制

#import <UIKit/UIKit.h>

@interface UITextField (Additions)

/**
 是否禁止拷贝 复制
 */
@property (nonatomic, assign, getter=isPrivacy) BOOL privacy;

/**
 是否禁止菜单
 */
@property (nonatomic, assign, getter=isDisableMenu) BOOL disableMenu;

@end


