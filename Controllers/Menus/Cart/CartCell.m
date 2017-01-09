//
//  CartCell.m
//  NewStore
//
//  Created by yusaiyan on 16/9/23.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "CartCell.h"

@interface CartCell () {
    CartNumberChangedBlock numberAddBlock;
    CartNumberChangedBlock numberCutBlock;
    CartCellSelectedBlock cellSelectedBlock;
    CartCellSelectedBlock cellClickBlock;
}

//选中按钮
@property (nonatomic,retain) UIButton *selectBtn;
//显示照片
@property (nonatomic,retain) UIImageView *picView;
//
@property (nonatomic,retain) UIImageView *promptView;
//商品名
@property (nonatomic,retain) UILabel *nameLabel;
//尺寸
@property (nonatomic,retain) UILabel *sizeLabel;
//价格
@property (nonatomic,retain) UILabel *priceLabel;
//数量
@property (nonatomic,retain)UILabel *numberLabel;

@end

@implementation CartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupMainView];
    }
    return self;
}

#pragma mark - public method

- (void)CartReloadDataWithModel:(CartModel *)model {
    
    self.promptView.hidden = model.cart_status;
    self.selectBtn.userInteractionEnabled = model.cart_status;

    
    [self.picView sd_setImageWithURL:[NSURL URLWithString:model.cart_pic] placeholderImage:[UIImage imageNamed:@"loading-6"] options:SDWebImageRetryFailed];
    
    self.nameLabel.text = model.cart_title;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.cart_price];
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)model.number];
    self.sizeLabel.text = model.cart_size;
    self.selectBtn.selected = model.select;
}

- (void)CartNumberAddWithBlock:(CartNumberChangedBlock)block {
    numberAddBlock = block;
}

- (void)CartNumberCutWithBlock:(CartNumberChangedBlock)block {
    numberCutBlock = block;
}

- (void)CartCellSelectedWithBlock:(CartCellSelectedBlock)block {
    cellSelectedBlock = block;
}

- (void)CartCellClickBlock:(CartCellSelectedBlock)block {
    cellClickBlock = block;
}

#pragma mark - 重写setter方法

- (void)setNumber:(NSInteger)number {
    _number = number;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)number];
}

- (void)setSelect:(BOOL)select {
    _select = select;
    self.selectBtn.selected = select;
}

#pragma mark - 按钮点击方法

/**
 *  勾选
 */
- (void)selectBtnClick:(UIButton*)button {
    button.selected = !button.selected;
    
    if (cellSelectedBlock) {
        cellSelectedBlock(button.selected);
    }
}

/**
 *  加
 */
- (void)addBtnClick:(UIButton*)button {
    
    NSInteger count = [self.numberLabel.text integerValue];
    count++;
    
    if (numberAddBlock) {
        numberAddBlock(count);
    }
}

/**
 *  减
 */
- (void)cutBtnClick:(UIButton*)button {
    NSInteger count = [self.numberLabel.text integerValue];
    count--;
    if(count <= 0){
        return ;
    }
    
    if (numberCutBlock) {
        numberCutBlock(count);
    }
}

/**
 *  点击图片
 */
- (void)buttonpress:(UITapGestureRecognizer *)gestureRecognizer {
    
    if (cellClickBlock) {
        cellClickBlock(YES);
    }
}

#pragma mark - 布局主视图
-(void)setupMainView {
    //白色背景
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 5, ScreenWidth, rowHeight-5);
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = ColorFromHex(0xEEEEEE).CGColor;
    bgView.layer.borderWidth = 1;
    [self addSubview:bgView];
    
    //选中按钮
    UIButton* selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.center = CGPointMake(20, bgView.height/2.0);
    selectBtn.bounds = CGRectMake(0, 0, 30, 30);
    [selectBtn setImage:[UIImage imageNamed:Bottom_UnSelectButtonString] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:Bottom_SelectButtonString] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:selectBtn];
    self.selectBtn = selectBtn;
    
    //照片背景
    UIView *imageBgView = [[UIView alloc]init];
    imageBgView.frame = CGRectMake(selectBtn.right + 10, 10, bgView.height - 20, bgView.height - 20);
    imageBgView.backgroundColor = ColorFromHex(0xF3F3F3);
    [bgView addSubview:imageBgView];
    
    //显示照片
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"loading-6"];
    imageView.frame = imageBgView.frame;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [bgView addSubview:imageView];
    self.picView = imageView;
    
    //显示照片
    UIImageView *promptView = [[UIImageView alloc]init];
    promptView.image = [UIImage imageNamed:@"cart_status_off"];
    promptView.frame = imageBgView.frame;
    promptView.contentMode = UIViewContentModeScaleAspectFill;
    [bgView addSubview:promptView];
    self.promptView = promptView;
    
    //图片点击
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress:)];
    [imageView addGestureRecognizer:singleTap];
    
    CGFloat width = (bgView.width - imageBgView.right - 30);
    //价格
    UILabel* priceLabel = [[UILabel alloc]init];
    priceLabel.frame = CGRectMake(bgView.width - width - 20, bgView.height - 35, width, 30);
    priceLabel.font = [UIFont boldSystemFontOfSize:13];
    priceLabel.textColor = THEME_COLORS_RED;
    priceLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    //商品名
    UILabel* nameLabel = [[UILabel alloc]init];
    nameLabel.frame = CGRectMake(imageBgView.right + 10, 10, width, 25);
    nameLabel.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //尺寸
    UILabel* sizeLabel = [[UILabel alloc]init];
    sizeLabel.frame = CGRectMake(nameLabel.left, nameLabel.bottom + 5, width, 20);
    sizeLabel.textColor = COLOR_898989;
    sizeLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:sizeLabel];
    self.sizeLabel = sizeLabel;
    
    //数量减按钮
    UIButton *cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cutBtn.frame = CGRectMake(imageBgView.right + 10, bgView.height - 35, 25, 25);
    [cutBtn setImage:[UIImage imageNamed:@"cart_cut_n"] forState:UIControlStateNormal];
    [cutBtn setImage:[UIImage imageNamed:@"cart_cut_h"] forState:UIControlStateHighlighted];
    [cutBtn addTarget:self action:@selector(cutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cutBtn];
    
    //数量显示
    UILabel* numberLabel = [[UILabel alloc]init];
    numberLabel.frame = CGRectMake(cutBtn.right + 5, cutBtn.top, 30, 25);
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.text = @"1";
    numberLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:numberLabel];
    self.numberLabel = numberLabel;
    
    //数量加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(numberLabel.right + 5, cutBtn.top, 25, 25);
    [addBtn setImage:[UIImage imageNamed:@"cart_add_n"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"cart_add_h"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:addBtn];
    
}

@end

