//
//  ClassifyCateModel.h
//  MailWorldClient
//
//  Created by yusaiyan on 16/9/3.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassifyCateModel : NSObject

/*
 *  主类ID
 */
@property (strong, nonatomic) NSString *classify_id;

/*
 *  子类ID
 */
@property (strong, nonatomic) NSString *classify_sub_id;

/*
 *  品牌名
 */
@property (strong, nonatomic) NSString *classify_title;

/**
 *  品牌logo
 */
@property (strong, nonatomic) NSString *classify_pic;

/*
 *  子类ID
 */
@property (strong, nonatomic) NSArray *classify_subArray;
@property (strong, nonatomic) NSMutableArray *classify_subclass;

- (id)initWithDictionary:(NSDictionary*)dictionary;

@end

