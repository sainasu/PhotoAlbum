//
//  ZGAssetPagePreviewController.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/17.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGAssetPagePreviewController.h"
#import "ZGPhotoAlbumHeader.h"
#import "ZGAssetPickerModel.h"
#import "ZGPagePreviewImageCell.h"
#import "ZGPagePreviewVideoCell.h"
#import "ZGCustomNavigationBar.h"
#import "ZGVideoEditController.h"
#import "ZGPhotoEditingController.h"


@interface ZGAssetPagePreviewController ()<ZGCustomAssetsPickerBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ZGPagePreviewImageCellDelegate, ZGCustomNavigationBarDelegate, ZGVideoEditControllerDelegate, ZGPhotoEditingControllerDelegate, ZGShowSelectedAssetsDelegate>
@property(nonatomic, strong) ZGCustomAssetPickerBar *pickerBar;
@property(nonatomic, strong) ZGCustomNavigationBar *navigaBar;
@property(nonatomic, strong) ZGShowSelectedAssets *showAssetsBar;

@property(nonatomic, assign) BOOL  hiddenPickerBar;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *indextPathArray;


@end

@implementation ZGAssetPagePreviewController

- (void)viewDidLoad {
        [super viewDidLoad];
        if (self.photoAlbumTitle == nil) {
                self.pagePreviewAssets = [NSMutableArray array];
                for (PHAsset *asset in self.selectedAssets) {
                        [self.pagePreviewAssets addObject:asset];
                }
        }
        self.indextPathArray = [NSMutableArray array];
        self.statusBarHidden = YES;
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self initPagePreviewSubView];
        [self initNavigationBar];
        [self initShowAssetBar];
        [self initAssetPickerBar];

        
}
-(void)viewWillLayoutSubviews{
                self.pickerBar.frame = CGRectMake(0, self.view.frame.size.height - HEIGHT_PHOTO_EIDT_BAR_TOOL_X, self.view.frame.size.width, HEIGHT_PHOTO_EIDT_BAR_TOOL_X);
                self.navigaBar.frame = CGRectMake(0, 0, self.view.frame.size.width, HEIGHT_PHOTO_EIDT_BAR_NAV_X);
                self.showAssetsBar.frame = CGRectMake(0, self.view.frame.size.height - HEIGHT_PHOTO_EIDT_BAR_TOOL_X  - HEIGHT_PHOTO_EIDT_BAR_TOOL * 1.5, self.view.frame.size.width, HEIGHT_PHOTO_EIDT_BAR_TOOL * 1.5);

        self.collectionView.frame =  self.view.bounds;
}
-(void)viewDidLayoutSubviews{
        [self.collectionView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        PHAsset *asset = self.pagePreviewAssets[self.indexPath.row];
        if ([self.selectedAssets containsObject:asset]) {// 判断Asset是否在selectedAssets数组中， 如果是：把位置传给他， 否则传-1；
                self.showAssetsBar.currentIndex = [self.selectedAssets indexOfObject:asset];
        }else{
                self.showAssetsBar.currentIndex = -1;
        }
}

#pragma mark - 初始化showAssetBar
- (void) initShowAssetBar{
        self.showAssetsBar = [[ZGShowSelectedAssets alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - HEIGHT_PHOTO_EIDT_BAR_TOOL_X  - HEIGHT_PHOTO_EIDT_BAR_TOOL * 1.5, self.view.frame.size.width, HEIGHT_PHOTO_EIDT_BAR_TOOL * 1.5) selectedAssets:self.selectedAssets showType:self.showType];
        self.showAssetsBar.delegate = self;
        if (self.photoAlbumTitle != nil) {
                self.showAssetsBar.hidden = !(self.selectedAssets.count);
        }
        [self.view addSubview:self.showAssetsBar];
}

#pragma mark - 初始化导航栏
- (void)initNavigationBar{
        self.navigaBar = [[ZGCustomNavigationBar alloc] init];
        self.navigaBar.navigationBarDelegate = self;
        self.navigaBar.videoMaximumDuration = self.videoMaximumDuration;
        PHAsset *asset = self.pagePreviewAssets[self.indexPath.row];
        self.navigaBar.videoDuration =  (NSInteger)asset.duration ;
        [self.view addSubview:self.navigaBar];
}
-(void)navigationBarLeftButton:(UIButton *)btn{
        if (self.pagePreviewDelegate && [self.pagePreviewDelegate conformsToProtocol:@protocol(ZGAssetPagePreviewControllerDelegate)]) {
                if (self.photoAlbumTitle == nil) {
                        self.pagePreviewAssets = self.previewButtonAssets;
                }
                [self.pagePreviewDelegate assetPagePreviewController:self didFinishPickingAssets:self.selectedAssets isOriginalImage:self.pickerBar.originalImageButton.selected clickBurron:@"navigationButton" pagePreviewAssets:self.pagePreviewAssets indexPathArray:self.indextPathArray];
        }
}
-(void)navigationBarReightButton:(UIButton *)sender{
        PHAsset *asset = self.pagePreviewAssets[self.indexPath.row];
        if (self.selectedAssets.count < self.maximumCount) {
                if (sender.selected == NO) {
                        [self.selectedAssets removeObject:asset];
                        self.showAssetsBar.cancelAsset = asset;
                        if (self.photoAlbumTitle == nil) {
                                self.showAssetsBar.currentIndex = [self.pagePreviewAssets indexOfObject:asset];
                        }else{
                                self.showAssetsBar.currentIndex = -1;
                        }
                }else{
                        if (self.photoAlbumTitle == nil) { // perview按钮时
                                // 找到selectedAssets的 第一个和最后的元素,  在pagePreviewAssets的位置
                                NSInteger firstIndex = [self.pagePreviewAssets indexOfObject:[self.selectedAssets firstObject]];
                                NSInteger lastIndex = [self.pagePreviewAssets indexOfObject:[self.selectedAssets lastObject]];
                                NSInteger currentIndex = self.indexPath.row;
                                if (firstIndex > currentIndex) {// 添加到最前面
                                        [self.selectedAssets insertObject:asset atIndex:0];
                                }else if (lastIndex < currentIndex) { // 添加到最后
                                        [self.selectedAssets addObject:asset];
                                }else if(firstIndex < currentIndex && lastIndex > currentIndex){
                                        NSInteger lCount = currentIndex - firstIndex + 1;
                                        for (NSInteger i = 1; i < lCount; i++) { // left
                                                PHAsset *leftAsset = self.pagePreviewAssets[currentIndex - i];
                                                for (NSInteger j = 0; j < self.selectedAssets.count; j++) {
                                                        if ([leftAsset isEqual:self.selectedAssets[j]]) {
                                                                [self.selectedAssets insertObject:asset atIndex:j + 1];
                                                        }
                                                }
                                        }
                                }
                        }else{// 点击cell时
                                [self.selectedAssets addObject:asset];
                        }
                        self.showAssetsBar.selectedAsset = asset;
                        if (self.photoAlbumTitle == nil) {
                                self.showAssetsBar.currentIndex = [self.pagePreviewAssets indexOfObject:asset];
                        }else{
                                self.showAssetsBar.currentIndex = [self.selectedAssets indexOfObject:asset];
                        }

                }
        }else{
                if (sender.selected == NO) {
                        [self.selectedAssets removeObject:asset];// 删除对应的PHAsset
                        sender.selected = NO;
                }else{
                        [self.selectedAssets addObject:asset];// 删除最后添加的
                        [self.selectedAssets removeObject:asset];
                        sender.selected = NO;
                        // [[[ZGAlertView alloc] initWithMessage:[NSString stringWithFormat:@"      %zi    ", self.maximumCount - self.selectedCount]] show];
                }
        }
        if (self.photoAlbumTitle != nil) {
                self.showAssetsBar.hidden = !(self.selectedAssets.count);
        }
        [self renewalNavigationItemRightButtonState];
}
-(void)renewalNavigationItemRightButtonState{
        PHAsset *asset = self.pagePreviewAssets[self.indexPath.row];
        for (int i = 0; i < self.selectedAssets.count; i++) {
                PHAsset *selectdAsset = self.selectedAssets[i];
                if ([selectdAsset isEqual:asset]) {
                        self.navigaBar.count = i + 1;               // 获取到当前页面的在已选择数组中的位置
                        return;
                }else{
                        self.navigaBar.count = 0;
                }
        }
        if (asset.mediaType == PHAssetMediaTypeImage) {
                self.pickerBar.originalImageButton.hidden = !self.allowsRawImageSelecting;
        }else{
                self.pickerBar.originalImageButton.hidden = YES;
        }
        if (self.photoAlbumTitle != nil) {
                self.showAssetsBar.hidden = !(self.selectedAssets.count);
        }
        
}
#pragma mark - 初始化工具栏
- (void)initAssetPickerBar{
        self.pickerBar = [[ZGCustomAssetPickerBar alloc] initWithFrame:CGRectZero returnType:self.returnType actionType:ZGCustomImagePickerActionTypeEdit];
        self.pickerBar.pickerBarDelegate = self;
        self.pickerBar.originalImageButton.hidden = !self.allowsRawImageSelecting;
        self.pickerBar.originalImageButton.selected = self.isOriginalImageButtonSelectd;
        self.pickerBar.videoMaximumDuration = self.videoMaximumDuration;
        self.pickerBar.allowsImageEditing = self.allowsImageEditing;
        PHAsset *asset = self.pagePreviewAssets[self.indexPath.row];
        self.pickerBar.videoDuration =  (NSInteger)asset.duration;
        [self.view addSubview:self.pickerBar];
        
}
#pragma mark - 初始化UICollectionView
-(void)initPagePreviewSubView{
        self.automaticallyAdjustsScrollViewInsets = NO;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - self.pickerBar.frame.size.height);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor blackColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.bounces = YES;
        self.collectionView.pagingEnabled = YES;
        [self.view addSubview:self.collectionView];
        //注册
        [self.collectionView registerClass:[ZGPagePreviewImageCell class] forCellWithReuseIdentifier:@"imageCell"];
        [self.collectionView registerClass:[ZGPagePreviewVideoCell class] forCellWithReuseIdentifier:@"videoCell"];
}

