//
//  ZGCropPictureView.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/11/22.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGCropPictureView.h"
#import "ZGCropPictureModel.h"
#import "ZGPhotoAlbumHeader.h"
@interface ZGCropPictureView()<UIScrollViewDelegate>
@property(nonatomic, assign) CGRect  cropFrame;
@property(nonatomic, assign) BOOL  isRound;

@property(nonatomic, strong) UIImage *cropImage;
@property(nonatomic, strong) UIImageView *cropImageView;
@property(nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIView *headerView;
@property(nonatomic, strong) UIView *footerView;
@property(nonatomic, strong) UIView *leftView;
@property(nonatomic, strong) UIView *rightView;

@end


@implementation ZGCropPictureView
- (instancetype)initWithFrame:(CGRect)frame cropImage:(UIImage *)cropImage cropSize:(CGSize)cropSize  isRound:(BOOL)round
{
        self = [super initWithFrame:frame];
        if (self) {
                self.cropImage = cropImage;
                self.isRound = round;
//                self.isRound = YES;
                // 重新按比例缩放传进来的size -- 保证在屏幕内且上下左右至少距离屏幕边缘10
                CGSize size;
                size = CGSizeMake(frame.size.width - 20, frame.size.height - 64 - 20);
                CGFloat scaleX = cropSize.width / size.width;
                CGFloat scaleY = cropSize.height / size.height;
                CGFloat scale = MAX(scaleX, scaleY);
                size = CGSizeMake(floorf(cropSize.width / scale) - 10, floorf(cropSize.height / scale)- 10);
                self.cropFrame = CGRectMake((frame.size.width - size.width) * 0.5, (frame.size.height - size.height) * 0.5, size.width, size.height);
                // 初始化scrollView
                self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
                self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                self.scrollView.alwaysBounceHorizontal = YES;
                self.scrollView.alwaysBounceVertical = YES;
                self.scrollView.showsHorizontalScrollIndicator = NO;
                self.scrollView.showsVerticalScrollIndicator = NO;
                self.scrollView.maximumZoomScale = 3.0f;
                self.scrollView.minimumZoomScale = 1.0f;
                self.scrollView.delegate = self;
                [self.scrollView setZoomScale:1.0f animated:YES];
                [self addSubview:self.scrollView];
                
                // 初始化imageView
                self.cropImageView = [[UIImageView alloc] initWithImage:cropImage];
                [self.scrollView addSubview:self.cropImageView];
                
                // 初始化遮挡Views
                [self initKeepViews];
        }
        return self;
}


#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
        return self.cropImageView;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
        //把当前的缩放比例设进ZoomScale，以便下次缩放时实在现有的比例的基础上
        [_scrollView setZoomScale:scale animated:NO];
        self.scrollView.contentSize = CGSizeMake(self.cropImageView.frame.size.width + _contentView.frame.origin.x * 2, self.cropImageView.frame.size.height + _contentView.frame.origin.y * 2);
}


#pragma mark - keepViews
- (void)initKeepViews{
        
        self.contentView = [[UIView alloc] initWithFrame:self.cropFrame];
        self.contentView.userInteractionEnabled = NO;
        if (self.isRound) {
                self.contentView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
                CAShapeLayer *layer = [CAShapeLayer new];
               
                CGFloat radius = self.cropFrame.size.width / 2;
                //按照顺时针方向
                BOOL clockWise = true;
                //初始化一个路径
                UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.cropFrame.size.width / 2, self.cropFrame.origin.y + 16) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:clockWise];
                [path closePath];
                layer.path = [path CGPath];
                layer.lineWidth = 1;
                layer.strokeColor = COLOR_FOR_BORDER.CGColor;
                layer.fillColor = [UIColor clearColor].CGColor;
                [self.contentView.layer addSublayer:layer];

        }else{
                self.contentView.backgroundColor = [UIColor clearColor];
                self.contentView.layer.borderWidth = 1.0f;
                self.contentView.layer.borderColor = COLOR_FOR_BORDER.CGColor;
        }
        [self addSubview:self.contentView];
        self.headerView = [[UIView alloc] init];
        self.headerView.backgroundColor = COLOR_FOR_PHOTO_EDIT_TOOL;
        self.headerView.userInteractionEnabled = NO;
        [self addSubview:self.headerView];
        self.footerView = [[UIView alloc] init];
        self.footerView.backgroundColor = COLOR_FOR_PHOTO_EDIT_TOOL;
        self.footerView.userInteractionEnabled = NO;
        [self addSubview:self.footerView];
        self.leftView = [[UIView alloc] init];
        self.leftView.backgroundColor = COLOR_FOR_PHOTO_EDIT_TOOL;
        self.leftView.userInteractionEnabled = NO;
        [self addSubview:self.leftView];
        self.rightView = [[UIView alloc] init];
        self.rightView.backgroundColor = COLOR_FOR_PHOTO_EDIT_TOOL;
        self.rightView.userInteractionEnabled = NO;
        [self addSubview:self.rightView];
        
}

#pragma mark - layoutSubviews
-(void)layoutSubviews{
        self.contentView.frame = self.cropFrame;
        self.headerView.frame = CGRectMake(0, 0, self.frame.size.width, (self.frame.size.height - self.cropFrame.size.height) * 0.5);
        self.footerView.frame = CGRectMake(0, self.contentView.frame.origin.y + self.contentView.frame.size.height, self.frame.size.width, (self.frame.size.height - self.cropFrame.size.height) * 0.5);
        self.leftView.frame = CGRectMake(0, self.headerView.frame.size.height, (self.frame.size.width - self.cropFrame.size.width) * 0.5, self.cropFrame.size.height);
        self.rightView.frame = CGRectMake(self.contentView.frame.size.width + self.contentView.frame.origin.x, self.headerView.frame.size.height, (self.frame.size.width - self.cropFrame.size.width) * 0.5, self.cropFrame.size.height);
        CGSize size;
        size = CGSizeMake(self.cropFrame.size.width, self.cropFrame.size.height);
        CGFloat scaleX = self.cropImage.size.width / size.width;
        CGFloat scaleY = self.cropImage.size.height / size.height;
        CGFloat scale = MIN(scaleX, scaleY);
        size = CGSizeMake(self.cropImage.size.width / scale,self.cropImage.size.height / scale);
        self.cropImageView.frame = CGRectMake( _contentView.frame.origin.x, _contentView.frame.origin.y, size.width, size.height);
        self.scrollView.contentSize = CGSizeMake(self.cropImageView.frame.size.width + _contentView.frame.origin.x * 2, self.cropImageView.frame.size.height + _contentView.frame.origin.y * 2);
        
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGCropPictureViewDelegate)]) {
                [self.delegate cropPictureView:self cropViewFrame:self.cropFrame];
        }
}


@end
