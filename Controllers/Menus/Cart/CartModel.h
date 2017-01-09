//
//  CartModel.h
//  NewStore
//
//  Created by yusaiyan on 16/9/23.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartModel : NSObject

/**
 *  勾选状态
 */
@property (assign, nonatomic) BOOL select;

/**
 *  数量
 */
@property (assign, nonatomic) NSInteger number;

/**
 *  购物车ID
 */
@property (strong, nonatomic) NSString *cart_id;

/**
 *  商品ID
 */
@property (strong, nonatomic) NSString *cart_pid;

/**
 *  商品图
 */
@property (strong, nonatomic) NSString *cart_pic;

/**
 *  价格
 */
@property (strong, nonatomic) NSString *cart_price;

/**
 *  规格
 */
@property (strong, nonatomic) NSString *cart_size;

/**
 *  商品标题
 */
@property (strong, nonatomic) NSString *cart_title;

/**
 *  商品状态
 */
@property (assign, nonatomic) BOOL cart_status;

- (id)initWithDictionary:(NSDictionary*)dictionary;

@end
