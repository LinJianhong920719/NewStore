//
//  RegisterViewController.m
//  NewStore
//
//  Created by edz on 17/1/10.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import "RegisterViewController.h"
#import "OrderListViewController.h"
#import "UserInformation.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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


#pragma mark - 登录接口

- (IBAction)loginBtn:(id)sender {
    [_passWord resignFirstResponder];
    
    
    if (_userName.text.length == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请输入用户名!";
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:1];
        return;
    }
    if (_passWord.text.length == 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请输入密码!";
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:1];
        return;
    }
    
    MBProgressHUD *hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"正在登录...";
    [hud showAnimated:YES];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         _userName.text,  @"name",
                         _passWord.text,@"password",
                         nil];
    NSString *url = [PPNetworkHelper requestURL:@"Api/Shop/login?"];
    
    [PPNetworkHelper POST:url parameters:dic encrypt:NO responseCache:^(NetworkingResponse *responseCache) {
        
        //获取缓存数据
        if (responseCache) {
            
        }
        
    } success:^(NetworkingResponse *responseObject) {
        [hud hideAnimated:YES];
        NSLog(@"result:%@",responseObject.result);
        NSArray *data = responseObject.result;
        [UserInformation setUserID:[data valueForKey:@"shop_id"]];
        OrderListViewController * disheView = [[OrderListViewController alloc]init];
        disheView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:disheView animated:YES];
    } failure:^(NSError *error) {
        [hud hideAnimated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"登录失败";
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:1];
    }];
}


@end
