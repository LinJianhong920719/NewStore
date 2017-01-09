//
//  ProductEntity.m
//  NewStore
//
//  Created by edz on 17/1/9.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import "ProductEntity.h"

@implementation ProductEntity

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _goodId = [attributes valueForKey:@"good_id"];
    
    return self;
}
@end
