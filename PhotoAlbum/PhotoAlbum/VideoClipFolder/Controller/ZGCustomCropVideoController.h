//
//  ZGCustomCropVideoController.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/30.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class ZGCustomCropVideoController;

@protocol ZGCustomCropVideoControllerDelegate <NSObject>
//返回截取好的视频
-(void)cropVideoController:(ZGCustomCropVideoController *)cropVideo didFinishCropVideoAsset:(PHAsset *)asset;
- (void)cropVideoControllerDidCancelCrop:(ZGCustomCropVideoController *)cropVideo;

@end

@interface ZGCustomCropVideoController : UIViewController

@property(nonatomic, weak) id<ZGCustomCropVideoControllerDelegate>  cropVideoDelegate;
@property(nonatomic, strong) NSURL *vcURL;/**需要参数URL*/
@property(nonatomic, assign) CGFloat lengthNumber;/**参数: 截取的长度*/
/**可选最大数(isPicturesAndVideoCombination = YES时有效)*/
@property(nonatomic, assign) NSInteger  maySelectMaximumCount;
@property(nonatomic, strong) UIViewController *fromViewController;/**来自哪儿个控制器*/


@end
