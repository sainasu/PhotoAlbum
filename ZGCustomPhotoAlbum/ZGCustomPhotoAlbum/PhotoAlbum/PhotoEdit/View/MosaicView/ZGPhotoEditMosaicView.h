//
//  ZGPhotoEditMosaicView.h
//  ZGPhotoEdit
//
//  Created by saina_barsud on 2017/12/19.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZGPhotoEditMosaicViewDelegate;

@interface ZGPhotoEditMosaicView : UIView
@property(nonatomic, strong) NSString *filterType;
@property(nonatomic, strong) UIImage *mosaicImage;
@property(nonatomic, assign) id<ZGPhotoEditMosaicViewDelegate> paintDelegate;

/// 初始化方法: 参数frame  && image
- (instancetype)initWithFrame:(CGRect)frame Image:(UIImage *)image;
/// 退后一步
- (void)backAction;
/// 清除所有mosaic操作
- (void)resetAvtion;

@end
@protocol ZGPhotoEditMosaicViewDelegate <NSObject>
/// 结束触摸屏幕(用于隐藏导航栏和工具栏)
- (void)paintViewTouchesEnded:(ZGPhotoEditMosaicView *)darwView;
/// 开始触摸屏幕(用于隐藏导航栏和工具栏)
- (void)paintViewTouchesBegen:(ZGPhotoEditMosaicView *)darwView;
@end
