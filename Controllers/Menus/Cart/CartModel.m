//
//  CartModel.m
//  NewStore
//
//  Created by yusaiyan on 16/9/23.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "CartModel.h"

@implementation CartModel

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {

        self.select      = NO;
        self.number      = [[dictionary valueForKey:@"number"]integerValue];
        self.cart_id     = [dictionary valueForKey:@"cid"];
        self.cart_pid    = [dictionary valueForKey:@"productId"];
        self.cart_pic    = [dictionary valueForKey:@"image"];
        self.cart_price  = [dictionary valueForKey:@"price"];
        self.cart_size   = [dictionary valueForKey:@"skuValue"];
        self.cart_title  = [dictionary valueForKey:@"name"];
        self.cart_status = [[dictionary valueForKey:@"status"]boolValue];

    }
    return self;
}

@end
