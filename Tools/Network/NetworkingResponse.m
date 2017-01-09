//
//  NetworkingResponse.m
//  GroupPurchase
//
//  Created by yusaiyan on 16/5/9.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "NetworkingResponse.h"

@implementation NetworkingResponse

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        NSLog(@"dictionary:%@",dictionary);
        self.result    = [dictionary valueForKey:@"data"];
        self.success   = [[dictionary valueForKey:@"success"]boolValue];
        self.error_msg = [dictionary valueForKey:@"error_msg"];
        self.status = [dictionary valueForKey:@"status"];
    }
    return self;
}

@end
