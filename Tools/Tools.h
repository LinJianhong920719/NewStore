//
//  Tools.h
//  NewStore
//
//  Created by yusaiyan on 16/5/6.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDefaultsKey.h"

@interface Tools : NSObject

+ (Tools *)sharedInstance;

+ (void) saveBool:(BOOL)boolValue forKey:(NSString *)key;
+ (BOOL) boolForKey:(NSString *)key;

+ (void) saveObject:(id)objectValue forKey:(NSString *)key;
+ (id) objectForKey:(NSString *)key;
+ (NSString *) stringForKey:(NSString *)key;
+ (NSArray *) arrayForKey:(NSString *)key;

+ (void) saveInteger:(NSInteger)intValue forKey:(NSString *)key;
+ (NSInteger)intForKey:(NSString *)key;

+ (void) saveDouble:(float)doubleValue forKey:(NSString *)key;
+ (float)doubleForKey:(NSString *)key;

+ (void) saveFloat:(float)floatValue forKey:(NSString *)key;
+ (float)floatForKey:(NSString *)key;

/**
 *  清除缓存
 */
+ (void)clearCaches;

/**
 *  判断为空
 *
 *  @param value object
 *  @return 结果 YES:空 NO:非空
 */
+ (BOOL)isBlankObject:(id)value;

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
