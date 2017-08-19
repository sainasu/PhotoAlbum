//
//  ZGPAHeader.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/7.
//  Copyright © 2017年 saina. All rights reserved.
//

#ifndef ZGPAHeader_h
#define ZGPAHeader_h
#import "ZGPhotoAlbumPickerBar.h"

#define kNavigationColor [UIColor colorWithRed:44/255.0 green:46/255.0 blue:67/255.0 alpha:0.9]/* 导航栏颜色 */
//控制器高和宽
#define kPAMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kPAMainScreenHeight [UIScreen mainScreen].bounds.size.height
//导航栏高度
#define kPANavigationHeight 44
#define kPAMainToolsHeight 49
//颜色
#define kPAColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kPANavigationViewColor kPAColor(10, 10, 10, 0.95)
//文件夹cell高度
#define kPAFolderCellHeight 60




//视频编辑工具栏颜色
#define kXGVCPickerColor [UIColor colorWithRed:37 / 255.0 green:37 / 255.0 blue:37 / 255.0 alpha:1.0]



#endif /* ZGPAHeader_h */
