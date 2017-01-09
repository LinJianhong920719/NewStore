//
//  CartViewController.m
//  NewStore
//
//  Created by yusaiyan on 16/9/23.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "CartViewController.h"
#import "CartCell.h"

@interface CartViewController () <UITableViewDelegate, UITableViewDataSource> {
    BOOL _isHasTabBarController;//是否含有tabbar
}

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *footerViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *footerViewBottom;

@property (strong, nonatomic) IBOutlet UIButton *selectAllBtn;
@property (strong, nonatomic) IBOutlet UILabel *totlePriceLabel;

@property (strong, nonatomic) IBOutlet UIView *cartEmptyView;

@property (strong, nonatomic) IBOutlet UITableView *m_tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *selectedArray;

@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNaviBarTitle:@"购物车"];
    
    _isHasTabBarController = self.hidesBottomBarWhenPushed ? YES : NO;
    
    self.jt_fullScreenPopGestureEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    //当进入购物车的时候判断是否有已选择的商品,有就清空
    //主要是提交订单后再返回到购物车,如果不清空,还会显示
    if (self.selectedArray.count > 0) {
//        for (CartModel *model in self.selectedArray) {
//            model.select = NO;//这个其实有点多余,提交订单后的数据源不会包含这些,保险起见,加上了
//        }
        [self.selectedArray removeAllObjects];
    }

    //初始化显示状态
    _selectAllBtn.selected = NO;
    _totlePriceLabel.text = @"￥0.00";
    
    [self loadData];
}

- (void)customLayout {

    if (_isHasTabBarController) {
        self.footerViewBottom.constant = 0;
    } else {
        [self hideNaviBarLeftBtn:YES];
        self.footerViewBottom.constant = 50;
    }
    
    if (self.dataArray.count > 0) {
        self.cartEmptyView.hidden = YES;
    } else {
        self.cartEmptyView.hidden = NO;
    }
    
}

#pragma mark - 初始化数组

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataArray;
}

- (NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectedArray;
}

#pragma mark - 获取购物车数据

- (void)loadData {

//    for (int i = 0; i < 10; i++) {
//        CartModel *model = [[CartModel alloc]init];
//        
//        model.cart_title = [NSString stringWithFormat:@"测试数据%d",i];
//        model.cart_price = [NSString stringWithFormat:@"%0.1f", (float)(1+arc4random_uniform(40000))/100];
//        model.number = 1+arc4random_uniform(10);
//        model.cart_pic = @"";
//        model.cart_size = @"18*20cm";
//        model.cart_pid = [NSString stringWithFormat:@"1%d",i];
//        model.cart_id = [NSString stringWithFormat:@"10%d",i];
//        
//        [self.dataArray addObject:model];
//    }
//    [self.m_tableView reloadData];
    
    [self customLayout];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         [UserInformation getUserId],          @"uid",
                         nil];
    
    NSString *url = [PPNetworkHelper requestURL:@"tomycart.do?"];
    
    [PPNetworkHelper POST:url parameters:dic encrypt:NO responseCache:^(id responseCache) {
        [self responseData:responseCache];
    } success:^(id responseObject) {
        [self responseData:responseObject];
    } failure:^(NSError *error) {
        [self showHUDText:@"数据加载失败，再刷新一下呗"];
    }];

}

