//
//  MyWalletViewController.m
//  Taozhuma-B2C
//
//  Created by Average on 16/8/27.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "MyWalletViewController.h"
#import "MyWalletEntity.h"
#import "MyWalletCell.h"
#import "WithdrawalViewController.h"

#define Reality_viewHeight ScreenHeight-ViewOrignY-40-50
#define Reality_viewWidth ScreenWidth
#define viewBottom(v)                       (v.frame.origin.y + v.frame.size.height)
#define viewRight(v)                        (v.frame.origin.x + v.frame.size.width)

@interface MyWalletViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    UIView * topsView;
    UITextField *cardNumberField;
    UIButton *cardBtn;
    NSString *type;
    UILabel *money;
}
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic, strong) NSMutableArray* data;
@end

@implementation MyWalletViewController
@synthesize mTableView = _mTableView;
@synthesize data = _data;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refeshData) name:@"refreshByWalletDetail"object:nil];

    [self initUI];
    [self loadData];
    [self setupHeader];
    [self setupFooter];
    _pageno = 1;
    
}

#pragma mark - 初始化UI



- (void)initUI {
    
    _data = [[NSMutableArray alloc]init];
    
    _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ViewOrignY, Reality_viewWidth, ScreenHeight-ViewOrignY) style:UITableViewStylePlain];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.scrollsToTop = YES;
    _mTableView.backgroundColor = self.view.backgroundColor;
    _mTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:_mTableView];
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Reality_viewWidth, 1)];
    [tableFooterView setBackgroundColor:[UIColor clearColor]];
    _mTableView.tableFooterView = tableFooterView;
    
    _mTableView.sectionHeaderHeight = 42;
    _mTableView.sectionFooterHeight = 10;
    //取消scrollview内容自动调整
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initTableHeaderView];
}

- (void)initTableHeaderView {
    
    
    topsView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, Reality_viewWidth, 204)];
    topsView.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, Reality_viewWidth, 20)];
    title.font = [UIFont systemFontOfSize:15];
    title.text = @"账户余额";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = UIColorWithRGBA(102, 102, 102, 1);
    [topsView addSubview: title];
    
    money = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBottom(title), Reality_viewWidth, 40)];
    money.font = [UIFont systemFontOfSize:28];
    money.text = @"0.00元";
    money.textAlignment = NSTextAlignmentCenter;
    money.textColor = UIColorWithRGBA(43, 132, 210, 1);
    [topsView addSubview:money];
    
    UIView *butView = [[UIView alloc]initWithFrame:CGRectMake(0, viewBottom(money)+5, Reality_viewWidth, 90)];
//    butView.backgroundColor = [UIColor greenColor];
    [topsView addSubview:butView];

    
    UIButton *withdrawalBtn = [[UIButton alloc]initWithFrame:CGRectMake(30,5, Reality_viewWidth-60, 40)];
    [withdrawalBtn setTitle:@"提现" forState:UIControlStateNormal];
    withdrawalBtn.backgroundColor = UIColorWithRGBA(43, 132, 210, 1);
    withdrawalBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    withdrawalBtn.titleLabel.textColor = [UIColor whiteColor];
    [withdrawalBtn.layer setMasksToBounds:YES];
    [withdrawalBtn.layer setCornerRadius:2.0]; //设置矩形四个圆角半径
    [withdrawalBtn addTarget:self action:@selector(withdrawal:) forControlEvents:UIControlEventTouchUpInside];
    [butView addSubview:withdrawalBtn];
    
    UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, viewBottom(withdrawalBtn)+10, 200, 20)];
    label1.text = @"注意:用户余额达到100元即可提现";
    label1.font = [UIFont systemFontOfSize:12.0f];
    [butView addSubview:label1];
    
    UIView *butomView = [[UIView alloc]initWithFrame:CGRectMake(0, viewBottom(butView), Reality_viewWidth, 10)];
    butomView.backgroundColor = BGCOLOR_DEFAULT;
    [topsView addSubview:butomView];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, viewBottom(butomView), Reality_viewWidth, 30)];
    label.text = @"往期提现记录";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = UIColorWithRGBA(102, 102, 102, 102);
    label.textAlignment = NSTextAlignmentLeft;
    [topsView addSubview:label];
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, viewBottom(label), Reality_viewWidth, 1)];
    line.backgroundColor = LINECOLOR_DEFAULT;
    [topsView addSubview:line];
    
    
    
    
    _mTableView.tableHeaderView = topsView;
}

#pragma mark - 加载数据

- (void)loadData {
    
    //获取用户余额
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         [UserInformation getUserId],  @"shop_id",
                         nil];
    NSString *url = [PPNetworkHelper requestURL:@"Api/Wallet/ShopWallet?"];
    
    [PPNetworkHelper POST:url parameters:dic encrypt:NO responseCache:^(NetworkingResponse *responseCache) {
        
        //获取缓存数据
        if (responseCache) {
            
        }
        
    } success:^(NetworkingResponse *responseObject) {
        //接口返回数据
        NSString *status = [responseObject valueForKey:@"status"];
        if ([status integerValue] == 201) {
            //显示数据页面
            
        }else if([status integerValue] == 200){
            NSString *amount = [[dic valueForKey:@"data"]valueForKey:@"amount"];
            money.text = [NSString stringWithFormat:@"¥ %@",amount];
        }
    }failure:^(NSError *error) {
        
    }];
    
    //获取余额明细
