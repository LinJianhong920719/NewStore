//
//  NewOrderEntity.m
//  NewStore
//
//  Created by edz on 17/1/7.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import "NewOrderEntity.h"

@implementation NewOrderEntity

@synthesize isCancleOrder;
@synthesize userId;
@synthesize isDelOrder;
@synthesize isDiscuss;
@synthesize shippingStatus;
@synthesize freightAmount;
@synthesize realAmount;
@synthesize useRemark;
@synthesize isDenialOrders;
@synthesize orderTotalId;
@synthesize orderSn;
@synthesize addressId;
@synthesize couponId;
@synthesize tradeType;
@synthesize createTime;
@synthesize goodInfo;

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(!self){
        return nil;
    }
    goodInfo = [[NSMutableArray alloc]init];
    isCancleOrder = [attributes valueForKey:@"is_cancel_order"];
    userId = [[attributes valueForKey:@"user_id"] integerValue];
    isDelOrder = [attributes valueForKey:@"is_del_order"];
    isDiscuss = [attributes valueForKey:@"is_discuss"];
    shippingStatus = [attributes valueForKey:@"shipping_status"];
    freightAmount = [attributes valueForKey:@"freight_amount"];
    realAmount = [attributes valueForKey:@"real_amount"];
    useRemark = [attributes valueForKey:@"user_remark"];
    isDenialOrders = [attributes valueForKey:@"is_denial_orders"];
    orderTotalId = [attributes valueForKey:@"order_total_id"];
    orderSn = [attributes valueForKey:@"order_sn"];
    addressId = [attributes valueForKey:@"address_id"];
    couponId = [attributes valueForKey:@"coupon_id"];
    tradeType = [attributes valueForKey:@"trade_type"];
    createTime = [attributes valueForKey:@"create_time"];
    goodInfo = [attributes valueForKey:@"goodInfo"];
    return  self;
}

@end
