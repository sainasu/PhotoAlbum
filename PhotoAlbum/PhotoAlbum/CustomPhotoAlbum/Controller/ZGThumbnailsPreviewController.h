//
//  ZGThumbnailsPreviewController.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/4.
//  Copyright © 2017年 saina. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ZGPAHeader.h"




@interface ZGThumbnailsPreviewController : UIViewController

/**是否发送原图*/
@property(nonatomic, assign) BOOL  isSendTheOriginalPictures;

/**图片与视频是否合选*/
@property(nonatomic, assign) BOOL  isPicturesAndVideoCombination;
/**可选最大数(isPicturesAndVideoCombination = YES时有效)*/
@property(nonatomic, assign) NSInteger  optionalMaximumNumber;
/**已选择数量*/
@property(nonatomic, assign) NSInteger  selectedNumber;
/**是否编辑图片*/
@property(nonatomic, assign) BOOL  whetherToEditPictures;
/**是否编辑视频*/
@property(nonatomic, assign) BOOL  whetherToEditVideo;
/**可发送视频最大时间(whetherToEditVideo = yes时有效)*/
@property(nonatomic, assign) NSInteger  maximumTimeVideo;
/**是否截图(whetherTheScreenshots = yes时 以上参数都无效)*/
@property(nonatomic, assign) BOOL  whetherTheScreenshots;
/**截图尺寸(whetherTheScreenshots = yes时有效)*/
@property(nonatomic, assign) CGSize  screenshotsSize;
@property(nonatomic, strong) UIViewController *fromViewController;/**来自哪儿个控制器*/



@property(nonatomic, strong) NSString *folderTitel;/**文件夹名称*/


@end
