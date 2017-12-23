//
//  ZGCustomNavigationBar.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/17.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZGCustomNavigationBarDelegate;

@interface ZGCustomNavigationBar : UIView
@property(nonatomic, assign) NSInteger count;
@property(nonatomic, assign) NSUInteger videoMaximumDuration;
@property(nonatomic, assign) NSUInteger videoDuration;

@property(nonatomic, assign) id<ZGCustomNavigationBarDelegate>  navigationBarDelegate;
@end
@protocol ZGCustomNavigationBarDelegate <NSObject>
- (void)navigationBarReightButton:(UIButton *)btn;
- (void)navigationBarLeftButton:(UIButton *)btn;
@end


