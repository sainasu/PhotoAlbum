//
//  ZGAssetPreviewController.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/17.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGAssetPreviewController.h"
#import "ZGAssetPreviewCell.h"
#import "ZGAssetPickerModel.h"
#import "ZGCropPictureController.h"
#import "ZGPhotoAlbumHeader.h"

#define ZGCIP_MAINSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define ZGCIP_MAINSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


@interface ZGAssetPreviewController ()<ZGAssetPagePreviewControllerDelegate, ZGCustomAssetsPickerBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ZGAssetPreviewCellDelegate, ZGCropPictureControllerDelegate, ZGNavigationTitleViewDelegate>
@property(nonatomic, strong) ZGCustomAssetPickerBar *pickerBar;
@property(nonatomic, strong) NSMutableArray *selecteAssets;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *previewAssets;
@property(nonatomic, strong) PHImageRequestOptions *options; //
@property(nonatomic, assign) BOOL isPagePerviewContorller;



@end

@implementation ZGAssetPreviewController

- (NSMutableArray *)selecteAssets
{
        if (!_selecteAssets) {
                _selecteAssets = [[NSMutableArray alloc]init];
        }
        return _selecteAssets;
}
- (NSMutableArray *)previewAssets
{
        if (!_previewAssets) {
                _previewAssets = [[NSMutableArray alloc]init];
        }
        return _previewAssets;
}




