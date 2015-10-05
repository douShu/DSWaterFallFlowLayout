//
//  DSClothesViewController.m
//  瀑布流
//
//  Created by 逗叔 on 15/10/5.
//  Copyright © 2015年 逗叔. All rights reserved.
//

#import "DSClothesViewController.h"
#import "DSWaterfallFlowLayout.h"
#import "DSClothesCell.h"
#import "DSClothes.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import <SDWebImageManager.h>

@interface DSClothesViewController () <DSWaterfallFlowLayoutDelegate>

@property (nonatomic, strong) NSMutableArray *clothesArray;

@end

@implementation DSClothesViewController

static NSString * const reuseIdentifier = @"ClothesCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    NSArray *temp = [DSClothes objectArrayWithFilename:@"clothes.plist"];
    self.clothesArray = temp.mutableCopy;
    
    self.collectionView.collectionViewLayout = [[DSWaterfallFlowLayout alloc] initWithDelegate:self];
    
    // 刷新数据
    __weak typeof(self) weakSelf = self;
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSArray *array = [DSClothes objectArrayWithFilename:@"clothes.plist"];
        
        [weakSelf.clothesArray insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
        [weakSelf.collectionView reloadData];
        
        // 结束刷新
        [weakSelf.collectionView.header endRefreshing];
    }];
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        NSArray *array = [DSClothes objectArrayWithFilename:@"clothes.plist"];

        [weakSelf.clothesArray addObjectsFromArray:array];
        
        [weakSelf.collectionView reloadData];
        
        NSLog(@"%tu", self.clothesArray.count);
        
        // 结束刷新
        [weakSelf.collectionView.footer endRefreshing];
    }];
}

#pragma mark - ------------------- 代理方法 -------------------
- (CGFloat)waterfallFlowLayout:(DSWaterfallFlowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath withItemWidth:(CGFloat)width {

    DSClothes *clothes = self.clothesArray[indexPath.item];
    
    return width * clothes.h / clothes.w;
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.clothesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DSClothesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.clothes = self.clothesArray[indexPath.item];
    
    return cell;
}

#pragma mark - ------------------- 懒加载 -------------------
- (NSMutableArray *)clothesArray {

    if (_clothesArray == nil) {
        
        _clothesArray = [NSMutableArray array];
    }
    return _clothesArray;
}

@end
