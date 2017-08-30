//
//  ZGCIPThumbnailsPreviewController.m
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/30.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGCIPThumbnailsPreviewController.h"
#import "ZGPAViewModel.h"
#import "ZGThumbnailsPreviewImageCell.h"
#import "ZGThumbnailsPreviewVideoCell.h"
#import "ZGCIPLargerVersionPreviewController.h"

static NSString * const CellReuseIdentify = @"CellReuseIdentify";
static NSString * const CellImageReuseIdentify = @"CellImageReuseIdentify";

static NSString * const SupplementaryViewHeaderIdentify = @"SupplementaryViewHeaderIdentify";
static NSString * const SupplementaryViewFooterIdentify = @"SupplementaryViewFooterIdentify";



@interface ZGCIPThumbnailsPreviewController  ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate , ZGCIPLargerVersionPreviewControllerDelegate,ZGChooseToCompleteDelegate>{
        UICollectionView *_myCollectionView;
        
}
@property(nonatomic, strong) NSMutableArray *thumbnailsPerviewData;/**小图预览数据源*/
@property(nonatomic, strong) NSMutableArray *thumbnailsSelectedAsset;/**选择的数据源*/
@property(nonatomic, assign) NSInteger  allSelectedAssetNum;/**<#注释#>*/
@property(nonatomic, strong) NSMutableDictionary *updataAssets;/**<#注释#>*/
@property(nonatomic, assign) BOOL isOriginalImage;/**是否是原图*/
@property(nonatomic, strong) ZGPhotoAlbumPickerBar *pickerBar;/**工具栏*/



@end

@implementation ZGCIPThumbnailsPreviewController

- (NSMutableDictionary *)updataAssets
{
        if (!_updataAssets) {
                _updataAssets = [[NSMutableDictionary alloc]init];
        }
        return _updataAssets;
}

