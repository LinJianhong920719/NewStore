//
//  Tools.m
//  NewStore
//
//  Created by yusaiyan on 16/5/6.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+ (Tools *)sharedInstance {
    static Tools *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Tools alloc] init];
    });
    return sharedInstance;
}

+ (void)saveBool:(BOOL)boolValue forKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:boolValue forKey:key];
}

+ (BOOL)boolForKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault boolForKey:key];
}

+ (void)saveObject:(id)objectValue forKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:objectValue forKey:key];
}

+ (id)objectForKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:key];
}

+ (NSString *)stringForKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault stringForKey:key];
}

+ (NSArray *)arrayForKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault arrayForKey:key];
}

+ (void)saveInteger:(NSInteger)intValue forKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:intValue forKey:key];
}

+ (NSInteger)intForKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault integerForKey:key];
}

+ (void)saveDouble:(float)doubleValue forKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setDouble:doubleValue forKey:key];
}

+ (float)doubleForKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault doubleForKey:key];
}

+ (void)saveFloat:(float)floatValue forKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setFloat:floatValue forKey:key];
}

+ (float)floatForKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault floatForKey:key];
}

#pragma mark -

+ (void)clearCaches {
    // 清除接口缓存数据
    [PPNetworkCache removeAllHttpCache];
    // 清除图片缓存
    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    // 清除系统缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

#pragma mark - 判断为空

+ (BOOL)isBlankObject:(id)object {
    
    if (object == nil || object == NULL) {
        return YES;
    }
    if ([object isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([(NSNull *)object isEqual:[NSNull null]]) {
        return YES;
    }

    if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSMutableArray class]]) {
        if (![object count]) {
            return YES;
        }
    }
    if ([object isKindOfClass:[NSString class]]) {
        if ([[object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
            return YES;
        }
        if ([object isEqualToString:@"<null>"] || [object isEqualToString:@"(null)"] || [object isEqualToString:@"null"]) {
            return YES;
        }
    }

    return NO;
}

#pragma mark - JSON格式转换

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if (err) {
        DLog(@"json解析失败：%@", err);
        return nil;
    }
    return dic;
}

@end
