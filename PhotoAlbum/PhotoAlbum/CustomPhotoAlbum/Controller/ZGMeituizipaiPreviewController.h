//
//  ZGMeituizipaiPreviewController.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/4.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZGPhotoAlbumPickerBar.h"
#import <Photos/Photos.h>
#import "ZGThumbnailsPreviewController.h"
@protocol  ZGMeituizipaiPreviewControllerDelegate <NSObject>

-(void)selectedAssetArray:(NSMutableArray *)sender isOriginalImage:(BOOL)isOriginal;

-(void)newAsset:(PHAsset *)asset oldAsset:(PHAsset *)oldAsset;
@end


typedef NS_ENUM(NSInteger, ZGPhotoAlbumNavigationBarStyle){
        ZGPANavigationBarStyleFolder = 1,//文件夹页面
        ZGPANavigationBarStyleThumbnailsPerview = 2,//小图预览页面
        ZGPANavigationBarStyleMeituizipaiPreview = 3,//大图预览页面
        ZGPANavigationBarStyleMeituizipaiPreviewVideo = 4,//大图预览页面video
        ZGPANavigationBarStyleMeituizipaiPreviewOneImage//单个图片
};

@interface ZGMeituizipaiPreviewController : UIViewController
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




@property(nonatomic, strong) PHAsset *meituizipaiSelectdAsset;/**点击的cell的Asset*/
@property(nonatomic, strong) NSString *folderTitel;/**文件夹名称*/
@property(nonatomic, assign) NSInteger  indexPathRow;/**点击的cell的位置*/
@property(nonatomic, strong) NSMutableArray *meituizipaiSelectedAssetData;/**选择的Asset数组*/
@property (nonatomic, assign) id<ZGMeituizipaiPreviewControllerDelegate>delegate;//代理属性
@property(nonatomic, strong) NSMutableDictionary *updataMeituizipaiAssets;/**<#注释#>*/
@property(nonatomic, assign) BOOL isOriginalImage;/**是否是原图*/


@end
