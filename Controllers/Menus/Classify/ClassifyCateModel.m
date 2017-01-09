//
//  ClassifyCateModel.m
//  MailWorldClient
//
//  Created by yusaiyan on 16/9/3.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "ClassifyCateModel.h"

@implementation ClassifyCateModel

- (id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
//        self.classify_id       = [dictionary valueForKey:@"id"];
        self.classify_title    = [dictionary valueForKey:@"name"];
        self.classify_pic      = [dictionary valueForKey:@"image"];
//        self.classify_sub_id   = [dictionary valueForKey:@"pid"];
        self.classify_subArray = [dictionary valueForKey:@"type"];
        
        self.classify_id       = [dictionary valueForKey:@"pid"];
        self.classify_sub_id   = [dictionary valueForKey:@"id"];

        self.classify_subclass = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
