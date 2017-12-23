//
//  ZGPhotoAlbumHeader.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/24.
//  Copyright © 2017年 saina. All rights reserved.
//

#ifndef ZGPhotoAlbumHeader_h
#define ZGPhotoAlbumHeader_h

#define APP_NAME @"Bainu"

#define UIColorFromHex(h,a) [UIColor colorWithRed:((float)((h & 0xFF0000) >> 16))/255.0 green:((float)((h & 0xFF00) >> 8))/255.0 blue:((float)(h & 0xFF))/255.0 alpha:a]

//////////////////////////// 通用尺寸 ///////////////////////////////


#define HEIGHT_PHOTO_EIDT_BAR_NAV                  44.0             /* 导航栏的高度 */
#define HEIGHT_PHOTO_EIDT_BAR_TOOL                 45.0            /* 编辑栏的高度 */
#define HEIGHT_PHOTO_EIDT_BAR_NAV_X  (([UIScreen mainScreen].bounds.size.height > 736.0) ? 67.0 : 44.0) // NAV bar 高度
#define HEIGHT_PHOTO_EIDT_BAR_TOOL_X  (([UIScreen mainScreen].bounds.size.height > 736.0) ? 79.0 : 45.0) // TOOL bar 高度
#define PHOTO_EIDT_BAR_CORNER_RADIUS                   3.0               /* 默认圆角 */


//////////////////////////// 通用颜色 ///////////////////////////////
#define COLOR_FOR_PHOTO_EDIT_TOOL    UIColorFromHex(0x000000,0.6)       //图片编辑导航栏与工具栏背景色
#define COLOR_FOR_PHOTO_EDIT_BACKGROUND    UIColorFromHex(0x252527,1.0)       //图片编辑背景色
#define COLOR_FOR_ASSET_POCKER_BACKGROUND    UIColorFromHex(0x000000,1.0)                //


#define COLOR_FOR_BACKGROUND            UIColorFromHex(0xF7F8FA,1.0)                // 背景颜色
#define COLOR_FOR_BACKGROUND_DARK       UIColorFromHex(0x1D1E2A,1.0)
#define COLOR_FOR_NAV_BAR               UIColorFromHex(0x2C2E43,0.95)
#define COLOR_FOR_NAV_BAR_TRANLUCENT    UIColorFromHex(0x2C2E43,0.95)                // 导航栏颜色
#define COLOR_FOR_BORDER                UIColorFromHex(0xC9CCDA,1.0)                // 描边颜色
#define COLOR_FOR_TEXT_GRAY             UIColorFromHex(0xB0B1B5,1.0)                // 文本灰色
#define COLOR_FOR_TEXT_RED              UIColorFromHex(0xFF5D51,1.0)                // 文本红色
#define COLOR_FOR_TAB_BAR               UIColorFromHex(0xF4F6F7,1.0)                // 菜单栏颜色
#define COLOR_FOR_BORDER_EDIT_BAR       UIColorFromHex(0xC3C4CD,1.0)                // 编辑栏描边颜色
#define COLOR_FOR_BORDER_TAB_BAR        UIColorFromHex(0xD1D8E1,1.0)                // 菜单栏描边颜色
#define COLOR_FOR_LABEL_FOLD            UIColorFromHex(0xF3F3F5,1.0)                // 当文本被折叠时的背景颜色
#define COLOR_FOR_LABEL_FOLD_SELECTED   UIColorFromHex(0xCCD2E0,1.0)                // 被折叠的文本被点击时的颜色
#define COLOR_FOR_INACTIVE_GRAY         UIColorFromHex(0x929292,1.0)                // 灰色弱化的组件或自体使用的颜色
#define COLOR_FOR_ACTIVE_BLUE           UIColorFromHex(0x0048FF,1.0)                // 蓝色组件使用的颜色
#define COLOR_FOR_BUTTON_BLUE           UIColorFromHex(0x4396EC,1.0)
#define COLOR_FOR_PINK_WOMAN            UIColorFromHex(0xFF68A4,1.0)                // 粉红色女生颜色
#define COLOR_FOR_BLUE_MAN              UIColorFromHex(0x4891FF,1.0)                // 蓝色男生颜色

#define COLOR_FOR_MOSAIC                [UIColor colorWithWhite:0 alpha:0.3]    // 弹出框透明背景
#define COLOR_FOR_ROW_SELECTED          [UIColor colorWithWhite:0.9 alpha:1.0]  //列表被选中时的颜色
#define COLOR_FOR_LABEL_SHADOW          [UIColor colorWithWhite:0.8 alpha:1.0]


#endif /* ZGPhotoAlbumHeader_h */
