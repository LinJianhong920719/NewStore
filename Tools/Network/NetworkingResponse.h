//
//  NetworkingResponse.h
//  GroupPurchase
//
//  Created by yusaiyan on 16/5/9.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkingResponse : NSObject

@property (nonatomic, strong) id result;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) NSString *error_msg;
@property (nonatomic, strong) NSString *status;

- (id)initWithDictionary:(NSDictionary*)dictionary;

@end
