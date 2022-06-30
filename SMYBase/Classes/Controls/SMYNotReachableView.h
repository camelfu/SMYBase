//
//  SMYNotReachableView.h
//  credit
//
//  Created by zhaojian on 2016/12/1.
//  Copyright © 2016年 smyfinancial. All rights reserved.
//
//  断网空页面

#import <UIKit/UIKit.h>

@protocol SMYNotReachableViewDelegate <NSObject>

/** 重新加载 */
- (void)reloadDidClicked;

@end

@interface SMYNotReachableView : UIView
    
@property (nonatomic, weak) id<SMYNotReachableViewDelegate> delegate;

@end