//    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
//                         [Tools stringForKey:KEY_USER_ID],@"user_id",
//                          [NSNumber numberWithInteger:_pageno], @"pager",
//                         nil];
//    NSString *paths = [NSString stringWithFormat:@"/Api/Wallet/getWalletUserLog?"];
//    NSLog(@"dics:%@",dics);
//    [HYBNetworking updateBaseUrl:SERVICE_URL];
//    [HYBNetworking getWithUrl:paths refreshCache:YES emphasis:NO params:dics success:^(id response) {
//        
//        NSDictionary *dic = response;
//        NSString *statusMsg = [dic valueForKey:@"status"];
//        if([statusMsg intValue] == 4001){
//            //弹框提示获取失败
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = @"获取失败!";
//            hud.yOffset = -50.f;
//            hud.removeFromSuperViewOnHide = YES;
//            [hud hide:YES afterDelay:2];
//            return;
//        }else if([statusMsg intValue] == 200){
//            
//            NSMutableArray *dataArray = [dic valueForKey:@"data"];
//            for (NSDictionary* dic in dataArray) {
//                MyWalletEntity* entity = [[MyWalletEntity alloc]initWithAttributes:dic];
//                [_data addObject:entity];
//            }
//            [_mTableView reloadData];
//
//        }
//        
//    } fail:^(NSError *error) {
//        
//    }];
    
    NSDictionary *dics = [[NSDictionary alloc]initWithObjectsAndKeys:
                         [UserInformation getUserId],  @"shop_id",
                         @"1",@"pager",
                         nil];
    NSString *urls = [PPNetworkHelper requestURL:@"/Api/Wallet/getWalletShopLog?"];
    
    [PPNetworkHelper GET:urls parameters:dics responseCache:^(NetworkingResponse *responseCache) {
        
        //获取缓存数据
        if (responseCache) {
            
        }
        
    } success:^(NetworkingResponse *responseObject) {
        //接口返回数据
        NSString *status = [responseObject valueForKey:@"status"];
        if ([status integerValue] == 201) {
            //显示数据页面
            
        }else if([status integerValue] == 200){
            NSMutableArray *dataArray = [responseObject valueForKey:@"data"];
            for (NSDictionary* dic in dataArray) {
                MyWalletEntity* entity = [[MyWalletEntity alloc]initWithAttributes:dic];
                [_data addObject:entity];
            }
            [_mTableView reloadData];
        }
    }failure:^(NSError *error) {
        
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
            _pageno = 1;
            [self loadData];
            [_mTableView reloadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
//    [refreshHeader beginRefreshing];
}
-(void)refeshData{
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
         _pageno ++;
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
    MyWalletCell *cell = (MyWalletCell *)[self tableView:_mTableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyWalletCell";
    MyWalletCell *cell = (MyWalletCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyWalletCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if ([_data count] > 0) {
        MyWalletEntity *entity = [_data objectAtIndex:[indexPath row]];
        
        if ([entity.message isEqualToString:@"已提现"]) {
            cell.payTitle.textColor = [UIColor greenColor];
        }else if ([entity.message isEqualToString:@"处理中"]){
            cell.payTitle.textColor = [UIColor redColor];
        }
        cell.payTitle.text = entity.message;
        cell.payDate.text = [NSString stringWithFormat:@"提现日期:%@",entity.createTime];
        cell.payMoney.text =[NSString stringWithFormat:@"￥%@",entity.val];
    }
    return cell;
}

- (IBAction)backClick:(id)sender {
    // 返回上页
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//点击键盘上的Return按钮响应的方法
-(IBAction)nextOnKeyboard:(UITextField *)sender{
    [cardNumberField resignFirstResponder];
    
    
}
//充值按钮
-(void)recharge:(UIButton*)btn{
//    RechargeViewController *vc= [[RechargeViewController alloc]initWithNibName:@"RechargeViewController" bundle:[NSBundle mainBundle]];
//    vc.title = @"充值";
//    [self.navigationController pushViewController:vc animated:YES];
}
//提现按钮
-(void)withdrawal:(UIButton*)btn{
    WithdrawalViewController *vc= [[WithdrawalViewController alloc]initWithNibName:@"WithdrawalViewController" bundle:[NSBundle mainBundle]];
    vc.title = @"提现";
    [self.navigationController pushViewController:vc animated:YES];
}

//去掉小数点之后的0；
-(NSString*)removeFloatAllZero:(NSString*)string
{
    //    第二种方法
    NSString * testNumber = string;
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    return outNumber;
}

@end
