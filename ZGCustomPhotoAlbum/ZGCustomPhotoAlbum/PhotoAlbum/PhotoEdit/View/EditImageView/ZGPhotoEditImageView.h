//
//  ZGPhotoEditImageView.h
//  ZGPhotoEdit
//
//  Created by saina_barsud on 2017/12/8.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZGPhotoEditDrawView.h"
@protocol ZGPhotoEditImageViewDelegate;
@interface ZGPhotoEditImageView : UIView
- (instancetype)initWithFrame:(CGRect)frame editImage:(UIImage *)image;
 /// 更改遮盖View的位置
@property(nonatomic, assign) CGRect replaceSubViewFrame;
@property(nonatomic, assign) id<ZGPhotoEditImageViewDelegate>  delegate;
/// 传递collectionView的pinch手势
@property(nonatomic, strong)   UIPinchGestureRecognizer *pinch;



/// 退后一步
- (void)undo;
/// 清除所有操作
- (void)clear;
 /// 是否为涂鸦按钮
- (void)isDrawView:(NSString *)isView  color:(UIColor *)color mosaicType:(NSString *)mosaic;
 /// 添加的图或文字
- (void)addContent:(id)content isOldLabel:(BOOL)isOldLabel textColor:(UIColor *)textColor;
/// 设置filter样式
- (void)filterType:(NSString *)type;

@end
@protocol ZGPhotoEditImageViewDelegate <NSObject>
/// 触摸结束
- (void)imageViewTouchesEnded:(ZGPhotoEditImageView *)darwView;
/// 触摸开始
- (void)imageViewTouchesBegen:(ZGPhotoEditImageView *)darwView;
/// 双击后调用代理, 传值
- (void)imageViewDoubleClick:(ZGPhotoEditImageView *)view content:(NSString *)content textColor:(UIColor *)color;
@end
