//
//  ZGVideoSliderView.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/19.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGVideoSliderView.h"
#define HEIGHT self.frame.size.height
#define WIDTH self.frame.size.width


@interface ZGVideoSliderView()<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIGestureRecognizerDelegate>

@property(nonatomic, assign) CGFloat  videoDuration;
@property(nonatomic, assign) CGFloat  cropCount;
@property(nonatomic, assign) CGFloat  collectionViewX;
@property(nonatomic, strong) AVURLAsset *urlAsset;



@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UIView *sliderRightView;
@property(nonatomic, strong) UIView *sliderLeftView;
@property(nonatomic, strong) UIImageView *rightActionView;
@property(nonatomic, strong) UIImageView *leftActionView;
@property(nonatomic, strong) UIView *animationView;
@property(nonatomic, strong) CABasicAnimation *animation;
@property(nonatomic, assign) CGFloat  animationTime;/**<#注释#>*/
@property(nonatomic, strong) AVAssetImageGenerator *gen;







@end
@implementation ZGVideoSliderView

- (instancetype)initWithFrame:(CGRect)frame videoURL:(NSURL *)url
{
        self = [super initWithFrame:frame];
        if (self) {
                self.backgroundColor = [UIColor blackColor];                
                AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:nil];
                self.gen = [[AVAssetImageGenerator alloc] initWithAsset:urlAsset];
                self.gen.appliesPreferredTrackTransform = YES;
                self.gen.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
                self.gen.maximumSize = CGSizeMake(WIDTH / 12 * [UIScreen mainScreen].scale, HEIGHT * [UIScreen mainScreen].scale);
                
                [self initCollectionView];
                [self initSliderView];
                
                UIPanGestureRecognizer *panL = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panLView:)];
                panL.delegate = self;
                [self.leftActionView addGestureRecognizer:panL];
                UIPanGestureRecognizer *panR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRView:)];
                panR.delegate = self;
                [self.rightActionView addGestureRecognizer:panR];
                
                

        }
        return self;
}
- (void)initSliderView{
       
        
        self.sliderRightView = [[UIView alloc] init];
        self.sliderRightView.backgroundColor = [UIColor colorWithRed:37 / 255.0 green:37 / 255.0  blue:37 / 255.0  alpha:0.8];
        self.sliderRightView.frame = CGRectMake(WIDTH - 20, 0, 20, HEIGHT);
        self.sliderRightView.userInteractionEnabled = NO;
        self.sliderRightView.layer.borderColor = [UIColor blackColor].CGColor;
        self.sliderRightView.layer.borderWidth = 1.0;
        [self addSubview:self.sliderRightView];
        
        self.sliderLeftView = [[UIView alloc] init];
        self.sliderLeftView.backgroundColor = [UIColor colorWithRed:37 / 255.0 green:37 / 255.0  blue:37 / 255.0  alpha:0.9];
        self.sliderLeftView.frame = CGRectMake(0, 0, 20, HEIGHT);
        self.sliderLeftView.userInteractionEnabled = NO;
        self.sliderLeftView.layer.borderColor = [UIColor blackColor].CGColor;
        self.sliderLeftView.layer.borderWidth = 1.0;
        [self addSubview:self.sliderLeftView];
        
        
        self.leftActionView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, HEIGHT)];
        self.leftActionView.backgroundColor = [UIColor whiteColor];
        self.leftActionView.userInteractionEnabled = YES;
        [self addSubview:self.leftActionView];
        
        self.rightActionView = [[UIImageView alloc] init];
        self.rightActionView.backgroundColor = [UIColor whiteColor];
        self.rightActionView.frame = CGRectMake(WIDTH - 20, 0, 20, HEIGHT);
        self.rightActionView.userInteractionEnabled = YES;
        [self addSubview:self.rightActionView];
        
        self.animationView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, 2, HEIGHT)];
        self.animationView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_animationView];
        

        
}
- (void) panLView:(UIPanGestureRecognizer *)panGestureRecognizer
{
        CGPoint translation = [panGestureRecognizer translationInView:self];
        CGPoint newCenter = CGPointMake(panGestureRecognizer.view.center.x + translation.x, panGestureRecognizer.view.center.y);
        newCenter.x = MAX(10, newCenter.x);
        newCenter.x = MIN(self.rightActionView.frame.origin.x - 40,newCenter.x);
        self.leftActionView.center = CGPointMake(newCenter.x, self.leftActionView.center.y);
        self.sliderLeftView.frame = CGRectMake(0, 0, 20 + self.leftActionView.frame.origin.x, HEIGHT);
        [panGestureRecognizer setTranslation:CGPointZero inView:self.leftActionView];
        [self delegateAction];
}
- (void) panRView:(UIPanGestureRecognizer *)panGestureRecognizer
{
        CGPoint translation = [panGestureRecognizer translationInView:self];
        CGPoint newCenter = CGPointMake(panGestureRecognizer.view.center.x + translation.x, panGestureRecognizer.view.center.y);
        newCenter.x = MIN(WIDTH - 10, newCenter.x);
        newCenter.x = MAX(self.leftActionView.frame.origin.x + 60,newCenter.x);
        self.rightActionView.center = CGPointMake(newCenter.x, self.rightActionView.center.y);
        self.sliderRightView.frame = CGRectMake(self.rightActionView.frame.origin.x, 0,WIDTH - self.rightActionView.frame.origin.x, HEIGHT);
        [panGestureRecognizer setTranslation:CGPointZero inView:self.leftActionView];
        [self delegateAction];

}
-(void)initCollectionView{
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor blackColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.layer.borderWidth = 1.0f;
        self.collectionView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.collectionView.bounces = NO;
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        [self addSubview:self.collectionView];
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"videoImages"];
        
      
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
        return self.videoDuration / (self.cropCount / 10);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"videoImages" forIndexPath:indexPath];
        

        CMTime time = CMTimeMakeWithSeconds((self.cropCount / 10) * indexPath.row, 1 * NSEC_PER_SEC);
        NSError *error = nil;
        CMTime actualTime;
        CGImageRef image = [self.gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        UIImage *videoImage = [UIImage imageWithCGImage:image];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
        imageView.image = videoImage;
        imageView.contentMode = UIViewContentModeScaleToFill;

        [cell addSubview:imageView];
        return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
        return CGSizeMake(collectionView.frame.size.width / 10, self.frame.size.height);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
        CGPoint point = scrollView.contentOffset;
        self.collectionViewX = point.x;
        [self delegateAction];
}

