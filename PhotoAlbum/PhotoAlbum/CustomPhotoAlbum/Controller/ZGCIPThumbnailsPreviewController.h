//
//  ZGCIPThumbnailsPreviewController.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/30.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZGPAHeader.h"
#import "ZGCustomImagePickerController.h"

@class ZGCIPThumbnailsPreviewController;
@protocol ZGThumbnailsPreviewControllerDelegate <NSObject>
//选择完成代理
-(void)thumbnailsPreviewController:(ZGCIPThumbnailsPreviewController *)thumbnails didFinishPickingImages:(NSMutableArray *)array isOriginalImage:(BOOL)original;
//取消选择
- (void)thumbnailsPreviewControllerDidCancel:(ZGCIPThumbnailsPreviewController *)picker;

@end

@interface ZGCIPThumbnailsPreviewController : UIViewController
/**是否发送原图*/
@property(nonatomic, assign) BOOL  isSendTheOriginalPictures;
/**完成或发送按钮样式 默认值: icon_navbar_ok*/
@property(nonatomic, strong) UIImage *sendButtonImage;
/**选择类型枚举*/
@property(nonatomic, assign) ZGCPSelectType  selectType;
/**可选最大数(isPicturesAndVideoCombination = YES时有效)*/
@property(nonatomic, assign) NSInteger  maySelectMaximumCount;
/**已选择数量*/
@property(nonatomic, assign) NSInteger  selectedCount;
/**是否编辑图片*/
@property(nonatomic, assign) BOOL  whetherToEditPictures;

/**可发送视频最大时间*/
@property(nonatomic, assign) NSInteger  maximumTimeVideo;
/**是否截图(whetherTheScreenshots = yes时 以上参数都无效)*/
@property(nonatomic, assign) BOOL  whetherTheCrop;
/**截图尺寸(whetherTheScreenshots = yes时有效)*/
@property(nonatomic, assign) CGSize  cropSize;
@property(nonatomic, strong) NSString *folderTitel;/**文件夹名称*/

@property (nonatomic, assign) id<ZGThumbnailsPreviewControllerDelegate> thumbnailsPreviewDelegate;//代理属性


@end
