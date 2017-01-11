//
//  OrderDetailViewController.m
//  HaoDangJiaMerchant
//
//  Created by edz on 17/1/6.
//  Copyright © 2017年 hdj. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailViewCell.h"
#import "OrderEntity.h"
#import "OrderDetailEntity.h"

@interface OrderDetailViewController (){
    OrderDetailEntity *orderDetailEntity;
}

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, 5, 38, 38);
    [btn setBackgroundImage:[UIImage imageNamed:@"NaviBtn_Back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackAction) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem*back=[[UIBarButtonItem alloc]initWithCustomView:btn];

    self.navigationItem.leftBarButtonItem=back;
    [self initUI];
    [self loadData];
}

- (void)initUI {
    
    _data = [[NSMutableArray alloc]init];
    _ortherInfo = [[NSMutableArray alloc]init];
    
    _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
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
    [_data removeAllObjects];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         _orderID,@"order_total_id",
                         [UserInformation getUserId],  @"shop_id",
                         nil];
    NSString *url = [PPNetworkHelper requestURL:@"Api/Order/showOrderDetail?"];
    
    [PPNetworkHelper GET:url parameters:dic responseCache:^(NetworkingResponse *responseCache) {
        
    } success:^(NetworkingResponse *responseObject) {

        //接口返回数据
        NSString *status = [responseObject valueForKey:@"status"];
        if ([status integerValue] == 200) {
            
            NSDictionary *orderData = [responseObject valueForKey:@"data"];
             orderDetailEntity = [[OrderDetailEntity alloc]initWithAttributes:orderData];
            
            NSArray *orderArray = [orderData valueForKey:@"good_info"];
            for (NSDictionary *dic in orderArray) {
                OrderEntity *orderEntity = [[OrderEntity alloc]initWithAttributes:dic];
                [_data addObject:orderEntity];
            }
            
            _addressInfo = orderDetailEntity.addressInfo;
            _couponInfo = orderDetailEntity.couponInfo;
            _orderInfo = orderDetailEntity.orderInfo;
            NSLog(@"_orderInfo1:%@",_orderInfo);
            
            [_mTableView reloadData];
        }
    } failure:^(NSError *error) {
        
        
    }];
    
    
}
#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderDetailViewCell *cell = (OrderDetailViewCell *)[self tableView:_mTableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_data count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
// section 头部间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 85;
}
// section 尾部间距
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 385;
}

