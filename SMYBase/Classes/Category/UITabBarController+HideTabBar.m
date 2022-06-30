//
//  UITabBarController+HideTabBar.m
//  shengbei
//
//  Created by ChenYong on 2019/2/18.
//  Copyright © 2019 smyfinancial. All rights reserved.
//

#import "UITabBarController+HideTabBar.h"

@implementation UITabBarController (HideTabBar)

- (void)hideTabbar:(BOOL)bHide {
    UINavigationController *navCtl = self.selectedViewController;
    if (![navCtl isKindOfClass:[UINavigationController class]]) {
        return;
    }
    NSMutableArray *aryViewCtls = [NSMutableArray arrayWithArray:navCtl.viewControllers];
    [(UIViewController *)aryViewCtls.lastObject setHidesBottomBarWhenPushed:bHide];
    UIViewController *viewCtl = [[UIViewController alloc] init];
    viewCtl.hidesBottomBarWhenPushed = bHide;
    [aryViewCtls addObject:viewCtl];
    [navCtl setViewControllers:aryViewCtls animated:NO];
    [aryViewCtls removeObject:viewCtl];
    [navCtl setViewControllers:aryViewCtls animated:NO];
}

@end
