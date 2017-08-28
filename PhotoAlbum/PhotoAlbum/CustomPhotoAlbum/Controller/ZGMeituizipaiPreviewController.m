//
//  ZGMeituizipaiPreviewController.m
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/4.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGMeituizipaiPreviewController.h"
#import "ZGPAHeader.h"
#import "ZGPAViewModel.h"
#import "ZGMeituizipaiPreviewImageCell.h"
#import "ZGMeituizipaiPreviewVideoCell.h"
#import "ZGCutView.h"
#import "SNPhotoEditorsController.h"
#import "ZGVCMainViewController.h"
#import "ZGFolderViewController.h"

@interface ZGMeituizipaiPreviewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, ZGPAImageCropperDelegate, SNPhotoEditorsControllerDelegate, ZGVCMainViewControllerDelegate>{
        NSString *tabBarRightButton;
        UIButton *_navigationRightButton;
        UIButton *_navigationLeftButton;
}
@property(nonatomic, strong) SNPhotoEditorsController *photoEditor;/**<#注释#>*/

@property(nonatomic, strong) ZGPhotoAlbumPickerBar *pickerBar;/**工具栏*/
@property(nonatomic, strong) UICollectionView *myCollectionView;/**大图展示VIew*/
@property(nonatomic, assign) NSInteger indexPath;/**当前cell的位置*/
@property(nonatomic, assign) NSInteger  allSelectedAssetNum;/**已选最大数*/

@property(nonatomic, strong) NSMutableArray *meituizipaiPreviewData;/**数据源*/
@property(nonatomic, strong) ZGCutView *cutView;/**截图View*/
@property(nonatomic, strong) NSURL *videoURL;/**视频URL*/
@property(nonatomic, assign) NSInteger videoTimer;/**当前视频的时长*/
@property(nonatomic, assign) BOOL  isTouch;/**<#注释#>*/




@end

@implementation ZGMeituizipaiPreviewController

- (NSMutableArray *)meituizipaiPreviewData
{
        if (!_meituizipaiPreviewData) {
                _meituizipaiPreviewData = [NSMutableArray array];
        }
        return _meituizipaiPreviewData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
        self.view.backgroundColor = kPAColor(37, 37, 38, 0.95);
       //获取数据
        if ([self.folderTitel isEqualToString:@"ZGMeituizipaiPreviewController"]) {
                for (PHAsset *asset in self.meituizipaiSelectedAssetData) {
                        [self.meituizipaiPreviewData addObject:asset];
                }
        }else{
                self.meituizipaiPreviewData = [ZGPAViewModel accordingToTheCollectionTitleOfLodingPHAsset:self.folderTitel];
                if (self.updataMeituizipaiAssets.count != 0) {
                        NSArray *keys = [self.updataMeituizipaiAssets allKeys];
                        for (int i = 0; i < keys.count; i++) {
                                NSString *key = keys[i];
                                PHAsset *newAsset = [self.updataMeituizipaiAssets objectForKey:key];
                                NSInteger index = [key integerValue];
                                [self.meituizipaiPreviewData replaceObjectAtIndex:index withObject:newAsset];

                        }
                }
        }
        
        
        self.indexPath = self.indexPathRow;
        [self initMeituizipaiPreviewSubViews];
}


