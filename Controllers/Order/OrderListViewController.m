//
//  OrderListViewController.m
//  ScrollViewVC
//
//  Created by TreeWriteMac on 16/6/21.
//  Copyright © 2016年 Raykin. All rights reserved.
//

#import "OrderListViewController.h"
//#import "ViewController.h"
//#import "NewCouponsViewController.h"
//#import "UseCouponsViewController.h"
//#import "OverdueCouponsViewController.h"
//#import "CustomViewController.h"
#import "AllOrderListViewController.h"
#import "CompleteOrderListViewController.h"
#import "DistributionOrderListViewController.h"
#import "NewOrderListViewController.h"
#import "ShopViewController.h"
#import "RegisterViewController.h"


//获取控制器的宽高
#define MeH self.view.frame.size.height
#define MeW self.view.frame.size.width

#define IOSVersion                          [[[UIDevice currentDevice] systemVersion] floatValue]
#define IsiOS7Later                         !(IOSVersion < 7.0)
#define ViewOrignY                          (IsiOS7Later?64.0f:44.0f)


@interface OrderListViewController ()


@end

@implementation OrderListViewController

- (void)initWithAddVCARY:(NSArray *)VCS TitleS:(NSArray *)TitleS{
   
    _VCAry                        = VCS;
    _TitleAry                     = TitleS;
     NSLog(@"_TitleAry:%@",_TitleAry);
    self.edgesForExtendedLayout   = UIRectEdgeNone;

        //先初始化各个界面
    UIView *BJView                = [[UIView alloc] initWithFrame:CGRectMake(0, 64, MeW, 40)];
    BJView.backgroundColor        = RGB(234, 235, 236);
        [self.view addSubview:BJView];

    for (int i                    = 0 ; i<_VCAry.count; i++) {
    UIButton *btn                 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame                     = CGRectMake(i*(MeW/_VCAry.count), 0, MeW/_VCAry.count, BJView.frame.size.height-2);
            [btn setTitle:_TitleAry[i] forState:UIControlStateNormal];
            [btn setTitleColor:RGB(35, 38, 40) forState:UIControlStateNormal];
            [btn setTitleColor:RGB(35, 38, 40) forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    btn.tag                       = 1000+i;
            [btn addTarget:self action:@selector(SeleScrollBtn:) forControlEvents:UIControlEventTouchUpInside];
            [BJView addSubview:btn];
        }

    _LineView                     = [[UIView alloc] initWithFrame:CGRectMake(0, BJView.frame.size.height-2, MeW/_VCAry.count, 2)];
    _LineView.backgroundColor     = RGB(35, 38, 40);
        [BJView addSubview:_LineView];
    
//    [self.view addSubview:BJView];
    _MeScroolView                 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, BJView.frame.size.height+24+40, MeW, MeH-BJView.frame.size.height-64)];
    
    _MeScroolView.backgroundColor = [UIColor whiteColor];
    _MeScroolView.pagingEnabled   = YES;
    _MeScroolView.delegate        = self;
        [self.view addSubview:_MeScroolView];

    for (int i2                   = 0; i2<_VCAry.count; i2++) {
    UIView *view                  = [[_VCAry objectAtIndex:i2] view];
    view.frame                    = CGRectMake(i2*MeW, BJView.frame.size.height-40, MeW, _MeScroolView.frame.size.height);
            [_MeScroolView addSubview:view];
            [self addChildViewController:[_VCAry objectAtIndex:i2]];
        }

        [_MeScroolView setContentSize:CGSizeMake(MeW*_VCAry.count, _MeScroolView.frame.size.height)];
NSLog(@"y;%f",_MeScroolView.frame.origin.y);
}

/**
 *  滚动停止调用
 *
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x/scrollView.frame.size.width;
    NSLog(@"当前第几页====%d",index);
    
    /**
     *  此方法用于改变x轴
     */
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = _LineView.frame;
        f.origin.x = index*(MeW/_VCAry.count);
        _LineView.frame = f;
    }];
    
    UIButton *btn = [self.view viewWithTag:1000+index];
    for (UIButton *b in btn.superview.subviews) {
        if ([b isKindOfClass:[UIButton class]]) {
            b.selected = (b==btn)?YES:NO;
        }
    }
    
}

//点击每个按钮然后选中对应的scroolview页面及选中按钮
-(void)SeleScrollBtn:(UIButton*)btn{
    for (UIButton *button in btn.superview.subviews)
    {
        if ([button isKindOfClass:[UIButton class]]) {
            button.selected = (button != btn) ? NO : YES;
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = _LineView.frame;
        f.origin.x = (btn.tag-1000)*(MeW/_VCAry.count);
        _LineView.frame = f;
        _MeScroolView.contentOffset = CGPointMake((btn.tag-1000)*MeW, 0);
    }];
    
    

}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    view.backgroundColor = RGB(35, 38, 40);
    [self.view addSubview:view];
    
    UILabel *hostLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 100, 40)];
    hostLabel.text = @"好当家";
    hostLabel.font = [UIFont systemFontOfSize:17.0f];
    hostLabel.textColor = [UIColor whiteColor];
    [view addSubview:hostLabel];
    
    UIButton *userButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-60, 20, 60, 40)];
    userButton.titleLabel.font = [UIFont systemFontOfSize: 17.0];
    [userButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [userButton setTitle:@"个人" forState:UIControlStateNormal];
    [userButton setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8) ];//将按钮的上下左右都缩进8个单位
    [userButton addTarget:self action:@selector(UserBtnClick:) forControlEvents:UIControlEventTouchUpInside];//为按钮增加时间侦听
    [view addSubview:userButton];

    [self initWithAddVCARY:@[[AllOrderListViewController new],[NewOrderListViewController new],[DistributionOrderListViewController new],[CompleteOrderListViewController new]]TitleS:@[@"全部",@"待发货",@"已发货",@"已收货"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}
- (IBAction)UserBtnClick:(id)sender {
    ShopViewController *sc1= [[ShopViewController alloc]initWithNibName:@"ShopViewController" bundle:[NSBundle mainBundle]];
    sc1.title = @"个人中心";
    [self.navigationController pushViewController:sc1 animated:YES];

}


@end
