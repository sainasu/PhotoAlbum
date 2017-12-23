//
//  ZGPhotoScrollView.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/11/2.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPhotoScrollView.h"

@implementation ZGPhotoScrollView


- (void)setContentOffsetY:(CGFloat)offsetY
{
        CGPoint contentOffset = self.contentOffset;
        contentOffset.y = offsetY;
        self.contentOffset = contentOffset;
}

- (void)setContentOffsetX:(CGFloat)offsetX
{
        CGPoint contentOffset = self.contentOffset;
        contentOffset.x = offsetX;
        self.contentOffset = contentOffset;
}

- (CGFloat)zoomScaleToBound
{
        CGFloat scaleW = self.bounds.size.width / self.photoContentView.bounds.size.width;
        CGFloat scaleH = self.bounds.size.height / self.photoContentView.bounds.size.height;
        CGFloat max = MAX(scaleW, scaleH);
        
        return max;
}

@end
