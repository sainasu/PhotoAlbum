//
//  ZGCustomCropVideoController.m
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/30.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGCustomCropVideoController.h"
#import "ZGCIPHeader.h"
#import "ZGVCVideoView.h"
#import "ZGVCSliderView.h"
#import "ZGVCPickerView.h"
#import "ZGPAViewModel.h"

@interface ZGCustomCropVideoController ()<ZGVCSliderViewDelegate, ZGVCVideoViewDelegate>

@property(nonatomic, strong) ZGVCPickerView *pickerView;/**工具栏*/
@property(nonatomic, strong) ZGVCSliderView *sliderView;/**选择框*/
@property(nonatomic, strong) ZGVCVideoView *videoView;/**视频播放器*/
@property(nonatomic, assign) CGFloat  startTimer;/**开始时间*/
@property(nonatomic, assign) CGFloat  endTimer;/**结束时间*/
@property(nonatomic, strong) NSURL *movieURL;/**视频路径*/


@end

@implementation ZGCustomCropVideoController

- (void)viewDidLoad {
        [super viewDidLoad];
        // Do any additional setup after loading the view.
        [self.navigationController setNavigationBarHidden:YES];
        self.view.backgroundColor = [UIColor blackColor];
        //数据源
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                         forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:self.vcURL options:opts];  // 初始化视频媒体文件
        CGFloat time = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
        
        
        if (self.lengthNumber <=  1) {
                self.lengthNumber = 15.0;
        }else if (self.lengthNumber > time){
                self.lengthNumber = time;
        }
        
        [self initPickerViews];//初始化工具栏
        
        [self initVideoView];//播放器
        
        
}


-(void)initVideoView{
        self.videoView = [[ZGVCVideoView alloc] initWithFrame:CGRectMake(0, 0, ZGCIP_MAINSCREEN_WIDTH, ZGCIP_MAINSCREEN_HEIGHT - ZGCIP_TABBAR_HEIGHT * 2) URL:self.vcURL];
        self.videoView.videoDelegate = self;
        [self.view addSubview:self.videoView];
        [self.videoView videoPlayStartTime:0.0 endTime:self.lengthNumber];
}



- (void)initPickerViews {
        //工具栏
        self.pickerView = [[ZGVCPickerView alloc] initWithFrame:CGRectMake(0, ZGCIP_MAINSCREEN_HEIGHT - ZGCIP_TABBAR_HEIGHT, ZGCIP_MAINSCREEN_WIDTH, ZGCIP_TABBAR_HEIGHT)];
        self.pickerView.backgroundColor = ZGCIP_CROP_VIDEO_TABBAR_COLOR;
        [self.pickerView.leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchDown];
        [self.pickerView.rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:self.pickerView];
        
        
        //滚动栏
        self.sliderView = [[ZGVCSliderView alloc] initWithFrame:CGRectMake(0, ZGCIP_MAINSCREEN_HEIGHT - ZGCIP_TABBAR_HEIGHT * 2, ZGCIP_MAINSCREEN_WIDTH, ZGCIP_TABBAR_HEIGHT) videoAsset:self.vcURL videoLength:self.lengthNumber];
        self.sliderView.backgroundColor = ZGCIP_CROP_VIDEO_TABBAR_COLOR;
        self.sliderView.sliderDelegate = self;
        [self.view addSubview:self.sliderView];
}
#pragma mark - 保存按钮
-(void)rightButtonAction:(UIButton *)sender{
        NSURL *videoFileUrl = [NSURL fileURLWithPath:self.vcURL.path];
        AVAsset *anAsset = [[AVURLAsset alloc] initWithURL:videoFileUrl options:nil];
        NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:anAsset];
        
        // Path to output file
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSURL *exportUrl = [NSURL URLWithString:[docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", [self arc4randomString]]]];
        
        if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
                
                AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:anAsset presetName:AVAssetExportPresetPassthrough];
                
                NSURL *furl = [NSURL fileURLWithPath:exportUrl.path];
                exportSession.outputURL = furl;
                exportSession.outputFileType = AVFileTypeQuickTimeMovie;
                
                CMTime start = CMTimeMakeWithSeconds(self.startTimer, anAsset.duration.timescale);
                CMTime duration = CMTimeMakeWithSeconds(self.endTimer - self.startTimer, anAsset.duration.timescale);
                CMTimeRange range = CMTimeRangeMake(start, duration);
                exportSession.timeRange = range;
                [exportSession exportAsynchronouslyWithCompletionHandler:^{
                        switch ([exportSession status]) {
                                case AVAssetExportSessionStatusFailed:
                                        break;
                                case AVAssetExportSessionStatusCancelled:
                                        break;
                                case AVAssetExportSessionStatusCompleted:
                                        [self saveVideoURL:exportSession.outputURL];
                                        break;
                                default:
                                        break;
                        }
                }];
        }
        
}
//拼接字符串--新视频的名字
-(NSString *)arc4randomString{
        NSString *string = [[NSString alloc]init];
        for (int i = 0; i < 32; i++) {
                int number = arc4random() % 36;
                if (number < 10) {
                        int figure = arc4random() % 10;
                        NSString *tempString = [NSString stringWithFormat:@"%d", figure];
                        string = [string stringByAppendingString:tempString];
                }else {
                        int figure = (arc4random() % 26) + 97;
                        char character = figure;
                        NSString *tempString = [NSString stringWithFormat:@"%c", character];
                        string = [string stringByAppendingString:tempString];
                }
        }
        return string;
}

#pragma mark - 保存视频方法
-(void)saveVideoURL:(NSURL *)url{
        NSError *error;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
        } error:&error];
        
        
        PHAsset *asset = [ZGPAViewModel lastAsset];
        if (asset.mediaType == PHAssetMediaTypeVideo) {
                [self.videoView stopPlaying];
                [self.cropVideoDelegate cropVideoController:self didFinishCropVideoAsset:asset];
        }
}
#pragma mark - 返回按钮
-(void)leftButtonAction:(UIButton *)sender{
        [self.videoView stopPlaying];
        [self.cropVideoDelegate cropVideoControllerDidCancelCrop:self];
        
}

#pragma mark - ZGVCSliderViewDelegate

-(void)playTheStartTime:(CGFloat)startTime endTime:(CGFloat)endTime{
        [self.videoView videoPlayStartTime:startTime endTime:endTime];
}

#pragma mark - ZGVCVideoViewDelegate

-(void)videoDelegatePlayStartTime:(CGFloat)startTime endTime:(CGFloat)endTime{
        [self.sliderView initWithAnimate:endTime - startTime];
        self.startTimer = startTime;
        self.endTimer = endTime;
}

-(BOOL)prefersStatusBarHidden
{
        return YES;// 返回YES表示隐藏，返回NO表示显示
}

@end
