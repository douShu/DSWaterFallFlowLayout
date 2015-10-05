//
//  DSWaterfallFlowLayout.h
//  瀑布流
//
//  Created by 逗叔 on 15/10/5.
//  Copyright © 2015年 逗叔. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSWaterfallFlowLayout;

@protocol DSWaterfallFlowLayoutDelegate <NSObject>

@required
/**
 * 返回 indexPath位置 cell 的高度
 */
- (CGFloat)waterfallFlowLayout: (DSWaterfallFlowLayout *)layout heightForItemAtIndexPath: (NSIndexPath *)indexPath withItemWidth: (CGFloat)width;

@optional
/**
 *  返回布局的行间距
 */
- (CGFloat)rowSpacingInWaterfallFlowLayout:(DSWaterfallFlowLayout *)layout;

/**
 *  返回布局的列间距
 */
- (CGFloat)columnSpacingInWaterfallFlowLayout:(DSWaterfallFlowLayout *)layout;

/**
 *  返回布局的边距
 */
- (UIEdgeInsets)edgeInsetsInWaterfallFlowLayout:(DSWaterfallFlowLayout *)layout;

/**
 *  返回布局的列数
 */
- (NSUInteger)columnCountInWaterfallFlowLayout:(DSWaterfallFlowLayout *)layout;
@end

@interface DSWaterfallFlowLayout : UICollectionViewLayout

@property (nonatomic, weak) id<DSWaterfallFlowLayoutDelegate> delegate;

- (instancetype)initWithDelegate: (id<DSWaterfallFlowLayoutDelegate>)delegate;

@end
