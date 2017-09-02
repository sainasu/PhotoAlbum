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
@property(nonatomic, strong) PHAsset *editPicturesAsset;  /**外面传进来的PHAsset*/
@property(nonatomic, strong) NSString *editPicturesCollectionTitle;  /**文件夹名称*/
@property (nonatomic, assign) id<ZGEditPicturesControllerDelegate>editPicturesDelegate;  //代理属性


@end