- (void)responseData:(id)data {
    
    [self.dataArray removeAllObjects];
    
    NSArray *result = [data valueForKey:@"result"];
    
    if (result && result.count > 0) {
        for (NSDictionary *dic in result) {
            for (NSDictionary *dics in [dic valueForKey:@"carts"]) {
                CartModel *model = [[CartModel alloc]initWithDictionary:dics];
                [self.dataArray addObject:model];
            }
        }
        [self.m_tableView reloadData];
    }
    
    [self customLayout];
    
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LZCartReusableCell"];
    if (cell == nil) {
        cell = [[CartCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LZCartReusableCell"];
    }
    
    CartModel *model = self.dataArray[indexPath.row];
    __block typeof(cell)wsCell = cell;
    
    [cell CartNumberAddWithBlock:^(NSInteger number) {
        
        if (model.cart_status) {
            
            wsCell.number = number;
            model.number = number;
            
            [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
            if ([self.selectedArray containsObject:model]) {
                [self.selectedArray removeObject:model];
                [self.selectedArray addObject:model];
                [self countPrice];
            }
        }
    }];
    
    [cell CartNumberCutWithBlock:^(NSInteger number) {
        
        if (model.cart_status) {
            
            wsCell.number = number;
            model.number  = number;
            
            [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
            
            //判断已选择数组里有无该对象,有就删除  重新添加
            if ([self.selectedArray containsObject:model]) {
                [self.selectedArray removeObject:model];
                [self.selectedArray addObject:model];
                [self countPrice];
            }
        }
    }];
    
    [cell CartCellSelectedWithBlock:^(BOOL select) {
        
        model.select = select;
        if (select) {
            [self.selectedArray addObject:model];
        } else {
            [self.selectedArray removeObject:model];
        }
        
        if (self.selectedArray.count == self.dataArray.count) {
            _selectAllBtn.selected = YES;
        } else {
            _selectAllBtn.selected = NO;
        }
        
        [self countPrice];

    }];
    
    [cell CartCellClickBlock:^(BOOL select) {
        
        if (model.cart_status) {
            DLog(@"cart_pid == %@", model.cart_pid);
            
            GoodsDetailsViewController *vc = [[GoodsDetailsViewController alloc]init];
            vc.proId = model.cart_pid;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
    [cell CartReloadDataWithModel:model];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品?删除后无法恢复!" preferredStyle:1];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            CartModel *model = [self.dataArray objectAtIndex:indexPath.row];
            
            NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                                 [UserInformation getUserId], @"uid",
                                 model.cart_id,                @"cids",
                                 nil];
            
            NSString *url = [PPNetworkHelper requestURL:@"delCart.do?"];
            
            [PPNetworkHelper POST:url parameters:dic encrypt:NO responseCache:^(id responseCache) {
            } success:^(id responseObject) {
                
                NSString *error_msg = [responseObject valueForKey:@"error_msg"];
                BOOL success = [[responseObject valueForKey:@"success"]boolValue];
                if (success) {
                    
                    [self.dataArray removeObjectAtIndex:indexPath.row];
                    // 删除
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    //判断删除的商品是否已选择
                    if ([self.selectedArray containsObject:model]) {
                        //从已选中删除,重新计算价格
                        [self.selectedArray removeObject:model];
                        [self countPrice];
                    }
                    
                    if (self.selectedArray.count == self.dataArray.count) {
                        _selectAllBtn.selected = YES;
                    } else {
                        _selectAllBtn.selected = NO;
                    }
                    
                    if (self.dataArray.count == 0) {
                        [self customLayout];
                    }
                    
                    //如果删除的时候数据紊乱,可延迟0.5s刷新一下
                    [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.5];
                    
                    if (self.cartNumberBlock) {
                        self.cartNumberBlock(_dataArray.count);
                    }
                    
                } else {
                    [self showHUDText:error_msg];
                }
                
            } failure:^(NSError *error) {
                [self showHUDText:@"请求失败,请稍后重试！"];
            }];

        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okAction];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (void)reloadTable {
    [self.m_tableView reloadData];
}

#pragma mark - 选中统计

/**
 *  计算已选中商品金额
 */
- (void)countPrice {
    double totlePrice = 0.0;
    
    for (CartModel *model in self.selectedArray) {
        
        double price = [model.cart_price doubleValue];
        
        totlePrice += price*model.number;
    }
    NSString *string = [NSString stringWithFormat:@"￥%.2f",totlePrice];
    self.totlePriceLabel.text = string;
}

#pragma mark - 按钮点击事件

- (IBAction)selectAllClick:(UIButton *)button {
    button.selected = !button.selected;
    
    self.selectAllBtn.selected = button.selected;
    
    //点击全选时,把之前已选择的全部删除
    for (CartModel *model in self.selectedArray) {
        model.select = NO;
    }
    
    [self.selectedArray removeAllObjects];
    
    if (button.selected) {
        for (CartModel *model in self.dataArray) {
            //根据状态判断是否勾选
            if (model.cart_status) {
                model.select = YES;
                [self.selectedArray addObject:model];
            }
        }
    }
    
    [self.m_tableView reloadData];
    [self countPrice];
    
}

- (IBAction)goToPayClick:(UIButton *)button {
    if (self.selectedArray.count > 0) {
        
        button.userInteractionEnabled = NO;
        
        NSString *modifyStr = @"";
        NSString *submitStr = @"";
        
        for (CartModel *model in self.selectedArray) {
            modifyStr = [NSString stringWithFormat:@"%@%@:%ld,", modifyStr, model.cart_id, (long)model.number];
            submitStr = [NSString stringWithFormat:@"%@%@,", submitStr, model.cart_id];
        }
        
        if (modifyStr.length > 1) {
            modifyStr = [modifyStr substringToIndex:modifyStr.length - 1];
        }
        if (submitStr.length > 1) {
            submitStr = [submitStr substringToIndex:submitStr.length - 1];
        }
        
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                             [UserInformation getUserId], @"uid",
                             modifyStr,                    @"cids",
                             nil];
        
        NSString *url = [PPNetworkHelper requestURL:@"toEditCart.do?"];
        
        [PPNetworkHelper POST:url parameters:dic encrypt:NO responseCache:^(id responseCache) {
        } success:^(id responseObject) {
            
            NSString *error_msg = [responseObject valueForKey:@"error_msg"];
            BOOL success = [[responseObject valueForKey:@"success"]boolValue];
            if (success) {
                ConfirmOrderViewController *vc = [[ConfirmOrderViewController alloc] init];
                vc.submitStr = submitStr;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [self showHUDText:error_msg];
            }
            
            button.userInteractionEnabled = YES;
        } failure:^(NSError *error) {
            [self showHUDText:@"请求失败,请稍后重试！"];
            button.userInteractionEnabled = YES;
        }];
    
    } else {
        [self showHUDText:@"你还没有选择任何商品"];
    }
}

- (IBAction)goToWalkClick:(UIButton *)button {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    dispatch_async(global_quque, ^{
        dispatch_async(main_queue, ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"TZM_Tabbar_0" object:nil];
        });
    });
    
}

@end
