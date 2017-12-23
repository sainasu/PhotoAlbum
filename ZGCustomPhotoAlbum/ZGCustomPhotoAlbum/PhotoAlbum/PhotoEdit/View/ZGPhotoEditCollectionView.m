//
//  ZGPhotoEditCollectionView.m
//  ZGPhotoEdit
//
//  Created by saina_barsud on 2017/12/8.
//  Copyright © 2017年 saina. All rights reserved.
/**
 用于绘画, mosaic, 添加图片||文字, 滤镜
 */

#import "ZGPhotoEditCollectionView.h"
#import "ZGPhotoEditModel.h"

@interface ZGPhotoEditCollectionView()<UIScrollViewDelegate, UIGestureRecognizerDelegate, ZGPhotoEditImageViewDelegate>
@property(nonatomic, assign) CGRect  imageFrame;
@property(nonatomic, assign) CGRect  newFrame;
@property(nonatomic, assign) CGFloat  minScale;



@property(nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ZGPhotoEditCollectionView
- (instancetype)initWithFrame:(CGRect)frame editImage:(UIImage *)editImage
{
        self = [super initWithFrame:frame];
        if (self) {
                self.backgroundColor = [UIColor blackColor];
                self.imageFrame = [ZGPhotoEditModel obtainFrame:editImage frame:[UIScreen mainScreen].bounds];
                self.newFrame = self.imageFrame;
                self.minScale = 1.0;
               
                // 初始化scrollView
                self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
                self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                self.scrollView.maximumZoomScale = 5.0f;  // 最大缩放倍数
                self.scrollView.minimumZoomScale = self.minScale;  // 最小缩放倍数
                self.scrollView.delegate = self;
                [self.scrollView setZoomScale:1.0f animated:YES];
                self.scrollView.showsVerticalScrollIndicator = NO; // 隐藏滚动条
                self.scrollView.showsHorizontalScrollIndicator = NO; //隐藏滚动条
                self.scrollView.scrollEnabled = NO; // 禁止滑动
                [self addSubview:self.scrollView];
                // 初始化imageView
                self.imageView = [[ZGPhotoEditImageView alloc] initWithFrame:CGRectZero editImage:editImage];
                self.imageView.delegate = self;
                [self.scrollView addSubview:self.imageView];
        }
        return self;
}
#pragma mark - ZGPhotoEditImageViewDelegate
- (void)imageViewTouchesEnded:(ZGPhotoEditDrawView *)darwView{
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditCollectionViewDelegate)]) {
                [self.delegate collectionViewTouchesEnded:self];
        }
        
}
- (void)imageViewTouchesBegen:(ZGPhotoEditDrawView *)darwView{
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditCollectionViewDelegate)]) {
                [self.delegate collectionViewTouchesBegen:self];
        }
        
}
- (void)imageViewDoubleClick:(ZGPhotoEditImageView *)view content:(NSString *)content textColor:(UIColor *)color{
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditCollectionViewDelegate)]) {
                [self.delegate collectionViewDoubleClick:self content:content textColor:color];
        }

}


#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
        return self.imageView;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
        self.imageView.pinch  = self.scrollView.pinchGestureRecognizer;
         //把当前的缩放比例设进ZoomScale，以便下次缩放时实在现有的比例的基础上
        [_scrollView setZoomScale:scale animated:NO];
        // 设置当前的可以滚动范围（缩放过的imageView的大小上加上更改的大小）
        self.scrollView.contentSize = CGSizeMake(self.newFrame.size.width * scale + self.newFrame.origin.x, self.newFrame.size.height * scale + self.newFrame.origin.y);
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
        CGFloat offsetX = (self.bounds.size.width > self.newFrame.size.width * self.scrollView.zoomScale) ? (self.bounds.size.width - self.newFrame.size.width) * 0.5 : 0.0;
        CGFloat offsetY = (self.bounds.size.height > self.newFrame.size.height * self.scrollView.zoomScale) ? (self.bounds.size.height - self.newFrame.size.height) * 0.5 : 0.0;
        _imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}


#pragma mark - fontion
- (void)undoOneStep{ // 撤销
        [self.imageView undo];
}
- (void)clearAllOperations{ // 清除
        [self.imageView clear];
}
- (void)addContent:(NSString *)content isOldLabel:(BOOL)isOldLabel textColor:(UIColor *)textColor{
        [self.imageView addContent:content isOldLabel:isOldLabel textColor:textColor];
}
-(void)drawView:(NSString *)isDrawView color:(UIColor *)color mosaicType:(NSString *)type{
        [self.imageView isDrawView:isDrawView color:color mosaicType:type];
}
-(void)setFilterType:(NSString *)filterType{
        _filterType = filterType;
        [self.imageView filterType: filterType];
}

#pragma mark - Setter
-(void)setAddImage:(UIImage *)addImage{
        [self.imageView addContent:addImage isOldLabel:NO textColor:nil];

}

-(void)setCropEndedFrame:(CGRect)cropEndedFrame{
        _cropEndedFrame = cropEndedFrame;
        //1.  调整遮盖View的位置
        self.imageView.replaceSubViewFrame = cropEndedFrame;
        //2. 调整能滑动或缩放的范围ContextSize
        CGFloat sclas = self.frame.size.width / cropEndedFrame.size.width;
        self.newFrame = CGRectMake((self.bounds.size.width > cropEndedFrame.size.width * sclas) ? ((self.bounds.size.width - cropEndedFrame.size.width * sclas) * 0.5 ): 0.0, (self.bounds.size.height > cropEndedFrame.size.height * sclas) ? ((self.bounds.size.height - cropEndedFrame.size.height * sclas) * 0.5 ): 0.0, cropEndedFrame.size.width * sclas, cropEndedFrame.size.height * sclas);
        self.scrollView.minimumZoomScale = sclas;
        self.imageView.transform = CGAffineTransformMakeScale(sclas, sclas); // 等比缩放推按至屏幕宽
        // 设置中心点
        CGFloat w = self.bounds.size.width - cropEndedFrame.origin.x - cropEndedFrame.size.width;
        CGFloat centerX = (cropEndedFrame.origin.x > 0) ? (self.bounds.size.width - (cropEndedFrame.origin.x - w) * sclas) * 0.5 : (self.bounds.size.width - cropEndedFrame.origin.x * sclas) * sclas * 0.5;
        CGFloat centerY = (self.bounds.size.height > self.newFrame.size.height) ? (self.bounds.size.height - self.newFrame.size.height * 0.9 - cropEndedFrame.origin.y): cropEndedFrame.origin.y * sclas;
        self.imageView.center = CGPointMake(centerX, centerY);
        // 设置滚动范围
        self.scrollView.contentSize = self.newFrame.size;
}
#pragma mrke - layoutSubviews
-(void)layoutSubviews{
        self.imageView.frame = CGRectMake((self.frame.size.width - self.imageFrame.size.width) / 2, (self.frame.size.height - self.imageFrame.size.height) / 2, self.imageFrame.size.width, self.imageFrame.size.height);
        self.scrollView.frame = self.bounds;
}



@end