- (NSMutableArray *)thumbnailsPerviewData
{
        if (!_thumbnailsPerviewData) {
                _thumbnailsPerviewData = [[NSMutableArray alloc]init];
        }
        return _thumbnailsPerviewData;
}
- (NSMutableArray *)thumbnailsSelectedAsset
{
        if (!_thumbnailsSelectedAsset) {
                _thumbnailsSelectedAsset = [[NSMutableArray alloc]init];
        }
        return _thumbnailsSelectedAsset;
}
- (void)viewDidLoad {
        [super viewDidLoad];
        self.view.backgroundColor = [UIColor whiteColor];
        [self initNavigationViewController];
        [self initPickerBar];
        
        NSMutableArray *assetArray = [[NSMutableArray alloc] init];
        assetArray = [ZGPAViewModel accordingToTheCollectionTitleOfLodingPHAsset:self.folderTitel];
        //数据源配置
        if (self.whetherTheCrop == YES ) {
                //如果是截图, 则把视频数据过滤掉
                for (PHAsset *imageAsset in assetArray) {
                        if (imageAsset.mediaType == PHAssetMediaTypeImage) {
                                [self.thumbnailsPerviewData addObject:imageAsset];
                        }
                }
        }
        if (self.selectType == ZGCPSelectTypeImage) {
                //如果是只能选择图片, 则把视频数据过滤掉
                for (PHAsset *imageAsset in assetArray) {
                        if (imageAsset.mediaType == PHAssetMediaTypeImage) {
                                [self.thumbnailsPerviewData addObject:imageAsset];
                        }
                }
                
        }
        if (self.selectType == ZGCPSelectTypeVideo) {
                //如果只能选择视频. 则吧图片数据过滤掉
                for (PHAsset *imageAsset in assetArray) {
                        if (imageAsset.mediaType == PHAssetMediaTypeVideo) {
                                [self.thumbnailsPerviewData addObject:imageAsset];
                        }
                }
                
        }
        if (self.selectType == ZGCPSelectTypeImageAndVideo) {
                //如果图片和视频和选, 则要全部数据
                self.thumbnailsPerviewData = assetArray;
        }
        
        [self initCollectionView];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.thumbnailsPerviewData.count - 1 inSection:0];
        
        if (self.thumbnailsPerviewData.count == 0) {
                [self dismissViewControllerAnimated:YES completion:nil];
        }else{
                //滚动到最底部
                [_myCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        }
        self.allSelectedAssetNum = 0;
        self.allSelectedAssetNum = self.selectedCount + self.thumbnailsSelectedAsset.count;
        
        
}
#pragma mark - 初始化CollectionView
-(void)initCollectionView{
        if (_myCollectionView) {
                [_myCollectionView removeFromSuperview];
        }
        self.automaticallyAdjustsScrollViewInsets = NO;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake((self.view.frame.size.width - 20)/3.0, 0);
        if (self.whetherTheCrop == NO) {
                _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,20 + kPANavigationHeight, kPAMainScreenWidth, kPAMainScreenHeight - kPAMainToolsHeight - 15 - kPANavigationHeight) collectionViewLayout:layout];
        }else{
                _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,20 + kPANavigationHeight, kPAMainScreenWidth, kPAMainScreenHeight - 15 - kPANavigationHeight) collectionViewLayout:layout];
        }
        _myCollectionView.backgroundColor = kPAColor(37, 37, 38, 1);
        _myCollectionView.dataSource = self;
        _myCollectionView.delegate = self;
        [self.view addSubview:_myCollectionView];
        //注册
        [_myCollectionView registerClass:[ZGThumbnailsPreviewVideoCell class] forCellWithReuseIdentifier:CellReuseIdentify];
        [_myCollectionView registerClass:[ZGThumbnailsPreviewImageCell class] forCellWithReuseIdentifier:CellImageReuseIdentify];
        
}
#pragma mark - UICollectionViewDataSource
//返回section 的数量
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
        return 1;
}
//返回对应section的item 的数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return self.thumbnailsPerviewData.count;
}
//创建和复用cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        ZGThumbnailsPreviewImageCell *imageCell = (ZGThumbnailsPreviewImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellImageReuseIdentify forIndexPath:indexPath];
        // 从asset中获得图片
        PHAsset *asset = self.thumbnailsPerviewData[indexPath.row];
        if (asset.hidden == NO) {//如果是隐藏的则不显示
                if (asset.mediaType == PHAssetMediaTypeVideo) {
                        ZGThumbnailsPreviewVideoCell *cell = (ZGThumbnailsPreviewVideoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentify forIndexPath:indexPath];
                        [cell.selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchDown];
                        cell.selectButton.tag = 1000 + indexPath.row;//tag值可以确定cell的位置
                        //如果是视频
                        cell.imageView.image = [ZGPAViewModel createAccessToImage:asset imageSize: CGSizeMake(kPAMainScreenWidth / 4, kPAMainScreenWidth / 4) contentMode:PHImageContentModeAspectFill];
                        cell.videoImage.image = [UIImage imageNamed:@"video_sign"];
                        NSUInteger seconds = (NSUInteger)round(asset.duration);
                        NSString *string = [NSString stringWithFormat:@"%02lu:%02lu",(seconds / 60) % 60, seconds % 60];
                        //获取到视频的时间
                        cell.videoTimer.text = string ;
                        
                        if (self.selectType != 0) {
                                cell.selectButton.selected = NO;
                                cell.selectButton.hidden = NO;
                        }else{
                                
                                cell.selectButton.hidden = YES;
                        }
                        if (self.maySelectMaximumCount == 1) {//单选时隐藏选择按钮
                                cell.selectButton.hidden = YES;
                        }
                        
                        return cell;
                        
                }else if (asset.mediaType == PHAssetMediaTypeImage) {
                        [imageCell.selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchDown];
                        imageCell.selectButton.tag = 1000 + indexPath.row;//tag值可以确定cell的位置
                        //如果是图片
                        imageCell.imageView.image = [ZGPAViewModel createAccessToImage:asset imageSize: CGSizeMake(kPAMainScreenWidth / 4, kPAMainScreenWidth / 4) contentMode:PHImageContentModeAspectFill];
                        imageCell.selectButton.selected = NO;
                        
                        if (self.selectType != 0) {
                                imageCell.selectButton.selected = NO;
                                imageCell.selectButton.hidden = NO;
                        }else{
                                imageCell.selectButton.hidden = YES;
                        }
                        if (self.maySelectMaximumCount == 1) {//单选时隐藏选择按钮
                                imageCell.selectButton.hidden = YES;
                        }
                        
                        
                        return imageCell;
                }
        }
        
        
        
        return imageCell;
}
//选择按钮的单击事件
-(void)selectButtonAction:(UIButton *)btn{
        btn.selected = !btn.selected;
        if (self.allSelectedAssetNum < self.maySelectMaximumCount) {
                if (btn.selected == YES) {
                        [self.thumbnailsSelectedAsset addObject:self.thumbnailsPerviewData[btn.tag - 1000]];
                }else{
                        //删除对应的PHAsset
                        [self.thumbnailsSelectedAsset removeObject:self.thumbnailsPerviewData[btn.tag - 1000]];
                }
        }else{
                if (btn.selected == NO) {
                        //删除对应的PHAsset
                        [self.thumbnailsSelectedAsset removeObject:self.thumbnailsPerviewData[btn.tag - 1000]];
                        btn.selected = NO;
                        
                        
                }else{
                        //删除最后添加的
                        [self.thumbnailsSelectedAsset addObject:self.thumbnailsPerviewData[btn.tag - 1000]];
                        [self.thumbnailsSelectedAsset removeObject:self.thumbnailsPerviewData[btn.tag - 1000]];
                        btn.selected = NO;
                        if (self.selectedCount == 0) {
                                [ZGPAViewModel aliertControllerTitle:[NSString stringWithFormat:@"最多能选%lu张图片",self.maySelectMaximumCount - self.selectedCount] viewController:self];
                                
                        }else{
                                [ZGPAViewModel aliertControllerTitle:[NSString stringWithFormat:@"已选择%lu张图片, 本次最多能选%lu张图片", self.selectedCount,self.maySelectMaximumCount - self.selectedCount] viewController:self];
                        }
                }
        }
        [self selectedCellAtIndexPan];
        
        
}
//更新被点击的cell按钮
-(void)selectedCellAtIndexPan{
        for (NSInteger i = 0; i < self.thumbnailsPerviewData.count; i++) {
                PHAsset *imageAsset = self.thumbnailsPerviewData[i];
                for (int j = 0; j < self.thumbnailsSelectedAsset.count; j++) {
                        PHAsset *asset = self.thumbnailsSelectedAsset[j];
                        if (imageAsset.mediaType == PHAssetMediaTypeImage) {
                                ZGThumbnailsPreviewImageCell *cell =  (ZGThumbnailsPreviewImageCell *)[_myCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                                if ([asset isEqual:imageAsset]) {
                                        cell.selectButton.selected = YES;
                                        [cell.selectButton setTitle:[NSString stringWithFormat:@"%d", j + 1] forState:UIControlStateSelected];
                                }
                        }else if (imageAsset.mediaType == PHAssetMediaTypeVideo) {
                                ZGThumbnailsPreviewVideoCell *cell =  (ZGThumbnailsPreviewVideoCell *)[_myCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                                if ([asset isEqual:imageAsset]) {
                                        cell.selectButton.selected = YES;
                                        [cell.selectButton setTitle:[NSString stringWithFormat:@"%d", j + 1] forState:UIControlStateSelected];
                                }
                                
                        }
                }
        }
        
        self.allSelectedAssetNum = 0;
        self.allSelectedAssetNum = self.selectedCount + self.thumbnailsSelectedAsset.count;
        //更新遮挡View
        if (self.thumbnailsSelectedAsset.count == 0) {
                [self.pickerBar isHiden:YES];
        }else{
                [self.pickerBar isHiden:NO];
        }
        
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        return CGSizeMake(kPAMainScreenWidth / 4, kPAMainScreenWidth / 4);
        
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
        
}
//cell即将出现
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0){
        [self selectedCellAtIndexPan];
}
//cell已经出现
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
        [self selectedCellAtIndexPan];
        
        
        
}
#pragma mark - UICollectionViewDelegate method
//点击了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        PHAsset *asset = self.thumbnailsPerviewData[indexPath.row];
        ZGCIPLargerVersionPreviewController *previewController = [ZGCIPLargerVersionPreviewController new];
        previewController.delegate = self;
        previewController.meituizipaiSelectdAsset = asset;
        previewController.folderTitel = self.folderTitel;
        previewController.indexPathRow = indexPath.row;
        previewController.updataMeituizipaiAssets = self.updataAssets;
        previewController.selectedCount = self.selectedCount;
        previewController.selectType = self.selectType;
        previewController.maySelectMaximumCount = self.maySelectMaximumCount;
        previewController.whetherToEditPictures = self.whetherToEditPictures;
        previewController.cropSize = self.cropSize;
        previewController.isOriginalImage = self.isOriginalImage;
        previewController.maximumTimeVideo = self.maximumTimeVideo;
        previewController.whetherTheCrop = self.whetherTheCrop;
        previewController.isSendTheOriginalPictures = self.isSendTheOriginalPictures;
        previewController.completeDelegate = self;
        previewController.sendButtonImage = self.sendButtonImage;
        
        //聊天
        previewController.meituizipaiSelectedAssetData = self.thumbnailsSelectedAsset;
        
        [self.navigationController pushViewController:previewController animated:YES];
        
}
#pragma mark - ZGMeituizipaiPreviewControllerDelegate
-(void)largerVersionPreviewController:(ZGCIPLargerVersionPreviewController *)largerVersion selectedAssetArray:(NSMutableArray *)sender isOriginalImage:(BOOL)isOriginal
{
        [largerVersion.navigationController popViewControllerAnimated:YES];
        self.isOriginalImage = isOriginal;
        if (self.isOriginalImage == YES) {
                self.pickerBar.originalImageButton.selected = YES;
                [_pickerBar.originalImageButton setImage:[UIImage imageNamed:@"icon_navbar_image_green"] forState:UIControlStateSelected];
        }else{
                self.pickerBar.originalImageButton.selected = NO;
                [_pickerBar.originalImageButton setImage:[UIImage imageNamed:@"icon_navbar_album"] forState:UIControlStateNormal];
        }
        
        self.thumbnailsSelectedAsset = sender;
        [_myCollectionView reloadData];
        [self selectedCellAtIndexPan];
        
        
        
}
-(void)largerVersionPreviewController:(ZGCIPLargerVersionPreviewController *)largerVersion newAsset:(PHAsset *)asset oldAsset:(PHAsset *)oldAsset{
        [largerVersion.navigationController popViewControllerAnimated:YES];
        //替换掉原有的数据源  和  被选择的数据<跳转到大图预览界面时也要替换数据>
        for (NSInteger i = 0; i < self.thumbnailsPerviewData.count; i++) {
                PHAsset *thumbnailsAsset = self.thumbnailsPerviewData[i];
                if ([oldAsset isEqual:thumbnailsAsset]) {
                        [self.thumbnailsPerviewData replaceObjectAtIndex:i withObject:asset];
                        [_myCollectionView reloadData];
                        [self.updataAssets setObject:asset forKey:[NSString stringWithFormat:@"%lu", i]];
                        
                }
        }
        for (NSInteger i = 0; i < self.thumbnailsSelectedAsset.count; i++) {
                PHAsset *thumbnailsAsset = self.thumbnailsSelectedAsset[i];
                if ([oldAsset isEqual:thumbnailsAsset]) {
                        [self.thumbnailsSelectedAsset replaceObjectAtIndex:i withObject:asset];
                }
        }
        [self selectedCellAtIndexPan];
}

