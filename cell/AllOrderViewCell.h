//
//  AllOrderViewCell.h
//  NewStore
//
//  Created by edz on 17/1/7.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllOrderEntity.h"

@interface AllOrderViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *proImage;
@property (weak, nonatomic) IBOutlet UILabel *proName;
@property (weak, nonatomic) IBOutlet UILabel *proPrice;
@property (weak, nonatomic) IBOutlet UILabel *proNum;
@property (weak, nonatomic) IBOutlet UILabel *proSize;
@property (weak, nonatomic) IBOutlet UILabel *proTime;


- (void)cellDataDraw:(AllOrderEntity *)model;
@end
