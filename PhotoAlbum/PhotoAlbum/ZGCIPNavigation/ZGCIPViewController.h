//
//  ZGCIPViewController.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/9/5.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZGCIPViewController : UIViewController
@property (nonatomic, assign) BOOL interactivePopGestureEnabled;    // 是否开启滑动返回，默认开启YES
@property (nonatomic, assign) BOOL statusBarHidden;//是否状态栏隐藏
/**
 自定义底层ViewController,  主要实现与导航栏有关的方法;
 1. 默认标题
 2. 默认返回按钮: imageForLeftButton 如果该方法的返回值不是空, 那么调用addLeftButton(添加左按钮)方法;
 
 
 
 
 最后.  继承于该类, 也继承了该类的导航栏,  可以方便的设定导航栏的属性;
 
 */
- (CGFloat)contentHeight; //高度
- (void)resignFirstResponderByView:(UIView *)view;//辞职第一响应者的观点
- (UIImage *)imageForLeftButton;            // 默认返回返回图标，如果想换别的，重写此方法即可
- (void)addLeftButton:(UIImage *)image;     // 添加一上角的按钮，不需要直接调用此方法
- (void)addLeftButtons:(NSArray *)images;   // 添加一上角的按钮
- (void)addRightButton:(UIImage *)image;    // 添加右上角的按钮，需要直接调用来添加
- (void)addRightButtons:(NSArray *)images;  // 添加右上角的按钮
-(void)addRightButtonSelectdImage:(UIImage *)selectdImage normalImage:(UIImage *)normalImage;  //点击改变状态的右边按钮
- (void)leftButtonAction:(id)sender;    // 左上角按钮按下之后调用此方法，默认实现了返回
- (void)rightButtonAction:(id)sender;   // 右上角按钮按下之后调用此方法
- (void)destroy;


@end