#pragma mark - ZGChooseToCompleteDelegate
//选择完成代理
-(void)largerVersionPreviewController:(ZGCIPLargerVersionPreviewController *)largerVersion didFinishPickingImages:(NSMutableArray *)array isOriginalImage:(BOOL)original{
        [largerVersion.navigationController popViewControllerAnimated:NO];
        [self.thumbnailsPreviewDelegate thumbnailsPreviewController:self didFinishPickingImages:array isOriginalImage:original];
        
        
}




#pragma mark - 初始化工具栏
-(void)initPickerBar{
        if (_pickerBar) {
                [_pickerBar removeFromSuperview];
        }
        
        //两样都能选
        if(self.selectType == ZGCPSelectTypeImageAndVideo ){//合选
                _pickerBar = [[ZGPhotoAlbumPickerBar alloc] initWithFrame:CGRectMake(0, kPAMainScreenHeight - kPAMainToolsHeight, kPAMainScreenWidth, kPAMainToolsHeight) isOldPickerBar:NO];
                [_pickerBar.leftButton setImage:[UIImage imageNamed:@"icon_navbar_review"] forState:UIControlStateNormal];
                [_pickerBar.rightButton setImage:self.sendButtonImage forState:UIControlStateNormal];
                
                [_pickerBar.rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchDown];
        }
        //只能单选
        if ( self.selectType == ZGCPSelectTypeImage || self.selectType == ZGCPSelectTypeVideo) {
                _pickerBar = [[ZGPhotoAlbumPickerBar alloc] initWithFrame:CGRectMake(0, kPAMainScreenHeight - kPAMainToolsHeight, kPAMainScreenWidth, kPAMainToolsHeight) isOldPickerBar:NO];
                [_pickerBar.leftButton setImage:[UIImage imageNamed:@"icon_navbar_review"] forState:UIControlStateNormal];
                [_pickerBar.rightButton setImage:self.sendButtonImage forState:UIControlStateNormal];
                [_pickerBar.rightButton addTarget:self action:@selector(rightCollectionButtonAction) forControlEvents:UIControlEventTouchDown];
                
        }
        
        //是否要原图
        if (self.isSendTheOriginalPictures == YES) {
                [_pickerBar.originalImageButton addTarget:self action:@selector(originalImageButtonAction:) forControlEvents:UIControlEventTouchDown];
                if (self.isOriginalImage == YES) {
                        self.pickerBar.originalImageButton.selected = YES;
                        [_pickerBar.originalImageButton setImage:[UIImage imageNamed:@"icon_navbar_image_green"] forState:UIControlStateSelected];
                }else{
                        self.pickerBar.originalImageButton.selected = NO;
                        [_pickerBar.originalImageButton setImage:[UIImage imageNamed:@"icon_navbar_album"] forState:UIControlStateNormal];
                }
        }else{
                _pickerBar.originalImageButton.hidden = YES;
                
        }
        [_pickerBar.leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:_pickerBar];
        [self selectedCellAtIndexPan];
        
}
//工具栏原图按钮
-(void)originalImageButtonAction:(UIButton *)sender{
        sender.selected = !sender.selected;
        if (sender.selected == YES) {
                [_pickerBar.originalImageButton setImage:[UIImage imageNamed:@"icon_navbar_image_green"] forState:UIControlStateSelected];
                self.isOriginalImage = YES;
                
        }else{
                [_pickerBar.originalImageButton setImage:[UIImage imageNamed:@"icon_navbar_album"] forState:UIControlStateNormal];
                self.isOriginalImage = NO;
        }
        
}

