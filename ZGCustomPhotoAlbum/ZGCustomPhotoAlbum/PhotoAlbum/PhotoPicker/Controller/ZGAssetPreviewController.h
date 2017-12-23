//
//  ZGAssetPreviewController.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/17.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGViewController.h"
#import "ZGAssetPagePreviewController.h"
#import "ZGCustomAssetPickerController.h"
#import "ZGCustomAssetPickerBar.h"

@protocol ZGAssetPreviewControllerDelegate;

@interface ZGAssetPreviewController : ZGViewController
@property(nonatomic, assign) ZGCustomAssetPickerSelectType  selectType;
@property(nonatomic, assign) ZGCustomImagePickerReturnType returnType;
@property(nonatomic, assign) BOOL  allowsRawImageSelecting;
@property(nonatomic, assign) NSUInteger  maximumCount;
@property(nonatomic, assign) NSUInteger  selectedCount;
@property(nonatomic, assign) BOOL  allowsImageEditing;
@property(nonatomic, assign) NSUInteger  videoMaximumDuration;
@property(nonatomic, assign) BOOL  allowsCroping;
@property(nonatomic, assign) CGSize  cropSize;
@property(nonatomic, assign) BOOL  isRound;


@property (nonatomic, assign) id<ZGAssetPreviewControllerDelegate> previewDelegate;
@property(nonatomic, strong) NSString *photoAlbumTitle;

@end

@protocol ZGAssetPreviewControllerDelegate <NSObject>
- (void)assetsPreviewController:(ZGAssetPreviewController *)picker didFinishPickingAssets:(NSMutableArray *)assets isOriginalImage:(BOOL)isOriginalImage;
- (void)assetsPreviewControllerDidCancel:(ZGAssetPreviewController *)picker;
@end

