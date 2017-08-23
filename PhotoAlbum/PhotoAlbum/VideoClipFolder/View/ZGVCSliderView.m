//
//  ZGVCSliderView.m
//  VideoClip
//
//  Created by saina_su on 2017/8/14.
//  Copyright © 2017年 saina. All rights reserved.
/*
底层是scrollView




*/

#import "ZGVCSliderView.h"
#import <AVFoundation/AVFoundation.h>

static NSString * const CellReuseIdentify = @"CellReuseIdentify";
static NSString * const SupplementaryViewHeaderIdentify = @"SupplementaryViewHeaderIdentify";
static NSString * const SupplementaryViewFooterIdentify = @"SupplementaryViewFooterIdentify";

#define kHeight self.frame.size.height
#define kColor(r, g, b, a) [UIColor colorWithRed:(r /255.0) green:(g /255.0) blue:(b /255.0) alpha:a]


@interface ZGVCSliderView ()<UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;/**滚动视图*/
@property(nonatomic, strong) UIView *leftView;/**左边View*/
@property(nonatomic, strong) UIView *rightView;/**右边View*/
@property(nonatomic, strong) UIButton *leftButton;/**左边按钮*/
@property(nonatomic, strong) UIButton *rightButton;/**右边安妮*/
@property(nonatomic, strong)  UIImageView *animodView;/**<#注释#>*/
//视频相关
@property(nonatomic, assign) NSInteger videoTimer;/**总时间*/
@property(nonatomic, strong) NSURL *videoURL;/**<#注释#>*/

@property(nonatomic, assign) CGFloat length;/**<#注释#>*/
@property(nonatomic, assign) CGFloat lengthTiemr;/**<#注释#>*/



@end

@implementation ZGVCSliderView

- (instancetype)initWithFrame:(CGRect)frame  videoAsset:(NSURL *)movieURL videoLength:(CGFloat)length
{
        self = [super initWithFrame:frame];
        if (self) {
                self.videoURL = movieURL;
                //数据源
                NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                                 forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
                AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:movieURL options:opts];  // 初始化视频媒体文件
                self.videoTimer = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
                self.length = 0;
                if (self.videoTimer < length) {
                        self.length = self.videoTimer;
                }else{
                        self.length = length;
                }
                
                [self initScrollView];//初始化滚动视图
                [self initSliderViews];//初始化选择框
                
                _animodView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];
                _animodView.frame = CGRectMake(self.leftButton.frame.origin.x + self.leftButton.frame.size.width - (self.frame.size.width / self.length / 2), 0, 3, kHeight);
                _animodView.backgroundColor = [UIColor whiteColor];
                [self addSubview:_animodView];
                
                [self initWithAnimate:self.length];
                }
        return self;
}
#pragma mark - 初始化滚动视图
-(void)initScrollView{
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(kHeight  , kHeight);
        layout.headerReferenceSize = CGSizeMake(self.frame.size.width / self.length, kHeight);
        layout.footerReferenceSize = CGSizeMake(self.frame.size.width / self.length, kHeight);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.layer.borderWidth = 1.0f;
        self.collectionView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.collectionView.bounces = NO;
       self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        [self addSubview:self.collectionView];
        //注册
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellReuseIdentify];
        //UICollectionElementKindSectionHeader注册是固定的
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SupplementaryViewHeaderIdentify];
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:SupplementaryViewFooterIdentify];}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        return  self.videoTimer;//可以利用时间
}
//定义展示的Section的个数 （组）
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
        return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentify forIndexPath:indexPath];
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:self.videoURL options:nil];  // 初始化视频媒体文件
        
        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:urlAsset];
        
        // 设定缩略图的方向
        // 如果不设定，可能会在视频旋转90/180/270°时，获取到的缩略图是被旋转过的，而不是正向的
        gen.appliesPreferredTrackTransform = YES;
        gen.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
        // 设置图片的最大size(分辨率)
        gen.maximumSize = CGSizeMake(self.frame.size.width / self.length * 2, kHeight* 2);
        CMTime time = CMTimeMakeWithSeconds(indexPath.row, 1 *NSEC_PER_SEC); //取第5秒，一秒钟600帧
        NSError *error = nil;
        CMTime actualTime;
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        
        UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
        CGImageRelease(image);
        UIImageView *imageView = [[UIImageView alloc] initWithImage:thumb];
        imageView.frame = cell.bounds;
        [cell addSubview:imageView];
       //按时间来请求数据, 本地不存储任何图片
        return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
        return CGSizeMake(self.frame.size.width / self.length, kHeight);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
        return UIEdgeInsetsMake(0, 0, 0, 0);
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
        
        CGPoint point = scrollView.contentOffset;
        //获取视频播放时间
        CGFloat leftPoint = (point.x + self.leftView.frame.size.width) / (self.frame.size.width / self.length);
        CGFloat rightPoint = (point.x + (self.frame.size.width -self.rightView.frame.size.width)) / (self.frame.size.width / self.length);
        [self.sliderDelegate playTheStartTime:leftPoint endTime:rightPoint];


}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
        
        if([kind isEqualToString:UICollectionElementKindSectionHeader]){
                UICollectionReusableView *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SupplementaryViewHeaderIdentify forIndexPath:indexPath];
                supplementaryView.backgroundColor = [UIColor whiteColor];
                return supplementaryView;
        }
        else if([kind isEqualToString:UICollectionElementKindSectionFooter]) {
                UICollectionReusableView *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:SupplementaryViewFooterIdentify forIndexPath:indexPath];
                supplementaryView.backgroundColor = [UIColor whiteColor];

                return supplementaryView;
        }
        kind = nil;
        return nil;
        
}

