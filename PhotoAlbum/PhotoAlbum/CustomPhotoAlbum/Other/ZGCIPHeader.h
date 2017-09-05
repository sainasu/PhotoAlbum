//
//  ZGCIPHeader.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/9/5.
//  Copyright © 2017年 saina. All rights reserved.
//

#ifndef ZGCIPHeader_h
#define ZGCIPHeader_h
#import "ZGPhotoAlbumPickerBar.h"

#define ZGCIP_NAVIGATION_COLOR [UIColor colorWithRed:44/255.0 green:46/255.0 blue:67/255.0 alpha:1.0]/* 导航栏颜色 */
#define ZGCIP_COSTOM_COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]



#define ZGCIP_MAINSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define ZGCIP_MAINSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define ZGCIP_NAVIGATION_HEIGHT 44
#define ZGCIP_TABBAR_HEIGHT 49
//文件夹cell高度
#define ZGCIP_CUSTOM_IMAGE_PICKER_CELL_HEIGHT 60






/*--------------------------图片编辑宏-------------------------*/
#define ZGCIP_CROP_VIDEO_TABBAR_COLOR [UIColor colorWithRed:44/255.0 green:46/255.0 blue:67/255.0 alpha:1.0]//工具栏颜色
#define ZGCIP_TABBAR_BUTTONS_SPACING(NUM) ((ZGCIP_MAINSCREEN_WIDTH - 20)/ 12) * NUM - (ZGCIP_TABBAR_HEIGHT / 2) + 10  //主工具栏按钮间距
#define ZGCIP_PUBLIC_POP_TABBAR_HRIGHT 49   //公用工具栏
#define ZGCIP_TABBAR_ROUNDED_CORNERS_WIDTH 3  //工具栏描边
#define ZGCIP_COLOR_PICKERBAR_COLOR [UIColor colorWithRed:187 / 255.0 green:194 / 255.0 blue:201 / 255.0 alpha:1.0]  //颜色选择条底色



#endif /* ZGCIPHeader_h */
