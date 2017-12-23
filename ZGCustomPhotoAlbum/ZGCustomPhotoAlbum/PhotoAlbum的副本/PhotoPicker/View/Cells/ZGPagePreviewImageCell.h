//
//  ZGPagePreviewImageCell.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/17.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZGPagePreviewImageView.h"

@protocol ZGPagePreviewImageCellDelegate;
@interface ZGPagePreviewImageCell : UICollectionViewCell<ZGPagePreviewImageViewDelegate>
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) ZGPagePreviewImageView *imageView;
@property(nonatomic, assign) id<ZGPagePreviewImageCellDelegate>  imageCellDelegate;

- (void)resetView;

@end

@protocol ZGPagePreviewImageCellDelegate <NSObject>
- (void)pagePreviewImageCell:(ZGPagePreviewImageCell *)imageView;

@end