#pragma mark - 初始化选择框
-(void)initSliderViews{

        self.leftView = [[UIView alloc] init];
        self.leftView.userInteractionEnabled = NO;
        self.leftView.backgroundColor = kColor(0, 0, 0, 0.75);
        self.leftView.frame = CGRectMake(0, 0, self.frame.size.width / self.length, kHeight);
        [self addSubview:self.leftView];
        
        self.rightView = [[UIView alloc] init];
        self.rightView.userInteractionEnabled = NO;
        self.rightView.backgroundColor = kColor(0, 0, 0, 0.75);
        self.rightView.frame = CGRectMake(self.frame.size.width - (self.frame.size.width / self.length) , 0, (self.frame.size.width / self.length), kHeight);
        [self addSubview:self.rightView];
        
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightButton.frame = CGRectMake(self.frame.size.width - self.frame.size.width / self.length  * 1.5 , 0, kHeight, kHeight);
        [self.rightButton setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
        self.rightButton.imageView.contentMode = UIViewContentModeScaleToFill;

        UIPanGestureRecognizer *rightPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightButtonPanAction:)];
        rightPan.delegate = self;
        [self.rightButton addGestureRecognizer:rightPan];
        [self addSubview:self.rightButton];
        
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftButton.frame = CGRectMake(self.frame.size.width / self.length / 3, 0, kHeight, kHeight);
        [self.leftButton setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal] ;
        
        self.leftButton.imageView.contentMode = UIViewContentModeScaleToFill;
        UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonPanAction:)];
        leftPan.delegate = self;
        [self.leftButton addGestureRecognizer:leftPan];
        [self addSubview:self.leftButton];

        
}

-(void)rightButtonPanAction:(UIPanGestureRecognizer *)pan{
        CGPoint point = [pan translationInView:self];
        CGFloat pointX = pan.view.center.x + point.x;

        if ( pointX <= self.frame.size.width - self.frame.size.width / self.length + kHeight / 2 && pan.view.center.x >= self.leftButton.center.x + self.frame.size.width / self.length) {
                //设置范围
                pan.view.center = CGPointMake(pointX, pan.view.center.y );
                [pan setTranslation:CGPointMake(0, 0) inView:self];
        }else{
                if (pan.view.center.x < self.leftButton.center.x + self.frame.size.width / self.length) {
                        pan.view.center = CGPointMake(self.leftButton.center.x + self.frame.size.width / self.length, pan.view.center.y );
                }
                if ( pointX > self.frame.size.width - self.frame.size.width / self.length + kHeight / 2) {
                        pan.view.center = CGPointMake(self.frame.size.width - self.frame.size.width / self.length, pan.view.center.y );
                }
        }
        
        self.rightView.frame = CGRectMake(self.rightButton.frame.origin.x + self.frame.size.width / self.length / 2, 0, self.frame.size.width - self.rightButton.frame.origin.x, kHeight);
        [self playTimes];



}

-(void)leftButtonPanAction:(UIPanGestureRecognizer *)pan{
        CGPoint point = [pan translationInView:self];
        CGFloat pointX = pan.view.center.x + point.x;
        //设置范围
        if (self.frame.size.width / self.length - 10 <= pointX  && pan.view.center.x <= self.rightButton.center.x - self.frame.size.width / self.length) {
                pan.view.center = CGPointMake(pointX, pan.view.center.y );
                [pan setTranslation:CGPointMake(0, 0) inView:self];
        }else{
                if (pan.view.center.x > self.rightButton.center.x - self.frame.size.width / self.length) {
                        pan.view.center = CGPointMake(self.rightButton.center.x - self.frame.size.width / self.length, pan.view.center.y );
                }
                if (self.frame.size.width / self.length - 10 > pointX) {
                        pan.view.center = CGPointMake(self.frame.size.width / self.length, pan.view.center.y );
                }
                
        }
        self.leftView.frame = CGRectMake(0, 0, self.leftButton.frame.origin.x + self.leftButton.frame.size.width - self.frame.size.width / self.length / 2, kHeight);
        [self playTimes];

}
-(void)playTimes{
        CGPoint collectionViewPoint = self.collectionView.contentOffset;
        //获取视频播放时间
        CGFloat leftPoint = (collectionViewPoint.x + self.leftView.frame.size.width) / (self.frame.size.width / self.length);
        CGFloat rightPoint = (collectionViewPoint.x + (self.frame.size.width -self.rightView.frame.size.width)) / (self.frame.size.width / self.length);
        
        [self.sliderDelegate playTheStartTime:leftPoint endTime:rightPoint];
}

#pragma mark - 设定动画
-(void) initWithAnimate:(CGFloat)timer{
        NSLog(@"----------%f", timer);
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];///.y的话就向下移动。
        animation.fromValue = [NSNumber numberWithFloat:self.leftButton.frame.origin.x - self.frame.size.width / self.length / 2];
        animation.toValue = [NSNumber numberWithFloat:self.rightButton.frame.origin.x - self.frame.size.width / self.length * 0.7];
        
        animation.duration = timer;
        animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
        animation.repeatCount = 1;
        animation.fillMode = kCAFillModeForwards;
        [self.animodView.layer addAnimation:animation forKey:nil];
        
}



@end
