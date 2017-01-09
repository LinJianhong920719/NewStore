//
//  UIColor+Hex.h
//  NewStore
//
//  Created by yusaiyan on 16/9/20.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <UIKit/UIKit.h>

//16进制RGB的颜色转换
#define ColorFromHex(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//R G B 颜色
#define ColorFromRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define UIColorWithRGBA(r,g,b,a)    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define COLOR_00BFFF                UIColorWithRGBA(0, 191, 255, 1)
#define COLOR_O2B853                UIColorWithRGBA(2, 184, 83, 1)
#define COLOR_262626                UIColorWithRGBA(38, 38, 38, 1)
#define COLOR_27AF40                UIColorWithRGBA(39, 175, 64, 1)
#define COLOR_333333                UIColorWithRGBA(51, 51, 51, 1)
#define COLOR_343434                UIColorWithRGBA(52, 52, 52, 1)
#define COLOR_3E3A39                UIColorWithRGBA(62, 58, 57, 1)
#define COLOR_46D232                UIColorWithRGBA(70, 210, 50, 1)
#define COLOR_474647                UIColorWithRGBA(71, 70, 71, 1)
#define COLOR_595757                UIColorWithRGBA(89, 87, 87, 1)
#define COLOR_666464                UIColorWithRGBA(102, 100, 100, 1)
#define COLOR_666666                UIColorWithRGBA(102, 102, 102, 1)
#define COLOR_707070                UIColorWithRGBA(112, 112, 112, 1)
#define COLOR_7DCDF3                UIColorWithRGBA(125, 205, 243, 1)
#define COLOR_842302                UIColorWithRGBA(132, 35, 2, 1)
#define COLOR_898989                UIColorWithRGBA(137, 137, 137, 1)
#define COLOR_999999                UIColorWithRGBA(153, 153, 153, 1)
#define COLOR_9FA0A0                UIColorWithRGBA(159, 160, 160, 1)
#define COLOR_B2B2B2                UIColorWithRGBA(178, 178, 178, 1)
#define COLOR_BD0A25                UIColorWithRGBA(189, 10, 37, 1)
#define COLOR_DB0A25                UIColorWithRGBA(219, 10, 37, 1)
#define COLOR_C8C8C8                UIColorWithRGBA(200, 200, 200, 1)
#define COLOR_CCCCCC                UIColorWithRGBA(204, 204, 204, 1)
#define COLOR_DCDCDC                UIColorWithRGBA(220, 220, 220, 1)
#define COLOR_E4287F                UIColorWithRGBA(228, 40, 127, 1)
#define COLOR_E61D58                UIColorWithRGBA(230, 29, 88, 1)
#define COLOR_E73C7B                UIColorWithRGBA(231, 60, 123, 1)
#define COLOR_EB4B82                UIColorWithRGBA(235, 75, 130, 1)
#define COLOR_EEEEEE                UIColorWithRGBA(238, 238, 238, 1)
#define COLOR_EEEFEF                UIColorWithRGBA(238, 239, 239, 1)
#define COLOR_F2F2F2                UIColorWithRGBA(242, 242, 242, 1)
#define COLOR_F4001B                UIColorWithRGBA(244, 0, 27, 1)
#define COLOR_F78B1B                UIColorWithRGBA(247, 139, 27, 1)
#define COLOR_F7F8F8                UIColorWithRGBA(247, 248, 248, 1)
#define COLOR_F8B725                UIColorWithRGBA(248, 183, 37, 1)
#define COLOR_F98E1A                UIColorWithRGBA(249, 142, 26, 1)
#define COLOR_FFCFOO                UIColorWithRGBA(255, 207, 0, 1)
#define COLOR_FDD714                UIColorWithRGBA(253, 215, 20, 1)
#define COLOR_FFFFFF                UIColorWithRGBA(255, 255, 255, 1)

#define COLOR_F37918                UIColorWithRGBA(243, 121, 24, 1)

#define LINECOLOR_SYSTEM            COLOR_C8C8C8
#define LINECOLOR_DEFAULT           COLOR_DCDCDC
#define BGCOLOR_DEFAULT             COLOR_F7F8F8
#define THEME_COLORS_RED            [UIColor colorWithHex:@"f85981"]
#define FONT_COLOR                  COLOR_262626
#define FONTS_COLOR                 COLOR_898989

@interface UIColor (Hex)

+ (UIColor *)randomColor;

+ (UIColor *)colorWithHex:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHex:(NSString *)color alpha:(CGFloat)alpha;

@end
