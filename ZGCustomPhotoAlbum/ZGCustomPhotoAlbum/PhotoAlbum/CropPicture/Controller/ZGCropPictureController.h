//
//  ZGCropPictureController.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/18.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGViewController.h"
#import <Photos/Photos.h>
@protocol ZGCropPictureControllerDelegate;

@interface ZGCropPictureController : ZGViewController
/// 截取的尺寸
@property(nonatomic, assign) CGSize  cropPictureSize;
/// 需要截取的图片
@property(nonatomic, strong) UIImage *cropPictureImage;
/// 是否要圆形
@property(nonatomic, assign) BOOL  isRound;

@property (nonatomic, assign) id<ZGCropPictureControllerDelegate> cropPictureDelegate;

@end
@protocol ZGCropPictureControllerDelegate <NSObject>
- (void)cropPictureController:(ZGCropPictureController *)cropPicture didFinishCropingPictureAsset:(PHAsset *)assets;
- (void)cropPictureControllerDidCancel:(ZGCropPictureController *)cropPicture;

@end
