//
//  ZGPhotoEditAddView.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/11/7.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZGPhotoEditAddViewDelegate;
@interface ZGPhotoEditAddView : UIView
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) UIColor *color;
@property(nonatomic, strong) UIImage *image;

- (void)stopTimer;
-(void)startCountDown;

@property(nonatomic, assign) id<ZGPhotoEditAddViewDelegate>  addDelegate;

@end
@protocol ZGPhotoEditAddViewDelegate <NSObject>
- (void)addViewTap:(ZGPhotoEditAddView *)addView tapAction:(NSInteger)tag;
- (void)addViewDoubleTap:(ZGPhotoEditAddView *)addView tapAction:(NSInteger)tag;
- (void)addViewRemoveFromSuperview:(ZGPhotoEditAddView *)addView;
@end