-(void)delegateAction{
        if (self.sliderDelegate && [self.sliderDelegate conformsToProtocol:@protocol(ZGVideoSliderViewDelegate)]) {
                CGFloat start = self.collectionViewX + self.leftActionView.frame.origin.x + self.leftActionView.frame.size.width;
                CGFloat startDuration = start / (self.collectionView.frame.size.width / 10) * (self.cropCount / 10);
                CGFloat duration = (self.rightActionView.frame.origin.x -  self.leftActionView.frame.origin.x - self.leftActionView.frame.size.width) /  (self.collectionView.frame.size.width / 10) * (self.cropCount / 10);
                [self.sliderDelegate videoSiliderView:self startDuration:startDuration duration:duration];
                self.animationTime = duration;
                [self initWithAnimate:self.animationTime];
        }
        
}
#pragma mark - 设定动画
- (void) initWithAnimate:(CGFloat)timer{
        if (!self.animation) {
                self.animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];///.y的话就向下移动。
        }
        self.animation.fromValue = [NSNumber numberWithFloat:self.leftActionView.frame.origin.x + 10];
        self.animation.toValue = [NSNumber numberWithFloat:self.rightActionView.frame.origin.x];
        self.animation.duration = timer;
        self.animation.removedOnCompletion = NO;// yes的话，又返回原位置了。
        self.animation.repeatCount = HUGE_VALF;
        self.animation.fillMode = kCAFillModeForwards;
        [self.animationView.layer addAnimation:self.animation forKey:nil];
        
}
-(void)setVideoMaximumDuration:(CGFloat)videoMaximumDuration{
        _videoMaximumDuration = videoMaximumDuration;
        self.videoDuration = (CGFloat)self.videoAsset.duration;
        if (self.videoDuration >= videoMaximumDuration) {
                self.cropCount = self.videoMaximumDuration;
        }else{
                self.cropCount = self.videoDuration;
        }
        [self initWithAnimate:self.videoMaximumDuration];

}


-(void)layoutSubviews{
        self.collectionView.frame = CGRectMake(20, 0, WIDTH - 40, HEIGHT);
}





@end
