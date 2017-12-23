//
//  ZGAssetPickerModel.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/16.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "ZGCustomAssetPickerController.h"


@interface ZGAssetPickerModel : NSObject
/// 按照selectedType获取所有相册
+(NSMutableArray *)obtainPhotoAlbums:(CGSize)size selectType:(ZGCustomAssetPickerSelectType)selectType;
/// 按照selectType与相册名称获取所有Asset
+(NSMutableArray *)obtainCollectionAllAssets:(NSString *)title selectType:(ZGCustomAssetPickerSelectType)selectType;
+ (BOOL)isCanUsePhotos;
@end
