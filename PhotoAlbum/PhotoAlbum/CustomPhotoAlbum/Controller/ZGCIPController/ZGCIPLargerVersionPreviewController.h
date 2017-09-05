//
//  ZGCIPLargerVersionPreviewController.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/30.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGCIPViewController.h"
#import <Photos/Photos.h>
#import "ZGCustomImagePickerController.h"

@class ZGCIPLargerVersionPreviewController;
@protocol  ZGCIPLargerVersionPreviewControllerDelegate <NSObject>

-(void)largerVersionPreviewController:(ZGCIPLargerVersionPreviewController *)largerVersion selectedAssetArray:(NSMutableArray *)sender isOriginalImage:(BOOL)isOriginal;
-(void)largerVersionPreviewController:(ZGCIPLargerVersionPreviewController *)largerVersion newAsset:(PHAsset *)asset oldAsset:(PHAsset *)oldAsset;

@end

@protocol ZGChooseToCompleteDelegate <NSObject>
//选择完成代理
-(void)largerVersionPreviewController:(ZGCIPLargerVersionPreviewController *)largerVersion didFinishPickingImages:(NSMutableArray *)array isOriginalImage:(BOOL)original;

@end

@interface ZGCIPLargerVersionPreviewController : ZGCIPViewController
/**选择类型枚举*/
@property(nonatomic, assign) ZGCPSelectType  selectType;
/**完成或发送按钮样式 默认值: icon_navbar_ok*/
@property(nonatomic, strong) UIImage *sendButtonImage;
/**是否发送原图*/
@property(nonatomic, assign) BOOL  isSendTheOriginalPictures;
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
@property(nonatomic, strong) UIViewController *fromViewController;/**来自哪儿个控制器*/




@property(nonatomic, strong) PHAsset *meituizipaiSelectdAsset; /**被点击cell的Asset*/
@property(nonatomic, strong) NSString *folderTitel; /**文件夹名称*/
@property(nonatomic, assign) NSInteger  indexPathRow; /**点击的cell的位置*/
@property(nonatomic, strong) NSMutableArray *meituizipaiSelectedAssetData; /**选择的Asset数组*/
@property (nonatomic, assign) id<ZGCIPLargerVersionPreviewControllerDelegate> delegate; //代理属性
@property(nonatomic, strong) NSMutableDictionary *updataMeituizipaiAssets; /**<#注释#>*/
@property(nonatomic, assign) BOOL isOriginalImage; /**是否是原图(按钮是否点击状态)*/
@property (nonatomic, assign) id<ZGChooseToCompleteDelegate> completeDelegate; //代理属性



@end
