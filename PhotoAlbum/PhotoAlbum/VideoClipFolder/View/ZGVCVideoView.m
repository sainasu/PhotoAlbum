//
//  ZGVCVideoView.m
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/15.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGVCVideoView.h"

@interface ZGVCVideoView()
@property(nonatomic,strong)AVPlayer *player; // 播放属性
@property(nonatomic,strong)AVPlayerItem *playerItem; // 播放属性
@property(nonatomic, strong) AVPlayerLayer *playerLayer;/**<#注释#>*/
@property(nonatomic, assign) CGFloat  startTime;/**<#注释#>*/
@property(nonatomic, assign) CGFloat  endTime;/**<#注释#>*/
@property (strong, nonatomic) id timeObserver;                      //视频播放时间观察者

@end

@implementation ZGVCVideoView

- (instancetype)initWithFrame:(CGRect)frame URL:(NSURL *)url
{
        self = [super initWithFrame:frame];
        if (self) {
                self.backgroundColor = [UIColor blackColor];
                //设置播放器
                // 创建AVPlayer
                self.playerItem = [AVPlayerItem playerItemWithURL:url];
                self.player = [AVPlayer playerWithPlayerItem:_playerItem];
                self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
                self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
                [self.layer addSublayer:self.playerLayer];
                
                [_player play];
                [self addProgressObserver];//进度监听
                [self addNotification];
        }
        return self;
}
-(void)layoutSubviews{
        self.playerLayer.frame = self.bounds;
 
}
//给AVPlayerItem添加播放完成通知
- (void)addNotification{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
}

// 播放完成通知
- (void)playbackFinished:(NSNotification *)notification{
        CMTime time = CMTimeMake(self.startTime, 1);
        [self.player seekToTime:time];
        [_player play];

        
}

#pragma mark - KVO
- (void)addProgressObserver{
        //这里设置每秒执行一次
        __weak __typeof(self) weakself = self;
        self.timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                float current = CMTimeGetSeconds(time);//当前播放时间
                        if (current >= weakself.endTime) {
                        CMTime time = CMTimeMake(weakself.startTime, 1);
                        [weakself.player seekToTime:time];
                        [weakself.videoDelegate videoDelegatePlayStartTime:weakself.startTime endTime:weakself.endTime];

                }
        }];

}

//调整播放时间
-(void)videoPlayStartTime:(CGFloat)startTime endTime:(CGFloat )endTime{
        self.startTime = startTime;
        self.endTime = endTime;
        CMTime time = CMTimeMake(startTime, 1);
        [self.player seekToTime:time];
        [self.videoDelegate videoDelegatePlayStartTime:self.startTime endTime:self.endTime];
        
}

-(void)stopPlaying{
         [_player pause];
}
#pragma mark - 横屏代码

- (BOOL)shouldAutorotate{
        
        return NO;
        
} //NS_AVAILABLE_IOS(6_0);当前viewcontroller是否支持转屏

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
        return UIInterfaceOrientationMaskLandscape;
        
} //当前viewcontroller支持哪些转屏方向


-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
        
        return UIInterfaceOrientationLandscapeRight;
        
}






- (void)dealloc{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.player removeTimeObserver:self.timeObserver];
}

















@end
