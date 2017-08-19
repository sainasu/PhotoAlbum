//
//  SNPEScreenshotView.h
//  SN_ImageEditor
//
//  Created by saina_su on 2017/7/10.
//  Copyright © 2017年 saina. All rights reserved.
//
//

#import <UIKit/UIKit.h>
/**
 *  截图View：实现截图功能, 自动调整大小 居中
 取消按钮: 取消截屏操作, 删除本身
 重置按钮: 重置选择框(现该为重新添加原有图片)
 保存按钮: 返回选择框区域的图片, 
 */

extern const CGFloat kMaxRotationAngle;//最大旋转角度

@class CropView;

@interface PhotoContentView : UIView
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@end

@protocol CropViewDelegate <NSObject>
- (void)cropEnded:(CropView *)cropView;
- (void)cropMoved:(CropView *)cropView;

@end

@interface CropView : UIView
@end
//代理
@protocol TweaButtonDelegate <NSObject>
-(void)buttonIsclick:(id)sender;
-(void)buttonIsDone:(id)sendet;
@end

@interface SNPEScreenshotView : UIView
// masks
@property (nonatomic, strong) UIView *topMask;
@property (nonatomic, strong) UIView *leftMask;
@property (nonatomic, strong) UIView *bottomMask;
@property (nonatomic, strong) UIView *rightMask;
@property (nonatomic, assign, readonly) CGFloat angle;
@property (nonatomic, assign, readonly) CGPoint photoContentOffset;
@property (nonatomic, strong, readonly) CropView *cropView;
@property (nonatomic, strong, readonly) PhotoContentView *photoContentView;
@property (nonatomic, strong, readonly) UISlider *slider;
@property (nonatomic, strong, readonly) UIButton *resetBtn;
@property (nonatomic, strong, readonly) UIButton *cancelBtn;
@property (nonatomic, strong, readonly) UIButton *doneBtn;
@property (nonatomic, strong) UIImage *image;
/**
 *<#注释#>
 */
@property(nonatomic, weak) id<TweaButtonDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame
                        image:(UIImage *)image
             maxRotationAngle:(CGFloat)maxRotationAngle;
- (instancetype)initWithFrame:(CGRect)frame
                        image:(UIImage *)image;
- (CGPoint)photoTranslation;
@end


@interface PhotoScrollView : UIScrollView
@property (nonatomic, strong) PhotoContentView *photoContentView;
@end

