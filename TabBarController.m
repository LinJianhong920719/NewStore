//
//  TabBarController.m
//  NewStore
//
//  Created by yusaiyan on 16/5/5.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabbar0:) name:@"TZM_Tabbar_0" object:nil];
    
    [self initMainView];
}

- (void)tabbar0:(NSNotification *)notification {
    self.selectedIndex = 0;
}

- (void)initMainView {
    
    JTNavigationController *nav1 = [[JTNavigationController alloc] initWithRootViewController:[[MainViewController alloc] init]];
    nav1.tabBarItem.image = [[UIImage imageNamed:@"Home_Normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav1.tabBarItem.selectedImage = [[UIImage imageNamed:@"Home_Normal_S"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav1.tabBarItem.title = @"首页";
    nav1.tabBarItem.tag = 1;
    nav1.fullScreenPopGestureEnabled = YES;

    JTNavigationController *nav2 = [[JTNavigationController alloc] initWithRootViewController:[[ClassifyViewController alloc] init]];
    nav2.tabBarItem.image = [[UIImage imageNamed:@"Classification_Normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav2.tabBarItem.selectedImage = [[UIImage imageNamed:@"Classification_Normal_S"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav2.tabBarItem.title = @"分类";
    nav2.tabBarItem.tag = 2;
    nav2.fullScreenPopGestureEnabled = YES;
    
    JTNavigationController *nav3 = [[JTNavigationController alloc] initWithRootViewController:[[ClassifyViewController alloc] init]];
    nav3.tabBarItem.image = [[UIImage imageNamed:@"Cart_Normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav3.tabBarItem.selectedImage = [[UIImage imageNamed:@"Cart_Normal_S"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav3.tabBarItem.title = @"购物车";
    nav3.tabBarItem.tag = 4;
    nav3.fullScreenPopGestureEnabled = YES;
    
    JTNavigationController *nav4 = [[JTNavigationController alloc] initWithRootViewController:[[MineViewController alloc] init]];
    nav4.tabBarItem.image = [[UIImage imageNamed:@"Mine_Normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav4.tabBarItem.selectedImage = [[UIImage imageNamed:@"Mine_Normal_S"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav4.tabBarItem.title = @"我的";
    nav4.tabBarItem.tag = 5;
    nav4.fullScreenPopGestureEnabled = YES;
    
    self.viewControllers = @[nav1, nav2, nav3, nav4];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:COLOR_262626, NSForegroundColorAttributeName, [UIFont systemFontOfSize:10.0f],NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:COLOR_E73C7B, NSForegroundColorAttributeName, [UIFont systemFontOfSize:10.0f],NSFontAttributeName,nil] forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -2)];
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)Item {
    DLog(@"tabBar: %ld", Item.tag);
}

- (void)switchHome {
    self.selectedIndex = 0;
}

- (void)tabBarController:(UITabBarController *)tabBarController willBeginCustomizingViewControllers:(NSArray *)viewControllers {

}

- (void)tabBarController:(UITabBarController *)tabBarController willEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {

}

- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {

}

- (void)viewWillLayoutSubviews {
    
    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
    tabFrame.size.height = Main_TabBarHeight;
    tabFrame.origin.y = self.view.frame.size.height - Main_TabBarHeight;
    self.tabBar.frame = tabFrame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
