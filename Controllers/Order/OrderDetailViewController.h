//
//  OrderDetailViewController.h
//  HaoDangJiaMerchant
//
//  Created by edz on 17/1/6.
//  Copyright © 2017年 hdj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView* mTableView;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, strong) NSMutableArray* data;
@property (nonatomic, strong) NSArray* addressInfo;
@property (nonatomic, strong) NSArray* couponInfo;
@property (nonatomic, strong) NSArray* orderInfo;
@property (nonatomic, strong) NSMutableArray* ortherInfo;
@property (nonatomic, strong) NSString *orderID;

@end
