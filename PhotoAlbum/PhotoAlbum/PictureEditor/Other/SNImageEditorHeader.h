//
//  SNImageEditorHeader.h
//  SN_ImageEditor
//
//  Created by saina_su on 2017/7/3.
//  Copyright © 2017年 saina. All rights reserved.
//


#import "SNMosaicView.h"
#import "SNPEDrawView.h"
#import "SNFilterScrollView.h"
#import "SNPEScreenshotView.h"
#import "SNPEAddImageView.h"
#import "SNPEAddWord.h"
#import "SNPEInputWordView.h"

#ifndef SNImageEditorHeader_h
#define SNImageEditorHeader_h

#define kPEMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kPEMainScreenHeight [UIScreen mainScreen].bounds.size.height
//导航栏高度
#define kPENavigationHeight 44
//工具栏高度
#define kPEMainToolHeight 45
//公用工具栏
#define kPEPublicToolsViewHeight 50

#define kPEMaxSize kPEMainToolHeight + kPENavigationHeight

//工具栏描边
#define kPEMainToolRoundedCornersWidth 3
//主工具栏按钮间距
#define kPEMainToolSpacing(num) ((kPEMainScreenWidth - 20)/ 12) * num - (kPEMainToolHeight / 2) + 10
//颜色
#define kPEColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//颜色选择条底色
#define kPEMyColorToolsColor [UIColor colorWithRed:187 / 255.0 green:194 / 255.0 blue:201 / 255.0 alpha:1.0]
#endif /* SNImageEditorHeader_h */
