//
//  ZGPhotoEditCropView.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/26.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZGCropView.h"
#import "ZGPhotoContentView.h"

@protocol ZGPhotoEditCropViewDelegate;

@interface ZGPhotoEditCropView : UIView
@property(nonatomic, assign) id<ZGPhotoEditCropViewDelegate>  cropDelegate;
@property(nonatomic, strong) UIImage *image;
@property (nonatomic, assign, readonly) CGFloat angle;
@property (nonatomic, assign, readonly) CGPoint photoContentOffset;
@property (nonatomic, strong, readonly) ZGCropView *cropView;
@property (nonatomic, strong, readonly) ZGPhotoContentView *photoContentView;
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;
@end

@protocol ZGPhotoEditCropViewDelegate <NSObject>
/**
 *point : scrollView.contentOffset
 *frame : cropView 相对于self的frame
 *transform ：imageView的transform
 *size ：是photoContentView的 size
 */
- (void)photoEditCropViewDidFinish:(ZGPhotoEditCropView *)cropView centerPoint:(CGPoint)point cropFrame:(CGRect)frame transform:(CGAffineTransform)transform  cropImageFrame:(CGRect)cropImageFrame;
- (void)photoEditCropViewDidCancel:(ZGPhotoEditCropView *)cropView cropImageFrame:(CGRect)cropImageFrame;
@end

