//
//  DSWaterfallFlowLayout.m
//  瀑布流
//
//  Created by 逗叔 on 15/10/5.
//  Copyright © 2015年 逗叔. All rights reserved.
//

#import "DSWaterfallFlowLayout.h"

#define DSCollectionViewWidth self.collectionView.frame.size.width

// 默认行间距
static const CGFloat DSDefaultRowSpacing = 10;

// 默认列间距
static const CGFloat DSDefaultColumnSpacing = 10;

// 默认边距
static const UIEdgeInsets DSDefaultEdgeInsets = {10, 10, 10, 10};

// 默认列数
static const NSInteger DSDefaultColumnCount = 3;


@interface DSWaterfallFlowLayout ()

/**
 * 所有 cell 的布局属性
 */
@property (nonatomic, strong) NSMutableArray *attrArrayM;

/**
 * 每一列的最大 y 坐标
 */
@property (nonatomic, strong) NSMutableArray *columnMaxYs;

- (CGFloat)rowSpacing;
- (CGFloat)columnSpacing;
- (CGFloat)columnCount;
- (UIEdgeInsets) edgeInsets;

@end


@implementation DSWaterfallFlowLayout


- (instancetype)initWithDelegate: (id<DSWaterfallFlowLayoutDelegate>)delegate {

    DSWaterfallFlowLayout *layout = [[DSWaterfallFlowLayout alloc] init];
    
    layout.delegate = delegate;
    
    return layout;
}

#pragma mark - ------------------- 实现内部方法 -------------------
/**
 * 决定 collectionView 的 contentsize
 */
- (CGSize)collectionViewContentSize {

    CGFloat maxY = [self.columnMaxYs[0] doubleValue];
    
    for ( int i = 1; i<self.columnCount; i++) {
        
        CGFloat y = [self.columnMaxYs[i] doubleValue];
        if (y > maxY) {
            
            maxY = y;
        }
    }
    return CGSizeMake(DSCollectionViewWidth, maxY + self.edgeInsets.bottom);
}

/**
 *  准备布局
 */
- (void)prepareLayout {

    [super prepareLayout];
    
    // 1. 重置每一列的最大 y 坐标
    [self.columnMaxYs removeAllObjects];
    for (int i = 0; i<self.columnCount; i++) {
        
        [self.columnMaxYs addObject:@(self.edgeInsets.top)];
    }
    
    // 2. 计算所有 cell 的布局属性
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    
    // 2.1. 先移除原来的
    [self.attrArrayM removeAllObjects];
    
    // 2.2 再布局新的 cell 属性
    for (int i = 0; i<count; i++) {
        
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        [self.attrArrayM addObject:attr];
    }
}

/**
 * 说明所有元素最终显示出来的布局属性
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {

    NSMutableArray *arrM = [NSMutableArray array];
    
    NSUInteger count = self.attrArrayM.count;
    for (int i = 0; i<count; i++) {
        
        UICollectionViewLayoutAttributes *attr = self.attrArrayM[i];
        
        // 只将显示出来的 cell 属性返回
        if (CGRectIntersectsRect(rect, attr.frame)) {
            
            [arrM addObject:attr];
        }
    }
    return arrM;
}

/**
 * 说明 indexpath 位置 cell 的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // 找出最短那一列的列号和最大 y 坐标
    CGFloat minY = [self.columnMaxYs[0] doubleValue];
    NSUInteger columnIndex = 0;
    for (int i = 1; i<self.columnMaxYs.count; i++) {
        
        CGFloat y = [self.columnMaxYs[i] doubleValue];
        
        if (y < minY) {
            minY = y;
            columnIndex = i;
        }
    }
    CGFloat width = (DSCollectionViewWidth - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnSpacing) / self.columnCount;
    CGFloat height = [self.delegate waterfallFlowLayout:self heightForItemAtIndexPath:indexPath withItemWidth:width];
    CGFloat x = self.edgeInsets.left + columnIndex * (width + self.columnSpacing);
    if (minY != self.edgeInsets.top) {
        
        minY += self.columnSpacing;
    }
    attr.frame = CGRectMake(x, minY, width, height);
    
    // 更行最大 y 坐标
    self.columnMaxYs[columnIndex] = @(CGRectGetMaxY(attr.frame));
    
    return attr;
}

#pragma mark - ------------------- 处理代理方法 -------------------
- (CGFloat)rowSpacing {
    
    if ([self.delegate respondsToSelector:@selector(rowSpacingInWaterfallFlowLayout:)]) {
        return [self.delegate rowSpacingInWaterfallFlowLayout:self];
    }

    return DSDefaultRowSpacing;
}

- (CGFloat)columnSpacing {
    
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterfallFlowLayout:)]) {
        return [self.delegate columnSpacingInWaterfallFlowLayout:self];
    }

    return DSDefaultColumnSpacing;
}

- (CGFloat)columnCount {
    
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterfallFlowLayout:)]) {
        return [self.delegate columnCountInWaterfallFlowLayout:self];
    }

    return DSDefaultColumnCount;
}

- (UIEdgeInsets)edgeInsets {
    
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterfallFlowLayout:)]) {
        return [self.delegate edgeInsetsInWaterfallFlowLayout:self];
    }

    return DSDefaultEdgeInsets;
}

#pragma mark - ------------------- 懒加载 -------------------
- (NSMutableArray *)attrArrayM {

    if (_attrArrayM == nil) {
        
        _attrArrayM = [NSMutableArray array];
    }
    return _attrArrayM;
}

- (NSMutableArray *)columnMaxYs {

    if (_columnMaxYs == nil) {
        
        _columnMaxYs = [NSMutableArray array];
    }
    return _columnMaxYs;
}

@end
