//
//  PaymentModel.m
//  GroupPurchase
//
//  Created by yusaiyan on 16/10/9.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "PaymentModel.h"

@implementation PaymentModel

- (id)initWithDicctionary:(NSDictionary*)dic paymentType:(NSString *)type {
    
    self = [super init];
    if (self) {
        
        self.paymentType = type;
        
        //支付宝支付
        if ([type isEqual:@"1"]) {
            [self apliPay:dic];
        }
        
        //微信支付
        if ([type isEqual:@"2"]) {
            [self weixinPay:dic];
        }
        
    }
    return self;
    
}

/**
 *  调起支付宝支付
 *
 *  @param dic  支付信息
 */
- (void)apliPay:(NSDictionary *)dic {
    DLog(@"apliPay == %@", dic);
    NSString *outTradeNo = [dic valueForKey:@"out_trade_no"];
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"ruiyuxinshangcheng";
    //签名成功后拼接的订单字符串
    NSString *orderString = [dic valueForKey:@"sign"];
    
    if (orderString != nil) {
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            DLog(@"reslut = %@",resultDic);
            
            NSString *memo = [resultDic valueForKey:@"memo"];
            NSString *resultStatus = [resultDic valueForKey:@"resultStatus"];
            
            NSString *strTitle = [NSString stringWithFormat:@"支付结果"];
            
            NSInteger resultInt;
            if ([resultStatus integerValue] == 9000) {
                resultInt = 1;
                memo = @"支付成功！";
            } else {
                resultInt = 0;
                memo = [NSString stringWithFormat:@"支付失败:%@",memo];
            }
            
            if (self.payResultsBlock) {
                self.payResultsBlock(resultInt, strTitle, memo);
                [PaymentModel queryPayStatus:outTradeNo paymentType:self.paymentType];
            }
            
        }];
        
    }
    
}

/**
 *  调起微信支付
 *
 *  @param dic  支付信息
 */
- (void)weixinPay:(NSDictionary *)dic {
    DLog(@"weixinPay == %@", dic);
    NSString *stamp = [dic objectForKey:@"timestamp"];
    
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [dic objectForKey:@"appid"];
    req.partnerId           = [dic objectForKey:@"partnerid"];
    req.prepayId            = [dic objectForKey:@"prepayid"];
    req.nonceStr            = [dic objectForKey:@"noncestr"];
    req.timeStamp           = stamp.intValue;
    req.package             = @"Sign=WXPay";
    req.sign                = [dic objectForKey:@"sign"];
    
    [WXApi sendReq:req];
}

/**
 *  支付状态同步处理
 *
 *  @param outTradeNo 订单号
 *  @param type       支付类型
 */
+ (void)queryPayStatus:(NSString *)outTradeNo paymentType:(NSString *)type {
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         outTradeNo,                    @"outTradeNo",
                         type,                          @"payMethod",
                         nil];
    
    NSString *url = [PPNetworkHelper requestURL:@"queryPayStatus.do?"];
    
    [PPNetworkHelper POST:url parameters:dic encrypt:NO responseCache:^(NetworkingResponse *responseCache) {
    } success:^(NetworkingResponse *responseObject) {
    } failure:^(NSError *error) {
    }];
    
}

@end
