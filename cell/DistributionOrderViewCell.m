//
//  DistributionOrderViewCell.m
//  NewStore
//
//  Created by edz on 17/1/7.
//  Copyright © 2017年 QunYu_TD. All rights reserved.
//

#import "DistributionOrderViewCell.h"
#import "ProductEntity.h"

@implementation DistributionOrderViewCell

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
- (void)cellDataDraw:(NSArray *)art {
    
    [proImage sd_setImageWithURL:[NSURL URLWithString:[art valueForKey:@"good_image"]] placeholderImage:[UIImage imageNamed:@"loading-6"] options:SDWebImageRetryFailed];
    
    if (art) {
        proName.text = [art valueForKey:@"good_name"];
        proNum.text = [NSString stringWithFormat:@"x%@",[art valueForKey:@"nums"]];
        proSize.text = [NSString stringWithFormat:@"规格:%@",[art valueForKey:@"good_size"]];
        NSString *price = [art valueForKey:@"good_price"];
        proPrice.text = [NSString stringWithFormat:@"￥%0.2f",[price floatValue]];
        proTime.text = [art valueForKey:@""];
    } else {
        proName.text = @"商品";
        proNum.text = @"x1";
    }
    
    
}
@end
