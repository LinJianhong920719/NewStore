//
//  OrderListViewController.h
//  ScrollViewVC
//
//  Created by TreeWriteMac on 16/6/21.
//  Copyright © 2016年 Raykin. All rights reserved.
//

#import "AppDelegate.h"
#import <UIKit/UIKit.h>

@interface OrderListViewController : UIViewController <UIScrollViewDelegate>
{
    NSArray  *_VCAry;
    NSArray  *_TitleAry;
    UIView   *_LineView;
    UIScrollView *_MeScroolView;
}

- (void)initWithAddVCARY:(NSArray*)VCS TitleS:(NSArray*)TitleS;

@end
