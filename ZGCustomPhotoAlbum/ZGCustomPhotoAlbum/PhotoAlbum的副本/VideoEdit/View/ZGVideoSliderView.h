//
//  ZGVideoSliderView.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/19.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@protocol ZGVideoSliderViewDelegate;

@interface ZGVideoSliderView : UIView
@property(nonatomic, assign) CGFloat videoMaximumDuration;
@property(nonatomic, strong) PHAsset *videoAsset;
- (instancetype)initWithFrame:(CGRect)frame videoURL:(NSURL *)url;

@property(nonatomic, assign) id<ZGVideoSliderViewDelegate>  sliderDelegate;
@end
@protocol ZGVideoSliderViewDelegate <NSObject>
- (void)videoSiliderView:(ZGVideoSliderView *)slider startDuration:(CGFloat)start duration:(CGFloat)duration;
@end