-(void)initMeituizipaiPreviewSubViews{
        [self updataPickerViewItem:self.indexPathRow];
        if (self.whetherTheScreenshots == YES) {
                if (self.cutView) {
                        [self.cutView removeFromSuperview];
                }
                UIImage *image = [ZGPAViewModel createAccessToImage:self.meituizipaiSelectdAsset imageSize:CGSizeMake(self.meituizipaiSelectdAsset.pixelWidth * 0.8, self.meituizipaiSelectdAsset.pixelHeight * 0.8) contentMode:PHImageContentModeAspectFill];
                
                CGFloat x = (kPAMainScreenWidth - self.screenshotsSize.width) / 2;
                CGFloat y = (kPAMainScreenHeight - kPANavigationHeight - self.screenshotsSize.height) / 2;

                self.cutView = [[ZGCutView alloc] initWithFrame:CGRectMake(0, kPANavigationHeight, kPAMainScreenWidth, kPAMainScreenHeight - kPANavigationHeight) Image:image cropFrame:CGRectMake(x,y, self.screenshotsSize.width, self.screenshotsSize.height) limitScaleRatio:1];
                self.cutView.delegate = self;
                [self.view addSubview:self.cutView];
        }else if(self.whetherTheScreenshots == NO){
                [self initCollectionView];
                self.allSelectedAssetNum = 0;
                self.allSelectedAssetNum = self.selectedNumber + self.meituizipaiSelectedAssetData.count;
                //更新导航栏
                [self updateNavigationBarButtonSelected:self.indexPathRow];
                [self.pickerBar isHiden:NO];


        }
}
#pragma mark - 截图之后的图片
- (void)imageCropper:(ZGCutView *)cropperViewController didFinished:(UIImage *)editedImage {

#warning mark - image转为PHAsset类型

        NSError *error;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                [PHAssetChangeRequest creationRequestForAssetFromImage:editedImage];
                
        } error:&error];
        PHAsset *asset = [ZGPAViewModel lastAsset];
        
        [self.meituizipaiSelectedAssetData addObject:asset];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"chooseToComplete" object:nil userInfo:@{@"dataAsset":self.meituizipaiSelectedAssetData}];
        [ZGPAViewModel removeLastAsset];
        [self dismissViewControllerAnimated:YES completion:nil];

}
/*******************************************滚动视图*****************************************************/
//初始化CollectionView编辑
-(void)initCollectionView{
        if (self.myCollectionView) {
                [self.myCollectionView removeFromSuperview];
        }
        self.automaticallyAdjustsScrollViewInsets = NO;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake( kPAMainScreenWidth, kPAMainScreenHeight - kPAMainToolsHeight- kPANavigationHeight);
        self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,kPANavigationHeight, kPAMainScreenWidth, kPAMainScreenHeight - kPAMainToolsHeight - kPANavigationHeight) collectionViewLayout:layout];
        self.myCollectionView.backgroundColor = kPAColor(37, 37, 38, 1);
        self.myCollectionView.dataSource = self;
        self.myCollectionView.delegate = self;
        self.myCollectionView.bounces = NO;
        self.myCollectionView.pagingEnabled = YES;
        self.myCollectionView.showsHorizontalScrollIndicator = NO;
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self.myCollectionView addGestureRecognizer:tap];
        
        [self.view addSubview:self.myCollectionView];
        //注册
        [self.myCollectionView registerClass:[ZGMeituizipaiPreviewImageCell class] forCellWithReuseIdentifier:@"ImageCell"];
        [self.myCollectionView registerClass:[ZGMeituizipaiPreviewVideoCell class] forCellWithReuseIdentifier:@"VideoCell"];
        //跳转到指定位置
        self.myCollectionView.contentOffset = CGPointMake(kPAMainScreenWidth * self.indexPathRow, 0);


}
-(void)tapAction:(UITapGestureRecognizer *)tap{
}

