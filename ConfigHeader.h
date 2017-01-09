//
//  ConfigHeader.h
//  NewStore
//
//  Created by yusaiyan on 16/8/26.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#ifndef ConfigHeader_h
#define ConfigHeader_h


#define kEnvironment 0     // 环境 0.测试 1.正式
#define kVersion     @"3.4"// 接口版本


#ifdef DEBUG

#ifndef kEnvironment
#define kEnvironment 0
#endif

#else

#ifndef kEnvironment
#define kEnvironment 1
#endif

#endif



#define SERVICE_URL @"http://www.ihaodangjia.com/"




#define SERVICE_TEL            @""                      // 客服电话

#define APPLE_ID               @""                      // 苹果商店id

// 微信是否安装
#define WXAppInstalled         [WXApi isWXAppInstalled]

//==============================   友盟   ==================================//

#define UMENG_APPKEY           @""        // 友盟 AppKey

#define WXAppId                @""              // 微信 AppId
#define WXAppSecret            @""// 微信

#define UMENG_CHANNEL_ID       @"App Store"  // 友盟渠道


#endif /* ConfigHeader_h */
