//
//  CompleteOrderListViewController.h
//  HDJMerchant
//
//  Created by edz on 17/1/6.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefreshHeaderView.h"
#import "SDRefreshFooterView.h"
//#import "BaseViewController.h"

@interface CompleteOrderListViewController :UIViewController

@property (nonatomic, strong) UITableView* mTableView;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, strong) NSMutableArray* data;
@property (nonatomic ,assign) NSInteger page;

@end
