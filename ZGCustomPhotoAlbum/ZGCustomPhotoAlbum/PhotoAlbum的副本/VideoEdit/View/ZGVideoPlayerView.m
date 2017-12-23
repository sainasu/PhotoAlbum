//
//  ZGVideoPlayerView.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/19.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGVideoPlayerView.h"
@interface ZGVideoPlayerView()
@property(nonatomic, strong) AVPlayer *player;
@property(nonatomic, strong) AVPlayerItem *playerItem;
@property(nonatomic, strong) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) id timeObserver;
@property(nonatomic, assign) CGFloat startsPlayingTime;
@property(nonatomic, assign) CGFloat duration;



@end
@implementation ZGVideoPlayerView
- (instancetype)initWithFrame:(CGRect)frame videoURL:(NSURL *)url
{
        self = [super initWithFrame:frame];
        if (self) {
                self.backgroundColor = [UIColor clearColor];
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
//                [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
                self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
                [self.layer addSublayer:self.playerLayer];
                [self.player play];
                //注册通知
                __weak __typeof(self) weakself = self;
                self.timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                        float current = CMTimeGetSeconds(time);//当前播放时间
                        if (current >= weakself.duration + weakself.startsPlayingTime) {
                                CMTime time = CMTimeMake(weakself.startsPlayingTime, 1);
                                [weakself.player seekToTime:time];
                                
                        }
                }];
        }
        return self;
}
-(void)layoutSubviews{
        self.playerLayer.frame = self.bounds;
}
- (void)videoPlayerViewStartPlayingTime:(CGFloat)start  duration:(CGFloat)duration{
        self.startsPlayingTime = start;
        self.duration = duration;
        [self.player seekToTime:CMTimeMake(start, 1.0) completionHandler:^(BOOL finished) {
                [self.player play];
        }];        
}

- (void)dealloc{
        [self.player removeTimeObserver:self.timeObserver];
}


@end
