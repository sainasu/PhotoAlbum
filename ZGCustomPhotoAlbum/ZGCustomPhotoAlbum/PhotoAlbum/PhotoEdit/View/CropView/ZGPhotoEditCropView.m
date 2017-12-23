//
//  ZGPhotoEditCropView.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/26.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPhotoEditCropView.h"
#import "ZGPhotoEditHeader.h"
#import "ZGPhotoEditModel.h"
#import "ZGPhotoScrollView.h"

static const CGFloat kMaximumCanvasWidthRatio = 0.9;
static const CGFloat kMaximumCanvasHeightRatio = 0.9;
static const CGFloat kCanvasHeaderHeigth = 49;
static const CGFloat kCropViewHotArea = 20;



@interface ZGPhotoEditCropView () <UIScrollViewDelegate, CropViewDelegate>
@property (nonatomic, strong) ZGPhotoScrollView *scrollView;
@property(nonatomic, strong) UIView *toolView; // <#注释#>

@property (nonatomic, strong) ZGCropView *cropView;
@property (nonatomic, assign) CGSize originalSize;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) BOOL manualZoomed;
// constants
@property (nonatomic, assign) CGSize maximumCanvasSize;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGPoint originalPoint;
@property (nonatomic, assign) CGFloat maxRotationAngle;



@property(nonatomic, strong) UIButton *cancelButton;
@property(nonatomic, strong) UIButton *resetButton;
@property(nonatomic, strong) UIButton *finishButton;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *rightView;


@end

@implementation ZGPhotoEditCropView
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
        self = [super initWithFrame:frame];
        if (self) {
                self.image = image;
                self.backgroundColor = COLOR_PHOTO_EIDT(0x000000);
                _maximumCanvasSize = CGSizeMake(kMaximumCanvasWidthRatio * self.frame.size.width ,
                                                kMaximumCanvasHeightRatio * self.frame.size.height - kCanvasHeaderHeigth);
                CGFloat scaleX = image.size.width / self.maximumCanvasSize.width;
                CGFloat scaleY = image.size.height / self.maximumCanvasSize.height;
                CGFloat scale = MAX(scaleX, scaleY);
                CGRect bounds = CGRectMake(0, 0, image.size.width / scale, image.size.height / scale);
                _originalSize = bounds.size;
                
                _centerY = self.maximumCanvasSize.height / 2 + kCanvasHeaderHeigth;
                
                _scrollView = [[ZGPhotoScrollView alloc] initWithFrame:bounds];
                _scrollView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, self.centerY);
                _scrollView.bounces = YES;
                _scrollView.layer.anchorPoint = CGPointMake(0.5, 0.5);
                _scrollView.alwaysBounceVertical = YES;
                _scrollView.alwaysBounceHorizontal = YES;
                _scrollView.delegate = self;
                _scrollView.minimumZoomScale = 1;
                _scrollView.maximumZoomScale = 2.5;
                _scrollView.showsVerticalScrollIndicator = NO;
                _scrollView.showsHorizontalScrollIndicator = NO;
                _scrollView.clipsToBounds = NO;
                _scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
                [self addSubview:_scrollView];
                
                _photoContentView = [[ZGPhotoContentView alloc] initWithFrame:self.bounds Image:self.image];
                _photoContentView.frame = self.scrollView.bounds;
                _photoContentView.backgroundColor = [UIColor clearColor];
                _photoContentView.userInteractionEnabled = YES;
                _scrollView.photoContentView = self.photoContentView;
                [self.scrollView addSubview:_photoContentView];
                [self initCropView];
                _originalPoint = [self convertPoint:self.scrollView.center toView:self];
                
                [self  initCropToolView];
        }
        return self;
}
- (void) initCropView{
        _cropView = [[ZGCropView alloc] initWithFrame:self.scrollView.frame];
        _cropView.center = self.scrollView.center;
        _cropView.delegate = self;
        [self addSubview:_cropView];
        
        self.topView = [[UIView alloc] init];
        self.topView.backgroundColor = COLOR_PHOTO_EIDT_BAR;
        self.topView.userInteractionEnabled = NO;
        [self addSubview:self.topView];
        self.bottomView = [[UIView alloc] init];
        self.bottomView.backgroundColor = COLOR_PHOTO_EIDT_BAR;
        self.bottomView.userInteractionEnabled = NO;
        [self addSubview:self.bottomView];
        self.leftView = [[UIView alloc] init];
        self.leftView.backgroundColor = COLOR_PHOTO_EIDT_BAR;
        self.leftView.userInteractionEnabled = NO;
        [self addSubview:self.leftView];
        self.rightView = [[UIView alloc] init];
        self.rightView.backgroundColor =COLOR_PHOTO_EIDT_BAR;
        self.rightView.userInteractionEnabled = NO;
        [self addSubview:self.rightView];
        [self fourViewsFrame:self.cropView.frame alpha:0.01f duration:0.1];
        
}

