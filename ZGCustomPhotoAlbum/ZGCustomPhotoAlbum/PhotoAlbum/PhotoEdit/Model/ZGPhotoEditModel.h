//
//  ZGPhotoEditModel.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/23.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
typedef struct CGPath *CGMutablePathRef;
typedef enum CGBlendMode CGBlendMode;


@interface ZGPhotoEditModel : NSObject

@property (nonatomic) CGMutablePathRef path;
@property (nonatomic, assign) CGBlendMode blendMode;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, strong) UIColor *lineColor;
- (void)strokeWithContext:(CGContextRef)context;



+ (UIImage *)obtainImage:(PHAsset *)asset imageSize:(CGSize)size;
+ (UIImage *)fliterEvent:(NSString *)filterName image:(UIImage *)image;

+ (CGRect)obtainFrame:(UIImage *)image frame:(CGRect)frame;

+ (UIImage *)transToMosaicImage:(UIImage*)orginImage blockLevel:(NSUInteger)level;
+ (UIImage *)textureWithTintColor:(UIColor *)color image:(UIImage *)imag;
+ (UIColor*)colorAtPixel:(CGPoint)point view:(UIImage *)view;
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font;
+ (BOOL) isEmpty:(NSString *) str;

@end
