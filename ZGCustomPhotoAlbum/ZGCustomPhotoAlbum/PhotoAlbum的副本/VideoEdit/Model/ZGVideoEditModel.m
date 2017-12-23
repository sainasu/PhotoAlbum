//
//  ZGVideoEditModel.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/19.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGVideoEditModel.h"
#import <AVFoundation/AVFoundation.h>




@implementation ZGVideoEditModel
#pragma mark - 获取最近添加相册中的最后一个Asset
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
+ (void)cropVideoUrl:(NSURL *)videoUrl captureVideoWithRange:(NSRange)videoRange completion:(MixcompletionBlock)completionHandle{

        NSURL *videoFileUrl = [NSURL fileURLWithPath:videoUrl.path];
        AVAsset *anAsset = [[AVURLAsset alloc] initWithURL:videoFileUrl options:nil];
        NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:anAsset];
        
        // Path to output file
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSURL *exportUrl = [NSURL URLWithString:[docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@Bainu.mp4", [self arc4randomString]]]];
        
        if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
                AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:anAsset presetName:AVAssetExportPresetPassthrough];
                NSURL *furl = [NSURL fileURLWithPath:exportUrl.path];
                exportSession.outputURL = furl;
                exportSession.outputFileType = AVFileTypeQuickTimeMovie;
                
                CMTime start = CMTimeMakeWithSeconds(videoRange.location, anAsset.duration.timescale);
                CMTime duration = CMTimeMakeWithSeconds(videoRange.length, anAsset.duration.timescale);
                CMTimeRange range = CMTimeRangeMake(start, duration);
                exportSession.timeRange = range;
                [exportSession exportAsynchronouslyWithCompletionHandler:^{
                                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                                        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:exportSession.outputURL];
                                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                                        if (error) {
                                                //NSLog(@"视频保存失败 = %@", error);
                                        }else{
                                                completionHandle();
                                        }
                                }];
                }];
        }
}
+ (NSString *)arc4randomString{
        NSString *string = [[NSString alloc]init];
        for (int i = 0; i < 32; i++) {
                int number = arc4random() % 36;
                if (number < 10) {
                        int figure = arc4random() % 10;
                        NSString *tempString = [NSString stringWithFormat:@"%d", figure];
                        string = [string stringByAppendingString:tempString];
                }else {
                        int figure = (arc4random() % 26) + 97;
                        char character = figure;
                        NSString *tempString = [NSString stringWithFormat:@"%c", character];
                        string = [string stringByAppendingString:tempString];
                }
        }
        return string;
}




@end
