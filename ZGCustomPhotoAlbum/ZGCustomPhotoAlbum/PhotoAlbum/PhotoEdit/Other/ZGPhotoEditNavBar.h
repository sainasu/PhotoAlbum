//
//  ZGPhotoEditNavBar.h
//  ZGPhotoEdit
//
//  Created by saina_barsud on 2017/12/11.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZGPhotoEditNavBarDelegate;
@interface ZGPhotoEditNavBar : UIView
@property(nonatomic, assign) id<ZGPhotoEditNavBarDelegate>  delegate;/**<#注释#>*/

@end
@protocol ZGPhotoEditNavBarDelegate <NSObject>
/// 导航取消编辑代理
- (void)photoEditNavBarReturnButton:(ZGPhotoEditNavBar *)returnButton;
/// 导航完成编辑代理
- (void)photoEditNavBarFinishButton:(ZGPhotoEditNavBar *)finishButton;
/// 导航后退代理代理
- (void)photoEditNavBarClearButton:(ZGPhotoEditNavBar *)clearButton;
/// 导航清除按钮代理
- (void)photoEditNavBarUndoButton:(ZGPhotoEditNavBar *)undoButton;
@end