-(void)fourViewsFrame:(CGRect)frame alpha:(CGFloat)alpha duration:(CGFloat)duration{
        [UIView animateWithDuration:duration animations:^{
                self.topView.frame = CGRectMake(0, 0, self.frame.size.width, frame.origin.y);
                self.bottomView.frame = CGRectMake(0, frame.origin.y + frame.size.height, self.frame.size.width, self.frame.size.height);
                self.rightView.frame = CGRectMake(0, frame.origin.y , frame.origin.x,  frame.size.height);
                self.leftView.frame = CGRectMake(frame.origin.x + frame.size.width, frame.origin.y, self.frame.size.width - frame.origin.x - frame.size.width, frame.size.height);
                self.rightView.alpha = alpha;
                self.leftView.alpha = alpha;
                self.bottomView.alpha = alpha;
                self.topView.alpha = alpha;
        }];
}
#pragma mark - CropView Delegate
- (void)cropMoved:(ZGCropView *)cropView
{
        [self fourViewsFrame:self.cropView.frame alpha:0.05f duration:0.1];
        
}
- (void)cropEnded:(ZGCropView *)cropView
{
        
        CGFloat scaleX = self.originalSize.width / cropView.bounds.size.width;
        CGFloat scaleY = self.originalSize.height / cropView.bounds.size.height;
        CGFloat scale = MIN(scaleX, scaleY);
        
        CGRect newCropBounds = CGRectMake(0, 0, scale * cropView.frame.size.width, scale * cropView.frame.size.height);
        
        CGFloat width = fabs(cos(self.angle)) * newCropBounds.size.width + fabs(sin(self.angle)) * newCropBounds.size.height;
        CGFloat height = fabs(sin(self.angle)) * newCropBounds.size.width + fabs(cos(self.angle)) * newCropBounds.size.height;
        
        CGRect scaleFrame = cropView.frame;
        if (scaleFrame.size.width >= self.scrollView.bounds.size.width) {
                scaleFrame.size.width = self.scrollView.bounds.size.width - 1;
        }
        if (scaleFrame.size.height >= self.scrollView.bounds.size.height) {
                scaleFrame.size.height = self.scrollView.bounds.size.height - 1;
        }
        
        CGPoint contentOffset = self.scrollView.contentOffset;
        CGPoint contentOffsetCenter = CGPointMake(contentOffset.x + self.scrollView.bounds.size.width / 2, contentOffset.y + self.scrollView.bounds.size.height / 2);
        CGRect bounds = self.scrollView.bounds;
        bounds.size.width = width;
        bounds.size.height = height;
        self.scrollView.bounds = CGRectMake(0, 0, width, height);
        CGPoint newContentOffset = CGPointMake(contentOffsetCenter.x - self.scrollView.bounds.size.width / 2, contentOffsetCenter.y - self.scrollView.bounds.size.height / 2);
        self.scrollView.contentOffset = newContentOffset;
        
        [UIView animateWithDuration:0.25 animations:^{
                // animate crop view
                cropView.bounds = CGRectMake(0, 0, newCropBounds.size.width, newCropBounds.size.height);
                cropView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, self.centerY);
                
                // zoom the specified area of scroll view
                CGRect zoomRect = [self convertRect:scaleFrame toView:self.scrollView.photoContentView];
                [self.scrollView zoomToRect:zoomRect animated:NO];
        }];
        
        self.manualZoomed = YES;
        [self.cropView dismissCropLines];
        
        CGFloat scaleH = self.scrollView.bounds.size.height / self.scrollView.contentSize.height;
        CGFloat scaleW = self.scrollView.bounds.size.width / self.scrollView.contentSize.width;
        __block CGFloat scaleM = MAX(scaleH, scaleW);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (scaleM > 1) {
                        scaleM = scaleM * self.scrollView.zoomScale;
                        [self.scrollView setZoomScale:scaleM animated:NO];
                }
                [UIView animateWithDuration:0.2 animations:^{
                        [self checkScrollViewContentOffset];
                        [self fourViewsFrame:self.cropView.frame alpha:1.0f duration:0.5];

                }];
        });
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
        return self.photoContentView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
        self.manualZoomed = YES;
}

- (void)checkScrollViewContentOffset
{
        self.scrollView.contentOffsetX = MAX(self.scrollView.contentOffset.x, 0);
        self.scrollView.contentOffsetY = MAX(self.scrollView.contentOffset.y, 0);
        if (self.scrollView.contentSize.height - self.scrollView.contentOffset.y <= self.scrollView.bounds.size.height) {
                self.scrollView.contentOffsetY = self.scrollView.contentSize.height - self.scrollView.bounds.size.height;
        }
        if (self.scrollView.contentSize.width - self.scrollView.contentOffset.x <= self.scrollView.bounds.size.width) {
                self.scrollView.contentOffsetX = self.scrollView.contentSize.width - self.scrollView.bounds.size.width;
        }
}

