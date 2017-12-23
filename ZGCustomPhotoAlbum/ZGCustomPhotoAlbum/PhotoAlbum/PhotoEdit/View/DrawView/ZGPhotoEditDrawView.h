//
//  ZGPhotoEditDrawView.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/11/6.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZGPhotoEditDrawViewDelegate;

@interface ZGPhotoEditDrawView : UIView

@property (nonatomic, strong) UIColor *lineColor;
@property(nonatomic, assign) id<ZGPhotoEditDrawViewDelegate>  delegate;
@property (nonatomic, assign) BOOL isEarse; // 橡皮擦

/// 退后一步
- (void)undo;
/// 清除所有操作
- (void)clear;
@end
@protocol ZGPhotoEditDrawViewDelegate <NSObject>

/// 结束触摸屏幕(用于隐藏导航栏和工具栏)
- (void)darwViewTouchesEnded:(ZGPhotoEditDrawView *)darwView;
/// 开始触摸屏幕(用于隐藏导航栏和工具栏)
- (void)darwViewTouchesBegen:(ZGPhotoEditDrawView *)darwView;

@end
