//
//  SMYHUDTool.m
//  shengbei
//
//  Created by 张云飞 on 2019/4/30.
//  Copyright © 2019 smyfinancial. All rights reserved.
//

#import "SMYHUDTool.h"
#import "SMYImageTool.h"
#import <objc/runtime.h>

static char *const KeyHudWillHide = "KeyHudWillHide";
static int progressValue = 0;
static CGFloat progressDuration;
static NSTimer *progressTimer;
static SMYProgressHUD *progressHUD;
static NSString *progressText;
static void(^progressHUDDidHideComplettion)();

@implementation SMYHUDTool

+ (SMYProgressHUD *)showLoadingHUDWithTitle:(NSString *)text inView:(UIView*)view {
    if (!view) {
        return nil;
    }
    SMYProgressHUD *hud = objc_getAssociatedObject(view, KeyHudWillHide);
    if (hud) {
        // 有可以重用的，取消其隐藏动作
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideHUDReally:) object:hud];
        objc_setAssociatedObject(hud.superview, KeyHudWillHide, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        hud = [[SMYProgressHUD alloc] initWithView:view];
        hud.margin = 10;
        [view addSubview:hud];
        hud.mode = SMYProgressHUDModeCustomView;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 52, 52)];
        NSString *strPath = [NSBundle.mainBundle pathForResource:@"samow" ofType:@"gif"];
        imageView.image = [SMYImageTool animateImageWithGifData:[NSData dataWithContentsOfFile:strPath]];
        hud.customView = imageView;
    }
    if (text.length > 0) {
        // 设置文字，同时，因为margin由默认的20改为10，因此为了文字显示不太靠近底部，追加一个换行符
        hud.detailsLabelText = [text stringByAppendingString:@"\n"];
    } else {
        hud.detailsLabelText = @"";
    }
    [hud show:YES];
    return hud;
}

+ (SMYProgressHUD *)showLoadingHUDInView:(UIView *)view {
    return [self showLoadingHUDWithTitle:nil inView:view];
}

+ (void)hideHUD:(SMYProgressHUD *)hud {
    if (!hud) {
        return;
    }
    if (hud.superview && !objc_getAssociatedObject(hud.superview, KeyHudWillHide)) {
        // 延时消失，便于重用，避免多个hud连续显示和关闭时闪烁
        objc_setAssociatedObject(hud.superview, KeyHudWillHide, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self performSelector:@selector(hideHUDReally:) withObject:hud afterDelay:0.1];
    } else {
        [self hideHUDReally:hud];
    }
}

+ (void)hideHUDInView:(UIView *)view {
    SMYProgressHUD *hud = nil;
    SMYProgressHUD *hudWillHide = objc_getAssociatedObject(view, KeyHudWillHide);
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[SMYProgressHUD class]] && subview != hudWillHide) {
            hud = (SMYProgressHUD *)subview;
            break;
        }
    }
    [self hideHUD:hud];
}

+ (void)hideHUDReally:(SMYProgressHUD *)hud {
    if (!hud) {
        return;
    }
    if (hud.superview && hud == objc_getAssociatedObject(hud.superview, KeyHudWillHide)) {
        // 不能重用了
        objc_setAssociatedObject(hud.superview, KeyHudWillHide, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:NO];
}

+ (SMYProgressHUD *)showTextHUD:(NSString *)text inView:(UIView *)view maintainTime:(NSTimeInterval)delay block:(void(^)())block {
    if (!text || !view) {
        if (block) {
            block();
        }
        return nil;
    }
    SMYProgressHUD *hud = [[SMYProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.labelText = text;
    hud.mode = SMYProgressHUDModeText;
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    [hud hide:YES afterDelay:delay block:block];
    return hud;
}

+ (SMYProgressHUD *)showTextHUD:(NSString *)text inView:(UIView *)view maintainTime:(NSTimeInterval)delay {
    return [self showTextHUD:text inView:view maintainTime:delay block:nil];
}

+ (SMYProgressHUD *)showDetailTextHUD:(NSString *)text inView:(UIView *)view maintainTime:(NSTimeInterval)delay block:(void(^)())block {
    if (!text || !view) {
        if (block) {
            block();
        }
        return nil;
    }
    SMYProgressHUD *hud = [[SMYProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.detailsLabelText = text;
    hud.mode = SMYProgressHUDModeText;
    hud.userInteractionEnabled = NO;
    [hud show:YES];
    [hud hide:YES afterDelay:delay block:block];
    return hud;
}

+ (SMYProgressHUD *)showDetailTextHUD:(NSString *)text inView:(UIView *)view maintainTime:(NSTimeInterval)delay {
    return [self showDetailTextHUD:text inView:view maintainTime:delay block:nil];
}

+ (SMYProgressHUD *)showProgressHUDWithTitle:(NSString *)text duration:(CGFloat)duration inView:(UIView *)inview {
    if (!text || !inview) {
        return nil;
    }
    progressDuration = duration;
    progressValue = 0;
    if (progressTimer) {
        [progressTimer invalidate];
        progressTimer = nil;
    }
    progressText = text;
    progressTimer = [NSTimer scheduledTimerWithTimeInterval:progressDuration/99.0 target:self selector:@selector(progressTimerAction) userInfo:nil repeats:YES];
    
    progressHUD = [[SMYProgressHUD alloc] initWithView:inview];
    [inview addSubview:progressHUD];
    progressHUD.mode = SMYProgressHUDModeCustomView;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 22)];
    NSString *strPath = [NSBundle.mainBundle pathForResource:@"samow" ofType:@"gif"];
    imageView.image = [SMYImageTool animateImageWithGifData:[NSData dataWithContentsOfFile:strPath]];
    progressHUD.customView = imageView;
    progressHUD.detailsLabelText = [NSString stringWithFormat:@"%@\n%i%%", progressText, progressValue];
    [progressHUD show:YES];
    return progressHUD;
}

+ (void)hideProgressHUD:(void(^)())complete {
    if (progressTimer) {
        [progressTimer invalidate];
        progressTimer = nil;
    }
    progressHUD.detailsLabelText = [NSString stringWithFormat:@"%@\n%i%%", progressText,100];
    progressHUDDidHideComplettion = complete;
    [self performSelector:@selector(hideProgressHUDWithDelay) withObject:nil afterDelay:0.4];
}

+ (void)progressTimerAction {
    progressValue += 1;
    if (progressValue == 99) {
        [progressTimer invalidate];
        progressTimer = nil;
    }
    if (progressHUD) {
        progressHUD.detailsLabelText = [NSString stringWithFormat:@"%@\n%i%%", progressText, progressValue];
    }
}

+ (void)hideProgressHUDWithDelay {
    [progressHUD hide:YES];
    if (progressHUDDidHideComplettion) {
        progressHUDDidHideComplettion();
    }
}

@end
