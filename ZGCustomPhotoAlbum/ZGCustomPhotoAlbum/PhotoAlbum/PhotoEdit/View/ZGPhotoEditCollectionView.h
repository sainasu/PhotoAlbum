//
//  ZGPhotoEditCollectionView.h
//  ZGPhotoEdit
//
//  Created by saina_barsud on 2017/12/8.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZGPhotoEditImageView.h"

@protocol ZGPhotoEditCollectionViewDelegate;
@interface ZGPhotoEditCollectionView : UIView

- (instancetype)initWithFrame:(CGRect)frame editImage:(UIImage *)editImage;
@property(nonatomic, assign) id<ZGPhotoEditCollectionViewDelegate>  delegate;
@property(nonatomic, strong) ZGPhotoEditImageView *imageView;
/// 添加的图片
@property(nonatomic, strong) UIImage *addImage;
/// 截图完成之后的frame
@property(nonatomic, assign) CGRect  cropEndedFrame;
@property(nonatomic, strong) NSString *filterType; // <#注释#>

/// 撤销一步,涂鸦或mosaic
- (void)undoOneStep;
/// 全部撤销
- (void)clearAllOperations;
/// 添加的文字
- (void)addContent:(NSString *)content isOldLabel:(BOOL)isOldLabel textColor:(UIColor *)textColor;
/// 设置涂鸦的颜色或mosaic的样式
-(void)drawView:(NSString *)isDrawView color:(UIColor *)color mosaicType:(NSString *)type;

@end
@protocol ZGPhotoEditCollectionViewDelegate <NSObject>
/// 触摸结束
- (void)collectionViewTouchesEnded:(ZGPhotoEditCollectionView *)view;
/// 触摸开始
- (void)collectionViewTouchesBegen:(ZGPhotoEditCollectionView *)view;
- (void)collectionViewDoubleClick:(ZGPhotoEditCollectionView *)view content:(NSString *)content textColor:(UIColor *)color;

@end
