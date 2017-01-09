//
//  BaseViewController.h
//  NewStore
//
//  Created by yusaiyan on 16/5/6.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "CustomViewController.h"

typedef void(^successCallback)();

@interface BaseViewController : CustomViewController <MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) MJRefreshGifHeader *header;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;


/**
 *  触发登录窗口
 *
 *  @param success 登录成功回调
 */
- (void)signInPageJump:(successCallback)success;

#pragma mark HUD

/**
 *  提示框
 *
 *  @param text  提示语
 *  @param delay 停留时间
 */
- (void)showHUDText:(NSString *)text;
- (void)showHUDText:(NSString *)text afterDelay:(NSTimeInterval)delay;

/**
 *  指示器HUD
 *
 *  @param text 提示语
 */
- (void)showHUDAnimatedText:(NSString *)text;

/**
 *  关闭HUD
 */
- (void)hudWasHidden;

#pragma mark

- (NSArray<UIViewController *> *)rootViewControllers;

#pragma mark -

/**
 *  添加无商品示意图
 */
- (void)openNPVWith:(UIView *)superView;
- (void)closeNPV;

@end