- (void) initCropToolView{
        self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 49, self.frame.size.width, 49)];
        self.toolView.backgroundColor = COLOR_PHOTO_EIDT_BAR;
        [self addSubview:self.toolView];

        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Nav_Close2"] forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(cropToolViewButtonsAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelButton setTag:0];
        [self addSubview:self.cancelButton];
        self.resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.resetButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Nav_Recovery"] forState:UIControlStateNormal];
        [self.resetButton addTarget:self action:@selector(cropToolViewButtonsAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.resetButton setTag:1];
        [self addSubview:self.resetButton];
        self.finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.finishButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Nav_Save"] forState:UIControlStateNormal];
        [self.finishButton addTarget:self action:@selector(cropToolViewButtonsAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.finishButton setTag:2];
        [self addSubview:self.finishButton];
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
        if (self.hidden) {
                return nil;
        }
        if (CGRectContainsPoint(self.cancelButton.frame, point)) {
                        return self.cancelButton;
                }else if (CGRectContainsPoint(self.resetButton.frame, point)){
                        return self.resetButton;
                }else if(CGRectContainsPoint(self.finishButton.frame, point)){
                        return self.finishButton;
                }else if (CGRectContainsPoint(CGRectInset(self.cropView.frame, - kCropViewHotArea, -kCropViewHotArea), point) && !CGRectContainsPoint(CGRectInset(self.cropView.frame, kCropViewHotArea, kCropViewHotArea), point)) {
                        return self.cropView;
                }else if(CGRectContainsPoint(self.toolView.frame, point)){
                        return self.toolView;
                }
        return self.scrollView;
}
-(void)cropToolViewButtonsAction:(UIButton *)button{
        if (button.tag == 0) { // 取消按钮点击事件
                if (self.cropDelegate && [self.cropDelegate conformsToProtocol:@protocol(ZGPhotoEditCropViewDelegate)]) {
                        [self.cropDelegate photoEditCropViewDidCancel:self cropImageFrame:CGRectMake(
                                                                                                     self.scrollView.contentOffset.x * 1.1 / self.scrollView.zoomScale,
                                                                                                     self.scrollView.contentOffset.y * 1.1 / self.scrollView.zoomScale,
                                                                                                     self.cropView.frame.size.width * 1.1 / self.scrollView.zoomScale,
                                                                                                     self.cropView.frame.size.height * 1.11/ self.scrollView.zoomScale)];
                }

        }else if (button.tag == 1){ // 重置按钮点击事件
                [UIView animateWithDuration:0.25 animations:^{
                        self.angle = 0;
                        self.scrollView.transform = CGAffineTransformIdentity;
                        self.scrollView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, self.centerY);
                        self.scrollView.bounds = CGRectMake(0, 0, self.originalSize.width, self.originalSize.height);
                        self.scrollView.minimumZoomScale = 1;
                        [self.scrollView setZoomScale:1 animated:NO];
                        self.cropView.frame = self.scrollView.frame;
                        self.cropView.center = self.scrollView.center;
                }];
                [self fourViewsFrame:self.cropView.frame alpha:0.05f duration:0.1];
        }else if (button.tag == 2){ //  完成按钮点击事件
                if (self.cropDelegate && [self.cropDelegate conformsToProtocol:@protocol(ZGPhotoEditCropViewDelegate)]) {
                        [self.cropDelegate photoEditCropViewDidFinish:self
                                                             transform:self.scrollView.photoContentView.transform
                                                       cropImageFrame:CGRectMake(
                                                                                 self.scrollView.contentOffset.x * 1.1 / self.scrollView.zoomScale,
                                                                                 self.scrollView.contentOffset.y * 1.1 / self.scrollView.zoomScale,
                                                                                 self.cropView.frame.size.width * 1.1 / self.scrollView.zoomScale,
                                                                                 self.cropView.frame.size.height * 1.11/ self.scrollView.zoomScale)];
                        
                }
        }
}
-(void)setImage:(UIImage *)image{
        _image = image;
        _photoContentView.imageView.image = image;
}

-(void)layoutSubviews{
        
        self.cancelButton.frame = CGRectMake(15, self.frame.size.height - HEIGHT_PHOTO_EIDT_BAR_TOOL_X, HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        self.resetButton.frame = CGRectMake(self.frame.size.width / 2 - HEIGHT_PHOTO_EIDT_BAR_TOOL_X * 0.5,  self.frame.size.height - HEIGHT_PHOTO_EIDT_BAR_TOOL_X, HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        self.finishButton.frame = CGRectMake(self.frame.size.width - HEIGHT_PHOTO_EIDT_BAR_TOOL_X - 15,  self.frame.size.height - HEIGHT_PHOTO_EIDT_BAR_TOOL_X, HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL);
}

@end












