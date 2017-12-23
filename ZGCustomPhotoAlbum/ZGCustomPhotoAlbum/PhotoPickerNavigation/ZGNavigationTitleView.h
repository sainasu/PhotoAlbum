//
//  ZGNavigationTitleView.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/18.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZGButtonBadge.h"
typedef NS_ENUM(NSInteger, ZGNavigationTitleViewStatus) {
        ZGNavigationTitleViewConnected,     // 已连接
        ZGNavigationTitleViewDisconnected,  // 已断开
        ZGNavigationTitleViewConnecting,    // 正在连接
};

@protocol ZGNavigationTitleViewDelegate;

@interface ZGNavigationTitleView : UIView

@property (nonatomic, assign) ZGNavigationTitleViewStatus connectStatus;
@property (nonatomic, assign) id<ZGNavigationTitleViewDelegate> delegate;

- (void)setLeftButtonsWithImageNames:(NSArray *)imageNames;
- (void)setRightButtonsWithImageNames:(NSArray *)imageNames;

//- (void)setBadge:(ZGNotificationValue)value onLeftIndex:(NSInteger)index;
//- (void)setBadge:(ZGNotificationValue)value onRightIndex:(NSInteger)index;

- (void)setButtonEnabled:(BOOL)enabled onLeftIndex:(NSInteger)index;
- (void)setButtonEnabled:(BOOL)enabled onRightIndex:(NSInteger)index;

@end

@protocol ZGNavigationTitleViewDelegate <NSObject>
@optional
- (void)navigationTitleView:(ZGNavigationTitleView *)titleView buttonClickedAtLeftIndex:(NSInteger)index;
- (void)navigationTitleView:(ZGNavigationTitleView *)titleView buttonClickedAtRightIndex:(NSInteger)index;
@end
