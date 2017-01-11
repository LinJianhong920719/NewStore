//
//  OrderDetailViewCell.m
//  NewStore
//
//  Created by edz on 17/1/7.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import "OrderDetailViewCell.h"
#import "ProductEntity.h"

@implementation OrderDetailViewCell

@synthesize proImage;
@synthesize proName;
@synthesize proPrice;
@synthesize proNum;
@synthesize proSize;
@synthesize proTime;


- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)cellDataDraw:(OrderEntity *)orderEntity {
    
    
    
    if (orderEntity) {
        [proImage sd_setImageWithURL:[NSURL URLWithString:orderEntity.goodImage] placeholderImage:[UIImage imageNamed:@"loading-6"] options:SDWebImageRetryFailed];
        proName.text = orderEntity.goodName;
        proNum.text = [NSString stringWithFormat:@"x%@",orderEntity.goodNums];
        proSize.text = [NSString stringWithFormat:@"规格:%@",orderEntity.goodSize];
        NSString *price = orderEntity.goodPirce;
        proPrice.text = [NSString stringWithFormat:@"￥%0.2f",[price floatValue]];
    } else {
        proName.text = @"商品";
        proNum.text = @"x1";
    }
    
    
}
@end
