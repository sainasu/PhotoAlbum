//
//  ZGEditPicturesController.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/30.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@class ZGEditPicturesController;
@protocol ZGEditPicturesControllerDelegate <NSObject>//协议
//编辑完成
- (void)editPicturesController:(ZGEditPicturesController *)editPictures photoEditorSaveImage:(PHAsset *)asset newAsset:(PHAsset *)newAsset;
//编辑取消
- (void)editPicturesControllerDidCancel:(ZGEditPicturesController *)editPictures;
@end

@interface ZGEditPicturesController : UIViewController

@property(nonatomic, strong) PHAsset *editPicturesAsset;  /**被编辑的PHAsset*/
@property(nonatomic, strong) UIImage *editImage;/**被编辑的图片*/

@property (nonatomic, assign) id<ZGEditPicturesControllerDelegate>editPicturesDelegate;  //代理属性


@end
