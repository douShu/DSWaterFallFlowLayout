//
//  DSClothesCell.h
//  瀑布流
//
//  Created by 逗叔 on 15/10/5.
//  Copyright © 2015年 逗叔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSClothes.h"

@interface DSClothesCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (nonatomic, strong) DSClothes *clothes;
@end