#pragma mark - UICollectionViewDataSource
/// 返回对应section的item 的数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return self.pagePreviewAssets.count;
}
/// 创建和复用cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        
        PHAsset *asset = self.pagePreviewAssets[indexPath.row];
        if (asset.mediaType == PHAssetMediaTypeImage) {
                ZGPagePreviewImageCell *imageCell = (ZGPagePreviewImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
                imageCell.imageCellDelegate = self;
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                options.synchronous = NO;
                options.resizeMode = PHImageRequestOptionsResizeModeFast;
                options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
                options.version = PHImageRequestOptionsVersionCurrent;
                options.networkAccessAllowed = YES;
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth * 0.3 * [UIScreen mainScreen].scale, asset.pixelHeight * 0.3 * [UIScreen mainScreen].scale) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                        imageCell.image = result;
                }];
                return imageCell;
        }else if (asset.mediaType == PHAssetMediaTypeVideo){
                ZGPagePreviewVideoCell *videoCell = (ZGPagePreviewVideoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"videoCell" forIndexPath:indexPath];
                videoCell.videoAsset = asset;
                return videoCell;
        }
        return nil;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0){
        [self renewalNavigationItemRightButtonState];
}
//将要滚动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
        PHAsset *asset = self.pagePreviewAssets[self.indexPath.row];
        if (asset.mediaType == PHAssetMediaTypeVideo) {
                ZGPagePreviewVideoCell *videoCell =  (ZGPagePreviewVideoCell *)[self.collectionView cellForItemAtIndexPath:_indexPath];
                [videoCell pauseVideo];
        }else{
                ZGPagePreviewImageCell *cell =  (ZGPagePreviewImageCell *)[self.collectionView cellForItemAtIndexPath:self.indexPath];
                [cell resetView];
        }

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
        CGPoint pInView = [self.view convertPoint:self.collectionView.center toView:self.collectionView];        // 将collectionView在控制器view的中心点转化成collectionView上的坐标
        NSIndexPath *indexPathNow = [self.collectionView indexPathForItemAtPoint:pInView];        // 获取这一点的indexPath
        self.indexPath = indexPathNow;        // 赋值给记录当前坐标的变量
        [self renewalNavigationItemRightButtonState];
        PHAsset *asset = self.pagePreviewAssets[self.indexPath.row];
        self.pickerBar.videoDuration =  (NSInteger)asset.duration;
        self.navigaBar.videoDuration =  (NSInteger)asset.duration;
        
        if ([self.selectedAssets containsObject:asset]) {// 如果Asset存在于selectedAssets数组中， 则把位置传给currentIndex
                if (self.photoAlbumTitle == nil) {
                        self.showAssetsBar.currentIndex = [self.pagePreviewAssets indexOfObject:asset];
                }else{
                        self.showAssetsBar.currentIndex = [self.selectedAssets indexOfObject:asset];
                }
        }else{// 否则， 把Asset传递给cancelAsset ， currentIndex = -1；
                if (self.photoAlbumTitle == nil) {
                        self.showAssetsBar.currentIndex = [self.pagePreviewAssets indexOfObject:asset];
                }else{
                        self.showAssetsBar.currentIndex = -1;
                }
                self.showAssetsBar.cancelAsset = asset;
        }
}

