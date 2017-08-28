//
//  ZGPAViewModel.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/7.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>


static CGSize minSizes = {100, 100};


@interface ZGPAViewModel : NSObject
#pragma mark - 获取到PHAsset
/**获取文件夹名称,和里面PHasst的数量以及第一张展示图*/
+(NSMutableArray *)createAccessToCollections;
//获取最新添加相册中的最后一个PHAsset
+(PHAsset *)lastAsset;
//删除最后添加的Asset
+(void)removeLastAsset;
//按照相册名获取PHAsset
+(NSMutableArray *)accordingToTheCollectionTitleOfLodingPHAsset:(NSString *)title;

//自定义按钮
+(UIButton *)createBtnFrame:(CGRect)frame image:(UIImage *)image SelectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action;

//获取图片
/**
 获取原图：size  == PHImageManagerMaximumSize
 contentMode == PHImageContentModeDefault
 缩略图：  size == 需要的大小
 contentMode == PHImageContentModeAspectFill
 */
+(UIImage *)createAccessToImage:(PHAsset *)asset imageSize:(CGSize)size contentMode:(PHImageContentMode)contentMode;
//
+(NSURL *)createAccessToVideo:(PHAsset *)asset;

//获取尺寸
+ (CGRect)adjustTheUIInTheImage:(UIImage *)image;










+(void)aliertControllerTitle:(NSString *)title viewController:(UIViewController *)view;

@end
