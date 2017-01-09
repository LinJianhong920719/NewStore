//
//  CartViewController.h
//  NewStore
//
//  Created by yusaiyan on 16/9/23.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "BaseViewController.h"

@interface CartViewController : BaseViewController

@property (nonatomic, copy) void (^cartNumberBlock)(NSInteger number);

@end