//工具栏按钮预览
-(void)leftButtonAction{
        ZGCIPLargerVersionPreviewController *previewController = [ZGCIPLargerVersionPreviewController new];
        previewController.delegate = self;
        previewController.folderTitel = @"ZGMeituizipaiPreviewController";
        previewController.indexPathRow = 0;
        previewController.meituizipaiSelectedAssetData = self.thumbnailsSelectedAsset;
        previewController.updataMeituizipaiAssets = self.updataAssets;
        previewController.selectedCount = self.selectedCount;
        previewController.selectType = self.selectType;
        previewController.maySelectMaximumCount = self.maySelectMaximumCount;
        previewController.whetherToEditPictures = self.whetherToEditPictures;
        previewController.cropSize = self.cropSize;
        previewController.isOriginalImage = self.isOriginalImage;
        previewController.maximumTimeVideo = self.maximumTimeVideo;
        previewController.isSendTheOriginalPictures = self.isSendTheOriginalPictures;
        previewController.completeDelegate = self;
        previewController.sendButtonImage = self.sendButtonImage;
        
        [self.navigationController pushViewController:previewController animated:YES];
        
}
-(void)rightButtonAction{
        if (self.isOriginalImage == YES) {
                //聊天中发送图片(<原图>)||视频"
                //    发送通知
                [self.thumbnailsPreviewDelegate thumbnailsPreviewController:self didFinishPickingImages:self.thumbnailsSelectedAsset isOriginalImage:YES];
        }else{
                
                [self.thumbnailsPreviewDelegate thumbnailsPreviewController:self didFinishPickingImages:self.thumbnailsSelectedAsset isOriginalImage:NO];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)rightCollectionButtonAction{
        //小图预览：完成类似收藏
        [self.thumbnailsPreviewDelegate thumbnailsPreviewController:self didFinishPickingImages:self.thumbnailsSelectedAsset isOriginalImage:NO];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
}

- (void)viewWillLayoutSubviews
{
        if (self.whetherTheCrop == NO) {
                _myCollectionView.frame = CGRectMake(0,20 + kPANavigationHeight, kPAMainScreenWidth, kPAMainScreenHeight - kPAMainToolsHeight - 15 - kPANavigationHeight) ;
        }else{
                _myCollectionView.frame = CGRectMake(0,20 + kPANavigationHeight, kPAMainScreenWidth, kPAMainScreenHeight - 15 - kPANavigationHeight) ;
        }
        _pickerBar.frame = CGRectMake(0, kPAMainScreenHeight - kPAMainToolsHeight, kPAMainScreenWidth, kPAMainToolsHeight);
        
}

#pragma mark - 设置导航
-(void)initNavigationViewController{
        self.navigationItem.title = _folderTitel;
        //设置标题颜色
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        //设置状态栏
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        //设置导航栏颜色
        self.navigationController.navigationBar.barTintColor = kPANavigationViewColor;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        //取消navigationRightButtonAction
        UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kPANavigationHeight, kPANavigationHeight)];
        [btnBack setBackgroundImage:[UIImage imageNamed:@"icon_navbar_back"] forState:UIControlStateNormal];
        [btnBack addTarget:self action:@selector(navigationLeftButtonAction) forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kPANavigationHeight, kPANavigationHeight)];
        [rightButton setBackgroundImage:[UIImage imageNamed:@"icon_navbar_close"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(navigationRightButtonAction) forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightItem;
        self.navigationItem.leftBarButtonItem = leftItem;
        
}

-(void)navigationRightButtonAction{
        [self.thumbnailsPreviewDelegate thumbnailsPreviewControllerDidCancel:self];
}
-(void)navigationLeftButtonAction{
        [self.navigationController popViewControllerAnimated:YES];
}

@end
