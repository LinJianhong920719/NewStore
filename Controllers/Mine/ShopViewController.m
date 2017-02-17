//
//  ShopViewController.m
//  NewStore
//
//  Created by edz on 17/1/9.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import "ShopViewController.h"
#import "RegisterViewController.h"
#import "MyWalletViewController.h"

@interface ShopViewController ()

@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, 5, 38, 38);
    [btn setBackgroundImage:[UIImage imageNamed:@"NaviBtn_Back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goBackAction) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem*back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem=back;
    
    //设置店铺介绍textView高度
    _shopIntroduce.layer.borderColor = [UIColor grayColor].CGColor;
    _shopIntroduce.layer.borderWidth =1.0;
    _shopIntroduce.layer.cornerRadius =5.0;
    _shopIntroduce.editable = NO;
    [self loadData];
}

#pragma mark - 加载数据

- (void)loadData {
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         [UserInformation getUserId],  @"shop_id",
                         nil];
    NSString *url = [PPNetworkHelper requestURL:@"Api/Shop/getInfo?"];
    
    [PPNetworkHelper GET:url parameters:dic responseCache:^(NetworkingResponse *responseCache) {
        
    } success:^(NetworkingResponse *responseObject) {
        
        //接口返回数据
        NSString *status = [responseObject valueForKey:@"status"];
        if ([status integerValue] == 201) {

        }else{
            NSArray *shopInfoArray = [responseObject valueForKey:@"data"];
            
            [_shopImage sd_setImageWithURL:[NSURL URLWithString:[shopInfoArray valueForKey:@"sj_image"]] placeholderImage:[UIImage imageNamed:@"loading-6"] options:SDWebImageRetryFailed];
            _shopName.text = [shopInfoArray valueForKey:@"sj_shop_name"];
            _shopAddress.text = [shopInfoArray valueForKey:@"sj_address"];
            _userName.text = [shopInfoArray valueForKey:@"sj_name"];
            _mobile.text = [shopInfoArray valueForKey:@"sj_phone"];
            _phone.text = [shopInfoArray valueForKey:@"sj_mobile"];
            _wallet.text = @"钱包";
            _distribution.text = @"商家配送";
            _shopIntroduce.text = [shopInfoArray valueForKey:@"sj_intro"];
        }
        
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)goBackAction{
    
    // 在这里增加返回按钮的自定义动作
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginOut:(id)sender {
    
    //退出当前账号
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定登出？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = 101;
    [alert show];
    
    
}

- (IBAction)MyWalletAciont:(id)sender {
    MyWalletViewController * disheView = [[MyWalletViewController alloc]init];
    disheView.title = @"钱包";
    disheView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:disheView animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        //清除用户id
        [UserInformation removeUserInfo];
        
        RegisterViewController * disheView = [[RegisterViewController alloc]init];
        disheView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:disheView animated:YES];
    }
    
}
@end
