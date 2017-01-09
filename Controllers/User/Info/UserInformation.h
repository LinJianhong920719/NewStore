//
//  UserInformation.h
//  NewStore
//
//  Created by yusaiyan on 16/9/20.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInformation : NSObject

/**
 *  缓存参数
 *
 *  @param info 用户信息字典
 */
+ (void)saveUserInfo:(NSDictionary *)info;

/**
 *  清除用户缓存数据
 */
+ (void)removeUserInfo;

/**
 *  设置缓存
 *
 *  @param str 参数值
 */
+ (void)setUserID:(NSString *)str;
+ (void)setUserType:(NSString *)str;
+ (void)setUserPhone:(NSString *)str;
+ (void)setUserName:(NSString *)str;
+ (void)setUserHead:(NSString *)str;
+ (void)setUserSex:(NSString *)str;

+ (void)setToken:(NSString *)str;
+ (void)setIDFA:(NSString *)str;

/**
 *  获取缓存
 *
 *  @return 参数值
 */
+ (NSString *)getUserId;
+ (NSString *)getUserType;
+ (NSString *)getUserPhone;
+ (NSString *)getUserName;
+ (NSString *)getUserHead;
+ (NSString *)getUserSex;

+ (NSString *)getToken;
+ (NSString *)getIDFA;

/**
 *  用户登录状态 通过用户ID判断
 */
+ (BOOL)userLogin;

@end
