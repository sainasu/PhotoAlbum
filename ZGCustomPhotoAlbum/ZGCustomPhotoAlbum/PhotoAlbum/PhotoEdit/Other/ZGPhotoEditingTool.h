//
//  ZGPhotoEditingTool.h
//  ZGPhotoEdit
//
//  Created by saina_barsud on 2017/12/8.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZGPhotoEditingToolDelegate;

@interface ZGPhotoEditingTool : UIView
@property(nonatomic, assign) id<ZGPhotoEditingToolDelegate>  delegate;
@property(nonatomic, strong) NSString *barType; /// 工具栏样式
- (instancetype)initWithFrame:(CGRect)frame filterImage:(UIImage *)filterImage;

@end
@protocol ZGPhotoEditingToolDelegate <NSObject>
/// 涂鸦按钮代理
- (void)photoEditingToolDrawAction:(ZGPhotoEditingTool *)tool;
 /// 添加图按钮代理
- (void)photoEditingToolAddImageAction:(ZGPhotoEditingTool *)tool;
 /// 添加文字代理
- (void)photoEditingToolAddTextAction:(ZGPhotoEditingTool *)tool;
/// 滤镜代理
- (void)photoEditingToolFilderAction:(ZGPhotoEditingTool *)tool;
/// mosaic代理
- (void)photoEditingToolMosaicAction:(ZGPhotoEditingTool *)tool;
 /// 截图代理
- (void)photoEditingToolCropAction:(ZGPhotoEditingTool *)tool;

- (void)photoEditTool:(ZGPhotoEditingTool *)tool brushColor:(UIColor *)color;
- (void)photoEditTool:(ZGPhotoEditingTool *)tool textColor:(UIColor *)color;
- (void)photoEditTool:(ZGPhotoEditingTool *)tool mosaicType:(NSString *)type;
- (void)photoEditTool:(ZGPhotoEditingTool *)tool filterType:(NSString *)type;

@end
