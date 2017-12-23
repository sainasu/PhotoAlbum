//
//  ZGAssetPagePreviewController.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/17.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGViewController.h"
#import "ZGCustomAssetPickerController.h"
#import "ZGCustomAssetPickerBar.h"
#import "ZGShowSelectedAssets.h"

@protocol ZGAssetPagePreviewControllerDelegate;

@interface ZGAssetPagePreviewController : ZGViewController
@property (nonatomic, assign) id<ZGAssetPagePreviewControllerDelegate> pagePreviewDelegate;
@property(nonatomic, assign) ZGCustomAssetPickerSelectType  selectType;
@property(nonatomic, assign) ZGCustomImagePickerReturnType returnType;
@property(nonatomic, assign) ZGSelectedAssetsShowType  showType;

@property(nonatomic, assign) BOOL  allowsRawImageSelecting;
@property(nonatomic, assign) NSUInteger  maximumCount;
@property(nonatomic, assign) NSUInteger  selectedCount;
@property(nonatomic, assign) BOOL  allowsImageEditing;
@property(nonatomic, assign) NSUInteger  videoMaximumDuration;

@property(nonatomic, strong) NSIndexPath  *indexPath;
@property(nonatomic, strong) NSMutableArray *selectedAssets;
@property(nonatomic, strong) NSMutableArray *pagePreviewAssets;
@property(nonatomic, strong) NSMutableArray *previewButtonAssets;

@property(nonatomic, strong) NSString *photoAlbumTitle; // 相册名称
@property(nonatomic, assign) BOOL  isOriginalImageButtonSelectd;

@end
@protocol ZGAssetPagePreviewControllerDelegate <NSObject>
- (void)assetPagePreviewController:(ZGAssetPagePreviewController *)picker didFinishPickingAssets:(NSMutableArray *)assets isOriginalImage:(BOOL)isOriginalImage clickBurron:(NSString *)buttonType pagePreviewAssets:(NSMutableArray *)previewAssets indexPathArray:(NSMutableArray *)array;

@end

