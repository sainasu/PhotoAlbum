//
//  ZGVCVideoView.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/15.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@protocol ZGVCVideoViewDelegate <NSObject>

-(void)videoDelegatePlayStartTime:(CGFloat)startTime endTime:(CGFloat)endTime;

@end


@interface ZGVCVideoView : UIView
@property(nonatomic, assign) id<ZGVCVideoViewDelegate> videoDelegate;/**<#注释#>*/



- (instancetype)initWithFrame:(CGRect)frame URL:(NSURL *)url;
-(void)stopPlaying;

-(void)videoPlayStartTime:(CGFloat)startTime endTime:(CGFloat )endTime;

@end
