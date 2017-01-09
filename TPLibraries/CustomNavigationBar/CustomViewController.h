//
//  CustomViewController.h
//  CustomNavigationBarDemo
//
//  Created by jimple on 14-1-6.
//  Copyright (c) 2014年 Jimple Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalDefine.h"
#import "CustomNaviBarView.h"

@interface CustomViewController : UIViewController

@property (nonatomic, readonly) CustomNaviBarView *m_viewNaviBar;

- (void)bringNaviBarToTopmost;

- (void)hideNaviBarLeftBtn:(BOOL)bIsHide;
- (void)hideNaviBar:(BOOL)bIsHide;
- (void)hideNaviBarUnderLine:(BOOL)bIsHide;
- (void)setNaviBarTitle:(NSString *)strTitle;
- (void)setNaviBarLeftBtn:(UIButton *)btn;
- (void)setNaviBarNearRightBtn:(UIButton *)btn;
- (void)setNaviBarRightBtn:(UIButton *)btn;

- (void)naviBarAddCoverView:(UIView *)view;
- (void)naviBarAddCoverViewOnTitleView:(UIView *)view;
- (void)naviBarRemoveCoverView:(UIView *)view;

// 是否可右滑返回
- (void)navigationCanDragBack:(BOOL)bCanDragBack;


@end
