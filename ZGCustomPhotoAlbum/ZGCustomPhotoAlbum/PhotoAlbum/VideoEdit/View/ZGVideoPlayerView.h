//
//  ZGVideoPlayerView.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/19.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@interface ZGVideoPlayerView : UIView

- (instancetype)initWithFrame:(CGRect)frame videoURL:(NSURL *)url;

- (void)videoPlayerViewStartPlayingTime:(CGFloat)start  duration:(CGFloat)duration;

@end