#pragma mark - UICollectionViewDataSource method
//返回section 的数量
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
        return 1;
}
//返回对应section的item 的数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return self.meituizipaiPreviewData.count;
}
//创建和复用cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        ZGMeituizipaiPreviewImageCell *cell = (ZGMeituizipaiPreviewImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
               // 从asset中获得图片
        PHAsset *asset = self.meituizipaiPreviewData[indexPath.row];
        if (asset.hidden == NO) {
                if (asset.mediaType == PHAssetMediaTypeVideo) {
                        ZGMeituizipaiPreviewVideoCell *videoCell = (ZGMeituizipaiPreviewVideoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"VideoCell" forIndexPath:indexPath];
                        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
                        options.version = PHImageRequestOptionsVersionCurrent;
                        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
                        PHImageManager *manager = [PHImageManager defaultManager];
                        [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                                
                                AVURLAsset *urlAsset = (AVURLAsset *)asset;
                                [videoCell initVideoView:urlAsset.URL];
                        }];
                        return videoCell;
                }else if (asset.mediaType == PHAssetMediaTypeImage) {
                        // 设定尺寸
                        
                        CGSize size = CGSizeMake(asset.pixelWidth * 0.5, asset.pixelHeight * 0.5);
                        cell.imageView.image = [ZGPAViewModel createAccessToImage:asset imageSize:size contentMode:PHImageContentModeAspectFill];
                        
                }
        }
        
        return cell;
}
#pragma mark - UICollectionViewDelegate method
// 滚动视图减速完成，滚动将停止时，调用该方法。一次有效滑动，只执行一次。
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
        NSInteger index = scrollView.contentOffset.x / kPAMainScreenWidth;
        [self updataPickerViewItem:index];
}
//滚动停止
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
        CGPoint estimateContentOffset = CGPointMake(targetContentOffset -> x, targetContentOffset -> y);
        self.indexPath = estimateContentOffset.x / kPAMainScreenWidth;
       
        [self updataPickerViewItem:self.indexPath];
        


}
//将要滚动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
        NSInteger row = scrollView.contentOffset.x / kPAMainScreenWidth;
        PHAsset *asset = self.meituizipaiPreviewData[row];
                if (asset.mediaType == PHAssetMediaTypeVideo) {
                        ZGMeituizipaiPreviewVideoCell *videoCell =  (ZGMeituizipaiPreviewVideoCell *)[_myCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                        [videoCell.player pause];
                        videoCell.playButton.hidden = NO;
                }else{
                        ZGMeituizipaiPreviewImageCell *cell =  (ZGMeituizipaiPreviewImageCell *)[_myCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                        [cell restore];//恢复

                }
        
}
/**
 * Cell将要出现的时候调用该方法
 */
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0){
        [self updataPickerViewItem:indexPath.row];
}

#pragma mark - UICollectionViewDelegateFlowLayout method
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        return CGSizeMake( kPAMainScreenWidth, kPAMainScreenHeight - kPAMainToolsHeight- kPANavigationHeight);
}


