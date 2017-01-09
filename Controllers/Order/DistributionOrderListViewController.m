//
//  DistributionOrderListViewController.m
//  HDJMerchant
//
//  Created by edz on 17/1/6.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DistributionOrderListViewController.h"
#import "OrderDetailViewController.h"
#import "DistributionOrderEntity.h"
#import "DistributionOrderViewCell.h"

#import "GlobalDefine.h"
#import "PPNetworkHelper.h"
#import "PPNetworkCache.h"

@interface DistributionOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
}

@end

@implementation DistributionOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self initUI];
    _page = 1;
    [self setupHeader];
    [self setupFooter];
}

- (void)initUI {
    
    _data = [[NSMutableArray alloc]init];
    
    _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-105) style:UITableViewStyleGrouped];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.scrollsToTop = YES;
    _mTableView.backgroundColor = RGB(234, 235, 236);
    _mTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:_mTableView];
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    [tableFooterView setBackgroundColor:[UIColor clearColor]];
    _mTableView.tableFooterView = tableFooterView;
    
    _mTableView.sectionHeaderHeight = 42;
    _mTableView.sectionFooterHeight = 10;
    
}

#pragma mark - 加载数据

- (void)loadData {
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                          [NSNumber numberWithInteger:_page],@"page",
                         @"36",  @"shop_id",
                         @"0",@"type",
                         nil];
    NSString *url = [PPNetworkHelper requestURL:@"Api/Order/showOrderInfo?"];
    
    [PPNetworkHelper GET:url parameters:dic responseCache:^(NetworkingResponse *responseCache) {
        
    } success:^(NetworkingResponse *responseObject) {
        if (_page == 1) {
            [_data removeAllObjects];
        }
        //接口返回数据
        NSArray *orderArray = [responseObject valueForKey:@"data"];
        for (NSDictionary *dic in orderArray) {
            DistributionOrderEntity *allOrderEntity = [[DistributionOrderEntity alloc]initWithAttributes:dic];
            [_data addObject:allOrderEntity];
        }
        
        [_mTableView reloadData];
        
    } failure:^(NSError *error) {
    
        
    }];
    

}



#pragma mark - SDRefresh

- (void)setupHeader
{
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshView];
    
    [refreshHeader addToScrollView:_mTableView];
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        _page = 1;
            [self loadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
}
-(void)refeshOrder{
        _page = 1;
        [self loadData];
}


- (void)setupFooter
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:_mTableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}

- (void)footerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _page ++;
                [self loadData];
        [self.refreshFooter endRefreshing];
    });
}

- (void)dealloc
{
    [self.refreshHeader removeFromSuperview];
    [self.refreshFooter removeFromSuperview];
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DistributionOrderViewCell *cell = (DistributionOrderViewCell *)[self tableView:_mTableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DistributionOrderEntity *entity = [_data objectAtIndex:section];
    NSLog(@"rowsCoutn:%ld",[entity.goodInfo count]);
    return [entity.goodInfo count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"_data.count:%ld",_data.count);
    return _data.count;
}
// section 头部间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
// section 尾部间距
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}

// section 头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DistributionOrderEntity *entity = [_data objectAtIndex:section];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *orderNo = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 25)];
    orderNo.text = [NSString stringWithFormat:@"订单编号:%@",entity.orderSn];
    orderNo.textColor = RGB(18, 104, 196);
    orderNo.textAlignment = NSTextAlignmentLeft;
    orderNo.font = [UIFont systemFontOfSize:11.0f];
    [view addSubview:orderNo];
    
    UILabel *orderStatus = [[UILabel alloc]initWithFrame:CGRectMake(orderNo.frame.size.width, 0, ScreenWidth-orderNo.frame.size.width-20, 25)];
    NSString *textStr;
    if ([entity.shippingStatus isEqualToString:@"0"]&&[entity.isCancleOrder isEqualToString:@"0"]) {
        textStr = @"未配送";
    }else if ([entity.shippingStatus isEqualToString:@"1"] && [entity.isCancleOrder isEqualToString:@"0"] && [entity.isDenialOrders isEqualToString:@"0"]){
        textStr = @"配送中";
    }else if ([entity.shippingStatus isEqualToString:@"2"] && [entity.isDenialOrders isEqualToString:@"0"] && [entity.isDiscuss isEqualToString:@"0"]){
        textStr = @"交易完成";
    }
    orderStatus.text = textStr;
    orderStatus.textColor = RGB(18, 104, 196);
    orderStatus.textAlignment = NSTextAlignmentRight;
    orderStatus.font = [UIFont systemFontOfSize:11.0f];
    [view addSubview:orderStatus];
    
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    DistributionOrderEntity *entity = [_data objectAtIndex:section];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 25)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *orderTime = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 180, 25)];
    orderTime.text = [NSString stringWithFormat:@"下单时间:%@",entity.createTime];
    orderTime.textAlignment = NSTextAlignmentLeft;
    orderTime.textColor = RGB(189, 190, 192);
    orderTime.font = [UIFont systemFontOfSize:11.0f];
    [view addSubview:orderTime];
    
    UILabel *allPirce = [[UILabel alloc]initWithFrame:CGRectMake(orderTime.frame.size.width, 0, ScreenWidth-orderTime.frame.size.width-5, 25)];
    NSString *realAmount = entity.realAmount;
    NSString *freightAmount = entity.freightAmount;
    allPirce.text = [NSString stringWithFormat:@"合计:%@ (含运费:%@)",realAmount,freightAmount];
    allPirce.textColor = RGB(189, 190, 192);
    allPirce.textAlignment = NSTextAlignmentRight;
    allPirce.font = [UIFont systemFontOfSize:11.0f];
    [view addSubview:allPirce];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, allPirce.frame.size.height, ScreenWidth, 5)];
    line.backgroundColor = RGB(234, 235, 236);
    [view addSubview:line];
    
    return view;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DistributionOrderViewCell";
    DistributionOrderViewCell *cell = (DistributionOrderViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DistributionOrderViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    DistributionOrderEntity *entity = [_data objectAtIndex:[indexPath section]];
    NSArray *carts = [entity.goodInfo objectAtIndex:[indexPath row]];
    
    //cell渲染
    [cell cellDataDraw:carts];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DistributionOrderEntity *entity = [_data objectAtIndex:[indexPath row]];
    
    
}




//回到tableView后cell的选中情况消失
- (void)viewWillAppear:(BOOL)animated {
    [_mTableView deselectRowAtIndexPath:[_mTableView indexPathForSelectedRow] animated:YES];
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
