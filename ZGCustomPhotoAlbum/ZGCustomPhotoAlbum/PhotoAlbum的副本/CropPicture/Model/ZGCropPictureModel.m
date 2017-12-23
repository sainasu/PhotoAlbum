//
//  ZGCropPictureModel.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/18.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGCropPictureModel.h"


@implementation ZGCropPictureModel
+(PHAsset *)lastAsset{
        // 所有智能相册
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        NSMutableArray *titels = [NSMutableArray array];
        
        for (NSInteger i = 0; i < smartAlbums.count; i++) {
                PHCollection *collection = smartAlbums[i];
                NSString *title = @"";
                if(i == 11){
                        title = collection.localizedTitle;
                }
                //遍历获取相册
                if ([collection isKindOfClass:[PHAssetCollection class]]) {
                        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
                        for (PHAsset *asset in fetchResult) {
                                //把所有的asset都存放到了字典中Recently Added
                                if ([collection.localizedTitle isEqualToString:title]) {
                                        [titels addObject:asset];
                                }
                                
                        }
                }
                
        }
        return [titels lastObject];
}
+ (CGRect)obtainFrame:(UIImage *)image frame:(CGRect)frame{
        CGSize size;
        size = CGSizeMake(frame.size.width , frame.size.height);
        CGFloat scaleX = image.size.width / size.width;
        CGFloat scaleY = image.size.height / size.height;
        CGFloat scale = MAX(scaleX, scaleY);
        CGRect bounds = CGRectMake(0, 0, floorf(image.size.width / scale), floorf(image.size.height / scale));
        return bounds;
}

@end
