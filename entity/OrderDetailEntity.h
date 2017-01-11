//
//  OrderDetailEntity.h
//  NewStore
//
//  Created by edz on 17/1/7.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailEntity : NSObject

@property (nonatomic, assign) NSString *userId;
@property (nonatomic, strong) NSString *orderSn;
@property (nonatomic, strong) NSString *addressId;
@property (nonatomic, strong) NSString *couponId;
@property (nonatomic, strong) NSString *tradeType;
@property (nonatomic, strong) NSString *payStatus;
@property (nonatomic, strong) NSMutableArray *addressInfo;
@property (nonatomic, strong) NSMutableArray *couponInfo;
@property (nonatomic, strong) NSMutableArray *goodInfo;
@property (nonatomic, strong) NSMutableArray *orderInfo;


- (id)initWithAttributes:(NSDictionary *)attributes;

@end
