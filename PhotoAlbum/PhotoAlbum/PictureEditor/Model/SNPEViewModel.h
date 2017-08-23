//
//  SNPEViewModel.h
//  SN_ImageEditor
//
//  Created by saina_su on 2017/7/10.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  封装方法
 */
static CGSize minSize = {30, 30};

@interface SNPEViewModel : NSObject
/**
 *  以image调整界面
 *
 *  @param image 参数image
 *
 *  @return 返回尺寸
 */
+ (CGRect)adjustTheUIInTheImage:(UIImage *)image oldImage:(UIImage *)oldImage;
+ (CGRect)adjust:(UIImage *)image oldImage:(UIImage *)oldImage;


+ (CGImageRef)newScaledImage:(CGImageRef)source withOrientation:(UIImageOrientation)orientation toSize:(CGSize)size withQuality:(CGInterpolationQuality)quality;
//创建filter按钮
+(UIScrollView *)initWithfilterScrollViewBackgroundColor:(UIColor *)color frame:(CGRect)ScrollViewFrame frameWidth:(CGFloat)width  addTarget:(id)target action:(SEL)action nameArr:(NSArray *)name;

/***  初始化色板*/
+(UIScrollView *)initWithColorScrollViewBackgroundColor:(UIColor *)color frame:(CGRect)ScrollViewFrame frameWidth:(CGFloat)width  addTarget:(id)target action:(SEL)action;

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;
//渲染图片
+ (UIImage *)textureWithTintColor:(UIColor *)color image:(UIImage *)imag;
//取色
+(UIColor*)colorAtPixel:(CGPoint)point view:(UIImage *)view;

//初始化按钮:Button
+(UIButton *)createBtnFrame:(CGRect)frame image:(UIImage *)image SelectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action;

/*
 *转换成马赛克,level代表一个点转为多少level*level的正方形
 */
+ (UIImage *)transToMosaicImage:(UIImage*)orginImage blockLevel:(NSUInteger)level;
//压缩图片
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage;
/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;


@end
