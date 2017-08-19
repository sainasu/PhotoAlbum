//
//  SNPhotoEditorsController.h
//  SN_ImageEditor
//
//  Created by saina_su on 2017/7/10.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@protocol SNPhotoEditorsControllerDelegate <NSObject>//协议
//点击cell的时候返回数组, 更新UI
- (void)photoEditorSaveImage:(PHAsset *)asset newAsset:(PHAsset *)newAsset;//协议方法

@end

@interface SNPhotoEditorsController : UIViewController
@property(nonatomic, strong) PHAsset *mainAsset;/**外面传进来的PHAsset*/
@property (nonatomic, assign) id<SNPhotoEditorsControllerDelegate>delegate;//代理属性
@property(nonatomic, strong) NSString *collectionTitle;/**文件夹名称*/

@end
