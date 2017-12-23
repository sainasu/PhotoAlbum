//
//  ZGPagePreviewImageView.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/17.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPagePreviewImageView.h"



@interface ZGPagePreviewImageView()<UIGestureRecognizerDelegate>{
        CGFloat _lastScale;
}
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIImageView *scorllImageView;
@property(nonatomic, strong) UIScrollView *scaleScrollView;
@property(nonatomic, strong) UIImageView *scaleImageView;
@property(nonatomic, assign) BOOL  doubleAction;

@end

@implementation ZGPagePreviewImageView
- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                self.userInteractionEnabled = YES;
                UIPinchGestureRecognizer *pingch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImageViewAction:)];
                pingch.delegate = self;
                _lastScale = 1.0;
                [self addGestureRecognizer:pingch];
                
                UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleClick:)];
                doubleTap.numberOfTapsRequired = 2;
                doubleTap.delegate = self;
                [self addGestureRecognizer:doubleTap];
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
                tap.delegate = self;
                [self addGestureRecognizer:tap];
                [tap requireGestureRecognizerToFail:doubleTap];
        }
        return self;
}
-(void)tapClick:(UITapGestureRecognizer *)tap{
        if (self.imageViewDelegate && [self.imageViewDelegate conformsToProtocol:@protocol(ZGPagePreviewImageViewDelegate)]) {
                [self.imageViewDelegate pagePreviewImageView:self];
        }

}
- (void)scaleImageViewAction:(UIPinchGestureRecognizer *)sender{
        CGFloat scale = sender.scale;//得到的是当前手势放大倍数
        CGFloat shouldScale = _lastScale + (scale - 1);//我们需要知道的是当前手势相收缩率对于刚才手势的相对收缩 scale - 1，然后加上最后一次收缩率，为当前要展示的收缩率
        [self setScaleImageWithScale:shouldScale];
        sender.scale = 1.0;//图片大小改变后设置手势scale为1
}
- (void)setScaleImageWithScale:(CGFloat)scale{
        //最大2倍最小1
        if (scale >= 2.5) {
                scale = 2.5;
        }else if(scale <=1){
                scale = 1;
        }
        _lastScale = scale;
        self.scaleImageView.transform = CGAffineTransformMakeScale(scale, scale);
        if (scale > 1) {
                CGFloat imageWidth = self.scaleImageView.frame.size.width;
                CGFloat imageHeight =  MAX(self.scaleImageView.frame.size.height, self.frame.size.height);
                [self bringSubviewToFront:self.scaleScrollView];
                self.scaleImageView.center = CGPointMake(imageWidth * 0.5, imageHeight * 0.5);
                self.scaleScrollView.contentSize = CGSizeMake(imageWidth, imageHeight);
                
                CGPoint offset = self.scaleScrollView.contentOffset;
                offset.x = (imageWidth - self.frame.size.width) / 2.0;
                offset.y = (imageHeight - self.frame.size.height) / 2.0;
                self.scaleScrollView.contentOffset = offset;
        }else{
                self.scaleImageView.center = self.scaleScrollView.center;
                self.scaleScrollView.contentSize = CGSizeZero;
        }
}

- (void)doubleClick:(UITapGestureRecognizer *)tap{
        if (_lastScale > 1) {
                _lastScale = 1;
        }else{
                _lastScale =2.5;
        }
        [UIView animateWithDuration:.5 animations:^{
                [self setScaleImageWithScale:_lastScale];
        }completion:^(BOOL finished) {
                if (_lastScale == 1) {
                        [self resetView];
                }
        }];
        
}
//当达到原图大小 清除 放大的图片 和scrollview
- (void)resetView{
        if (!self.scaleScrollView) {
                return;
        }
        _scaleImageView.alpha = 1.0;
        self.scaleScrollView.hidden = YES;
        [self.scaleScrollView removeFromSuperview];
        self.scaleScrollView = nil;
        self.scaleImageView = nil;
}

- (UIScrollView *)scrollView{
        
        if (!_scrollView) {
                _scrollView = [[UIScrollView alloc] init];
                _scrollView.backgroundColor = [UIColor blackColor];
                [self addSubview:_scrollView];
        }
        return _scrollView;
}
-(UIImageView *)scorllImageView{
        
        if (!_scorllImageView) {
                _scorllImageView = [[UIImageView alloc] init];
                _scorllImageView.image = self.image;
                _scorllImageView.contentMode = UIViewContentModeScaleAspectFit;
                [self.scrollView addSubview:self.scorllImageView];
        }
        return _scorllImageView;
}
-(UIScrollView *)scaleScrollView{
        if (!_scaleScrollView) {
                _scaleScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
                _scaleScrollView.bounces = NO;
                _scaleScrollView.backgroundColor = [UIColor blackColor];
                _scaleScrollView.contentSize =  self.bounds.size;
                _scaleScrollView.showsVerticalScrollIndicator = FALSE;
                _scaleScrollView.showsHorizontalScrollIndicator = FALSE;
                [self addSubview:_scaleScrollView];
                
        }
        return _scaleScrollView;
}
- (UIImageView *)scaleImageView{
        if (!_scaleImageView) {
                _scaleImageView = [[UIImageView alloc]initWithFrame:[self adjustTheUIInTheImage:self.image]];
                _scaleImageView.image = self.image;
                _scaleImageView.contentMode = UIViewContentModeScaleAspectFit;
                _scorllImageView.center = self.scaleScrollView.center;
                [self.scaleScrollView addSubview:_scaleImageView];
        }
        return _scaleImageView;
}

- (void)layoutSubviews{
        [super layoutSubviews];
        
        CGSize imageSize = [self adjustTheUIInTheImage:self.image].size;
        //图片高度大于屏幕高度
        if (self.frame.size.width  > self.frame.size.height) {
                [self scrollView];
                self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.frame.size.width );
                self.scorllImageView.center = self.scrollView.center;
                self.scorllImageView.bounds = CGRectMake(0, 0, imageSize.width, self.frame.size.width);
        }else{
                if (_scrollView)[_scrollView removeFromSuperview];
        }
        
        
        
}
- (CGRect)adjustTheUIInTheImage:(UIImage *)image{
        
        CGSize size;
        size = CGSizeMake(self.frame.size.width , self.frame.size.height);
        CGFloat scaleX = image.size.width / size.width;
        CGFloat scaleY = image.size.height / size.height;
        CGFloat scale = MAX(scaleX, scaleY);
        CGRect bounds = CGRectMake(0, 0, floorf(image.size.width / scale), floorf(image.size.height / scale));
        return bounds;
}


@end