/********************************************工具栏与导航****************************************************/
-(void)initNavigationViewController:(PHAsset *)asset{

        if (_navigationLeftButton) {
                [_navigationLeftButton removeFromSuperview];
        }
        if (_navigationRightButton) {
                [_navigationRightButton removeFromSuperview];
        }
        
        //设置导航标题卡
        self.navigationItem.title = @"";
        //设置导航栏颜色
        self.navigationController.navigationBar.barTintColor = kPANavigationViewColor;
        //返回按钮
        _navigationLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_navigationLeftButton addTarget:self action:@selector(navigationLeftButtonAction:) forControlEvents:UIControlEventTouchDown];
        [_navigationLeftButton setImage:[UIImage imageNamed:@"icon_navbar_back"] forState:UIControlStateNormal];
        _navigationLeftButton.frame = CGRectMake(0, 0, kPANavigationHeight, kPANavigationHeight);
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_navigationLeftButton];
        //右边按钮
        _navigationRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_navigationRightButton addTarget:self action:@selector(navigationRightButtonAction:) forControlEvents:UIControlEventTouchDown];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_navigationRightButton];

        if (asset.mediaType == PHAssetMediaTypeVideo){//大图预览页面
                if (self.isPicturesAndVideoCombination == YES) {
                        _navigationRightButton.frame = CGRectMake(0, 0, kPANavigationHeight / 1.5, kPANavigationHeight / 1.5);
                        _navigationRightButton.layer.borderColor = kPAColor(230, 230, 230, 1.0).CGColor;
                        _navigationRightButton.layer.borderWidth = 1.0;
                        _navigationRightButton.layer.cornerRadius = 14.666;
                        _navigationRightButton.layer.masksToBounds = YES;
                        [_navigationLeftButton setImage:[UIImage imageNamed:@"icon_navbar_back"] forState:UIControlStateNormal];
                        [_navigationRightButton setTitleColor:kPAColor(230, 230, 230, 1.0) forState:UIControlStateNormal];
                        [_navigationRightButton setTitleColor:kPAColor(230, 230, 230, 1.0) forState:UIControlStateSelected];
                        _navigationRightButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold"  size:20];
                        [_navigationRightButton setBackgroundImage:[UIImage imageNamed:@"icon_navbar_ok"] forState:UIControlStateNormal];
                        [_navigationRightButton setBackgroundImage:[UIImage imageNamed:@"video_record"] forState:UIControlStateSelected];
                        
                        [_navigationRightButton setTitle:@"" forState:UIControlStateNormal];
                        _navigationRightButton.selected = NO;
                        

                }else{
                        _navigationRightButton.hidden = YES;

                }
                
        }else{
                if (self.whetherTheScreenshots == NO) {
                        _navigationRightButton.frame = CGRectMake(0, 0, kPANavigationHeight / 1.5, kPANavigationHeight / 1.5);
                        _navigationRightButton.layer.borderColor = kPAColor(230, 230, 230, 1.0).CGColor;
                        _navigationRightButton.layer.borderWidth = 1.0;
                        _navigationRightButton.layer.cornerRadius = 14.666;
                        _navigationRightButton.layer.masksToBounds = YES;
                        [_navigationRightButton setTitleColor:kPAColor(230, 230, 230, 1.0) forState:UIControlStateNormal];
                        [_navigationRightButton setTitleColor:kPAColor(230, 230, 230, 1.0) forState:UIControlStateSelected];
                        _navigationRightButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold"  size:20];
                        [_navigationRightButton setBackgroundImage:[UIImage imageNamed:@"icon_navbar_ok"] forState:UIControlStateNormal];
                        [_navigationRightButton setBackgroundImage:[UIImage imageNamed:@"video_record"] forState:UIControlStateSelected];
                        
                        [_navigationRightButton setTitle:@"" forState:UIControlStateNormal];
                        _navigationRightButton.selected = NO;
                }else{
                        _navigationRightButton.frame = CGRectMake(0, 0, kPANavigationHeight , kPANavigationHeight);
                        [_navigationRightButton setBackgroundImage:[UIImage imageNamed:@"icon_navbar_ok"] forState:UIControlStateNormal];
                }
                

        }
        
        
}

//导航选择按钮
-(void)navigationRightButtonAction:(UIButton *)sender{
        sender.selected = !sender.selected;
        if (self.whetherTheScreenshots == YES) {
                //截图确认按钮
                [self.cutView confirm];
                sender.selected = NO;
                [self.cutView reloadInputViews];
                
                
        }else{
                if (self.allSelectedAssetNum <= self.optionalMaximumNumber-1) {
                        if (sender.selected == YES) {
                                [self.meituizipaiSelectedAssetData addObject:self.meituizipaiPreviewData[self.indexPath]];
                        }else{
                                //删除对应的PHAsset
                                [self.meituizipaiSelectedAssetData removeObject:self.meituizipaiPreviewData[self.indexPath]];
                        }
                }else{
                        if (sender.selected == NO) {
                                //删除对应的PHAsset
                                [self.meituizipaiSelectedAssetData removeObject:self.meituizipaiPreviewData[self.indexPath]];
                                sender.selected = NO;
                        }else{
                                [self.meituizipaiSelectedAssetData addObject:self.meituizipaiPreviewData[self.indexPath]];
                                [self.meituizipaiSelectedAssetData removeObject:self.meituizipaiPreviewData[self.indexPath]];
                                sender.selected = NO;
                                
                                if (self.selectedNumber == 0) {
                                        [ZGPAViewModel aliertControllerTitle:[NSString stringWithFormat:@"最多能选%lu张图片", self.optionalMaximumNumber] viewController:self];
                                }else{
                                        [ZGPAViewModel aliertControllerTitle:[NSString stringWithFormat:@"已选择%lu张图片, 本次最多能选%lu张图片", self.selectedNumber,self.optionalMaximumNumber - self.selectedNumber] viewController:self];
                                }
                        }
                        
                }
                
                
                [self updateNavigationBarButtonSelected:self.indexPath];
                self.allSelectedAssetNum = 0;
                self.allSelectedAssetNum = self.selectedNumber + self.meituizipaiSelectedAssetData.count;
        }
}