#pragma mark - ZGShowSelectedAssetsDelegate
-(void)showSelectedAssetsView:(ZGShowSelectedAssets *)showAssetsView clickCellAtIndextPath:(PHAsset *)asset{
        NSUInteger index = [self.pagePreviewAssets indexOfObject:asset];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        self.indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self renewalNavigationItemRightButtonState];
}
- (void)showSelectedAssetsView:(ZGShowSelectedAssets *)showAssetsView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
        if (self.photoAlbumTitle == nil) { // 如果是预览按钮， 则刷新（替换）全部数据
                PHAsset *asset = self.pagePreviewAssets[sourceIndexPath.row];
                [self.pagePreviewAssets removeObject:asset];
                [self.pagePreviewAssets insertObject:asset atIndex:destinationIndexPath.row];
                NSArray *indexPathArray = [NSArray arrayWithObjects:sourceIndexPath, destinationIndexPath, nil];
                
                
                        [self.collectionView reloadItemsAtIndexPaths:indexPathArray];
                
                if (self.selectedAssets.count == self.pagePreviewAssets.count) {     //取出移动row数据
                        PHAsset *asset = self.selectedAssets[sourceIndexPath.row];
                        [self.selectedAssets removeObject:asset]; //从数据源中移除该数据
                        [self.selectedAssets insertObject:asset atIndex:destinationIndexPath.row]; //将数据插入到数据源中的目标位置

                }else{   // 操作pagePreviewAssets，之后按照pagePreviewAssets的数据排序selected数据， 然后刷新数据
                        NSMutableArray *array = [NSMutableArray array];
                        for (PHAsset *asset in self.pagePreviewAssets) {
                                if ([self.selectedAssets containsObject:asset]) {
                                        [array addObject:asset];
                                }else{
                                        self.showAssetsBar.cancelIndex = [self.pagePreviewAssets indexOfObject:asset];
                                }
                        }
                        self.selectedAssets = array;
                        
                }
        }else{
                if (destinationIndexPath.row < self.selectedAssets.count) {
                        PHAsset *asset = self.selectedAssets[sourceIndexPath.row];
                        [self.selectedAssets removeObject:asset];
                        [self.selectedAssets insertObject:asset atIndex:destinationIndexPath.row];
                }else{
                        PHAsset *asset = self.selectedAssets[sourceIndexPath.row];
                        [self.selectedAssets removeObject:asset];
                        [self.selectedAssets insertObject:asset atIndex:self.selectedAssets.count - 1];

                }
                
        }
        self.showAssetsBar.currentIndex = destinationIndexPath.row;
        [self renewalNavigationItemRightButtonState];
}

