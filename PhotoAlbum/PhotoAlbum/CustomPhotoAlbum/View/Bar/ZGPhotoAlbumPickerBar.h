//
//  ZGPhotoAlbumPickerBar.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/4.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ZGPhotoAlbumPickerBar : UIView

- (instancetype)initWithFrame:(CGRect)frame isOldPickerBar:(BOOL)isOld;

@property(nonatomic, strong) UIButton *leftButton;/**预览按钮*/
@property(nonatomic, strong) UIButton *rightButton;/**发送按钮*/
@property(nonatomic, strong) UIButton *originalImageButton;/**<#注释#>*/
@property(nonatomic, assign) CGFloat  timer;/**<#注释#>*/
@property(nonatomic, assign) CGFloat  maxTimer;/**<#注释#>*/
-(void)isHiden:(BOOL)hiden;


@property(nonatomic, assign) BOOL  isHiden;/**<#注释#>*/



@end
