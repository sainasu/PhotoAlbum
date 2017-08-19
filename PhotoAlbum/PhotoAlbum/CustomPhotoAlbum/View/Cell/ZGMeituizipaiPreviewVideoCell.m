//
//  ZGMeituizipaiPreviewVideoCell.m
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/7.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGMeituizipaiPreviewVideoCell.h"
@interface ZGMeituizipaiPreviewVideoCell()<UIGestureRecognizerDelegate>
@property(nonatomic, strong)AVPlayerItem *playerItem;/**<#注释#>*/
@property(nonatomic, strong)AVPlayerLayer *playerLayer;/**<#注释#>*/


@end

@implementation ZGMeituizipaiPreviewVideoCell

- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                self.userInteractionEnabled = YES;
                //底层View
                self.videoView = [[UIImageView alloc]init];
                self.videoView.backgroundColor=[UIColor blackColor];
                //播放体会图片
                self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
                self.playButton.backgroundColor = [UIColor clearColor];
                [self.playButton addTarget:self action:@selector(playBUttonAciton:) forControlEvents:UIControlEventTouchDown];
                [self.playButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
                [self.playButton setBackgroundImage:[UIImage imageNamed:@"video_play_sign"] forState:UIControlStateNormal];
                self.playButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
                
                //
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                //
                self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
                self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
                //
                [self.videoView.layer addSublayer:self.playerLayer];
                [self addSubview:self.videoView];

                [self addSubview:self.playButton];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
                tap.delegate = self;
                [self addGestureRecognizer:tap];
                
                [self addNotification];
                
        }
        return self;
}
-(void)layoutSubviews{
        self.videoView.frame = self.bounds;
        self.playButton.frame = CGRectMake(0, 0, self.bounds.size.width / 4, self.bounds.size.width / 4);
        self.playButton.center = self.videoView.center;
        self.playerLayer.frame =self.videoView.bounds;

}

-(void)initVideoView:(NSURL *)url{
        [self.player pause];
        if (self.url != url) {
                [self.player replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:url]];
                self.url = url;
        }
}
//给AVPlayerItem添加播放完成通知
- (void)addNotification{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
}

//监听获得消息
-(void)playbackFinished:(NSNotification *)not{
        CMTime time = CMTimeMake(0, 1);
        [self.player seekToTime:time];
        [_player play];
}
-(void)playBUttonAciton:(UIButton *)sender{
        sender.selected = !sender.selected;
        if ( self.playButton.hidden == YES) {
                self.playButton.hidden =NO;
                [self.playButton setBackgroundImage:[UIImage imageNamed:@"video_play_sign"] forState:UIControlStateNormal];
                [self.player pause];
        }else{
                [self.playButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
                self.playButton.hidden = YES;
                [self.player play];
                
        }
}
-(void)tapAction{
        if ( self.playButton.hidden == YES) {
                self.playButton.hidden =NO;
                [self.playButton setBackgroundImage:[UIImage imageNamed:@"video_play_sign"] forState:UIControlStateNormal];
                [self.player pause];
        }else{
                [self.playButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
                self.playButton.hidden = YES;
                [self.player play];
                
        }
}

- (void)dealloc
{
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:nil];
}


@end
