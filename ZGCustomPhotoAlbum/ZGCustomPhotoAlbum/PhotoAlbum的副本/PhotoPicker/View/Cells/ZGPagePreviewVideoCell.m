//
//  ZGPagePreviewVideoCell.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/17.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPagePreviewVideoCell.h"
#import <AVFoundation/AVFoundation.h>
#import "ZGAssetPickerModel.h"
@interface ZGPagePreviewVideoCell()<UIGestureRecognizerDelegate>
@property(nonatomic, strong) UIButton *playButton;
@property(nonatomic, strong) UIImageView *imageView; //
@property(nonatomic, strong) AVPlayer *player;
@property(nonatomic, strong)AVPlayerItem *playerItem;
@property(nonatomic, strong)AVPlayerLayer *playerLayer;


@end
@implementation ZGPagePreviewVideoCell
- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                self.backgroundColor = [UIColor blackColor];
                self.imageView = [[UIImageView alloc] init];
                self.imageView.contentMode = UIViewContentModeScaleAspectFit;
                [self addSubview:self.imageView];
                
                
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
                self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
                self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
                [self.layer addSublayer:self.playerLayer];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                tap.delegate = self;
                [self addGestureRecognizer:tap];
                
                self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
                self.playButton.imageView.contentMode = UIViewContentModeScaleToFill;
                [self.playButton setBackgroundImage:[UIImage imageNamed:@"PhotoAlbum_Video_play_start"] forState:UIControlStateNormal];
                [self.playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:self.playButton];
                
                
        }
        return self;
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
        self.playButton.hidden = !self.playButton.hidden;
        if (self.playButton.hidden == YES) {
                [self.player play];
        }else{
                [self.player pause];
        }
}
-(void)layoutSubviews{
        self.playButton.frame = CGRectMake(0, 0, self.frame.size.width / 4, self.frame.size.width / 4);
        self.playButton.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        self.playerLayer.frame = self.bounds;
        self.imageView.frame = self.bounds;
}

-(void)playButtonAction:(UIButton *)play{
        self.playButton.hidden = !self.playButton.hidden;
        if (self.playButton.hidden == YES) {
                [self.player play];
        }else{
                [self.player pause];
        }
}
-(void)setVideoAsset:(PHAsset *)videoAsset{
        _videoAsset = videoAsset;
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeMediumQualityFormat;
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:videoAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                AVURLAsset *urlAsset = (AVURLAsset *)asset;
                dispatch_sync(dispatch_get_main_queue(), ^{
                        [self.player replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:[NSURL URLWithString:[urlAsset.URL relativeString]]]];
                });
        }];
        PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
        imageOptions.synchronous = NO;
        imageOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
        imageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        imageOptions.version = PHImageRequestOptionsVersionCurrent;
        imageOptions.networkAccessAllowed = YES;
        [[PHImageManager defaultManager] requestImageForAsset:videoAsset targetSize:CGSizeMake(videoAsset.pixelWidth * 0.3 * [UIScreen mainScreen].scale, videoAsset.pixelHeight * 0.3 * [UIScreen mainScreen].scale) contentMode:PHImageContentModeDefault options:imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                        self.imageView.image = result;
        }];
}
-(void)pauseVideo{
        [self.player pause];
        self.playButton.hidden = NO;

}

@end
