//
//  OrderEntity.h
//  NewStore
//
//  Created by edz on 17/1/11.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderEntity : NSObject

@property(strong, nonatomic) NSString *goodId;
@property(strong, nonatomic) NSString *goodName;
@property(strong, nonatomic) NSString *goodImage;
@property(strong, nonatomic) NSString *goodPirce;
@property(strong, nonatomic) NSString *goodSize;
@property(strong, nonatomic) NSString *goodNums;

- (id)initWithAttributes:(NSDictionary *)attributes;


@end
