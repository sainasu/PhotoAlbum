//
//  ZGAssetPickerModel.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/16.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGAssetPickerModel.h"

@implementation ZGAssetPickerModel
#pragma mark - 获取所有相册
+(NSMutableArray *)obtainPhotoAlbums:(CGSize)size  selectType:(ZGCustomAssetPickerSelectType)type{
        
        NSMutableArray *myDataArray = [NSMutableArray array];
        // 所有智能相册
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        for (NSInteger i = 0; i < smartAlbums.count; i++) {
                NSMutableArray *dataArray = [NSMutableArray array];
                        
                PHAssetCollection *assetCollection = smartAlbums[i];
                PHFetchOptions *options = [[PHFetchOptions alloc] init];
                options.fetchLimit = 0;
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
                [dataArray addObject:[NSString stringWithFormat:@"%@", assetCollection.localizedTitle]];
                __block UIImage *image = [[UIImage alloc] init];
                PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
                // 同步获得图片, 只会返回1张图片
                requestOptions.synchronous = YES;
                requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
                PHAsset *asset = [[PHAsset alloc] init];
                if (type == ZGCustomAssetPickerSelectTypeImage) {
                        [dataArray addObject:[NSString stringWithFormat:@"%zi", [fetchResult countOfAssetsWithMediaType:PHAssetMediaTypeImage]]];
                        NSMutableArray *imageAssets = [[NSMutableArray alloc] init];
                        for (PHAsset *imageAsset in fetchResult) {
                                if (imageAsset.mediaType == PHAssetMediaTypeImage) {
                                        [imageAssets addObject:imageAsset];
                                }
                        }
                        asset = imageAssets.lastObject;

                }else if (type ==ZGCustomAssetPickerSelectTypeVideo) {
                        [dataArray addObject:[NSString stringWithFormat:@"%zi", [fetchResult countOfAssetsWithMediaType:PHAssetMediaTypeVideo]]];
                        NSMutableArray *videoAssets = [[NSMutableArray alloc] init];
                        for (PHAsset *imageAsset in fetchResult) {
                                if (imageAsset.mediaType == PHAssetMediaTypeVideo) {
                                        [videoAssets addObject:imageAsset];
                                }
                        }
                        asset = videoAssets.lastObject;
                }else if (type ==  ZGCustomAssetPickerSelectTypeImageAndVideo) {
                        [dataArray addObject:[NSString stringWithFormat:@"%zi",fetchResult.count]];
                        asset = fetchResult.lastObject;
                }
                
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                        if (result == nil) {
                                image = [UIImage imageNamed:@"PhotoAlbum_placeholder"];
                        }else{
                                image = result;
                        }
                }];
                
                [dataArray addObject:image];
                [myDataArray addObject:dataArray];
        }
        // 列出所有用户创建的相册
        PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        for (NSInteger i = 0; i < topLevelUserCollections.count; i++) {
                NSMutableArray *dataArray = [NSMutableArray array];
                PHAssetCollection *topLevelUserassetCollection = topLevelUserCollections[i];;
                PHFetchOptions *topLevelUseroptions = [[PHFetchOptions alloc] init];
                topLevelUseroptions.fetchLimit = 0;
                PHFetchResult *topLevelUserfetchResult = [PHAsset fetchAssetsInAssetCollection:topLevelUserassetCollection options:topLevelUseroptions];
                [dataArray addObject:[NSString stringWithFormat:@"%@", topLevelUserassetCollection.localizedTitle]];
                __block UIImage *image = [[UIImage alloc] init];
                PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
                // 同步获得图片, 只会返回1张图片
                requestOptions.synchronous = YES;
                requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
                PHAsset *asset = [[PHAsset alloc] init];
                if (type == ZGCustomAssetPickerSelectTypeImage) {
                        [dataArray addObject:[NSString stringWithFormat:@"%zi", [topLevelUserfetchResult countOfAssetsWithMediaType:PHAssetMediaTypeImage]]];
                        NSMutableArray *imageAssets = [[NSMutableArray alloc] init];
                        for (PHAsset *imageAsset in topLevelUserfetchResult) {
                                if (imageAsset.mediaType == PHAssetMediaTypeImage) {
                                        [imageAssets addObject:imageAsset];
                                }
                        }
                        asset = imageAssets.lastObject;
                        
                }else if (type ==ZGCustomAssetPickerSelectTypeVideo) {
                        [dataArray addObject:[NSString stringWithFormat:@"%zi", [topLevelUserfetchResult countOfAssetsWithMediaType:PHAssetMediaTypeVideo]]];
                        NSMutableArray *videoAssets = [[NSMutableArray alloc] init];
                        for (PHAsset *imageAsset in topLevelUserfetchResult) {
                                if (imageAsset.mediaType == PHAssetMediaTypeVideo) {
                                        [videoAssets addObject:imageAsset];
                                }
                        }
                        asset = videoAssets.lastObject;
                }else if (type ==  ZGCustomAssetPickerSelectTypeImageAndVideo) {
                        [dataArray addObject:[NSString stringWithFormat:@"%zi",topLevelUserfetchResult.count]];
                        asset = topLevelUserfetchResult.lastObject;
                }
                
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                        if (result == nil) {
                                image = [UIImage imageNamed:@"PhotoAlbum_placeholder"];
                        }else{
                                image = result;
                        }
                }];
                [dataArray addObject:image];
                [myDataArray addObject:dataArray];
        }
        if (TARGET_IPHONE_SIMULATOR) { // 如果不是模拟器
                [myDataArray exchangeObjectAtIndex:0 withObjectAtIndex:3];
                [myDataArray removeObjectAtIndex:5];
                [myDataArray removeObjectAtIndex:1];


        }else{
                if (myDataArray.count > 0) {
                        [myDataArray exchangeObjectAtIndex:0 withObjectAtIndex:2];
                        [myDataArray exchangeObjectAtIndex:0 withObjectAtIndex:7];
                        [myDataArray exchangeObjectAtIndex:3 withObjectAtIndex:9];
                        [myDataArray exchangeObjectAtIndex:1 withObjectAtIndex:16];
                        [myDataArray exchangeObjectAtIndex:4 withObjectAtIndex:11];
                        [myDataArray removeObjectAtIndex:5];
                        [myDataArray removeObjectAtIndex:9];


                }
        }
       
        
        return myDataArray;
}
#pragma mark - 按照相册名获取相册中所有Asset
+(NSMutableArray *)obtainCollectionAllAssets:(NSString *)title selectType:(ZGCustomAssetPickerSelectType)selectType{
        NSMutableArray *arr = [NSMutableArray array];
        // 所有智能相册
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        
        for (NSInteger i = 0; i < smartAlbums.count; i++) {
                PHCollection *collection = smartAlbums[i];
                //把所有的asset都存放到了字典中Recently Added
                if ([collection.localizedTitle isEqualToString:title]) {
                        //遍历获取相册
                        if ([collection isKindOfClass:[PHAssetCollection class]]) {
                                PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                                PHFetchOptions *options = [[PHFetchOptions alloc] init];
                                options.fetchLimit = 0;
                                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
                                for (PHAsset *asset in fetchResult) {
                                        if (selectType == ZGCustomAssetPickerSelectTypeImage) {
                                                if (asset.mediaType == PHAssetMediaTypeImage) {
                                                        [arr addObject:asset];
                                                }
                                        }else if (selectType ==ZGCustomAssetPickerSelectTypeVideo) {
                                                if (asset.mediaType == PHAssetMediaTypeVideo) {
                                                        [arr addObject:asset];
                                                }
                                        }else if (selectType ==  ZGCustomAssetPickerSelectTypeImageAndVideo) {
                                                [arr addObject:asset];
                                                
                                        }
                                }
                        }
                }
        }
        // 列出所有用户创建的相册
        PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        for (NSInteger i = 0; i < topLevelUserCollections.count; i++) {
                PHCollection *userCollection = topLevelUserCollections[i];
                if ([userCollection.localizedTitle isEqualToString:title]) {
                        //遍历获取相册
                        if ([userCollection isKindOfClass:[PHAssetCollection class]]) {
                                PHAssetCollection *assetCollection = (PHAssetCollection *)userCollection;
                                PHFetchOptions *options = [[PHFetchOptions alloc] init];
                                options.fetchLimit = 0;
                                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
                                for (PHAsset *asset in fetchResult) {
                                        //把所有的asset都存放到了字典中Recently Added
                                        if (selectType == ZGCustomAssetPickerSelectTypeImage) {
                                                if (asset.mediaType == PHAssetMediaTypeImage) {
                                                        [arr addObject:asset];
                                                }
                                        }else if (selectType ==ZGCustomAssetPickerSelectTypeVideo) {
                                                if (asset.mediaType == PHAssetMediaTypeVideo) {
                                                        [arr addObject:asset];
                                                }
                                        }else if (selectType ==  ZGCustomAssetPickerSelectTypeImageAndVideo) {
                                                [arr addObject:asset];

                                        }
                                }
                        }
                }
        }
        
        return arr;
}
+ (BOOL)isCanUsePhotos {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusNotDetermined) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                }
        }else{
                return YES;
        }
        return NO;
}




@end