//导航返回按钮
-(void)navigationLeftButtonAction:(UIButton *)sender{
        if (self.isOriginalImage == YES) {
                [self.delegate selectedAssetArray:self.meituizipaiSelectedAssetData isOriginalImage: YES];

        }else{
                [self.delegate selectedAssetArray:self.meituizipaiSelectedAssetData isOriginalImage: NO];

        }
        PHAsset *asset = self.meituizipaiPreviewData[self.indexPath];
        if (asset.mediaType == PHAssetMediaTypeVideo) {
                ZGMeituizipaiPreviewVideoCell *videoCell =  (ZGMeituizipaiPreviewVideoCell *)[_myCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.indexPath inSection:0]];
                [videoCell.player pause];
                videoCell.playButton.hidden = NO;
        }

        [self.navigationController popViewControllerAnimated:YES];
       }

//更新导航按钮标题和点击状态
-(void)updateNavigationBarButtonSelected:(NSInteger)index{
        
        PHAsset *imageAsset = self.meituizipaiPreviewData[index];
        for (int j = 0; j < self.meituizipaiSelectedAssetData.count; j++) {
                PHAsset *asset = self.meituizipaiSelectedAssetData[j];
                if ([asset isEqual:imageAsset]) {
                        [_navigationRightButton setTitle:[NSString stringWithFormat:@"%d", j + 1] forState:UIControlStateSelected];
                        _navigationRightButton.selected = YES;
                }
        }
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
//更新工具栏按钮
-(void)updataPickerViewItem:(NSInteger)index{
        if (self.pickerBar) {
                [self.pickerBar removeFromSuperview];
        }
        PHAsset *asset = self.meituizipaiPreviewData[index];

        if (self.whetherTheScreenshots == NO){
                __weak typeof(self) weakSelf = self;
                if (asset.mediaType == PHAssetMediaTypeVideo) {
                        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
                        options.version = PHImageRequestOptionsVersionOriginal;
                        options.deliveryMode = PHVideoRequestOptionsDeliveryModeHighQualityFormat;
                        
                        PHImageManager *manager = [PHImageManager defaultManager];
                                // 这里放任务代码
                                [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset,AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                                        AVURLAsset *urlAsset = (AVURLAsset *)asset;
                                        weakSelf.videoTimer = urlAsset.duration.value / urlAsset.duration.timescale;
                                        weakSelf.videoURL = [[NSURL alloc] init];
                                        weakSelf.videoURL = urlAsset.URL;
                                }];
                        }
                //更新导航栏和工具栏
                if (asset.mediaType == PHAssetMediaTypeVideo) {
                //是视频
                        
                        if (self.whetherToEditVideo == YES) {
                                //视屏和图片都可编辑
                                if(_videoTimer < self.maximumTimeVideo){//视频时间小于最大限制时间
                                        _pickerBar = [[ZGPhotoAlbumPickerBar alloc] initWithFrame:CGRectMake(0, kPAMainScreenHeight -kPAMainToolsHeight, kPAMainScreenWidth, kPAMainToolsHeight) isOldPickerBar:NO];
                                        [_pickerBar.leftButton setImage:[UIImage imageNamed:@"icon_navbar_edit"] forState:UIControlStateNormal];
                                        [_pickerBar.leftButton addTarget:self action:@selector(videoEditButton) forControlEvents:UIControlEventTouchDown];
                                        if (self.isPicturesAndVideoCombination == YES) {
                                                [_pickerBar.rightButton setImage:[UIImage imageNamed:@"icon_navbar_send_blue"] forState:UIControlStateNormal];

                                        }else{
                                                [_pickerBar.rightButton setImage:[UIImage imageNamed:@"icon_navbar_ok"] forState:UIControlStateNormal];

                                        }
                                        [_pickerBar.rightButton addTarget:self action:@selector(videoSndButton) forControlEvents:UIControlEventTouchDown];
                                        
                                }else{
                                        _pickerBar = [[ZGPhotoAlbumPickerBar alloc] initWithFrame:CGRectMake(0, kPAMainScreenHeight -kPAMainToolsHeight, kPAMainScreenWidth, kPAMainToolsHeight) isOldPickerBar:NO];
                                        [_pickerBar.leftButton setImage:[UIImage imageNamed:@"icon_navbar_edit"] forState:UIControlStateNormal];
                                        [_pickerBar.leftButton addTarget:self action:@selector(videoEditButton) forControlEvents:UIControlEventTouchDown];
                                       
                                                [_pickerBar.rightButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                                
                                }
                        }else{
                                //视频不可编辑
                                        _pickerBar = [[ZGPhotoAlbumPickerBar alloc] initWithFrame:CGRectMake(0, kPAMainScreenHeight - kPAMainToolsHeight, kPAMainScreenWidth, kPAMainToolsHeight) isOldPickerBar:NO];
                                        [_pickerBar.leftButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                                        _pickerBar.leftButton.hidden = YES;
                                        if (self.isPicturesAndVideoCombination == YES) {
                                                [_pickerBar.rightButton setImage:[UIImage imageNamed:@"icon_navbar_send_blue"] forState:UIControlStateNormal];
                                        }else{
                                                [_pickerBar.rightButton setImage:[UIImage imageNamed:@"icon_navbar_ok"] forState:UIControlStateNormal];
                                                
                                        }

                                        [_pickerBar.rightButton addTarget:self action:@selector(videoSndButton) forControlEvents:UIControlEventTouchDown];
                                }
                }else{
                //是图片
                        if (self.whetherToEditPictures == YES) {
                                _pickerBar = [[ZGPhotoAlbumPickerBar alloc] initWithFrame:CGRectMake(0, kPAMainScreenHeight -kPAMainToolsHeight, kPAMainScreenWidth, kPAMainToolsHeight) isOldPickerBar:NO];
                                [_pickerBar.leftButton setImage:[UIImage imageNamed:@"icon_navbar_edit"] forState:UIControlStateNormal];
                                [_pickerBar.leftButton addTarget:self action:@selector(imageEditButton) forControlEvents:UIControlEventTouchDown];
                                if (self.isPicturesAndVideoCombination == YES) {
                                        [_pickerBar.rightButton setImage:[UIImage imageNamed:@"icon_navbar_send_blue"] forState:UIControlStateNormal];
                                }else{
                                        [_pickerBar.rightButton setImage:[UIImage imageNamed:@"icon_navbar_ok"] forState:UIControlStateNormal];
                                }
                                [_pickerBar.rightButton addTarget:self action:@selector(imageSndButton) forControlEvents:UIControlEventTouchDown];
                        }else{
                                _pickerBar = [[ZGPhotoAlbumPickerBar alloc] initWithFrame:CGRectMake(0, kPAMainScreenHeight -kPAMainToolsHeight, kPAMainScreenWidth, kPAMainToolsHeight) isOldPickerBar:NO];
                                [_pickerBar.leftButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                                _pickerBar.leftButton.hidden = YES;
                                if (self.isPicturesAndVideoCombination == YES) {
                                        [_pickerBar.rightButton setImage:[UIImage imageNamed:@"icon_navbar_send_blue"] forState:UIControlStateNormal];
                                }else{
                                        [_pickerBar.rightButton setImage:[UIImage imageNamed:@"icon_navbar_ok"] forState:UIControlStateNormal];
                                }
                                [_pickerBar.rightButton addTarget:self action:@selector(imageSndButton) forControlEvents:UIControlEventTouchDown];
                        }
                //是否要原图
                        if (self.isSendTheOriginalPictures == YES) {
                                [_pickerBar.originalImageButton addTarget:self action:@selector(originalImageButtonAction:) forControlEvents:   UIControlEventTouchDown];
                                if (self.isOriginalImage == YES) {
                                        self.pickerBar.originalImageButton.selected = YES;
                                        [_pickerBar.originalImageButton setImage:[UIImage imageNamed:@"icon_navbar_image_green"] forState:UIControlStateSelected];
                                }else{
                                        self.pickerBar.originalImageButton.selected = NO;
                                        [_pickerBar.originalImageButton setImage:[UIImage imageNamed:@"icon_navbar_album"] forState:UIControlStateNormal];
                                }
                        }else{
                                [_pickerBar.originalImageButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
   
                        }
                }
                self.pickerBar.isHiden = YES;
                [self.view addSubview:self.pickerBar];
        }
        [self initNavigationViewController:asset];
        [self updateNavigationBarButtonSelected:self.indexPath];

}
//视频发送(完成)按钮
-(void)videoSndButton{
        if (self.isPicturesAndVideoCombination == NO) {
                if (self.selectedNumber != 0 || self.meituizipaiSelectedAssetData.count != 0){
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"chooseToComplete" object:nil userInfo:@{@"dataAsset":self.meituizipaiSelectedAssetData}];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"isOriginalImage" object:nil userInfo:@{@"Value":self.pickerBar.originalImageButton}];
                        [self dismissViewControllerAnimated:YES completion:nil];
                } else{
                        PHAsset *asset = self.meituizipaiPreviewData[self.indexPath];
                        [self.meituizipaiSelectedAssetData addObject:asset];
                         [[NSNotificationCenter defaultCenter]postNotificationName:@"chooseToComplete" object:nil userInfo:@{@"dataAsset":self.meituizipaiSelectedAssetData}];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"isOriginalImage" object:nil userInfo:@{@"Value":self.pickerBar.originalImageButton}];
                        [self dismissViewControllerAnimated:YES completion:nil];

                        
                }
        }else{
        
                if (self.meituizipaiSelectedAssetData.count == 0) {
                        PHAsset *asset = self.meituizipaiPreviewData[self.indexPath];
                        [self.meituizipaiSelectedAssetData addObject:asset];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"chooseToComplete" object:nil userInfo:@{@"dataAsset":self.meituizipaiSelectedAssetData}];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"isOriginalImage" object:nil userInfo:@{@"Value":self.pickerBar.originalImageButton}];
                        [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"chooseToComplete" object:nil userInfo:@{@"dataAsset":self.meituizipaiSelectedAssetData}];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"isOriginalImage" object:nil userInfo:@{@"Value":self.pickerBar.originalImageButton}];
                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                }


        }
        
}
//视频编辑按钮
-(void)videoEditButton{
        
        // 视频编辑
        ZGVCMainViewController *zgVC = [ZGVCMainViewController new];
        zgVC.vcURL = self.videoURL;
        zgVC.vcDelegate = self;
        zgVC.lengthNumber = self.maximumTimeVideo;
        zgVC.isPicturesAndVideoCombination = self.isPicturesAndVideoCombination;
        zgVC.fromViewController = self.fromViewController;
        [self presentViewController:zgVC animated:YES completion:nil];
}
//图片发送按钮
-(void)imageSndButton{
        if (self.meituizipaiSelectedAssetData.count == 0) {
                PHAsset *asset = self.meituizipaiPreviewData[self.indexPath];
                [self.meituizipaiSelectedAssetData addObject:asset];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"chooseToComplete" object:nil userInfo:@{@"dataAsset":self.meituizipaiSelectedAssetData}];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"isOriginalImage" object:nil userInfo:@{@"Value":self.pickerBar.originalImageButton}];
                [self dismissViewControllerAnimated:YES completion:nil];
        }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"chooseToComplete" object:nil userInfo:@{@"dataAsset":self.meituizipaiSelectedAssetData}];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"isOriginalImage" object:nil userInfo:@{@"Value":self.pickerBar.originalImageButton}];
                [self dismissViewControllerAnimated:YES completion:nil];

        }
        
}
//图片编辑按钮
-(void)imageEditButton{
        //图片编辑
        PHAsset *asset = self.meituizipaiPreviewData[self.indexPath];
        self.photoEditor = [SNPhotoEditorsController new];
        self.photoEditor.delegate = self;
        self.photoEditor.collectionTitle = self.folderTitel;
        self.photoEditor.mainAsset = asset;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.photoEditor];
        [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - SNPhotoEditorsControllerDelegate
-(void)photoEditorSaveImage:(PHAsset *)asset newAsset:(PHAsset *)newAsset{
        //这时已经保存到相册中了, 所以才能拿到对应的Asset
        //获取到新的Asset, 替换当前页面对应的旧Asset, 返回到上个页面时, 替换到对应的Asset;
        [self.meituizipaiPreviewData replaceObjectAtIndex:self.indexPath withObject:newAsset];
        [_myCollectionView reloadData];
        for (int i = 0; i < self.meituizipaiSelectedAssetData.count; i++) {
                PHAsset *selectedAsset = self.meituizipaiSelectedAssetData[i];
                if ([selectedAsset isEqual:asset]) {
                        [self.meituizipaiSelectedAssetData replaceObjectAtIndex:i withObject:newAsset];
                }
        }
        [self.delegate newAsset:newAsset oldAsset:asset];
}


#pragma mark - ZGVCMainViewControllerDelegate
//返回的asset
-(void)cuttingVideoAsset:(PHAsset *)asset{
        
        //如果是合选, 则加入数组中
        PHAsset *oldAsset = [self.meituizipaiPreviewData objectAtIndex:self.indexPath];
        if (self.isPicturesAndVideoCombination == YES) {
                [self.meituizipaiPreviewData replaceObjectAtIndex:self.indexPath withObject:asset];
                [_myCollectionView reloadData];
                for (int i = 0; i < self.meituizipaiSelectedAssetData.count; i++) {
                        PHAsset *selectedAsset = self.meituizipaiSelectedAssetData[i];
                        if ([selectedAsset isEqual:asset]) {
                                [self.meituizipaiSelectedAssetData replaceObjectAtIndex:i withObject:asset];
                        }
                }
                [self.delegate newAsset:asset oldAsset:oldAsset];

        }else{//否则直接返回编辑完成的视频(判断选择数组中是否有值, 有则询问, 没有直接dis掉页面)
                [self.meituizipaiSelectedAssetData addObject:asset];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"chooseToComplete" object:nil userInfo:@{@"dataAsset":self.meituizipaiSelectedAssetData}];
        }
}

-(void)viewWillLayoutSubviews{
        self.myCollectionView.frame = CGRectMake(0,kPANavigationHeight, kPAMainScreenWidth, kPAMainScreenHeight - kPAMainToolsHeight - kPANavigationHeight);
        self.pickerBar.frame = CGRectMake(0, kPAMainScreenHeight - kPAMainToolsHeight, kPAMainScreenWidth, kPAMainToolsHeight);
}

-(BOOL)prefersStatusBarHidden
{
        return YES;// 返回YES表示隐藏，返回NO表示显示
}

- (void)dealloc
{
        self.photoEditor = nil;
        self.pickerBar = nil;
        self.myCollectionView = nil;
        self.meituizipaiPreviewData = nil;
        self.meituizipaiSelectdAsset = nil;
        self.cutView = nil;
        self.videoURL = nil;
}


@end
