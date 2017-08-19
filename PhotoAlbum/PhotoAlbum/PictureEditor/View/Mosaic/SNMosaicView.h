//
//  SNMosaicView.h
//  SN_ImageEditor
//
//  Created by saina_su on 2017/7/3.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>
/**
 *  实现mosaic效果, 
        不同的mosaic按钮: 原始 优化 以传进来的图片为主
        撤销按钮: 删除最近添加的操作
        清屏安妮: 删除所有操作
 */



@protocol SNMosaicViewDelegate <NSObject>//协议
//点击cell的时候返回数组, 更新UI
-(void)hidenNavigationViewAndPickerView:(BOOL)hiden;
@end


@interface SNMosaicView : UIView
{
        BOOL ISENBALE;
}
@property (nonatomic, retain)  UIImageView *MyImageView;
@property (nonatomic, retain)  UIImageView *MyImageViewA;
@property(nonatomic, assign) id<SNMosaicViewDelegate>  mosaicDelegate;/**<#注释#>*/

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;
//清屏
- (void)clear;
//撤销
- (void)undo;
//mosaic图片
-(void)setMosaicImage:(UIImage *)image;

@end
