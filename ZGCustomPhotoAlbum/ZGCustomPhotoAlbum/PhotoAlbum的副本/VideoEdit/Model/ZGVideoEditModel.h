//
//  ZGVideoEditModel.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/19.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
typedef void (^MixcompletionBlock)(void);

@interface ZGVideoEditModel : NSObject
+ (void)cropVideoUrl:(NSURL *)videoUrl captureVideoWithRange:(NSRange)videoRange completion:(MixcompletionBlock)completionHandle;
+(PHAsset *)lastAsset;

@end
