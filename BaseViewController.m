//
//  BaseViewController.m
//  NewStore
//
//  Created by yusaiyan on 16/5/6.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (strong, nonatomic) UIView *noProView;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    self.view.backgroundColor = ColorFromHex(0xF4F8FB);
    
    [PPNetworkHelper networkStatusWithBlock:^(PPNetworkStatus status) {
        DLog(@"webStatus == %ld", (unsigned long)status);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self bringNaviBarToTopmost];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self hudWasHidden];
}

#pragma mark 登录识别及回调

- (void)signInPageJump:(successCallback)success {
    
    if ([UserInformation userLogin]) {
        success();
    } else {
//        SignInViewController *vc = [[SignInViewController alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//        vc.successCallback = ^{
//            //登录成功
            success();
//        };
    }
    
}

#pragma mark - MJRefresh

- (MJRefreshGifHeader *)header {
    if (!_header) {
        
        NSArray *idleImages = @[[UIImage imageNamed:@"mj_arrow_down"]];
        NSArray *pullingImages = @[[UIImage imageNamed:@"mj_arrow_up"]];
        NSArray *refreshingImages = @[[UIImage imageNamed:@"mj_refreshing_01"], [UIImage imageNamed:@"mj_refreshing_02"], [UIImage imageNamed:@"mj_refreshing_03"], [UIImage imageNamed:@"mj_refreshing_04"]];
        
        _header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        [_header setImages:idleImages forState:MJRefreshStateIdle];
        [_header setImages:pullingImages forState:MJRefreshStatePulling];
        [_header setImages:refreshingImages forState:MJRefreshStateRefreshing];
        _header.lastUpdatedTimeLabel.hidden = YES;
        _header.stateLabel.hidden = YES;
    }
    return _header;
}

- (void)loadNewData {

}

- (MJRefreshAutoNormalFooter *)footer {
    if (!_footer) {
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        [_footer setTitle:@"" forState:MJRefreshStateIdle];
        [_footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
        [_footer setTitle:@"已显示全部" forState:MJRefreshStateNoMoreData];
        _footer.stateLabel.font = [UIFont systemFontOfSize:13];
        _footer.stateLabel.textColor = [UIColor grayColor];
    }
    return _footer;
}

- (void)loadMoreData {
    
}

#pragma mark - MBProgressHUDDelegate methods

- (void)showHUDText:(NSString *)text {
    [self showHUDText:text afterDelay:1];
}

- (void)showHUDText:(NSString *)text afterDelay:(NSTimeInterval)delay {
    
    if (text && text.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = text;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:delay];
    }
    
}

- (void)showHUDAnimatedText:(NSString *)text {
    [self hudWasHidden];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    HUD.label.text = text;
    HUD.userInteractionEnabled = NO;
    [HUD showAnimated:YES];
}

- (void)hudWasHidden {
    [HUD removeFromSuperview];
    HUD = nil;
}

#pragma mark

- (NSArray<UIViewController *> *)rootViewControllers {
    return self.jt_navigationController.jt_viewControllers;
}
#pragma mark - 无商品示意图

- (UIView *)noProView {
    if (!_noProView) {
        _noProView = [[UIView alloc]init];
        _noProView.userInteractionEnabled = NO;
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font  = [UIFont systemFontOfSize:17];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = RGB(140,140,140);
        titleLabel.text  = @"暂无相关商品";
        [self.noProView addSubview:titleLabel];

        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.noProView.mas_centerX).with.offset(0);
            make.centerY.equalTo(self.noProView.mas_centerY).with.offset(0);
            //            make.top.equalTo(emptyIV.mas_bottom).with.offset(30);
            make.width.mas_equalTo(self.noProView.mas_width);
            make.height.mas_equalTo(20);
        }];
    }
    return _noProView;
}

- (void)openNPVWith:(UIView *)superView {
    self.noProView.hidden = NO;
    
    self.noProView.width = superView.width;
    self.noProView.height = superView.height;
    [superView addSubview:self.noProView];
    
}

- (void)closeNPV {
    self.noProView.hidden = YES;
}

@end
