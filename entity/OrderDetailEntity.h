//
//  OrderDetailEntity.h
//  NewStore
//
//  Created by edz on 17/1/7.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailEntity : NSObject

@property (nonatomic, strong) NSString *isCancleOrder;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *isDelOrder;
@property (nonatomic, strong) NSString *isDiscuss;
@property (nonatomic, strong) NSString *shippingStatus;
@property (nonatomic, strong) NSString *freightAmount;
@property (nonatomic, strong) NSString *realAmount;
@property (nonatomic, strong) NSString *useRemark;
@property (nonatomic, strong) NSString *isDenialOrders;
@property (nonatomic, strong) NSString *orderTotalId;
@property (nonatomic, strong) NSString *orderSn;
@property (nonatomic, strong) NSString *addressId;
@property (nonatomic, strong) NSString *couponId;
@property (nonatomic, strong) NSString *tradeType;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSMutableArray *goodInfo;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
