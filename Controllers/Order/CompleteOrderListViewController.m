//
//  CompleteOrderListViewController.m
//  HDJMerchant
//
//  Created by edz on 17/1/6.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "CompleteOrderListViewController.h"
#import "OrderDetailViewController.h"
#import "CompleteOrderEntity.h"
#import "CompleteOrderViewCell.h"

#import "GlobalDefine.h"
#import "PPNetworkHelper.h"
#import "PPNetworkCache.h"

@interface CompleteOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
}

@end

@implementation CompleteOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self initUI];
    _page = 1;
    [self setupHeader];
    [self setupFooter];
}

- (void)initUI {
    
    _completeOrderData = [[NSMutableArray alloc]init];
    
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
                         [UserInformation getUserId],  @"shop_id",
                         @"3",@"type",
                         nil];
    NSString *url = [PPNetworkHelper requestURL:@"Api/Order/showOrderInfo?"];
    
    [PPNetworkHelper GET:url parameters:dic responseCache:^(NetworkingResponse *responseCache) {
        
    } success:^(NetworkingResponse *responseObject) {
        
        //接口返回数据
        NSString *status = [responseObject valueForKey:@"status"];
        if ([status integerValue] == 201) {
            //显示无订单页面
            [self orederNullView];
        }else{
            NSArray *orderArray = [responseObject valueForKey:@"data"];
            for (NSDictionary *dic in orderArray) {
                CompleteOrderEntity *allOrderEntity = [[CompleteOrderEntity alloc]initWithAttributes:dic];
                [_completeOrderData addObject:allOrderEntity];
            }
            
            [_mTableView reloadData];
        }
        
        
    } failure:^(NSError *error) {
    
        
    }];
}

-(void)orederNullView{
    UIView *orderNullView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    orderNullView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:orderNullView];
    
    UIImageView *orderNullImage = [[UIImageView alloc]initWithFrame:CGRectMake(turn5(117), 110, 90, 90)];
    [orderNullImage setImage:[UIImage imageNamed:@"order_null"]];
    [orderNullView addSubview:orderNullImage];
    UILabel *orderNullLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 210, ScreenWidth, 20)];
    orderNullLabel.text = @"暂无订单";
    orderNullLabel.font = [UIFont systemFontOfSize:15.0f];
    orderNullLabel.textColor = RGB_FONT;
    orderNullLabel.textAlignment = NSTextAlignmentCenter;
    [orderNullView addSubview:orderNullLabel];
    
    UIButton *readloadDataBtn = [[UIButton alloc]initWithFrame:CGRectMake(turn5(105), 250, 120, 30)];
    [readloadDataBtn setTitle:@"刷新订单页面" forState:UIControlStateNormal];
    [readloadDataBtn setTitleColor:RGB_FONT forState:UIControlStateNormal];
    readloadDataBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [readloadDataBtn.layer setMasksToBounds:YES];
    [readloadDataBtn.layer setCornerRadius:6.0]; //设置矩形四个圆角半径
    [readloadDataBtn.layer setBorderWidth:1.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 102.0f/255.0f, 102.0f/255.0f, 102.0f/255.0f, 1 });
    [readloadDataBtn addTarget:self action:@selector(refeshOrder) forControlEvents:UIControlEventTouchUpInside];
    
    [readloadDataBtn.layer setBorderColor:colorref];//边框颜色
    
    [orderNullView addSubview:readloadDataBtn];
    
    
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
            [_mTableView reloadData];
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
    CompleteOrderViewCell *cell = (CompleteOrderViewCell *)[self tableView:_mTableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CompleteOrderEntity *entity = [_completeOrderData objectAtIndex:section];
    NSLog(@"rowsCoutn:%ld",[entity.goodInfo count]);
    return [entity.goodInfo count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"_completeOrderData.count:%ld",_completeOrderData.count);
    return _completeOrderData.count;
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
    CompleteOrderEntity *entity = [_completeOrderData objectAtIndex:section];
    
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
    
    CompleteOrderEntity *entity = [_completeOrderData objectAtIndex:section];
    
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
    static NSString *CellIdentifier = @"CompleteOrderViewCell";
    CompleteOrderViewCell *cell = (CompleteOrderViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CompleteOrderViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    CompleteOrderEntity *entity = [_completeOrderData objectAtIndex:[indexPath section]];
    NSArray *carts = [entity.goodInfo objectAtIndex:[indexPath row]];
    
    //cell渲染
    [cell cellDataDraw:carts];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CompleteOrderEntity *entity = [_completeOrderData objectAtIndex:[indexPath row]];
    
    
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
