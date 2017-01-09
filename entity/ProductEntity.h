//
//  ProductEntity.h
//  NewStore
//
//  Created by edz on 17/1/9.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductEntity : NSObject

@property (strong, nonatomic) NSString *goodId;

- (id)initWithAttributes:(NSDictionary *)attributes;

@end
