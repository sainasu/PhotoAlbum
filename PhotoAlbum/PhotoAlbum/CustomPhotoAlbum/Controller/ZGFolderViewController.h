//
//  ZGFolderViewController.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/4.
//  Copyright © 2017年 saina. All rights reserved.
//
/*
需求参数: 
 
 1 图与视频是否合选:
        1.1 最大选择数量:
        1.2 已经选择数量:
 2 图片是否可编辑:
 3 视频是否可编辑:
        3.1 发送视屏最大时间:

 4 是否截图: (如果是截图, 以上参数均无效)
        4.1 截图尺寸
 5 来自哪儿个控制器:

 **获取结果 ==> @{@"chooseToComplete" : @"dataAsset"}
 [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chooseToCompleteData:) name:@"chooseToComplete" object:nil];
 ** 是否原图 ==> @{@"isOriginalImage" : @"Value"}
 [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isOriginalImage:) name:@"isOriginalImage" object:nil];
 
 */

#import <UIKit/UIKit.h>
#import "ZGThumbnailsPreviewController.h"
#import "ZGPAHeader.h"

@interface ZGFolderViewController : UIViewController


//下列参数
/**图片与视频是否合选*/
@property(nonatomic, assign) BOOL  isPicturesAndVideoCombination;
/**是否发送原图*/
@property(nonatomic, assign) BOOL  isSendTheOriginalPictures;
/**可选最大数*/
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
/**(必须)来自哪儿个控制器*/
@property(nonatomic, strong) UIViewController *fromViewController;



@end