// section 头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *orderNo = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 25)];
    orderNo.text = [NSString stringWithFormat:@"订单编号:%@",orderDetailEntity.orderSn];
    orderNo.textColor = RGB(18, 104, 196);
    orderNo.textAlignment = NSTextAlignmentLeft;
    orderNo.font = [UIFont systemFontOfSize:11.0f];
    [view addSubview:orderNo];
    
    UILabel *orderStatus = [[UILabel alloc]initWithFrame:CGRectMake(orderNo.frame.size.width, 0, ScreenWidth-orderNo.frame.size.width-20, 25)];
    NSString *textStr;
    NSLog(@"_orderInfo:%@",_orderInfo);
    if ([[_orderInfo valueForKey:@"shipping_status"] isEqualToString:@"0"]&&[[_orderInfo valueForKey:@"is_cancel_order"] isEqualToString:@"0"]) {
        textStr = @"未配送";
    }else if ([[_orderInfo valueForKey:@"shipping_status"] isEqualToString:@"1"] && [[_orderInfo valueForKey:@"is_cancel_order"] isEqualToString:@"0"] && [[_orderInfo valueForKey:@"is_denial_orders"] isEqualToString:@"0"]){
        textStr = @"配送中";
    }else if ([[_orderInfo valueForKey:@"shipping_status"] isEqualToString:@"2"] && [[_orderInfo valueForKey:@"is_denial_orders"] isEqualToString:@"0"] && [[_orderInfo valueForKey:@"is_discuss"] isEqualToString:@"0"]){
        textStr = @"交易完成";
    }
    orderStatus.text = textStr;
    orderStatus.textColor = RGB(18, 104, 196);
    orderStatus.textAlignment = NSTextAlignmentRight;
    orderStatus.font = [UIFont systemFontOfSize:11.0f];
    [view addSubview:orderStatus];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(5, ViewBottom(orderStatus), ScreenWidth-10, 1)];
    line.backgroundColor = RGB(234, 235, 236);
    [view addSubview: line];
    
    //地址view
    UIView *addressView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewBottom(line), ScreenWidth, 60)];
    addressView.backgroundColor =[UIColor whiteColor];
    [view addSubview:addressView];
    //地址图标
    UIImageView *addImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 18, 27)];
    [addImage setImage:[UIImage imageNamed:@"shop_positon"]];
    [addressView addSubview:addImage];
    
    //收货人姓名
    UILabel *userNameLab = [[UILabel alloc]initWithFrame:CGRectMake(ViewRight(addImage)+10, 5, 60, 20)];
    userNameLab.text = [_addressInfo valueForKey:@"guest_name"];
    
    userNameLab.textAlignment = NSTextAlignmentLeft;
    userNameLab.font = [UIFont systemFontOfSize:12.0f];
    userNameLab.textColor = FONT_COLOR;
    [addressView addSubview:userNameLab];
    
    //收货人手机号码
    UILabel *userPhoneLab = [[UILabel alloc]initWithFrame:CGRectMake(ViewRight(userNameLab), 5, ScreenWidth-userNameLab.frame.size.width-addImage.frame.size.width-40, 20)];
    userPhoneLab.text = [_addressInfo valueForKey:@"mobile"];
    userPhoneLab.textAlignment = NSTextAlignmentRight;
    userPhoneLab.font = [UIFont systemFontOfSize:12.0f];
    userPhoneLab.textColor = FONT_COLOR;
    [addressView addSubview:userPhoneLab];
    
    //收货人地址
    UILabel *userAddressLab = [[UILabel alloc]initWithFrame:CGRectMake(ViewRight(addImage)+10, ViewBottom(userNameLab)+5, ScreenWidth-addImage.frame.size.width, 20)];
    userAddressLab.text = [_addressInfo valueForKey:@"address"];
    userAddressLab.textAlignment = NSTextAlignmentLeft;
    userAddressLab.font = [UIFont systemFontOfSize:12.0f];
    userAddressLab.textColor = FONT_COLOR;
    [addressView addSubview:userAddressLab];
 
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 25)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    //商品总价
    UILabel *realAmount = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 90, 25)];
    realAmount.text = @"商品总价";
    realAmount.textAlignment = NSTextAlignmentLeft;
    realAmount.textColor = RGB(189, 190, 192);
    realAmount.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:realAmount];
    
    UILabel *realAmountText = [[UILabel alloc]initWithFrame:CGRectMake(realAmount.frame.size.width, 10, ScreenWidth-realAmount.frame.size.width-25, 25)];
    realAmountText.text = [NSString stringWithFormat:@"%@",[_orderInfo valueForKey:@"real_amount"]];
    realAmountText.textColor = RGB(189, 190, 192);
    realAmountText.textAlignment = NSTextAlignmentLeft;
    realAmountText.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:realAmountText];
    
    //配送费
    UILabel *freightAmount = [[UILabel alloc]initWithFrame:CGRectMake(10, ViewBottom(realAmount)+5, 90, 25)];
    freightAmount.text = @"配送费";
    freightAmount.textAlignment = NSTextAlignmentLeft;
    freightAmount.textColor = RGB(189, 190, 192);
    freightAmount.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:freightAmount];
    
    UILabel *freightAmountText = [[UILabel alloc]initWithFrame:CGRectMake(freightAmount.frame.size.width, ViewBottom(realAmountText)+5, ScreenWidth-realAmount.frame.size.width-25, 25)];
    freightAmountText.text = [NSString stringWithFormat:@"%@",[_orderInfo valueForKey:@"freight_amount"]];
    freightAmountText.textColor = RGB(189, 190, 192);
    freightAmountText.textAlignment = NSTextAlignmentLeft;
    freightAmountText.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:freightAmountText];
    
    //订单总价
    UILabel *orderAmount = [[UILabel alloc]initWithFrame:CGRectMake(10, ViewBottom(freightAmount)+5, 90, 25)];
    orderAmount.text = @"订单总价";
    orderAmount.textAlignment = NSTextAlignmentLeft;
    orderAmount.textColor = RGB(189, 190, 192);
    orderAmount.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:orderAmount];
    
    UILabel *orderAmountText = [[UILabel alloc]initWithFrame:CGRectMake(orderAmount.frame.size.width, ViewBottom(freightAmountText)+5, ScreenWidth-orderAmount.frame.size.width-25, 25)];
    orderAmountText.text = [NSString stringWithFormat:@"%@",[_orderInfo valueForKey:@"real_amount"]];
    orderAmountText.textColor = RGB(189, 190, 192);
    orderAmountText.textAlignment = NSTextAlignmentLeft;
    orderAmountText.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:orderAmountText];
    
    //实付款
    UILabel *payAmount = [[UILabel alloc]initWithFrame:CGRectMake(10, ViewBottom(orderAmount)+5, 90, 25)];
    payAmount.text = @"实付款";
    payAmount.textAlignment = NSTextAlignmentLeft;
    payAmount.textColor = RGB(189, 190, 192);
    payAmount.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:payAmount];
    
    UILabel *payAmountText = [[UILabel alloc]initWithFrame:CGRectMake(payAmount.frame.size.width, ViewBottom(orderAmountText)+5, ScreenWidth-payAmount.frame.size.width-25, 25)];
    payAmountText.text = [NSString stringWithFormat:@"%@",[_orderInfo valueForKey:@"real_amount"]];
    payAmountText.textColor = RGB(189, 190, 192);
    payAmountText.textAlignment = NSTextAlignmentLeft;
    payAmountText.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:payAmountText];
    
    //支付类型
    UILabel *tradeType = [[UILabel alloc]initWithFrame:CGRectMake(10, ViewBottom(payAmount)+5, 90, 25)];
    tradeType.text = @"支付类型";
    tradeType.textAlignment = NSTextAlignmentLeft;
    tradeType.textColor = RGB(189, 190, 192);
    tradeType.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:tradeType];
    
    UILabel *tradeTypeText = [[UILabel alloc]initWithFrame:CGRectMake(tradeType.frame.size.width, ViewBottom(payAmountText)+5, ScreenWidth-tradeType.frame.size.width-25, 25)];
    if ([orderDetailEntity.tradeType integerValue] == 1) {
       tradeTypeText.text = @"支付宝支付";
    }else if ([orderDetailEntity.tradeType integerValue] == 2){
         tradeTypeText.text = @"微信支付";
    }
    tradeTypeText.textColor = RGB(189, 190, 192);
    tradeTypeText.textAlignment = NSTextAlignmentLeft;
    tradeTypeText.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:tradeTypeText];
    
    //下单时间
    UILabel *createTime = [[UILabel alloc]initWithFrame:CGRectMake(10, ViewBottom(tradeType)+5, 90, 25)];
    createTime.text = @"下单时间";
    createTime.textAlignment = NSTextAlignmentLeft;
    createTime.textColor = RGB(189, 190, 192);
    createTime.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:createTime];
    
    UILabel *createTimeText = [[UILabel alloc]initWithFrame:CGRectMake(createTime.frame.size.width, ViewBottom(tradeTypeText)+5, ScreenWidth-createTime.frame.size.width-25, 25)];
    createTimeText.text = [NSString stringWithFormat:@"%@",[_orderInfo valueForKey:@"create_time"]];
    createTimeText.textColor = RGB(189, 190, 192);
    createTimeText.textAlignment = NSTextAlignmentLeft;
    createTimeText.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:createTimeText];
    
    //发货时间
    UILabel *sendTime = [[UILabel alloc]initWithFrame:CGRectMake(10, ViewBottom(createTime)+5, 90, 25)];
    sendTime.text = @"发货时间";
    sendTime.textAlignment = NSTextAlignmentLeft;
    sendTime.textColor = RGB(189, 190, 192);
    sendTime.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:sendTime];
    
    UILabel *sendTimeText = [[UILabel alloc]initWithFrame:CGRectMake(sendTime.frame.size.width, ViewBottom(createTimeText)+5, ScreenWidth-sendTime.frame.size.width-25, 25)];
    sendTimeText.text = [NSString stringWithFormat:@"%@",[_orderInfo valueForKey:@"send_time"]];
    sendTimeText.textColor = RGB(189, 190, 192);
    sendTimeText.textAlignment = NSTextAlignmentLeft;
    sendTimeText.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:sendTimeText];
    
    //收货时间
    UILabel *acceptTime = [[UILabel alloc]initWithFrame:CGRectMake(10, ViewBottom(sendTime)+5, 90, 25)];
    acceptTime.text = @"收货时间";
    acceptTime.textAlignment = NSTextAlignmentLeft;
    acceptTime.textColor = RGB(189, 190, 192);
    acceptTime.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:acceptTime];
    
    UILabel *acceptTimeText = [[UILabel alloc]initWithFrame:CGRectMake(acceptTime.frame.size.width, ViewBottom(sendTimeText)+5, ScreenWidth-acceptTime.frame.size.width-25, 25)];
    acceptTimeText.text = [NSString stringWithFormat:@"%@",[_orderInfo valueForKey:@"accept_time"]];
    acceptTimeText.textColor = RGB(189, 190, 192);
    acceptTimeText.textAlignment = NSTextAlignmentLeft;
    acceptTimeText.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:acceptTimeText];
   
    //用户留言
    UILabel *userRemark = [[UILabel alloc]initWithFrame:CGRectMake(10, ViewBottom(acceptTime)+5, 90, 25)];
    userRemark.text = @"用户留言";
    userRemark.textAlignment = NSTextAlignmentLeft;
    userRemark.textColor = RGB(189, 190, 192);
    userRemark.font = [UIFont systemFontOfSize:13.0f];
    [view addSubview:userRemark];
   
    
    UITextView *textview = [[UITextView alloc] initWithFrame:CGRectMake(userRemark.frame.size.width, ViewBottom(acceptTimeText)+5, ScreenWidth-userRemark.frame.size.width-25, 65)];
    textview.backgroundColor=[UIColor whiteColor]; //背景色
    textview.scrollEnabled = NO;    //当文字超过视图的边框时是否允许滑动，默认为“YES”
    textview.editable = NO;        //是否允许编辑内容，默认为“YES”
    textview.font=[UIFont fontWithName:@"Arial" size:13.0]; //设置字体名字和字体大小;
    textview.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
    textview.textColor = RGB(189, 190, 192);
    textview.text = [_orderInfo valueForKey:@"user_remark"];//设置显示的文本内容
    textview.layer.borderColor = RGB(18, 104, 196).CGColor;
    textview.layer.borderWidth = 1.0;
    textview.layer.cornerRadius = 5.0;
    [view addSubview:textview];
    
    
    UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, ViewBottom(textview)+10, ScreenWidth, 60)];
    btnView.backgroundColor =RGBA(229, 230, 231, 0.8);
    [view addSubview:btnView];
    
    //发货按钮
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.backgroundColor=RGB(18, 104, 196);
    sendBtn.frame = CGRectMake(turn5(15), 10, turn5(90), 40);
    [sendBtn setTitle:@"发货" forState:UIControlStateNormal];
    [sendBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
    sendBtn.layer.cornerRadius = 5;
    [sendBtn addTarget:self action:@selector(sendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:sendBtn];
    
    //拒绝按钮
    UIButton *refuseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refuseBtn.backgroundColor=RGB(18, 104, 196);
    refuseBtn.frame = CGRectMake(ViewRight(sendBtn)+turn5(10), 10, turn5(90), 40);
    [refuseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    [refuseBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
    refuseBtn.layer.cornerRadius = 5;
    [refuseBtn addTarget:self action:@selector(refuseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:refuseBtn];
    
    //联系买家按钮
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    callBtn.backgroundColor=RGB(18, 104, 196);
    callBtn.frame = CGRectMake(ViewRight(refuseBtn)+turn5(10), 10, turn5(90), 40);
    [callBtn setTitle:@"联系买家" forState:UIControlStateNormal];
    [callBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
    callBtn.layer.cornerRadius = 5;
    [callBtn addTarget:self action:@selector(callBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:callBtn];
    
    if([[_orderInfo valueForKey:@"shipping_status"] isEqualToString:@"1"] && [[_orderInfo valueForKey:@"is_cancel_order"] isEqualToString:@"0"] && [[_orderInfo valueForKey:@"is_denial_orders"] isEqualToString:@"0"])
    {
        sendBtn.backgroundColor = [UIColor grayColor];
        sendBtn.enabled =NO;
        
        refuseBtn.backgroundColor = [UIColor grayColor];
        refuseBtn.enabled =NO;
        
    }
    
    
    return view;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"OrderDetailViewCell";
    OrderDetailViewCell *cell = (OrderDetailViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderDetailViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    OrderEntity *entity = [_data objectAtIndex:[indexPath row]];
    
    //cell渲染
    [cell cellDataDraw:entity];
    
    return cell;
}

//发货
-(IBAction)sendBtnClicked:(id)sender{
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         _orderID,@"order_total_id",
                         orderDetailEntity.userId,@"user_id",
                         [UserInformation getUserId],  @"shop_id",
                         @"1",@"status",
                         nil];
    NSString *url = [PPNetworkHelper requestURL:@"Api/Shop/updStatus?"];
    
    [PPNetworkHelper GET:url parameters:dic responseCache:^(NetworkingResponse *responseCache) {
        
    } success:^(NetworkingResponse *responseObject) {
        
        //接口返回数据
        NSString *status = [responseObject valueForKey:@"status"];
        if ([status integerValue] == 200) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"发货成功!";
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES afterDelay:2];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrder" object:nil];  //通知购物车页面刷新
            
            [self performSelector:@selector(backClick:) withObject:nil afterDelay:1.0];
            
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"发货失败!";
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES afterDelay:2];
            return ;
        }
    } failure:^(NSError *error) {
        
        
    }];
}


//拒绝
-(IBAction)refuseBtnClicked:(id)sender{
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         _orderID,@"order_total_id",
                         orderDetailEntity.userId,@"user_id",
                         [UserInformation getUserId],  @"shop_id",
                         @"4",@"status",
                         nil];
    NSString *url = [PPNetworkHelper requestURL:@"Api/Shop/updStatus?"];
    
    [PPNetworkHelper GET:url parameters:dic responseCache:^(NetworkingResponse *responseCache) {
        
    } success:^(NetworkingResponse *responseObject) {
        
        //接口返回数据
        NSString *status = [responseObject valueForKey:@"status"];
        if ([status integerValue] == 200) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"拒单成功!";
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES afterDelay:2];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrder" object:nil];  //通知购物车页面刷新
            
            [self performSelector:@selector(backClick:) withObject:nil afterDelay:1.0];
            
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"拒单失败!";
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES afterDelay:2];
            return ;
        }
    } failure:^(NSError *error) {
        
        
    }];
}
//联系买家
-(IBAction)callBtnClicked:(id)sender{
//    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",[_addressInfo valueForKey:@"mobile"]];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"1008611"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)goBackAction{
    // 在这里增加返回按钮的自定义动作
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
