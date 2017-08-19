//
//  ZGThumbnailsPreviewController.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/4.
//  Copyright © 2017年 saina. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ZGPAHeader.h"

typedef NS_ENUM(NSInteger, ZGThumbnailsPreviewStyle){
        ZGThumbnailsPreviewStyleChat = 1,//1聊天
        ZGThumbnailsPreviewStyleAvatar = 2,//2头像  ==  3相册封面  == 4摇一摇头像
        ZGThumbnailsPreviewStyleSCircleOfFriends = 3,//5朋友圈
        ZGThumbnailsPreviewStyleCollection = 4,//== 6收藏
        ZGThumbnailsPreviewStyleBitmap = 5//7对话框背景  == 8添加表情
};

@interface ZGThumbnailsPreviewController : UIViewController
@property(nonatomic, assign) ZGThumbnailsPreviewStyle photoAlibumStyle;/**相册样式枚举*/
@property(nonatomic, assign) NSInteger selectedNumber;/**已选择图片的数量*/
@property(nonatomic, strong) NSString *folderTitel;/**文件夹名称*/
@property(nonatomic, strong) ZGPhotoAlbumPickerBar *pickerBar;/**工具栏*/
@property(nonatomic, assign) BOOL barType;/**相册样式枚举*/

@property(nonatomic, assign) NSInteger  largestNumber;/**可选最大数*/
@property(nonatomic, assign) CGFloat  minCopVideoTimer;/**<#注释#>*/
@property(nonatomic, assign) CGFloat  maxCopVideoTimer;/**<#注释#>*/
//图片剪切参数
@property(nonatomic, assign) CGSize  CutViewSize;/**<#注释#>*/


@end
