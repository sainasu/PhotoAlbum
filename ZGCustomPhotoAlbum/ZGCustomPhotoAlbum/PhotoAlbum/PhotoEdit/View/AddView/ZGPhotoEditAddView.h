//
//  ZGPhotoEditAddView.h
//  ZGPhotoEdit
//
//  Created by saina_barsud on 2017/12/14.
//  Copyright © 2017年 saina. All rights reserved.
//
/**
 * 添加图片和文字
 
 * 手势： 缩放、拖拽
 * 按钮： 右上角有删除按钮
 * 界面： 操作状态（白边）限时2s之后隐藏，且多View之间不能同时出现白边
 * 代理： 删除代理： 删除时触发
 双击代理： 双击时触发（添加文字VIew的方法， 双击编辑已有文字）
 */


#import <UIKit/UIKit.h>

@protocol ZGPhotoEditAddViewDelegate;
@interface ZGPhotoEditAddView : UIView
@property(nonatomic, assign) id<ZGPhotoEditAddViewDelegate>  delegate;
/// 传入的内容, id类型, 必须进行判断
@property(nonatomic, strong) id content;
/// 如果为YES 则隐藏删除按钮， 否则显示
@property(nonatomic, assign) BOOL  isHiddenRemoveButton;
/// 文本颜色
@property(nonatomic, strong) UIColor *textColot;


@end

@protocol ZGPhotoEditAddViewDelegate <NSObject>
/// 删除所添加的(图片或文字)代理
- (void)addImageViewRemoveButton:(ZGPhotoEditAddView *)view;
/// 双击添加文字时, 弹出输入视图再次编辑
- (void)addImageViewDoubleClick:(ZGPhotoEditAddView *)view content:(NSString *)content textColor:(UIColor *)color;

- (void)addImageViewGestureRecognizer:(UIGestureRecognizer *)ges;

@end

