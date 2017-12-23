//
//  ZGPhotoScrollView.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/11/2.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZGPhotoContentView.h"
@interface ZGPhotoScrollView : UIScrollView
@property (nonatomic, strong) ZGPhotoContentView *photoContentView;
- (void)setContentOffsetY:(CGFloat)offsetY;
- (void)setContentOffsetX:(CGFloat)offsetX;
- (CGFloat)zoomScaleToBound;
@end