#pragma mark - ZGCustomAssetsPickerBarDelegate
-(void)assetsPickerBarActionButton:(UIButton *)ActionButton{
       __block PHAsset *currentAsset = self.pagePreviewAssets[_indexPath.row];
        if (currentAsset.mediaType == PHAssetMediaTypeImage){
                ZGPhotoEditingController *photoEdit = [ZGPhotoEditingController new];
                photoEdit.photoAsset = currentAsset;
                photoEdit.photoDelegate = self;
                [self presentViewController:photoEdit animated:NO completion:nil];
        }else{
                
                ZGPagePreviewVideoCell *videoCell =  (ZGPagePreviewVideoCell *)[self.collectionView cellForItemAtIndexPath:_indexPath];
                [videoCell pauseVideo];
                ZGVideoEditController *videoEdit = [ZGVideoEditController new];
                videoEdit.videoEditDelegate = self;
                videoEdit.videoMaximumDuration = self.videoMaximumDuration;
                videoEdit.videoAsset = currentAsset;
                [self presentViewController:videoEdit animated:YES completion:nil];
                
        }
}
-(void)assetsPickerBarRetrunButton:(UIButton *)retrunButton{
        if (self.pagePreviewDelegate && [self.pagePreviewDelegate conformsToProtocol:@protocol(ZGAssetPagePreviewControllerDelegate)]) {
                if (self.selectedAssets.count == 0) {
                        [self.pagePreviewDelegate assetPagePreviewController:self didFinishPickingAssets:self.selectedAssets isOriginalImage:self.pickerBar.originalImageButton.selected clickBurron:@"pickerBarButton" pagePreviewAssets:self.pagePreviewAssets[self.indexPath.row]  indexPathArray:self.indextPathArray];

                }else{
                        [self.pagePreviewDelegate assetPagePreviewController:self didFinishPickingAssets:self.selectedAssets isOriginalImage:self.pickerBar.originalImageButton.selected clickBurron:@"pickerBarButton" pagePreviewAssets:self.pagePreviewAssets  indexPathArray:self.indextPathArray];

                }
                

        }
}
#pragma mark - ZGPhotoEditingControllerDelegate
- (void)photoEditController:(ZGPhotoEditingController *)photoEdit didFinishEditAsset:(PHAsset *)asset{
        [photoEdit dismissViewControllerAnimated:NO completion:nil];
        PHAsset *currentAsset = self.pagePreviewAssets[self.indexPath.row];
        [self.pagePreviewAssets replaceObjectAtIndex:self.indexPath.row withObject:asset];
        if (self.photoAlbumTitle == nil) {
                for (NSInteger i = 0; i < self.previewButtonAssets.count; i++) {
                        PHAsset *previewAsset = self.previewButtonAssets[i];
                        if ([previewAsset isEqual:currentAsset]) {
                                [self.previewButtonAssets replaceObjectAtIndex:i withObject:asset];
                                [self.indextPathArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                        }
                }
        }else{
                [self.indextPathArray addObject:self.indexPath];

        }
        if ([self.selectedAssets containsObject:currentAsset]) {
                [self.selectedAssets replaceObjectAtIndex:[self.selectedAssets indexOfObject:currentAsset] withObject:asset];
                self.showAssetsBar.cancelAsset = currentAsset;
                self.showAssetsBar.selectedAsset = asset;
                
        }
                [self.collectionView reloadItemsAtIndexPaths:@[self.indexPath]];
        
        [self renewalNavigationItemRightButtonState];
}
- (void)photoEditControllerDidCancel:(ZGPhotoEditingController *)photoEdit{
        [photoEdit dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark - ZGVideoEditControllerDelegate
-(void)videoEditControllerDidCancel:(ZGVideoEditController *)videoEdit{
        [videoEdit dismissViewControllerAnimated:YES completion:nil];
}

-(void)videoEditController:(ZGVideoEditController *)videoEdit didFinishEditAssets:(PHAsset *)asset{
        [videoEdit dismissViewControllerAnimated:YES completion:nil];
        PHAsset *currentAsset = self.pagePreviewAssets[self.indexPath.row];

        [self.pagePreviewAssets replaceObjectAtIndex:self.indexPath.row withObject:asset];
        if (self.photoAlbumTitle == nil) {
                for (NSInteger i = 0; i < self.previewButtonAssets.count; i++) {
                        PHAsset *previewAsset = self.previewButtonAssets[i];
                        if ([previewAsset isEqual:currentAsset]) {
                                [self.previewButtonAssets replaceObjectAtIndex:i withObject:asset];
                                [self.indextPathArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                        }
                }
        }else{
                [self.indextPathArray addObject:self.indexPath];
        }
        for (NSInteger i = 0; i < self.selectedAssets.count; i++) {
                PHAsset *selectedAsset = self.selectedAssets[i];
                if ([selectedAsset isEqual:currentAsset]) {
                }
        }
        if ([self.selectedAssets containsObject:currentAsset]) {
                [self.selectedAssets replaceObjectAtIndex:[self.selectedAssets indexOfObject:currentAsset] withObject:asset];
                self.showAssetsBar.cancelAsset = currentAsset;
                self.showAssetsBar.selectedAsset = asset;

        }
        
        [self.collectionView reloadItemsAtIndexPaths:@[self.indexPath]];
        [self renewalNavigationItemRightButtonState];
}

#pragma mark - ZGPagePreviewImageCellDelegate
-(void)pagePreviewImageCell:(ZGPagePreviewImageCell *)imageView{
        self.hiddenPickerBar = !self.hiddenPickerBar;
        if (self.hiddenPickerBar == NO ) {
                [UIView animateWithDuration:0.1 animations:^{
                                                        self.pickerBar.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, HEIGHT_PHOTO_EIDT_BAR_TOOL_X);
                                self.navigaBar.frame = CGRectMake(0, -HEIGHT_PHOTO_EIDT_BAR_NAV, self.view.frame.size.width, HEIGHT_PHOTO_EIDT_BAR_NAV);
                                self.showAssetsBar.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, HEIGHT_PHOTO_EIDT_BAR_TOOL_X * 1.5);
                                
                        
                }];
        }
}

@end
