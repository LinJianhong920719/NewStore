//
//  OrderEntity.m
//  NewStore
//
//  Created by edz on 17/1/11.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import "OrderEntity.h"

@implementation OrderEntity

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _goodId = [attributes valueForKey:@"good_id"];
    _goodName = [attributes valueForKey:@"good_name"];
    _goodImage = [attributes valueForKey:@"good_image"];
    _goodPirce = [attributes valueForKey:@"good_price"];
    _goodSize = [attributes valueForKey:@"good_size"];
    _goodNums = [attributes valueForKey:@"nums"];
    
    return self;
}


@end
