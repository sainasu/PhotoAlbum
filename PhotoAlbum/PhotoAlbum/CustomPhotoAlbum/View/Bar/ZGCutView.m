//
//  ZGCutView.m
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/8.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGCutView.h"
#import "SNPEViewModel.h"
@interface ZGCutView()<UIGestureRecognizerDelegate>
@property (nonatomic, retain) UIImage *originalImage;
@property (nonatomic, retain) UIImage *editedImage;

@property (nonatomic, retain) UIImageView *showImgView;
@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, retain) UIView *ratioView;

@property (nonatomic, assign) CGRect oldFrame;
@property (nonatomic, assign) CGRect largeFrame;
@property (nonatomic, assign) CGFloat limitRatio;
@property (nonatomic, assign) CGRect latestFrame;
@property(nonatomic, assign) BOOL  isEque;/**<#注释#>*/
@property(nonatomic, strong) UIImage* smallImage;/**<#注释#>*/



@end


@implementation ZGCutView
- (instancetype)initWithFrame:(CGRect)frame Image:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio
{
        self = [super initWithFrame:frame];
        if (self) {
                self.backgroundColor = [UIColor blackColor];

                self.cropFrame = cropFrame;
                if (cropFrame.size.width == cropFrame.size.height) {
                        self.isEque = YES;
                }else{
                        self.isEque = NO;
                }
                self.limitRatio = limitRatio;
                self.originalImage = originalImage;
                [self initSubViews];
        }
        return self;
}

//初始化子视图
-(void)initSubViews{
        self.showImgView = [[UIImageView alloc] initWithFrame:self.cropFrame];
        self.showImgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.showImgView setMultipleTouchEnabled:YES];
        [self.showImgView setUserInteractionEnabled:YES];
        [self.showImgView setImage:self.originalImage];
        [self.showImgView setUserInteractionEnabled:YES];
        [self.showImgView setMultipleTouchEnabled:YES];
        // 设置位置
        if (self.originalImage.size.height <= self.cropFrame.size.height) {
                if (self.originalImage.size.width > self.originalImage.size.height) {//宽
                        CGFloat oriWidth = self.originalImage.size.width * (self.cropFrame.size.height / self.originalImage.size.height);
                        CGFloat oriHeight = self.cropFrame.size.height;
                        CGFloat oriX = self.cropFrame.origin.x + (self.cropFrame.size.width - oriWidth) / 2;
                        CGFloat oriY = self.cropFrame.origin.y + (self.cropFrame.size.height - oriHeight) / 2;
                        self.oldFrame = CGRectMake(oriX, oriY, oriWidth, oriHeight);
                }else{
                        CGFloat w = self.cropFrame.size.width / self.originalImage.size.width;
                        CGFloat h = self.cropFrame.size.height / self.originalImage.size.height;

                        if (w > h) {
                                CGFloat oriWidth = self.cropFrame.size.width;
                                CGFloat oriHeight = self.originalImage.size.height * (self.cropFrame.size.width / self.originalImage.size.width);
                                CGFloat oriX = self.cropFrame.origin.x + (self.cropFrame.size.width - oriWidth) / 2;
                                CGFloat oriY = self.cropFrame.origin.y + (self.cropFrame.size.height - oriHeight) / 2;
                                self.oldFrame = CGRectMake(oriX, oriY, oriWidth, oriHeight);

                        }else{
                                CGFloat oriWidth = self.originalImage.size.width  * (self.cropFrame.size.height / self.originalImage.size.height);
                                CGFloat oriHeight = self.cropFrame.size.height;
                                CGFloat oriX = self.cropFrame.origin.x + (self.cropFrame.size.width - oriWidth) / 2;
                                CGFloat oriY = self.cropFrame.origin.y + (self.cropFrame.size.height - oriHeight) / 2;
                                self.oldFrame = CGRectMake(oriX, oriY, oriWidth, oriHeight);
  
                        }
                        
                }
        }else{
                if (self.originalImage.size.width > self.originalImage.size.height) {//宽
                        CGFloat oriWidth = self.originalImage.size.width * (self.cropFrame.size.height / self.originalImage.size.height);
                        CGFloat oriHeight = self.cropFrame.size.height;
                        CGFloat oriX = self.cropFrame.origin.x + (self.cropFrame.size.width - oriWidth) / 2;
                        CGFloat oriY = self.cropFrame.origin.y + (self.cropFrame.size.height - oriHeight) / 2;
                        self.oldFrame = CGRectMake(oriX, oriY, oriWidth, oriHeight);
                }else{
                        CGFloat w = self.cropFrame.size.width / self.originalImage.size.width;
                        CGFloat h = self.cropFrame.size.height / self.originalImage.size.height;
                        
                        if (w > h) {
                                CGFloat oriWidth = self.cropFrame.size.width;
                                CGFloat oriHeight = self.originalImage.size.height * (self.cropFrame.size.width / self.originalImage.size.width);
                                CGFloat oriX = self.cropFrame.origin.x + (self.cropFrame.size.width - oriWidth) / 2;
                                CGFloat oriY = self.cropFrame.origin.y + (self.cropFrame.size.height - oriHeight) / 2;
                                self.oldFrame = CGRectMake(oriX, oriY, oriWidth, oriHeight);
                                
                        }else{
                                CGFloat oriWidth = self.originalImage.size.width  * (self.cropFrame.size.height / self.originalImage.size.height);
                                CGFloat oriHeight = self.cropFrame.size.height;
                                CGFloat oriX = self.cropFrame.origin.x + (self.cropFrame.size.width - oriWidth) / 2;
                                CGFloat oriY = self.cropFrame.origin.y + (self.cropFrame.size.height - oriHeight) / 2;
                                self.oldFrame = CGRectMake(oriX, oriY, oriWidth, oriHeight);
                                
                        }
                        
                }
        }
        
        self.latestFrame = self.oldFrame;
        self.showImgView.frame = self.oldFrame;
        
        self.largeFrame = CGRectMake(0, 0, self.limitRatio * self.oldFrame.size.width, self.limitRatio * self.oldFrame.size.height);
        
        [self addGestureRecognizers];
        [self addSubview:self.showImgView];
        
        self.overlayView = [[UIView alloc] initWithFrame:self.bounds];
        self.overlayView.alpha = .5f;
        self.overlayView.backgroundColor = [UIColor blackColor];
        self.overlayView.userInteractionEnabled = NO;
        self.overlayView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.overlayView];
        
        self.ratioView = [[UIView alloc] initWithFrame:self.cropFrame];
        self.ratioView.layer.borderColor = [UIColor yellowColor].CGColor;
        self.ratioView.layer.borderWidth = 1.0f;
        self.ratioView.autoresizingMask = UIViewAutoresizingNone;
        [self addSubview:self.ratioView];
        
        [self overlayClipping];

}
//添加手势
-(void)addGestureRecognizers{
        // 添加缩放手势
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
        pinchGestureRecognizer.delegate = self;
        [self addGestureRecognizer:pinchGestureRecognizer];
        
        // 添加拖拽手势
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
        panGestureRecognizer.delegate = self;
        [self addGestureRecognizer:panGestureRecognizer];

}
// 缩放手势
- (void)pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
        UIView *view = self.showImgView;
        if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
                view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
                pinchGestureRecognizer.scale = 1;
        }
        else if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded) {
                CGRect newFrame = self.showImgView.frame;
                newFrame = [self handleScaleOverflow:newFrame];
                newFrame = [self handleBorderOverflow:newFrame];
                [UIView animateWithDuration:0.3f animations:^{
                        self.showImgView.frame = newFrame;
                        self.latestFrame = newFrame;
                }];
        }
}

