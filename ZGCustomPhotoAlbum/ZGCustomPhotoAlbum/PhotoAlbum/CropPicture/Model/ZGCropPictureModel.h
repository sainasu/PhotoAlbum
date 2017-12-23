//
//  ZGCropPictureModel.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/18.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@interface ZGCropPictureModel : NSObject
+(PHAsset *)lastAsset;
+ (CGRect)obtainFrame:(UIImage *)image frame:(CGRect)frame;

@end
