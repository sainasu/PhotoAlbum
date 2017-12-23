//
//  ZGCropCornerView.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/11/2.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGCropCornerView.h"

static const CGFloat kCropViewCornerLength = 22.0;

@implementation ZGCropCornerView

- (instancetype)initWithCornerType:(CropCornerType)type
{
        if (self = [super init]) {
                self.frame = CGRectMake(0, 0, kCropViewCornerLength, kCropViewCornerLength);
                self.backgroundColor = [UIColor clearColor];
                
                CGFloat lineWidth = 3;
                UIView *horizontal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCropViewCornerLength, lineWidth)];
                horizontal.backgroundColor = [UIColor whiteColor];
                [self addSubview:horizontal];
                
                UIView *vertical = [[UIView alloc] initWithFrame:CGRectMake(0, 0, lineWidth, kCropViewCornerLength)];
                vertical.backgroundColor = [UIColor whiteColor];
                [self addSubview:vertical];
                
                if (type == CropCornerTypeUpperLeft) {
                        horizontal.center = CGPointMake(kCropViewCornerLength / 2, lineWidth / 2);
                        vertical.center = CGPointMake(lineWidth / 2, kCropViewCornerLength / 2);
                } else if (type == CropCornerTypeUpperRight) {
                        horizontal.center = CGPointMake(kCropViewCornerLength / 2, lineWidth / 2);
                        vertical.center = CGPointMake(kCropViewCornerLength - lineWidth / 2, kCropViewCornerLength / 2);
                } else if (type == CropCornerTypeLowerRight) {
                        horizontal.center = CGPointMake(kCropViewCornerLength / 2, kCropViewCornerLength - lineWidth / 2);
                        vertical.center = CGPointMake(kCropViewCornerLength - lineWidth / 2, kCropViewCornerLength / 2);
                } else if (type == CropCornerTypeLowerLeft) {
                        horizontal.center = CGPointMake(kCropViewCornerLength / 2, kCropViewCornerLength - lineWidth / 2);
                        vertical.center = CGPointMake(lineWidth / 2, kCropViewCornerLength / 2);
                }
        }
        return self;
}

@end
