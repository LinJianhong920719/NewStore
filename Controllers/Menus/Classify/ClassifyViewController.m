//
//  ClassifyViewController.m
//  MailWorldClient
//
//  Created by yusaiyan on 16/9/2.
//  Copyright © 2016年 QunYu_TD. All rights reserved.
//

#import "ClassifyViewController.h"
#import "ClassifyCateCell.h"
#import "ClassifyCateModel.h"

//#import "ProductListViewController.h"

#define tableViewWidth              100
#define collectViewWidth            ScreenWidth-tableViewWidth

#define margin                      turn6(8)
#define cellSpacing                 turn6(0)     //item间距
#define cellRowShowsNumber          3      //每行显示的item个数
#define collectionViewCellWidths    (collectViewWidth-(cellRowShowsNumber-1)*cellSpacing-margin)/cellRowShowsNumber
#define collectionViewCellSize      CGSizeMake(collectionViewCellWidths, 88)

@interface ClassifyViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource> {
    NSInteger currentRow;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self hideNaviBarLeftBtn:YES];
    
    [self setNaviBarTitle:@"分类"];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)loadData {
    
    NSString *url = [PPNetworkHelper requestURL:@"productType.do?"];
    
    [PPNetworkHelper POST:url parameters:nil encrypt:NO responseCache:^(id responseCache) {
        [self responseData:responseCache];
    } success:^(id responseObject) {
        [self responseData:responseObject];
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)responseData:(id)data {
    
    NSArray *result = [data valueForKey:@"result"];
    
    if (result) {
        
        [_dataArray removeAllObjects];
        
        for (NSDictionary *dic in result) {
            ClassifyCateModel *model = [[ClassifyCateModel alloc]initWithDictionary:dic];
            [self.dataArray addObject:model];
            
            for (NSDictionary *subDic in model.classify_subArray) {
                ClassifyCateModel *modelSub = [[ClassifyCateModel alloc]initWithDictionary:subDic];
                [model.classify_subclass addObject:modelSub];
            }
            
        }
        
    }
    
    [self.collectionView reloadData];
    [self.tableView reloadData];
    
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

#pragma mark - UICollectionView

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(tableViewWidth, ViewOrignY+10, collectViewWidth, ScreenHeight-ViewOrignY-60) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_collectionView];
        
        UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([ClassifyCateCell class]) bundle:[NSBundle mainBundle]];
        [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ClassifyCateCell"];
        
    }
    return _collectionView;
}

// ----------------------------------------------------------------------------------------
// 定义展示的Section的个数
// ----------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

// ----------------------------------------------------------------------------------------
// 定义展示的UICollectionViewCell的个数
// ----------------------------------------------------------------------------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    ClassifyCateModel *model = [_dataArray objectAtIndex:currentRow];
    return model.classify_subclass.count;
}

// ----------------------------------------------------------------------------------------
// 每个UICollectionView展示的内容
// ----------------------------------------------------------------------------------------
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * CellIdentifier = @"ClassifyCateCell";
    
    ClassifyCateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    NSInteger item = [indexPath item];
    
    if ([_dataArray count] > 0) {
        ClassifyCateModel *model = [_dataArray objectAtIndex:currentRow];
        ClassifyCateModel *modelSub = [model.classify_subclass objectAtIndex:item];
        
        [cell.banner sd_setImageWithURL:[NSURL URLWithString:modelSub.classify_pic] placeholderImage:[UIImage imageNamed:@"loading-4"] options:SDWebImageRetryFailed];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@", modelSub.classify_title];
    }
    
    return cell;
}

#pragma mark -- UICollectionView 点击

// ----------------------------------------------------------------------------------------
// UICollectionView被选中时调用的方法
// ----------------------------------------------------------------------------------------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = [indexPath item];
    
    ClassifyCateModel *model = [_dataArray objectAtIndex:currentRow];
    ClassifyCateModel *modelSub = [model.classify_subclass objectAtIndex:item];
    
//    GoodsListViewController * product = [[GoodsListViewController alloc]init];
//    product.typeId = modelSub.classify_sub_id;
//    product.title  = modelSub.classify_title;
//    product.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:product animated:YES];
}

// ----------------------------------------------------------------------------------------
// 返回这个UICollectionView是否可以被选择
// ----------------------------------------------------------------------------------------
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark -- UICollectionViewDelegateFlowLayout

// ----------------------------------------------------------------------------------------
// 定义每个Item 的大小
// ----------------------------------------------------------------------------------------
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionViewCellSize;
}

// ----------------------------------------------------------------------------------------
// 定义每个UICollectionView 的 margin
// ----------------------------------------------------------------------------------------
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, margin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return cellSpacing;
}

//定义每个Item 的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return cellSpacing;
}

#pragma mark - UITableView

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.frame = CGRectMake(0, ViewOrignY+10, tableViewWidth, ScreenHeight-ViewOrignY-60);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = COLOR_F2F2F2;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        
        currentRow = 0;
    }
    return _tableView;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
    NSInteger row = [indexPath row];
    
    if (currentRow == row) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = THEME_COLORS_RED;
    } else {
        cell.backgroundColor = COLOR_F2F2F2;
        cell.textLabel.textColor = COLOR_595757;
    }
    
    ClassifyCateModel *model = [_dataArray objectAtIndex:row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", model.classify_title];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = [indexPath row];
    currentRow = row;
    
    [_tableView reloadData];
    
    
    [_collectionView reloadData];
}

@end
