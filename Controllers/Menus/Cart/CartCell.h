//
//  CartCell.h
//  NewStore
//
//  Created by yusaiyan on 16/9/23.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartModel.h"

static NSString *Bottom_UnSelectButtonString = @"cart_unSelect";
static NSString *Bottom_SelectButtonString = @"cart_select";
static NSInteger rowHeight = 100;

typedef void (^CartNumberChangedBlock)(NSInteger number);
typedef void (^CartCellSelectedBlock)(BOOL select);

@interface CartCell : UITableViewCell

@property (assign, nonatomic) NSInteger number;
@property (assign, nonatomic) BOOL select;

- (void)CartReloadDataWithModel:(CartModel*)model;
- (void)CartNumberAddWithBlock:(CartNumberChangedBlock)block;
- (void)CartNumberCutWithBlock:(CartNumberChangedBlock)block;
- (void)CartCellSelectedWithBlock:(CartCellSelectedBlock)block;
- (void)CartCellClickBlock:(CartCellSelectedBlock)block;

@end
