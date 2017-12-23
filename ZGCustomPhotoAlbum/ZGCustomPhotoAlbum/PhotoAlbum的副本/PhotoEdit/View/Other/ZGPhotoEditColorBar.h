//
//  ZGPhotoEditColorBar.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/23.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZGPhotoEditColorBarDelegate;

@interface ZGPhotoEditColorBar : UIView
@property(nonatomic, assign) BOOL  isBack;
@property(nonatomic, assign) id<ZGPhotoEditColorBarDelegate>  colorDelegate;
- (void)cellSelected:(UIColor *)color;
@end
@protocol ZGPhotoEditColorBarDelegate <NSObject>
- (void)photoEditColorViewSelectedColor:(UIColor *)color isDraw:(BOOL)draw;

@end

