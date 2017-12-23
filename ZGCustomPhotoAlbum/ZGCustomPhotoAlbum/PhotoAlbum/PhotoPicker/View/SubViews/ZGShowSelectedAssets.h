//
//  ZGShowSelectedAssets.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/11/24.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@protocol ZGShowSelectedAssetsDelegate;
typedef NS_ENUM(NSInteger, ZGSelectedAssetsShowType) {
        ZGSelectedAssetsShowTypePreviewAction,
        ZGSelectedAssetsShowTypeCellAction
};

@interface ZGShowSelectedAssets : UIView
- (instancetype)initWithFrame:(CGRect)frame selectedAssets:(NSMutableArray *)assets showType:(ZGSelectedAssetsShowType)showType;
@property(nonatomic, assign) ZGSelectedAssetsShowType  showType;
@property(nonatomic, assign) id<ZGShowSelectedAssetsDelegate>  delegate;

@property(nonatomic, assign) NSInteger currentIndex; // 当前下标
@property(nonatomic, assign) NSInteger cancelIndex; // 当前下标

@property(nonatomic, strong) PHAsset *selectedAsset; // 选择时的Asset
@property(nonatomic, strong) PHAsset *cancelAsset; // 选择时的Asset


@end

@protocol ZGShowSelectedAssetsDelegate <NSObject>
 // 点击cell的时候, pagePreviewController跟随跳转
- (void)showSelectedAssetsView:(ZGShowSelectedAssets *)showAssetsView clickCellAtIndextPath:(PHAsset *)asset;
- (void)showSelectedAssetsView:(ZGShowSelectedAssets *)showAssetsView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;

@end


