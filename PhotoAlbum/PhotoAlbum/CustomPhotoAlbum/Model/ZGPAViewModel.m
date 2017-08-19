//
//  ZGPAViewModel.m
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/7.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPAViewModel.h"
#import "ZGPAHeader.h"
 #import <sys/utsname.h>
@implementation ZGPAViewModel

struct utsname systemInfo;



+(NSURL *)createAccessToVideo:(PHAsset *)asset{
        
        __block NSURL *myURL;
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                AVURLAsset *urlAsset = (AVURLAsset *)asset;
                myURL = urlAsset.URL;
        }];
        return myURL;
}

//获取图片
+(UIImage *)createAccessToImage:(PHAsset *)asset imageSize:(CGSize)size contentMode:(PHImageContentMode)contentMode{
        __block UIImage *image = [[UIImage alloc] init];
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        // 同步获得图片, 只会返回1张图片
        options.synchronous = YES;
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:contentMode options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                image = result;
        }];
        
        return image;
}

#pragma mark - 获取到PHAsset
+(NSMutableArray *)createAccessToCollections{
        //需要相册名称   ----   个数   ---  第一个照片
        NSMutableArray *myDataArray = [NSMutableArray array];
        // 所有智能相册
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        
        for (NSInteger i = 0; i < smartAlbums.count; i++) {
                NSMutableArray *nameArr = [NSMutableArray array];
                PHCollection *collection = smartAlbums[i];
                //存放名字
                [nameArr addObject:collection.localizedTitle];
                
                //遍历获取相册
                if ([collection isKindOfClass:[PHAssetCollection class]]) {
                        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
                        NSMutableArray *assetArr = [NSMutableArray array];
                        for (PHAsset *asset in fetchResult) {
                                //把所有的asset都存放到了字典中
                                [assetArr addObject:asset];
                                
                        }
                        [nameArr addObject:assetArr];
                }
                [myDataArray addObject:nameArr];
        }
        
       // 2.手机类型：iPhone 6
        uname(&systemInfo);
        NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
        if ([platform isEqualToString:@"iPhone5,1"] || [platform isEqualToString:@"iPhone5,2"]) {
                //NSLog(@"iPhone 5");
        }
        if ([platform isEqualToString:@"iPhone5,3"] || [platform isEqualToString:@"iPhone5,4"]) {
                //NSLog(@"iPhone 5c");

        }
        if ([platform isEqualToString:@"iPhone6,1"] || [platform isEqualToString:@"iPhone6,2"]){
                //NSLog(@"iPhone 5s");

        }
        if ([platform isEqualToString:@"iPhone7,1"]) {
               // NSLog(@"iPhone 6 Plus");
        }
        if ([platform isEqualToString:@"iPhone7,2"]){
                //NSLog(@"iPhone 6");

        }
        if ([platform isEqualToString:@"iPhone8,1"]){
               // NSLog(@"iPhone 6s");

        }
        
        if ([platform isEqualToString:@"iPhone8,2"]) {
                //NSLog(@"iPhone 6s Plus");

                [myDataArray removeObjectAtIndex:5];
                
                [myDataArray exchangeObjectAtIndex:0 withObjectAtIndex:6];
                [myDataArray exchangeObjectAtIndex:2 withObjectAtIndex:8];
                [myDataArray exchangeObjectAtIndex:3 withObjectAtIndex:8];
                [myDataArray exchangeObjectAtIndex:4 withObjectAtIndex:6];
                [myDataArray removeObjectAtIndex:9];
                [myDataArray exchangeObjectAtIndex:5 withObjectAtIndex:9];


        }
        
        if ([platform isEqualToString:@"iPhone8,4"]){
                //NSLog(@"iPhone SE");

                
        }
        
        if ([platform isEqualToString:@"iPhone9,1"]){
                //NSLog(@"iPhone 7");

                
        }
        
        if ([platform isEqualToString:@"iPhone9,2"]) {
                //NSLog(@"iPhone 7 Plus");

                
        }
        return myDataArray;
}


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
+(NSMutableArray *)accordingToTheCollectionTitleOfLodingPHAsset:(NSString *)title{
        NSMutableArray *arr = [NSMutableArray array];
        
        // 所有智能相册
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        
        for (NSInteger i = 0; i < smartAlbums.count; i++) {
                PHCollection *collection = smartAlbums[i];
                //遍历获取相册
                if ([collection isKindOfClass:[PHAssetCollection class]]) {
                        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
                        for (PHAsset *asset in fetchResult) {
                                //把所有的asset都存放到了字典中Recently Added
                                if ([collection.localizedTitle isEqualToString:title]) {
                                        [arr addObject:asset];
                                }
                                
                        }
                }
                
        }
        return arr;
}

//自定义按钮
+(UIButton *)createBtnFrame:(CGRect)frame image:(UIImage *)image SelectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action{
        UIButton *createButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [createButton setImage:image forState:UIControlStateNormal];
        [createButton setImage:selectedImage forState:UIControlStateHighlighted];
        [createButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        createButton.frame = frame;
        return createButton;
}

+ (CGRect)adjustTheUIInTheImage:(UIImage *)image{
        
        CGSize size = image.size;
        
        /**
         
         *  按照image的大小调整View的大小
         */
        
        //比原图高， 且 原图比屏幕矮
        if (size.width > kPAMainScreenWidth) {
                size.height *= (kPAMainScreenWidth / size.width);
                size.width = kPAMainScreenWidth;
        }else{
                size.height *= (kPAMainScreenWidth / size.width);
                size.width = kPAMainScreenWidth;
                
        }
        if (size.height > kPAMainScreenHeight) {
                size.width *= (kPAMainScreenWidth / + size.width);
                size.height = kPAMainScreenHeight;
        }else{
                size.width *= (kPAMainScreenWidth / + size.width);
                size.height = size.height;
        }
        
        
        if (size.width < minSizes.width) {
                size.height *= (minSizes.width / size.width);
                size.width = minSizes.width;
        }
        
        if (size.height < minSizes.height) {
                size.width *= (minSizes.height / size.height);
                size.height = minSizes.height;
        }
        
        CGRect frame;
        frame.size = size;
        return frame;
}
#pragma mark - 提示
+(void)aliertControllerTitle:(NSString *)title viewController:(UIViewController *)VC {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
       
        // 添加按钮
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }]];
        
        [VC presentViewController:alert animated:YES completion:nil];
}

@end
