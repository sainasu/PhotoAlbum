//
//  ZGPhotoEditHeader.h
//  ZGPhotoEdit
//
//  Created by saina_barsud on 2017/12/11.
//  Copyright © 2017年 saina. All rights reserved.
//

#ifndef ZGPhotoEditHeader_h
#define ZGPhotoEditHeader_h


#define COLOR_PHOTO_EIDT_BAR [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6] // bar  颜色
#define COLOR_PHOTO_EIDT(h) [UIColor colorWithRed:((float)((h & 0xFF0000) >> 16))/255.0 green:((float)((h & 0xFF00) >> 8))/255.0 blue:((float)(h & 0xFF))/255.0 alpha:1.0] // bar  颜色
#define COLOR_PHOTO_EIDT_1(h,a) [UIColor colorWithRed:((float)((h & 0xFF0000) >> 16))/255.0 green:((float)((h & 0xFF00) >> 8))/255.0 blue:((float)(h & 0xFF))/255.0 alpha:a]


#define HEIGHT_PHOTO_EIDT_BAR_NAV  44.0 // NAV bar 高度83pt
#define HEIGHT_PHOTO_EIDT_BAR_TOOL  45 // TOOL bar 高度

#define HEIGHT_PHOTO_EIDT_BAR_NAV_X  (([UIScreen mainScreen].bounds.size.height > 736.0) ? 67.0 : 44.0) // NAV bar 高度
#define HEIGHT_PHOTO_EIDT_BAR_TOOL_X  (([UIScreen mainScreen].bounds.size.height > 736.0) ? 83.0 : 45.0) // TOOL bar 高度

#define COLOR_FOR_PHOTO_EDIT_TOOL    COLOR_PHOTO_EIDT_1(0x000000,0.6)       //图片编辑导航栏与工具栏背景色
#define COLOR_FOR_PHOTO_EDIT_BACKGROUND    COLOR_PHOTO_EIDT_1(0x252527,1.0)       //图片编辑背景色
#define COLOR_FOR_ASSET_POCKER_BACKGROUND    COLOR_PHOTO_EIDT_1(0x000000,1.0)                //


#endif /* ZGPhotoEditHeader_h */
