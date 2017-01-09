//
//  PPNetworkHelper.m
//  GroupPurchase
//
//  Created by yusaiyan on 16/9/20.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "PPNetworkHelper+Config.h"
#import <CommonCrypto/CommonDigest.h>
#import "AFNetworkActivityIndicatorManager.h"

#define Identification @"taozhumapintuan@corp.com"

@implementation NSString (md5)

+ (NSString *)md5:(NSString *)string {
    if (string == nil || [string length] == 0) {
        return nil;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([string UTF8String], (int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}

@end


@implementation PPNetworkHelper (Config)

+ (NSString *)requestURL:(NSString *)url {
    return [NSString stringWithFormat:@"%@%@", SERVICE_URL, url];
}

+ (NSString *)resetPrefix:(NSString *)prefix requestURL:(NSString *)url {
    return [NSString stringWithFormat:@"%@%@", prefix, url];
}

// 仅对一级字典结构起作用
+ (NSString *)generateGETAbsoluteURL:(NSString *)url params:(id)params {
    if (params == nil || ![params isKindOfClass:[NSDictionary class]] || [params count] == 0) {
        return url;
    }
    
    NSString *queries = @"";
    for (NSString *key in params) {
        id value = [params objectForKey:key];
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            continue;
        } else if ([value isKindOfClass:[NSArray class]]) {
            continue;
        } else if ([value isKindOfClass:[NSSet class]]) {
            continue;
        } else {
            queries = [NSString stringWithFormat:@"%@%@=%@&",
                       (queries.length == 0 ? @"" : queries),
                       key,
                       value];
        }
    }
    
    if (queries.length > 1) {
        queries = [queries substringToIndex:queries.length - 1];
    }
    
    if (([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) && queries.length > 1) {
        if ([url rangeOfString:@"?"].location != NSNotFound
            || [url rangeOfString:@"#"].location != NSNotFound) {
            url = [NSString stringWithFormat:@"%@%@", url, queries];
        } else {
            queries = [queries substringFromIndex:1];
            url = [NSString stringWithFormat:@"%@?%@", url, queries];
        }
    }
    
    return url.length == 0 ? queries : url;
}


#pragma mark - POST请求自动缓存

+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(NSDictionary *)parameters
                   encrypt:(BOOL)encrypt
             responseCache:(PPRequestCache)cache
                   success:(PPRequestSuccess)success
                   failure:(PPRequestFailed)failure
{
    
    NSDictionary *responseCache = [PPNetworkCache httpCacheForURL:URL parameters:parameters];
    
    NetworkingResponse *respond = [[NetworkingResponse alloc]initWithDictionary:responseCache];
    cache(respond);
    
    DLog(@" === %@", [self generateGETAbsoluteURL:URL params:parameters]);
    
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerHTTP];
    
    return [PPNetworkHelper POST:URL parameters:parameters success:^(id responseObject) {
        
        [PPNetworkCache setHttpCache:responseObject URL:URL parameters:parameters];
        
        NetworkingResponse *respond = [[NetworkingResponse alloc]initWithDictionary:responseObject];
        success(respond);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

#pragma mark - 上传图片文件

+ (NSURLSessionTask *)uploadWithURL:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                             images:(NSArray<UIImage *> *)images
                              names:(NSArray<NSString *> *)names
                           fileName:(NSString *)fileName
                           mimeType:(NSString *)mimeType
                           progress:(HttpProgress)progress
                            success:(HttpRequestSuccess)success
                            failure:(HttpRequestFailed)failure
{
    
    DLog(@" === %@", [self generateGETAbsoluteURL:URL params:parameters]);
    
    NSMutableArray *nameArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < images.count; i ++) {
        
        if (names && names.count > i) {
            [nameArray addObject:names[i]];
        } else {
            [nameArray addObject:[NSString stringWithFormat:@"image%d", i+1]];
        }

    }
    
    AFHTTPSessionManager *manager = [PPNetworkHelper createAFHTTPSessionManager];
    return [manager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (images) {
            
            //压缩-添加-上传图片
            [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                [formData appendPartWithFileData:imageData name:nameArray[idx] fileName:[NSString stringWithFormat:@"%@%lu.%@",fileName,(unsigned long)idx,mimeType?mimeType:@"jpeg"] mimeType:[NSString stringWithFormat:@"image/%@",mimeType?mimeType:@"jpeg"]];
            }];
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        progress ? progress(uploadProgress) : nil;
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NetworkingResponse *respond = [[NetworkingResponse alloc]initWithDictionary:responseObject];
        success ? success(respond) : nil;
        DLog(@"responseObject = %@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure ? failure(error) : nil;
        DLog(@"error = %@",error);
    }];
    
}

#pragma mark - 设置AFHTTPSessionManager相关属性

+ (AFHTTPSessionManager *)createAFHTTPSessionManager
{
    //打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求参数的类型:HTTP (AFJSONRequestSerializer,AFHTTPRequestSerializer)
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //设置请求的超时时间
    manager.requestSerializer.timeoutInterval = 30.f;
    //设置服务器返回结果的类型:JSON (AFJSONResponseSerializer,AFHTTPResponseSerializer)
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    return manager;
}


@end

