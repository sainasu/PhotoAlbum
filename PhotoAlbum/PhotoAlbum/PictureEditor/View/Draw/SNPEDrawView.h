//
//  SNPEDrawView.h
//  SN_ImageEditor
//
//  Created by saina_su on 2017/7/10.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  实现涂鸦功能, 选择不同颜色 
        撤销按钮: 移除上一个操作
        清屏按钮: 移除所有操作
 */
@interface SNPEDrawView : UIView
//清屏
- (void)clear;
//撤销
- (void)undo;
//设置线的宽度
- (void)setLineWith:(CGFloat)lineWidth;
//设置线的颜色
- (void)setLineColor:(UIColor *)color;


@end
