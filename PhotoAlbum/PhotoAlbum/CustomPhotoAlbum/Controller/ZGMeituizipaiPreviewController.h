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

-(void)selectedAssetDataArray:(NSMutableArray *)sender isOriginalImage:(BOOL)isOriginal;
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

@property (nonatomic, assign) ZGPhotoAlbumBarType barType;
@property (nonatomic, assign) ZGPhotoAlbumNavigationBarStyle navigationBarStyle;
@property(nonatomic, assign) ZGThumbnailsPreviewStyle photoAlibumStyle;/**相册样式枚举*/
@property(nonatomic, strong) PHAsset *meituizipaiSelectdAsset;/**点击的cell的Asset*/
@property(nonatomic, strong) NSString *folderName;/**文件夹名称*/
@property(nonatomic, assign) NSInteger  indexPathRow;/**点击的cell的位置*/
@property(nonatomic, assign) BOOL isTabBar;/**是否初始tabbar*/
@property(nonatomic, strong) NSMutableArray *meituizipaiSelectedAssetData;/**选择的Asset数组*/
@property(nonatomic, assign) NSInteger  existingCount;/**已经选择的数量*/
@property (nonatomic, assign) id<ZGMeituizipaiPreviewControllerDelegate>delegate;//代理属性
@property(nonatomic, strong) NSMutableDictionary *updataMeituizipaiAssets;/**<#注释#>*/
@property(nonatomic, assign) BOOL isOriginalImage;/**是否是原图*/

//视频操作参数
@property(nonatomic, assign) NSInteger  largestNumber;/**可选最大数*/
@property(nonatomic, assign) CGFloat  minCopVideoTimer;/**<#注释#>*/
@property(nonatomic, assign) CGFloat  maxCopVideoTimer;/**<#注释#>*/

//图片剪切参数
@property(nonatomic, assign) CGSize  CutViewSize;/**<#注释#>*/



@end
