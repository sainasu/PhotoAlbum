//
//  ZGVideoEditController.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/19.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@protocol ZGVideoEditControllerDelegate;

@interface ZGVideoEditController : UIViewController
@property(nonatomic, strong) PHAsset *videoAsset;
@property(nonatomic, assign) NSUInteger videoMaximumDuration;
@property (nonatomic, assign) id<ZGVideoEditControllerDelegate> videoEditDelegate;
@property(nonatomic, strong) NSURL *videoURL;

@end

@protocol ZGVideoEditControllerDelegate <NSObject>
- (void)videoEditController:(ZGVideoEditController *)videoEdit didFinishEditAssets:(PHAsset *)asset;
- (void)videoEditControllerDidCancel:(ZGVideoEditController *)videoEdit;
@end

