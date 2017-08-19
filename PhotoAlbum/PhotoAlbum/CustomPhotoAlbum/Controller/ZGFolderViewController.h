//
//  ZGFolderViewController.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/4.
//  Copyright © 2017年 saina. All rights reserved.
//
/*
 1  聊天相册:
 导航:  返回按钮: 返回到相册选择页面;   相册名称;    取消按钮  返回到最初页面;
 
 弹出 最近添加相册小图展示页面 且滚动到最底下;
 cell的特点, 图片和视频cell右上角有选择按钮, 视频/图片可以同时选.点击cell之后跳转到大图预览页面{111工具栏:编辑按钮   原图按钮   发送按钮};
 
 222工具栏: 预览按钮:     原图按钮:     发送按钮:
 
 2  头像(相册封面/摇一摇头像):
 弹出 最近添加相册小图展示页面 且滚动到最下方
 cell的特点: 没有右上角没有按钮,  点击cell直接进入截图页面, 截图尺寸固定, 可以放大缩小图片;
 
 导航:  返回按钮: 返回到相册选择页面;   相册名称;    取消按钮  返回到最初页面;
 
 没有工具栏:
 
 
 3   朋友圈(收藏功能):
 导航:  返回按钮: 返回到相册选择页面;   相册名称;    取消按钮  返回到最初页面;
 
 弹出 最近添加相册小图展示页面 且滚动到最底下;
 cell特点: 图片cell右上角有选择按钮,  视频cell上面没有选择按钮, 点击cell之后跳转到大图预览页面{导航: 返回按钮; 选择按钮;  333444工具栏: 编辑按钮(如果是收藏, 则没有);   完成按钮
 555视频工具栏: 提示文     编辑按钮}
 
 工具栏 :预览按钮:             完成按钮:
 
 
 4  对话框背景(添加表情):
 导航:  返回按钮: 返回到相册选择页面;   相册名称;    取消按钮  返回到最初页面;
 
 弹出 最近添加相册小图展示页面 且滚动到最底下;
 cell特点, 没有任何按钮, 单击之后跳转到大图预览页面{大图预览页面: 导航栏(返回按钮和完成按钮, 没有工具栏)}
 
 没有工具栏
 
 */

#import <UIKit/UIKit.h>
#import "ZGThumbnailsPreviewController.h"
#import "ZGPAHeader.h"

@interface ZGFolderViewController : UIViewController


@property(nonatomic, assign) ZGThumbnailsPreviewStyle  thumbnailsPreviewStyle;/**小图预览界面样式*/
@property(nonatomic, assign) NSInteger selectedNum;/**已经选择数*/
@property(nonatomic, assign) BOOL  isInitializationPickerBar;/**样式*/
@property(nonatomic, assign) NSInteger  largestNum;/**可以选择的最大数*/
@property(nonatomic, assign) CGFloat  minCopVideoTimer;/**<#注释#>*/
@property(nonatomic, assign) CGFloat  maxCopVideoTimer;/**<#注释#>*/

//图片剪切参数
@property(nonatomic, assign) CGSize  CutViewSize;/**<#注释#>*/














@end
