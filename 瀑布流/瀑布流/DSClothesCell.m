//
//  DSClothesCell.m
//  瀑布流
//
//  Created by 逗叔 on 15/10/5.
//  Copyright © 2015年 逗叔. All rights reserved.
//

#import "DSClothesCell.h"
#import <UIImageView+WebCache.h>

@implementation DSClothesCell

- (void)setClothes:(DSClothes *)clothes {

    self.price.text = clothes.price;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:clothes.img]];
}
@end
