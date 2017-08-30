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
//点击cell的时候返回数组, 更新UI
- (void)editPicturesController:(ZGEditPicturesController *)editPictures photoEditorSaveImage:(PHAsset *)asset newAsset:(PHAsset *)newAsset;//协议方法

@end

@interface ZGEditPicturesController : UIViewController
@property(nonatomic, strong) PHAsset *mainAsset;/**外面传进来的PHAsset*/
@property (nonatomic, assign) id<ZGEditPicturesControllerDelegate>editPicturesDelegate;//代理属性
@property(nonatomic, strong) NSString *collectionTitle;/**文件夹名称*/


@end
