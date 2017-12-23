//
//  ZGPagePreviewVideoCell.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/17.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface ZGPagePreviewVideoCell : UICollectionViewCell
-(void)pauseVideo;
@property(nonatomic, strong) PHAsset *videoAsset;

@end
