//
//  ZGCustomImagePickerController.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/30.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZGPAHeader.h"
@class ZGCustomImagePickerController;
//选择类型
typedef NS_ENUM(NSInteger, ZGCPSelectType) {
        ZGCPSelectTypeImageAndVideo = 1,//图片和视频
        ZGCPSelectTypeImage = 2,//图片
        ZGCPSelectTypeVideo = 3//视频
};
/*
//TODO:图和视频合选的时====> 例如: 朋友圈;

//TODO:横屏
*/

@protocol ZGCustomImagePickerControllerDelegate <NSObject>
//返回选择完成的数据delegate（用户选择完成后调用该方法）
- (void)customImagePickerController:(ZGCustomImagePickerController *)picker  didFinishPickingImages:(NSMutableArray *)data isSendTheOriginalPictures:(BOOL)idOriginalPictures;
//取消选择(用户取消选择时调用该代理)
- (void)customImagePickerControllerDidCancel:(ZGCustomImagePickerController *)picker;
@end



@interface ZGCustomImagePickerController : UIViewController
//下列参数
/**选择类型枚举*/
@property(nonatomic, assign) ZGCPSelectType  selectType;
/**完成或发送按钮样式 默认值: icon_navbar_ok*/
@property(nonatomic, strong) UIImage *sendButtonImage;
/**是否发送原图*/
@property(nonatomic, assign) BOOL  isSendTheOriginalPictures;
/**可选最大数 默认：optionalMaximumNumber = 15, 当等于optionalMaximumNumber = 1 时则没有选择按钮*/
@property(nonatomic, assign) NSInteger  maySelectMaximumCount;
/**已选择数量 默认：0*/
@property(nonatomic, assign) NSInteger  selectedCount;
/**是否编辑图片 默认NO*/
@property(nonatomic, assign) BOOL  whetherToEditPictures;
/**可发送视频最大时间（默认时间是 15s)*/
@property(nonatomic, assign) NSInteger  maximumTimeVideo;
/**是否截图(whetherTheCrop = yes时 以上参数都无效)*/
@property(nonatomic, assign) BOOL  whetherTheCrop;
/**截图尺寸(whetherTheCrop = yes时有效) 默认值：[UIScreen mainScreen].bounds.size。 宽或高都不能等于0*/
@property(nonatomic, assign) CGSize  cropSize;
@property(nonatomic, assign) id<ZGCustomImagePickerControllerDelegate>  customImagePickerDelegate;/**返回数据代理*/


@end
