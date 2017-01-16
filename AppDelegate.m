//
//  AppDelegate.m
//  NewStore
//
//  Created by yusaiyan on 16/5/5.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "AppDelegate.h"
#import <AdSupport/AdSupport.h>
#import <UserNotifications/UserNotifications.h>

#import "UMSocial.h"
#import "UMSocialData.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMessage.h"
#import "OrderListViewController.h"
#import "RegisterViewController.h"




@interface AppDelegate () <WXApiDelegate, UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

+ (AppDelegate *)sharedAppDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //设置OrderListViewController为根视图
    NSString *shopId = [UserInformation getUserId];
    if (shopId == nil || [shopId isEqualToString:@""]) {
       RegisterViewController *oc = [RegisterViewController alloc];
        UINavigationController *root = [[UINavigationController alloc]initWithRootViewController:oc];
        self.window.rootViewController = root;
    }else{
        OrderListViewController *oc = [[OrderListViewController alloc]init];
        UINavigationController *root = [[UINavigationController alloc]initWithRootViewController:oc];
        self.window.rootViewController = root;
    }

    [self.window makeKeyAndVisible];
    
    self.window.backgroundColor = [UIColor whiteColor];

    //获取idfa
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [UserInformation setIDFA:idfa];
    
    dispatch_async(global_quque, ^{
        // 耗时的操作
        [self setup_UMengAnalytics];
        [self umeng_LoginQuick];
        [self setup_UMessage:launchOptions];
    });
    
    //阿里云推送初始化
    [self initCloudPush];
    // 点击通知将App从关闭状态启动时，将通知打开回执上报
    // [CloudPushSDK handleLaunching:launchOptions];(Deprecated from v1.8.1)
    [CloudPushSDK sendNotificationAck:launchOptions];
    return YES;
}
- (void)initCloudPush {
    // SDK初始化
    [CloudPushSDK asyncInit:@"23604130" appSecret:@"81ce7b1f9cb5ba748b278962c71034ef" callback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
            NSLog(@"ssssid:%@",[CloudPushSDK getDeviceId]);
        } else {
            NSLog(@"Push SDK init failed, error: %@", res.error);
        }
    }];
}

/**
 *    注册苹果推送，获取deviceToken用于推送
 *
 *    @param     application
 */
- (void)registerAPNS:(UIApplication *)application {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                           categories:nil]];
        [application registerForRemoteNotifications];
    }
    else {
        // iOS < 8 Notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
}
/*
 *  苹果推送注册成功回调，将苹果返回的deviceToken上传到CloudPush服务器
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Register deviceToken success.");
        } else {
            NSLog(@"Register deviceToken failed, error: %@", res.error);
        }
    }];
}
/*
 *  苹果推送注册失败回调
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}
/**
 *    注册推送消息到来监听
 */
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
}
/**
 *    处理到来推送消息
 *
 *    @param     notification
 */
- (void)onMessageReceived:(NSNotification *)notification {
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSLog(@"Receive message title: %@, content: %@.", title, body);
}


/*
 *  App处于启动状态时，通知打开回调
 */
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    NSLog(@"Receive one notification.");
    // 取得APNS通知内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    // 内容
    NSString *content = [aps valueForKey:@"alert"];
    // badge数量
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    // 播放声音
    NSString *sound = [aps valueForKey:@"sound"];
    // 取得Extras字段内容
    NSString *Extras = [userInfo valueForKey:@"Extras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content = [%@], badge = [%ld], sound = [%@], Extras = [%@]", content, (long)badge, sound, Extras);
    // iOS badge 清0
    application.applicationIconBadgeNumber = 0;
    // 通知打开回执上报
    // [CloudPushSDK handleReceiveRemoteNotification:userInfo];(Deprecated from v1.8.1)
    [CloudPushSDK sendNotificationAck:userInfo];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
//     [MQManager closeMeiqiaService];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//      [MQManager openMeiqiaService];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



// ----------------------------------------------------------------------------------------
// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
// ----------------------------------------------------------------------------------------
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

