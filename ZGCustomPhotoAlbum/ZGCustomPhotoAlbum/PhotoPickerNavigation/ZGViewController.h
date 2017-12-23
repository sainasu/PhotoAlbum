//
//  ZGViewController.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/14.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZGNavigationTitleView.h"
@interface ZGViewController : UIViewController
@property (nonatomic, assign) BOOL interactivePopGestureEnabled;    // 是否开启滑动返回，默认开启YES
@property (nonatomic, assign) BOOL statusBarHidden;

- (CGFloat)contentHeight;
- (void)resignFirstResponderByView:(UIView *_Nullable)view;
- (NSArray *_Nullable)imageNamesForLeftButtons;
- (ZGNavigationTitleView *_Nullable)navigationTitleView;
- (void)addObserver:(SEL _Nullable )aSelector name:(nullable NSNotificationName)aName;
- (void)destroy;                            // 页面被销毁时被调用                     // 页面被销毁时被调用
@end
