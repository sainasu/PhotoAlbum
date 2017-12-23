//
//  ZGAssetPreviewCell.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/17.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZGAssetPreviewCellDelegate;

@interface ZGAssetPreviewCell : UICollectionViewCell
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, assign) NSInteger count;
@property(nonatomic, assign) NSUInteger videoDuration;

@property (nonatomic, assign) id<ZGAssetPreviewCellDelegate> cellImageDelegate;


@end
@protocol ZGAssetPreviewCellDelegate <NSObject>

- (void)assetPreviewCell:(ZGAssetPreviewCell *)imageCell actionButton:(UIButton *)btn;

@end
