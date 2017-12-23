//
//  SNPEAddWord.h
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
 4 天机文本, 按照文本的长度调整大小
 */


@protocol SNAddTextDelegate <NSObject>

-(void)addWordViewTouchesBegan:(NSSet<UITouch *> *)touches;

@end
@interface SNPEAddWord : UIView <UIGestureRecognizerDelegate>
@property(nonatomic, assign) id<SNAddTextDelegate>  addTextDelegate;/**<#注释#>*/
@property(nonatomic, strong) UILabel *label;/**<#注释#>*/

- (instancetype)initWithFrame:(CGRect)frame word:(NSString *)word color:(UIColor *)color;

@end
