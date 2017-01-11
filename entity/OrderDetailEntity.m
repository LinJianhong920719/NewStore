//
//  OrderDetailEntity.m
//  NewStore
//
//  Created by edz on 17/1/7.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import "OrderDetailEntity.h"

@implementation OrderDetailEntity

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(!self){
        return nil;
    }
    _goodInfo = [[NSMutableArray alloc]init];
    _couponInfo = [[NSMutableArray alloc]init];
    _orderInfo = [[NSMutableArray alloc]init];
    _addressInfo = [[NSMutableArray alloc]init];
    
    _userId = [attributes valueForKey:@"user_id"];
    _orderSn = [attributes valueForKey:@"order_sn"];;
    _addressId = [attributes valueForKey:@"address_id"];;
    _couponId = [attributes valueForKey:@"coupon_id"];;
    _tradeType = [attributes valueForKey:@"trade_type"];;
    _payStatus = [attributes valueForKey:@"pay_status"];;
    _addressInfo = [attributes valueForKey:@"address_info"];;
    _couponInfo = [attributes valueForKey:@"coupon_info"];;
    _goodInfo = [attributes valueForKey:@"good_info"];;
    _orderInfo = [attributes valueForKey:@"order_info"];;
    return  self;
}

@end
