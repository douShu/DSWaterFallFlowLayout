//
//  DSClothes.h
//  瀑布流
//
//  Created by 逗叔 on 15/10/5.
//  Copyright © 2015年 逗叔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSClothes : NSObject
// 宽度
@property (nonatomic, assign) CGFloat w;
// 高度
@property (nonatomic, assign) CGFloat h;
// 图片
@property (nonatomic, copy) NSString *img;
// 价格
@property (nonatomic, copy) NSString *price;

@end