- (void)viewDidLoad {
        [super viewDidLoad];
        self.view.backgroundColor = [UIColor blackColor];
        [[self navigationTitleView] setLeftButtonsWithImageNames:@[@"icon_navbar_back"]];
        [[self navigationTitleView] setRightButtonsWithImageNames:@[@"icon_navbar_close"]];
        [self navigationTitleView].delegate = self;
        self.navigationItem.title = self.photoAlbumTitle;
        [self initAssetPickerBar];
        self.previewAssets = [ZGAssetPickerModel obtainCollectionAllAssets:self.photoAlbumTitle selectType:self.selectType];
        [self initWithTotalPreviewControllerSubViews];
        
}
-(void)viewWillLayoutSubviews{
        
                self.pickerBar.frame = CGRectMake(0, self.view.frame.size.height - HEIGHT_PHOTO_EIDT_BAR_TOOL_X, self.view.frame.size.width, HEIGHT_PHOTO_EIDT_BAR_TOOL_X);
                if (self.maximumCount == 1 || self.allowsCroping == YES) {
                        self.collectionView.frame = self.view.bounds;
                }else{
                        self.collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - HEIGHT_PHOTO_EIDT_BAR_TOOL_X);
                }

}
-(void)viewDidLayoutSubviews{
        if (!TARGET_IPHONE_SIMULATOR) { // 如果不是模拟器
                //  滚动到最底部
                if (self.isPagePerviewContorller == NO) {
                        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.previewAssets.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
                }
        }
}
#pragma mark - navigationBarAction 
- (void)navigationTitleView:(ZGNavigationTitleView *)titleView  buttonClickedAtRightIndex:(NSInteger)index{
        if (self.previewDelegate && [self.previewDelegate conformsToProtocol:@protocol(ZGAssetPreviewControllerDelegate)]) {
                [self.previewDelegate assetsPreviewControllerDidCancel:self];
        }

}
- (void)navigationTitleView:(ZGNavigationTitleView *)titleView buttonClickedAtLeftIndex:(NSInteger)index{
        [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - 初始化Tool
- (void)initAssetPickerBar{
        self.pickerBar = [[ZGCustomAssetPickerBar alloc] initWithFrame:CGRectZero returnType:self.returnType actionType:ZGCustomImagePickerActionTypePreview];
        self.pickerBar.pickerBarDelegate = self;
        self.pickerBar.count = self.selecteAssets.count;
        self.pickerBar.originalImageButton.hidden = !self.allowsRawImageSelecting;
        [self.view addSubview:self.pickerBar];
        
}
#pragma mark - 初始化UICollectionView
-(void) initWithTotalPreviewControllerSubViews{
        self.isPagePerviewContorller = NO;
        self.options = [[PHImageRequestOptions alloc] init];
        self.options.synchronous = NO;
        self.options.resizeMode = PHImageRequestOptionsResizeModeFast;
        self.options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        self.options.version = PHImageRequestOptionsVersionCurrent;
        self.options.networkAccessAllowed = YES;
        

        self.automaticallyAdjustsScrollViewInsets = NO;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(self.view.frame.size.width / ([UIScreen mainScreen].scale + 1), self.view.frame.size.width / ([UIScreen mainScreen].scale + 1));
      
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView.backgroundColor = COLOR_FOR_ASSET_POCKER_BACKGROUND;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.bounces = YES;
        self.collectionView.alwaysBounceVertical = YES;
        [self.view addSubview:self.collectionView];
        [self.collectionView registerClass:[ZGAssetPreviewCell class] forCellWithReuseIdentifier:@"imageCell"];
        
}
#pragma mark - UICollectionViewDelegate
/// 返回对应section的item 的数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return self.previewAssets.count;
}
/// 创建和复用cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        ZGAssetPreviewCell *imageCell = (ZGAssetPreviewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
        imageCell.cellImageDelegate = self;
        imageCell.tag = indexPath.row;
        PHAsset *asset = self.previewAssets[indexPath.row];

        if (self.allowsCroping == YES || self.maximumCount == 1 || self.videoMaximumDuration < (NSUInteger)round(asset.duration)) {
                imageCell.count = -1;
        }else{
                imageCell.count = 0;
        }
        // 从asset中获得图片
        CGFloat imageWidth = ceilf(imageCell.frame.size.width * [UIScreen mainScreen].scale);
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(imageWidth, imageWidth) contentMode:PHImageContentModeDefault options:self.options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                imageCell.image = result;
        }];
        imageCell.videoDuration = (NSUInteger)round(asset.duration);
        
        return imageCell;
}
//点击了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        if (self.allowsCroping == YES) {
                PHAsset *asset = self.previewAssets[indexPath.row];
                ZGCropPictureController *cropPicture = [[ZGCropPictureController alloc] init];
                cropPicture.cropPictureDelegate = self;
                cropPicture.cropPictureSize = self.cropSize;
                
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                options.synchronous = YES;
                options.resizeMode = PHImageRequestOptionsResizeModeFast;
                options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
                options.version = PHImageRequestOptionsVersionCurrent;
                options.networkAccessAllowed = YES;
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth * 0.3  * [UIScreen mainScreen].scale, asset.pixelHeight * 0.3  * [UIScreen mainScreen].scale) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                cropPicture.cropPictureImage = result;
                }];
                [self.navigationController presentViewController:cropPicture animated:YES completion:nil];
        }else{ // 跳转到分页视图
                ZGAssetPagePreviewController *pagePreview = [ZGAssetPagePreviewController new];
                pagePreview.isOriginalImageButtonSelectd = self.pickerBar.originalImageButton.selected;
                pagePreview.pagePreviewDelegate = self;
                pagePreview.indexPath = indexPath;
                pagePreview.selectedAssets = self.selecteAssets;
                pagePreview.pagePreviewAssets = self.previewAssets;
                pagePreview.returnType = self.returnType;
                pagePreview.selectType = self.selectType;
                pagePreview.photoAlbumTitle = self.photoAlbumTitle;
                pagePreview.allowsRawImageSelecting = self.allowsRawImageSelecting;
                pagePreview.maximumCount = self.maximumCount;
                pagePreview.selectedCount = self.selectedCount;
                pagePreview.allowsImageEditing = self.allowsImageEditing;
                pagePreview.videoMaximumDuration = self.videoMaximumDuration;
                pagePreview.showType = ZGSelectedAssetsShowTypeCellAction;

                [self.navigationController pushViewController:pagePreview animated:YES];
        }
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0){
        [self updateCellState:self.selecteAssets];
        
}
#pragma mark - ZGAssetPreviewCellDelegate
- (void)assetPreviewCell:(ZGAssetPreviewCell *)imageCell actionButton:(UIButton *)btn
{
        PHAsset *asset = self.previewAssets[imageCell.tag];
        if (self.selecteAssets.count < self.maximumCount) {
                if (btn.selected == YES) {
                        [self.selecteAssets addObject:asset];
                }else{
                        [self.selecteAssets removeObject:asset];
                }
        }else{
                if (btn.selected == NO) {
                        [self.selecteAssets removeObject:asset];
                        btn.selected = NO;
                }else{
                        [self.selecteAssets addObject:asset];
                        [self.selecteAssets removeObject:asset];
                        btn.selected = NO;
                        // [[[ZGAlertView alloc] initWithMessage:[NSString stringWithFormat:@"      %zi    ", self.maximumCount - self.selectedCount]] show];
                }
        }
        [self updateCellState:self.selecteAssets];
}
-(void)updateCellState:(NSMutableArray *)assets{
        
        for (int i = 0; i < assets.count; i++) {
                PHAsset *asset = assets[i];
                for (int j = 0; j < self.previewAssets.count; j++) {
                        PHAsset *totalAsset = self.previewAssets[j];
                        ZGAssetPreviewCell *cell =  (ZGAssetPreviewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0]];
                        if ([asset isEqual:totalAsset]) {
                                cell.count = i + 1;
                        }
                }
        }
        self.pickerBar.count = assets.count;
}
#pragma mark - ZGCropPictureControllerDelegate
- (void)cropPictureController:(ZGCropPictureController *)picker didFinishCropingPictureAsset:(PHAsset *)asset{
        [picker dismissViewControllerAnimated:NO completion:nil];
        if (self.previewDelegate && [self.previewDelegate conformsToProtocol:@protocol(ZGAssetPreviewControllerDelegate)]) {
                [self.selecteAssets addObject:asset];
                [self.previewDelegate assetsPreviewController:self didFinishPickingAssets:self.selecteAssets isOriginalImage:NO];
        }
}
- (void)cropPictureControllerDidCancel:(ZGCropPictureController *)cropPicture{
        [cropPicture dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - ZGAssetPagePreviewControllerDelegate
-(void)assetPagePreviewController:(ZGAssetPagePreviewController *)picker didFinishPickingAssets:(NSMutableArray *)assets isOriginalImage:(BOOL)isOriginalImage clickBurron:(NSString *)buttonType pagePreviewAssets:(NSMutableArray *)previewAssets indexPathArray:(NSMutableArray *)array{
        [self.navigationController setNavigationBarHidden:NO];
        self.isPagePerviewContorller = YES;
        self.pickerBar.originalImageButton.selected = isOriginalImage;
        self.previewAssets = previewAssets;
        if (array.count > 0) {
                [self.collectionView reloadItemsAtIndexPaths:array];
        }
        self.selecteAssets = assets;
        if ([buttonType isEqualToString:@"pickerBarButton"]) { // 发送或完成按钮
                [picker.navigationController popViewControllerAnimated:NO];
                if (self.previewDelegate && [self.previewDelegate conformsToProtocol:@protocol(ZGAssetPreviewControllerDelegate)]) {
                        [self.previewDelegate assetsPreviewController:self didFinishPickingAssets:assets isOriginalImage:isOriginalImage];
                }
                self.previewAssets = previewAssets;
        }else if ([buttonType isEqualToString:@"navigationButton"]){
                [picker.navigationController popViewControllerAnimated:YES];
                for (NSInteger j = 0; j < self.previewAssets.count; j++) {
                        PHAsset *previewAsset = self.previewAssets[j];
                        ZGAssetPreviewCell *cell =  (ZGAssetPreviewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0]];
                        if (self.allowsCroping == YES || self.maximumCount == 1 || self.videoMaximumDuration < (NSUInteger)round(previewAsset.duration)) {
                                cell.count = -1;
                        }else{
                                cell.count = 0;
                        }
                        for (int i = 0; i < assets.count; i++) {
                                PHAsset *asset = assets[i];
                                if ([asset isEqual:previewAsset]) {
                                        cell.count = i + 1;
                                }
                        }
                }
                self.pickerBar.count = assets.count;
        }
}



#pragma mark - ZGCustomAssetsPickerBarDelegate
- (void)assetsPickerBarActionButton:(UIButton *)ActionButton{
        ZGAssetPagePreviewController *pagePreview = [ZGAssetPagePreviewController new];
        pagePreview.pagePreviewDelegate = self;
        pagePreview.isOriginalImageButtonSelectd = self.pickerBar.originalImageButton.selected;
        pagePreview.selectedAssets = self.selecteAssets;
        pagePreview.previewButtonAssets = self.previewAssets;
        pagePreview.returnType = self.returnType;
        pagePreview.selectType = self.selectType;
        pagePreview.photoAlbumTitle = nil;
        pagePreview.allowsRawImageSelecting = self.allowsRawImageSelecting;
        pagePreview.maximumCount = self.maximumCount;
        pagePreview.selectedCount = self.selectedCount;
        pagePreview.allowsImageEditing = self.allowsImageEditing;
        pagePreview.videoMaximumDuration = self.videoMaximumDuration;
        pagePreview.showType = ZGSelectedAssetsShowTypePreviewAction;
        [self.navigationController pushViewController:pagePreview animated:YES];
}
- (void)assetsPickerBarRetrunButton:(UIButton *)retrunButton{
        if (self.previewDelegate && [self.previewDelegate conformsToProtocol:@protocol(ZGAssetPreviewControllerDelegate)]) {
                [self.previewDelegate assetsPreviewController:self didFinishPickingAssets:self.selecteAssets isOriginalImage:self.pickerBar.originalImageButton.selected];
        }
}


@end