// 拖拽手势
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
        UIView *view = self.showImgView;
        if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
                // 计算加速器
                CGFloat absCenterX = self.cropFrame.origin.x + self.cropFrame.size.width / 2;
                CGFloat absCenterY = self.cropFrame.origin.y + self.cropFrame.size.height / 2;
                CGFloat scaleRatio = self.showImgView.frame.size.width / self.cropFrame.size.width;
                CGFloat acceleratorX = 1 - ABS(absCenterX - view.center.x) / (scaleRatio * absCenterX);
                CGFloat acceleratorY = 1 - ABS(absCenterY - view.center.y) / (scaleRatio * absCenterY);
                CGPoint translation = [panGestureRecognizer translationInView:view.superview];
                [view setCenter:(CGPoint){view.center.x + translation.x * acceleratorX, view.center.y + translation.y * acceleratorY}];
                [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
        }
        else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
                // bounce to original frame
                CGRect newFrame = self.showImgView.frame;
                newFrame = [self handleBorderOverflow:newFrame];
                [UIView animateWithDuration:0.3f animations:^{
                        self.showImgView.frame = newFrame;
                        self.latestFrame = newFrame;
                }];
        }
}

- (CGRect)handleScaleOverflow:(CGRect)newFrame {
        // 反弹原始框架
        CGPoint oriCenter = CGPointMake(newFrame.origin.x + newFrame.size.width/2, newFrame.origin.y + newFrame.size.height/2);
        if (newFrame.size.width < self.oldFrame.size.width) {
                newFrame = self.oldFrame;
        }
        
        newFrame.origin.x = oriCenter.x - newFrame.size.width/2;
        newFrame.origin.y = oriCenter.y - newFrame.size.height/2;
        return newFrame;
}

