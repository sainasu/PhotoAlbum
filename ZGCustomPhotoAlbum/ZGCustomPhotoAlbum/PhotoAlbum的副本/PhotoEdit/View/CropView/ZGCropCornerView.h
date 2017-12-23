//
//  ZGCropCornerView.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/11/2.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CropCornerType) {
        CropCornerTypeUpperLeft,
        CropCornerTypeUpperRight,
        CropCornerTypeLowerRight,
        CropCornerTypeLowerLeft
};

@interface ZGCropCornerView : UIView
- (instancetype)initWithCornerType:(CropCornerType)type;

@end
