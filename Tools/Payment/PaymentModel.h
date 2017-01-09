//
//  PaymentModel.h
//  GroupPurchase
//
//  Created by yusaiyan on 16/10/9.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentModel : NSObject

@property (strong, nonatomic) NSString *paymentType;

@property (nonatomic, copy) void (^payResultsBlock)(NSInteger status, NSString *title,NSString *msg);

/**
 *  支付处理
 *
 *  @param dic  支付信息
 *  @param type 支付类型
 */
- (id)initWithDicctionary:(NSDictionary*)dic paymentType:(NSString *)type;

/**
 *  支付同步
 *
 *  @param outTradeNo 流水号
 *  @param type       支付类型
 */
+ (void)queryPayStatus:(NSString *)outTradeNo paymentType:(NSString *)type;

@end