- (CGRect)handleBorderOverflow:(CGRect)newFrame {
        // 水平对其
        if (newFrame.origin.x > self.cropFrame.origin.x) newFrame.origin.x = self.cropFrame.origin.x;
        if (self.isEque == YES) {
                if (CGRectGetMaxX(newFrame) < self.cropFrame.size.width) newFrame.origin.x = self.cropFrame.size.width - newFrame.size.width;
        }else{
        if (CGRectGetMaxX(newFrame) < self.cropFrame.size.width) newFrame.origin.x = self.cropFrame.size.width - newFrame.size.width+ 13;
        }
        // 垂直
        if (newFrame.origin.y > self.cropFrame.origin.y) newFrame.origin.y = self.cropFrame.origin.y;
        if (CGRectGetMaxY(newFrame) < self.cropFrame.origin.y + self.cropFrame.size.height) {
                newFrame.origin.y = self.cropFrame.origin.y + self.cropFrame.size.height - newFrame.size.height;
        }
        // 适应给定大小
        if (self.showImgView.frame.size.width > self.showImgView.frame.size.height && newFrame.size.height <= self.cropFrame.size.height) {
                newFrame.origin.y = self.cropFrame.origin.y + (self.cropFrame.size.height - newFrame.size.height) / 2;
        }
        return newFrame;
}

//
-(void)overlayClipping{
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        CGMutablePathRef path = CGPathCreateMutable();
        // 左边的比率
        CGPathAddRect(path, nil, CGRectMake(0, 0,
                                            self.ratioView.frame.origin.x,
                                            self.overlayView.frame.size.height));
        // 右边的比率
        CGPathAddRect(path, nil, CGRectMake(
                                            self.ratioView.frame.origin.x + self.ratioView.frame.size.width,
                                            0,
                                            self.overlayView.frame.size.width - self.ratioView.frame.origin.x - self.ratioView.frame.size.width,
                                            self.overlayView.frame.size.height));
        // 上边
        CGPathAddRect(path, nil, CGRectMake(0, 0,
                                            self.overlayView.frame.size.width,
                                            self.ratioView.frame.origin.y));
        // 下边
        CGPathAddRect(path, nil, CGRectMake(0,
                                            self.ratioView.frame.origin.y + self.ratioView.frame.size.height,
                                            self.overlayView.frame.size.width,
                                            self.overlayView.frame.size.height - self.ratioView.frame.origin.y + self.ratioView.frame.size.height));
        maskLayer.path = path;
        self.overlayView.layer.mask = maskLayer;
        CGPathRelease(path);
     
}

- (void)confirm{
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPAImageCropperDelegate)]) {
                [self.delegate imageCropper:self didFinished:[self getSubImage]];
        }
}
-(UIImage *)getSubImage{
        CGRect squareFrame = self.cropFrame;
        CGFloat scaleRatio = self.latestFrame.size.width / self.originalImage.size.width;
        CGFloat x = (squareFrame.origin.x - self.latestFrame.origin.x) / scaleRatio;
        CGFloat y = (squareFrame.origin.y - self.latestFrame.origin.y) / scaleRatio;
        CGFloat w = squareFrame.size.width / scaleRatio;
        CGFloat h = squareFrame.size.height / scaleRatio;
        if (self.latestFrame.size.width < self.cropFrame.size.width) {
                CGFloat newW = self.originalImage.size.width;
                CGFloat newH = newW * (self.cropFrame.size.height / self.cropFrame.size.width);
                x = 0; y = y + (h - newH) / 2;
                w = newH; h = newH;
        }
        if (self.latestFrame.size.height < self.cropFrame.size.height) {
                CGFloat newH = self.originalImage.size.height;
                CGFloat newW = newH * (self.cropFrame.size.width / self.cropFrame.size.height);
                x = x + (w - newW) / 2; y = 0;
                w = newH; h = newH;
        }
        CGRect myImageRect = CGRectMake(x, y, w, h);
        CGImageRef imageRef = self.originalImage.CGImage;
        CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
        CGSize size;
        size.width = myImageRect.size.width;
        size.height = myImageRect.size.height;
        UIGraphicsBeginImageContext(size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextDrawImage(context, myImageRect, subImageRef);
        _smallImage = [UIImage imageWithCGImage:subImageRef];
        //获取目录
        NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        //创建目录
        NSString *path = [NSString stringWithFormat:@"%@Image", document];
        // 判断文件夹是否存在，如果不存在，则创建
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
       NSString *sandBoxFilePath = [path stringByAppendingPathComponent:@".png"];
        [ UIImagePNGRepresentation(_smallImage) writeToFile:sandBoxFilePath atomically:YES];
     
        UIGraphicsEndImageContext();
        CGImageRelease(subImageRef);

        return _smallImage;
}

- (void)dealloc {
        self.originalImage = nil;
        self.showImgView = nil;
        self.editedImage = nil;
        self.overlayView = nil;
        self.ratioView = nil;
        self.smallImage = nil;
}
//允许多种手势同时操作
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
        return YES;
}

@end
