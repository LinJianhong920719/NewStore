//
//  UserInformation.m
//  NewStore
//
//  Created by yusaiyan on 16/9/20.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "UserInformation.h"

@implementation UserInformation

+ (void)saveUserInfo:(NSDictionary *)info {
    [UserInformation saveObjectDic:info forKey:@"uid"];
    [UserInformation saveObjectDic:info forKey:@"type"];
    [UserInformation saveObjectDic:info forKey:@"phone"];
    [UserInformation saveObjectDic:info forKey:@"name"];
    [UserInformation saveObjectDic:info forKey:@"image"];
    [UserInformation saveObjectDic:info forKey:@"sex"];
}

+ (void)removeUserInfo {
    [UserInformation removeObjectForKey:@"uid"];
    [UserInformation removeObjectForKey:@"type"];
    [UserInformation removeObjectForKey:@"phone"];
    [UserInformation removeObjectForKey:@"name"];
    [UserInformation removeObjectForKey:@"image"];
    [UserInformation removeObjectForKey:@"sex"];
    [UserInformation removeObjectForKey:@"device_token"];
    [UserInformation removeObjectForKey:@"device_idfa"];
}

#pragma mark - SET

+ (void)setUserID:(NSString *)str {
    [UserInformation saveObject:str forKey:@"uid"];
}

+ (void)setUserType:(NSString *)str {
    [UserInformation saveObject:str forKey:@"type"];
}

+ (void)setUserPhone:(NSString *)str {
    [UserInformation saveObject:str forKey:@"phone"];
}

+ (void)setUserName:(NSString *)str {
    [UserInformation saveObject:str forKey:@"name"];
}

+ (void)setUserHead:(NSString *)str {
    [UserInformation saveObject:str forKey:@"image"];
}

+ (void)setUserSex:(NSString *)str {
    [UserInformation saveObject:str forKey:@"sex"];
}

+ (void)setToken:(NSString *)str {
    [UserInformation saveObject:str forKey:@"device_token"];
}

+ (void)setIDFA:(NSString *)str {
    [UserInformation saveObject:str forKey:@"device_idfa"];
}

#pragma mark - GET

+ (NSString *)getUserId {
    return [UserInformation objectForKey:@"uid"];
}

+ (NSString *)getUserType {
    return [UserInformation objectForKey:@"type"];
}

+ (NSString *)getUserPhone {
    return [UserInformation objectForKey:@"phone"];
}

+ (NSString *)getUserName {
    return [UserInformation objectForKey:@"name"];
}

+ (NSString *)getUserHead {
    return [UserInformation objectForKey:@"image"];
}

+ (NSString *)getUserSex {
    return [UserInformation objectForKey:@"sex"];
}

+ (NSString *)getToken {
    return [UserInformation objectForKey:@"device_token"];
}

+ (NSString *)getIDFA {
    return [UserInformation objectForKey:@"device_idfa"];
}

+ (BOOL)userLogin {
    NSString *uid = [UserInformation getUserId];
    if (uid && ![uid isEqual:@""]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - NSUserDefaults

+ (void)saveObjectDic:(id)object forKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    id obj = [object valueForKey:key];
    if (obj && ![obj isEqual:@""]) {
        [userDefault setObject:[object valueForKey:key] forKey:key];
    }
}

+ (void)saveObject:(id)object forKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:object forKey:key];
}

+ (id)objectForKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:key] ? [userDefault objectForKey:key] : @"";
}

+ (void)removeObjectForKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:key];
}

@end
