//
//  SNPEAddImageView.h
//  SN_ImageEditor
//
//  Created by saina_su on 2017/7/10.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 主要实现功能:
 1 添加手势: 拖动 缩放 长按 旋转
 2 长按时 闪烁一下之后会删除
 3 触摸或点击是出现白色边框证明处于编辑状态
 4 添加图片
 */
@interface SNPEAddImageView : UIView


- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;

@end
