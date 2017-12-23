//
//  ZGPhotoEditPaintView.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/31.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZGPhotoEditPaintViewDelegate;
@interface ZGPhotoEditPaintView : UIView
@property(nonatomic, strong) NSString *filterType;
@property(nonatomic, strong) UIImage *mosaicImage;
@property(nonatomic, assign) BOOL  isMosaic;
@property(nonatomic, assign) id<ZGPhotoEditPaintViewDelegate> paintDelegate;/**<#注释#>*/


- (instancetype)initWithFrame:(CGRect)frame Image:(UIImage *)image;

- (void)backAction;
- (void)resetAvtion;
- (void)userInteractionStop;

@end
@protocol ZGPhotoEditPaintViewDelegate <NSObject>
- (void)paintView:(ZGPhotoEditPaintView *)paintView;

@end



