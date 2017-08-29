//
//  ZGFolderViewController.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/4.
//  Copyright © 2017年 saina. All rights reserved.
//
/*
需求参数: 
 
 1 图与视频是否合选:(== YES是<发送按钮>, == NO是<完成按钮>)
        1.1 最大选择数量:
        1.2 已经选择数量:
 2 图片是否可编辑:
 3 视频是否可编辑:
        3.1 发送视频最大时间:

 4 是否截图: (如果是截图, 以上参数均无效)
        4.1 截图尺寸
 5 来自哪儿个控制器:

 **获取结果 ==> @{@"chooseToComplete" : @"dataAsset"}
 [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chooseToCompleteData:) name:@"chooseToComplete" object:nil];
 ** 是否原图 ==> @{@"isOriginalImage" : @"Value"}
 [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isOriginalImage:) name:@"isOriginalImage" object:nil];
 
 */

#import <UIKit/UIKit.h>
#import "ZGPAHeader.h"


//选择类型
typedef NS_ENUM(NSInteger, ZGCPSelectType) {
        ZGCPSelectTypeNone = 0,
        ZGCPSelectTypeImageAndVideo = 1,//图片和视频
        ZGCPSelectTypeImage = 2,//图片
        ZGCPSelectTypeVideo = 3//视频
};


@protocol ZGFolderViewControllerDelegate <NSObject>
//返回选择完成的数据delegate
-(void)returnData:(NSMutableArray *)data isSendTheOriginalPictures:(BOOL)idOriginalPictures;

@end

@interface ZGFolderViewController : UIViewController
//下列参数
/**选择类型枚举*/
@property(nonatomic, assign) ZGCPSelectType  selectType;
/**完成或发送按钮样式 默认值: icon_navbar_ok*/
@property(nonatomic, strong) UIImage *sendButtonImage;
/**是否发送原图*/
@property(nonatomic, assign) BOOL  isSendTheOriginalPictures;
/**可选最大数 默认：optionalMaximumNumber = 15, 当等于optionalMaximumNumber = 1 时则没有选择按钮*/
@property(nonatomic, assign) NSInteger  optionalMaximumNumber;
/**已选择数量 默认：0*/
@property(nonatomic, assign) NSInteger  selectedNumber;
/**是否编辑图片 默认NO*/
@property(nonatomic, assign) BOOL  whetherToEditPictures;
/**可发送视频最大时间（默认时间是 15s)*/
@property(nonatomic, assign) NSInteger  maximumTimeVideo;
/**是否截图(whetherTheCrop = yes时 以上参数都无效)*/
@property(nonatomic, assign) BOOL  whetherTheCrop;
/**截图尺寸(whetherTheCrop = yes时有效) 默认值：[UIScreen mainScreen].bounds.size。 宽或高都不能等于0*/
@property(nonatomic, assign) CGSize  cropSize;

@property(nonatomic, assign) id<ZGFolderViewControllerDelegate>  folderViewDelegate;/**返回数据代理*/




@end
