//
//  ClassifyCateCell.h
//  MailWorldClient
//
//  Created by yusaiyan on 16/9/3.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ClassifyCateCellSize CGSizeMake(turn6(104), turn6(67)+23)

@interface ClassifyCateCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *banner;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end