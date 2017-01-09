//
//  PPNetworkHelper.h
//  GroupPurchase
//
//  Created by yusaiyan on 16/9/20.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <PPNetworkHelper/PPNetworkHelper.h>
#import "NetworkingResponse.h"

#define PPErrorMsg @"请求失败,请稍后重试"

/** 请求成功的Block */
typedef void(^PPRequestSuccess)(NetworkingResponse *responseObject);

/** 请求失败的Block */
typedef void(^PPRequestFailed)(NSError *error);

/** 缓存的Block */
typedef void(^PPRequestCache)(NetworkingResponse *responseCache);

@interface NSString (md5)

+ (NSString *)md5:(NSString *)string;

@end

@interface PPNetworkHelper (Config)

/**
 *  接口拼接
 *
 *  @param url 接口名
 *
 *  @return 完整接口
 */
+ (NSString *)requestURL:(NSString *)url;

+ (NSString *)resetPrefix:(NSString *)prefix requestURL:(NSString *)url;

/**
 *  POST请求,自动缓存
 *
 *  @param URL           请求地址
 *  @param parameters    请求参数
 *  @param responseCache 缓存数据的回调
 *  @param success       请求成功的回调
 *  @param failure       请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancle方法
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                            encrypt:(BOOL)encrypt
                      responseCache:(PPRequestCache)cache
                            success:(PPRequestSuccess)success
                            failure:(PPRequestFailed)failure;

/**
 *  上传图片文件
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param images     图片数组
 *  @param name       文件对应服务器上的字段
 *  @param fileName   文件名
 *  @param mimeType   图片文件的类型,例:png、jpeg(默认类型)....
 *  @param progress   上传进度信息
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancle方法
 */
+ (__kindof NSURLSessionTask *)uploadWithURL:(NSString *)URL
                                  parameters:(NSDictionary *)parameters
                                      images:(NSArray<UIImage *> *)images
                                       names:(NSArray<NSString *> *)names
                                    fileName:(NSString *)fileName
                                    mimeType:(NSString *)mimeType
                                    progress:(HttpProgress)progress
                                     success:(HttpRequestSuccess)success
                                     failure:(HttpRequestFailed)failure;

@end