// ----------------------------------------------------------------------------------------
// 请求委托打开一个URL资源（IOS9.0及以上）
// ----------------------------------------------------------------------------------------
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {

//    return [self applicationOpenURL:url];
//}

// ----------------------------------------------------------------------------------------
// 请求委托打开一个URL资源（IOS9.0及以下）
// ----------------------------------------------------------------------------------------
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    
//    return [self applicationOpenURL:url];
//}



// ----------------------------------------------------------------------------------------
// iOS10新增：处理前台收到通知的代理方法
// ----------------------------------------------------------------------------------------
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    } else {
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

// ----------------------------------------------------------------------------------------
// iOS10新增：处理后台点击通知的代理方法
// ----------------------------------------------------------------------------------------
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    } else {
        //应用处于后台时的本地推送接受
    }
    
}

#pragma mark - 友盟
#pragma mark UMengAnalytics 统计

- (void)setup_UMengAnalytics {
    
    UMConfigInstance.appKey = UMENG_APPKEY;
    UMConfigInstance.channelId = UMENG_CHANNEL_ID;
    
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
}

#pragma mark UMeng(快速登录)

- (void)umeng_LoginQuick {
    
    [UMSocialData setAppKey:UMENG_APPKEY];
    
    // 打开新浪微博的SSO开关
    //    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SinaAppKey
    //                                              secret:SinaAppSecret
    //                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    // 设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:WXAppId
                            appSecret:WXAppSecret
                                  url:@"http://www.umeng.com/social"];
    
    // 隐藏指定没有安装客户端的平台
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline, UMShareToSina, UMShareToWechatSession, UMShareToWechatTimeline]];
    
}

#pragma mark UMessage 推送

- (void)setup_UMessage:(NSDictionary *)launchOptions {
    
    [UMessage startWithAppkey:UMENG_APPKEY launchOptions:launchOptions];
    
    
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];
    
}

#pragma mark - 第三方跳转回调

//- (BOOL)applicationOpenURL:(NSURL *)url {
//    
//    //调用其他SDK，例如支付宝SDK等
//    
//    NSString *urlStr = [url absoluteString];
//    
//    if ([urlStr rangeOfString:@"pingpp"].location != NSNotFound) {
//        BOOL canHandleURL = [Pingpp handleOpenURL:url withCompletion:nil];
//        return canHandleURL;
//    }
//    
//    //跳转支付宝钱包进行支付，处理支付结果
//    if ([url.host isEqualToString:@"safepay"]) {
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            DLog(@"result = %@",resultDic);
//            
//            NSString *strStatus = [resultDic valueForKey:@"resultStatus"];
//            NSString *strMsg = [resultDic valueForKey:@"memo"];
//            NSString *strTitle = @"支付结果";
//            
//            if ([strStatus isEqualToString:@"9000"]) {
//                strStatus = @"1";
//            } else {
//                strStatus = @"0";
//            }
//            
//            NSArray *array = @[strStatus, strTitle, strMsg];
//            [[NSNotificationCenter defaultCenter] postNotificationName:PayForResults object:array];
//            
//        }];
//    }
//    
//    //微信支付
//    if ([urlStr rangeOfString:@"pay"].location != NSNotFound) {
//        return [WXApi handleOpenURL:url delegate:self];
//    }
//    
//    return YES;
//    
//}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // 处理微信的回调信息
    return  [WXApi handleOpenURL:url delegate:self];
}

// ----------------------------------------------------------------------------------------
// 微信 支付回调
// ----------------------------------------------------------------------------------------
- (void)onResp:(BaseResp*)resp {
    
    NSString *strTitle = @"支付结果";
    
    if ([resp isKindOfClass:[PayResp class]]) {
        
        NSArray *array;
        switch (resp.errCode) {
            case WXSuccess:
                array = @[@"1", strTitle, @"支付成功！"];
                break;
            case WXErrCodeUserCancel:
                array = @[@"0", strTitle, @"用户中途取消"];
                break;
            default:
                array = @[@"0", strTitle, @"支付失败！"];
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:PayForResults object:array];
    }
    
}

#pragma mark - 检测更新

- (void)checkAppUpdate {
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    NSString *nowVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", APPLE_ID]];
    NSString * file =  [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *dic = [[Tools dictionaryWithJsonString:file]valueForKey:@"results"][0];
    
    NSString *newVersion = [dic valueForKey:@"version"];
    NSString *title = [NSString stringWithFormat:@"有可更新版本%@", newVersion];
    NSString *message = [dic valueForKey:@"releaseNotes"];
    
    if (![nowVersion isEqualToString:newVersion])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"更新",nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        // 此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", APPLE_ID]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
