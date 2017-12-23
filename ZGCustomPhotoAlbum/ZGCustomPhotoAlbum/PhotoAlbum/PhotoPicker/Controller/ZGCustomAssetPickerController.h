//
//  ZGCustomAssetPickerController.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/14.
//  Copyright © 2017年 saina. All rights reserved.
//
/**
 控制器： 默认选择只能选择图片， 最大数9，完成按钮， 不能编辑。
 */

#import "ZGViewController.h"
#import "ZGCustomAssetPickerBar.h"
//选择类型
typedef NS_ENUM(NSInteger, ZGCustomAssetPickerSelectType) {
        ZGCustomAssetPickerSelectTypeImageAndVideo,
        ZGCustomAssetPickerSelectTypeImage,
        ZGCustomAssetPickerSelectTypeVideo
};

@protocol ZGCustomAssetsPickerControllerDelegate;

@interface ZGCustomAssetPickerController : ZGViewController
/// 选择类型枚举， 默认是 ZGCustomAssetPickerSelectTypeImageAndVideo
@property(nonatomic, assign) ZGCustomAssetPickerSelectType  selectType;
 /// 完成或发送按钮样式 默认值: ZGCustomAssetPickerReturnTypeSend
@property(nonatomic, assign) ZGCustomImagePickerReturnType returnType;
/// 是否允许选择原图，默认是NO（NO则没有原图按钮。YES则有原图按钮), 只对图片有作用
@property(nonatomic, assign) BOOL  allowsRawImageSelecting;
/// 可选最大数 默认为9。 当maximumCount = 1 时则没有选择按钮
@property(nonatomic, assign) NSUInteger  maximumCount;
/// 已选择数量 默认：0， 大于maximumCount， 则默认设置为0；
@property(nonatomic, assign) NSUInteger  selectedCount;
/// 是否编辑图片， 只有当ZGCustomImagePickerSelectType =ZGCustomImagePickerSelectTypeImage ||ZGCustomImagePickerSelectTypeImageAndVideo时有效，   默认NO
@property(nonatomic, assign) BOOL  allowsImageEditing;
///可发送视频最大持续时间（默认时间是 300s)以秒为单位， 如果小于1s或大于300，则默认设置为300s；
@property(nonatomic, assign) NSUInteger  videoMaximumDuration;
///截图：allowsCroping == YES 且 self.selectType != ZGCustomImagePickerSelectTypeVideo时 = yes， 默认为NO
@property(nonatomic, assign) BOOL  allowsCroping;
/// 截图尺寸(allowsCroping = yes时有效，默认值为：CGSizeMake(self.view.frame.size.width, self.view.frame.size.width))宽或高不能等于0
@property(nonatomic, assign) CGSize  cropSize;
/// 图片选择器代理
@property (nonatomic, assign) id<ZGCustomAssetsPickerControllerDelegate> assetsPickerDelegate;
@end

@protocol ZGCustomAssetsPickerControllerDelegate <NSObject>
/// 操作完成之后代理: 返回@[Asset], 是否为原图
- (void)customAssetsPickerController:(ZGCustomAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets isOriginalImage:(BOOL)isOriginalImage;
/// 取消选择, 关闭控制器
- (void)customAssetsPickerControllerDidCancel:(ZGCustomAssetPickerController *)picker;
@end

