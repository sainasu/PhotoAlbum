//
//  ZGCustomImagePickerController.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/30.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGCIPViewController.h"
#import "ZGCIPHeader.h"
@class ZGCustomImagePickerController;
//选择类型
typedef NS_ENUM(NSInteger, ZGCIPSelectType) {
        ZGCIPSelectTypeImageAndVideo = 1,//图片和视频
        ZGCIPSelectTypeImage = 2,//图片
        ZGCIPSelectTypeVideo = 3//视频
};
/*
//TODO:图和视频合选的时====> 例如: 朋友圈;

//TODO:横屏
*/

@protocol ZGCustomImagePickerControllerDelegate <NSObject>
//返回选择完成的数据delegate（用户选择完成后调用该方法）
- (void)customImagePickerController:(ZGCustomImagePickerController *)picker  didFinishPickingAssets:(NSMutableArray *)assets isSendTheOriginalPictures:(BOOL)idOriginalPictures;
//取消选择(用户取消选择时调用该代理)
- (void)customImagePickerControllerDidCancel:(ZGCustomImagePickerController *)picker;
@end

@interface ZGCustomImagePickerController : ZGCIPViewController
//下列参数
/**选择类型枚举*/
@property(nonatomic, assign) ZGCIPSelectType  selectType;
/**完成或发送按钮样式 默认值: icon_navbar_ok*/
@property(nonatomic, strong) UIImage *returnButtonType;
/**是否发送原图raw*/
@property(nonatomic, assign) BOOL  isRawImage;
/**可选最大数 默认：optionalMaximumNumber = 9, 当optionalMaximumNumber = 1 时则没有选择按钮*/
@property(nonatomic, assign) NSInteger  maximumCount;
/**已选择数量 默认：0*/
@property(nonatomic, assign) NSInteger  selectedCount;
/**是否编辑图片 默认NO */
@property(nonatomic, assign) BOOL  allowsEditing;
/**可发送视频最大时间（默认时间是 15s), 时间以秒为单位 maxDuration*/
@property(nonatomic, assign) NSInteger  maxDuration;
/**是否截图, 默认值： NO  (whetherTheCrop = yes时 以上参数都无效) */
@property(nonatomic, assign) BOOL  shouldCrop;
/**截图尺寸(whetherTheCrop = yes时有效)宽或高都不能等于0 （必须有值）*/
@property(nonatomic, assign) CGSize  cropSize;

@property(nonatomic, assign) id<ZGCustomImagePickerControllerDelegate>  customImagePickerDelegate;/**返回数据代理*/


@end
