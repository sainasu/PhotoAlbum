//
//  ZGVideoEditController.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/19.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGVideoEditController.h"
#import "ZGVideoPlayerView.h"
#import "ZGVideoToolView.h"
#import "ZGVideoSliderView.h"
#import "ZGVideoEditModel.h"
#import "ZGPhotoAlbumHeader.h"

@interface ZGVideoEditController ()<ZGVideoToolViewDelegate, ZGVideoSliderViewDelegate>
@property(nonatomic, strong) ZGVideoPlayerView *playerView;
@property(nonatomic, strong) ZGVideoToolView *toolView;
@property(nonatomic, strong) ZGVideoSliderView *sliderView;
@property(nonatomic, assign) NSRange cropRange;



@end

@implementation ZGVideoEditController



- (void)viewDidLoad {
    [super viewDidLoad];
        self.view.backgroundColor = [UIColor blackColor];
        [self initSubView];
        
        
}
- (void)initSubView{
        self.toolView = [[ZGVideoToolView alloc] init];
        self.toolView.videoToolDelegate = self;
        [self.view addSubview:self.toolView];
        self.cropRange = NSMakeRange(0, self.videoMaximumDuration);
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:self.videoAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                AVURLAsset *urlAsset = (AVURLAsset *)asset;
                dispatch_sync(dispatch_get_main_queue(), ^{
                      NSURL *videoURL = [NSURL URLWithString:[urlAsset.URL relativeString]];
                        self.videoURL = videoURL;
                        self.sliderView = [[ZGVideoSliderView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - HEIGHT_PHOTO_EIDT_BAR_TOOL_X * 3, self.view.frame.size.width, HEIGHT_PHOTO_EIDT_BAR_TOOL_X * 1.5) videoURL:videoURL];
                        self.sliderView.sliderDelegate = self;
                        self.sliderView.videoAsset = _videoAsset;
                        self.sliderView.videoMaximumDuration = self.videoMaximumDuration;
                        [self.view addSubview:self.sliderView];
                        
                        self.playerView = [[ZGVideoPlayerView alloc] initWithFrame:CGRectZero videoURL:videoURL];
                        [self.playerView videoPlayerViewStartPlayingTime:0.0 duration:self.videoMaximumDuration];
                        [self.view addSubview:self.playerView];
                });
        }];
}

#pragma mark - ZGVideoToolViewDelegate
-(void)videoToolViewEditFinish:(ZGVideoToolView *)tool{
        [ZGVideoEditModel cropVideoUrl:self.videoURL captureVideoWithRange:self.cropRange completion:^{
                if (self.videoEditDelegate && [self.videoEditDelegate conformsToProtocol:@protocol(ZGVideoEditControllerDelegate)]) {
                        [self.videoEditDelegate videoEditController:self didFinishEditAssets:[ZGVideoEditModel lastAsset]];
                }
                
        }];
}

-(void)videoToolViewEditCancel:(ZGVideoToolView *)tool{
        if (self.videoEditDelegate && [self.videoEditDelegate conformsToProtocol:@protocol(ZGVideoEditControllerDelegate)]) {
                [self.videoEditDelegate videoEditControllerDidCancel:self];
        }
}
-(void)setVideoAsset:(PHAsset *)videoAsset{
        _videoAsset = videoAsset;
}
#pragma mark - ZGVideoSliderViewDelegate
- (void)videoSiliderView:(ZGVideoSliderView *)slider startDuration:(CGFloat)start duration:(CGFloat)duration{
        [self.playerView videoPlayerViewStartPlayingTime:start duration:duration];
        self.cropRange = NSMakeRange(start, duration);
}


-(void)viewWillLayoutSubviews{
        CGFloat height = self.view.frame.size.height;
        CGFloat width = self.view.frame.size.width;
        self.playerView.frame = CGRectMake(0, 44, width, height * 0.70);
        self.toolView.frame = CGRectMake(0, height - HEIGHT_PHOTO_EIDT_BAR_TOOL, width, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        self.sliderView.frame = CGRectMake(0, height - HEIGHT_PHOTO_EIDT_BAR_TOOL * 3, width, HEIGHT_PHOTO_EIDT_BAR_TOOL * 1.5);
        
}
- (BOOL)prefersStatusBarHidden
{
        return YES;
}

@end
