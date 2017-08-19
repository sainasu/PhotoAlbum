//
//  ZGThumbnailsPreviewVideoCell.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/7.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZGThumbnailsPreviewVideoCell : UICollectionViewCell
@property(nonatomic, strong) UIImageView *imageView;/**图片*/
@property(nonatomic, strong) UIImageView *videoImage;/**视频图片*/
@property(nonatomic, strong) UILabel *videoTimer;/**视频时间*/
@property(nonatomic, strong)  UIButton *selectButton;/**选择按钮*/


@end
