//
//  ZGVCMainViewController.m
//  VideoClip
//
//  Created by saina_su on 2017/8/14.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGVCMainViewController.h"
#import "ZGPAHeader.h"
#import <Photos/Photos.h>
#import "ZGVCVideoView.h"
#import "ZGVCSliderView.h"
#import "ZGVCPickerView.h"



@interface ZGVCMainViewController ()<ZGVCSliderViewDelegate, ZGVCVideoViewDelegate>
@property(nonatomic, strong) ZGVCPickerView *pickerView;/**工具栏*/
@property(nonatomic, strong) ZGVCSliderView *sliderView;/**选择框*/
@property(nonatomic, strong) ZGVCVideoView *videoView;/**视频播放器*/
@property(nonatomic, assign) CGFloat  startTimer;/**开始时间*/
@property(nonatomic, assign) CGFloat  endTimer;/**结束时间*/
@property(nonatomic, strong) NSURL *movieURL;/**视频路径*/




@end

@implementation ZGVCMainViewController
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
        self.videoView = [[ZGVCVideoView alloc] initWithFrame:CGRectMake(0, 0, kPAMainScreenWidth, kPAMainScreenHeight - kPAMainToolsHeight * 2) URL:self.vcURL];
        self.videoView.videoDelegate = self;
        [self.view addSubview:self.videoView];
        [self.videoView videoPlayStartTime:0.0 endTime:self.lengthNumber];
}



- (void)initPickerViews {
        //工具栏
        self.pickerView = [[ZGVCPickerView alloc] initWithFrame:CGRectMake(0, kPAMainScreenHeight - kPAMainToolsHeight, kPAMainScreenWidth, kPAMainToolsHeight)];
        self.pickerView.backgroundColor = kXGVCPickerColor;
        [self.pickerView.leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchDown];
        [self.pickerView.rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:self.pickerView];
        
        
        //滚动栏
        self.sliderView = [[ZGVCSliderView alloc] initWithFrame:CGRectMake(0, kPAMainScreenHeight - kPAMainToolsHeight * 2, kPAMainScreenWidth, kPAMainToolsHeight) videoAsset:self.vcURL videoLength:self.lengthNumber];
        self.sliderView.backgroundColor = kXGVCPickerColor;
        self.sliderView.sliderDelegate = self;
        [self.view addSubview:self.sliderView];
}

-(void)rightButtonAction:(UIButton *)sender{
        NSURL *videoFileUrl = [NSURL fileURLWithPath:self.vcURL.path];
        AVAsset *anAsset = [[AVURLAsset alloc] initWithURL:videoFileUrl options:nil];
        NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:anAsset];
        
        // Path to output file
        NSString *tmpDir = NSTemporaryDirectory();
        NSURL *exportUrl = [NSURL URLWithString:[tmpDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", [self arc4randomString]]]];
       
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
                                                            //NSLog(@"导出失败: %@", [[exportSession error] localizedDescription]);
                                        break;
                                case AVAssetExportSessionStatusCancelled:
                                                           //NSLog(@"取消了出口");
                                        break;
                                case AVAssetExportSessionStatusCompleted:
                                        [self playMovie:exportSession.outputURL];
                                        break;
                                default:
                                        break;
                        }
                }];
        }

}
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
-(void)playMovie: (NSURL *) movieURL{
        
        if (movieURL) {
                [self.vcDelegate cuttingVideoAsset:movieURL];
                [self.videoView stopPlaying];
                [self dismissViewControllerAnimated:YES completion:nil];
        }
        
}

-(void)leftButtonAction:(UIButton *)sender{
       
        [self.videoView stopPlaying];
        [self dismissViewControllerAnimated:YES completion:nil];

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
