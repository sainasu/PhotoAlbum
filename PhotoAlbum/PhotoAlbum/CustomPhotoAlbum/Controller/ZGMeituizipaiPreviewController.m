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

@interface ZGMeituizipaiPreviewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, ZGPAImageCropperDelegate, SNPhotoEditorsControllerDelegate, ZGVCMainViewControllerDelegate>{
        NSString *tabBarRightButton;
        UIButton *_navigationRightButton;
        UIButton *_navigationLeftButton;
}
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
               if ([self.folderName isEqualToString:@"ZGMeituizipaiPreviewController"]) {
                for (PHAsset *asset in self.meituizipaiSelectedAssetData) {
                        [self.meituizipaiPreviewData addObject:asset];
                }
        }else{
                self.meituizipaiPreviewData = [ZGPAViewModel accordingToTheCollectionTitleOfLodingPHAsset:self.folderName];
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

        [self initMeituizipaiPreviewSubViews];
        self.indexPath = self.indexPathRow;
        PHAsset *asset = _meituizipaiPreviewData[self.indexPath];
        if (asset.mediaType == PHAssetMediaTypeVideo) {
                PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
                options.version = PHImageRequestOptionsVersionCurrent;
                options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
                PHImageManager *manager = [PHImageManager defaultManager];
                [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                        
                        AVURLAsset *urlAsset = (AVURLAsset *)asset;
                        self.videoTimer = urlAsset.duration.value / urlAsset.duration.timescale;
                        self.videoURL = [[NSURL alloc] init];
                        self.videoURL = urlAsset.URL;
                        
                }];
        }
                              //初始化导航栏和工具栏
                        [self initPickerBar:self.barType];
                        [self initNavigationViewController:self.navigationBarStyle];
                        [self updataPickerViewItem:self.indexPath];
                        [self updateNavigationBarButtonSelected:self.indexPath];

 



}


-(void)initMeituizipaiPreviewSubViews{

        if (self.navigationBarStyle == ZGPANavigationBarStyleMeituizipaiPreviewOneImage) {
                if (self.cutView) {
                        [self.cutView removeFromSuperview];
                }
                UIImage *image = [ZGPAViewModel createAccessToImage:self.meituizipaiSelectdAsset imageSize:CGSizeMake(self.meituizipaiSelectdAsset.pixelWidth * 0.6, self.meituizipaiSelectdAsset.pixelHeight * 0.6) contentMode:PHImageContentModeAspectFill];
                
                CGFloat x = (kPAMainScreenWidth - self.CutViewSize.width) / 2;
                CGFloat y = (kPAMainScreenHeight - kPANavigationHeight - self.CutViewSize.height) / 2;

                self.cutView = [[ZGCutView alloc] initWithFrame:CGRectMake(0, kPANavigationHeight, kPAMainScreenWidth, kPAMainScreenHeight - kPANavigationHeight) Image:image cropFrame:CGRectMake(x,y, self.CutViewSize.width, self.CutViewSize.height) limitScaleRatio:1];
                self.cutView.delegate = self;
                [self.view addSubview:self.cutView];
        }else{
                [self initCollectionView];
                self.allSelectedAssetNum = 0;
                self.allSelectedAssetNum = self.existingCount + self.meituizipaiSelectedAssetData.count;
                [self updateNavigationBarButtonSelected:self.indexPathRow];
                [self.pickerBar isHiden:NO];


        }
}
#pragma mark -
- (void)imageCropper:(ZGCutView *)cropperViewController didFinished:(UIImage *)editedImage {
                [ZGPAViewModel aliertControllerTitle:[NSString stringWithFormat:@"截图之后的图片%@", editedImage] viewController:self];
}


/*******************************************截图View*****************************************************/



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
                        
                        CGSize size = CGSizeMake(asset.pixelWidth * 0.6, asset.pixelHeight * 0.6);
                        cell.imageView.image = [ZGPAViewModel createAccessToImage:asset imageSize:size contentMode:PHImageContentModeAspectFill];
                        
                }
        }
        
        return cell;
}
#pragma mark - UICollectionViewDelegate method
//点击了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}

// 滚动视图减速完成，滚动将停止时，调用该方法。一次有效滑动，只执行一次。
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
        NSInteger index = scrollView.contentOffset.x / kPAMainScreenWidth;
        [self updataPickerViewItem:index];
        [self updateNavigationBarButtonSelected:index];
}
//滚动停止
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
        CGPoint estimateContentOffset = CGPointMake(targetContentOffset -> x, targetContentOffset -> y);
        self.indexPath = estimateContentOffset.x / kPAMainScreenWidth;
       
        [self updataPickerViewItem:self.indexPath];
        [self updateNavigationBarButtonSelected:self.indexPath];


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
#pragma mark - UICollectionViewDelegateFlowLayout method
//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        return CGSizeMake( kPAMainScreenWidth, kPAMainScreenHeight - kPAMainToolsHeight- kPANavigationHeight);
}

/********************************************工具栏与导航****************************************************/
-(void)initNavigationViewController:(ZGPhotoAlbumNavigationBarStyle)naviBarStyle{
        if (_navigationLeftButton) {
                [_navigationLeftButton removeFromSuperview];
        }
        if (_navigationRightButton) {
                [_navigationRightButton removeFromSuperview];
        }
        //设置导航标题
        self.navigationItem.title = @"";
        //设置标题颜色
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        //设置状态栏
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        //设置导航栏颜色
        self.navigationController.navigationBar.barTintColor = kPANavigationViewColor;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        //取消navigationRightButtonAction
        _navigationLeftButton = [[UIButton alloc] init];
        [_navigationLeftButton addTarget:self action:@selector(navigationLeftButtonAction:) forControlEvents:UIControlEventTouchDown];
        _navigationRightButton = [[UIButton alloc] init];
        [_navigationRightButton addTarget:self action:@selector(navigationRightButtonAction:) forControlEvents:UIControlEventTouchDown];
        
        if (naviBarStyle == ZGPANavigationBarStyleFolder) {//文件夹页面
                _navigationLeftButton.enabled = NO;
                [_navigationRightButton setImage:[UIImage imageNamed:@"icon_navbar_close"] forState:UIControlStateNormal];
        }else if (naviBarStyle == ZGPANavigationBarStyleThumbnailsPerview){//小图预览页面
                [_navigationLeftButton setImage:[UIImage imageNamed:@"icon_navbar_back"] forState:UIControlStateNormal];
                [_navigationRightButton setImage:[UIImage imageNamed:@"icon_navbar_close"] forState:UIControlStateNormal];
                
        }else if (naviBarStyle == ZGPANavigationBarStyleMeituizipaiPreview){//大图预览页面
                [_navigationLeftButton setImage:[UIImage imageNamed:@"icon_navbar_back"] forState:UIControlStateNormal];
                [_navigationRightButton setTitleColor:kPAColor(230, 230, 230, 1.0) forState:UIControlStateNormal];
                [_navigationRightButton setTitleColor:kPAColor(230, 230, 230, 1.0) forState:UIControlStateSelected];
                _navigationRightButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold"  size:20];
                [_navigationRightButton setBackgroundImage:[UIImage imageNamed:@"icon_navbar_ok"] forState:UIControlStateNormal];
                [_navigationRightButton setBackgroundImage:[UIImage imageNamed:@"video_record"] forState:UIControlStateSelected];
                
                [_navigationRightButton setTitle:@"" forState:UIControlStateNormal];
                _navigationRightButton.selected = NO;
                
                
        }else if (naviBarStyle == ZGPANavigationBarStyleMeituizipaiPreviewVideo){//大图预览页面
                [_navigationLeftButton setImage:[UIImage imageNamed:@"icon_navbar_back"] forState:UIControlStateNormal];
                
                _navigationRightButton.hidden = YES;
                
        }else if (naviBarStyle == ZGPANavigationBarStyleMeituizipaiPreviewOneImage){
                [_navigationLeftButton setImage:[UIImage imageNamed:@"icon_navbar_back"] forState:UIControlStateNormal];
                [_navigationRightButton setImage:[UIImage imageNamed:@"icon_navbar_ok"] forState:UIControlStateNormal];
        }
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_navigationLeftButton];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_navigationRightButton];
        self.navigationItem.rightBarButtonItem = rightItem;
        self.navigationItem.leftBarButtonItem = leftItem;
        
}

//导航选择按钮
-(void)navigationRightButtonAction:(UIButton *)sender{
        sender.selected = !sender.selected;
        if (self.isTabBar == NO) {
                //截图确认按钮
                [self.cutView confirm];
                sender.selected = NO;
                [self.cutView reloadInputViews];
                
                
        }else{
                if (self.allSelectedAssetNum <= self.largestNumber-1) {
                        if (sender.selected == YES) {
                                [self.meituizipaiSelectedAssetData addObject:self.meituizipaiPreviewData[self.indexPath]];
                        }else{
                                //删除对应的PHAsset
                                [self.meituizipaiSelectedAssetData removeObject:self.meituizipaiPreviewData[self.indexPath]];
                        }
                }else{
                        //删除最后添加的
                        [self.meituizipaiSelectedAssetData addObject:self.meituizipaiPreviewData[self.indexPath]];
                        [self.meituizipaiSelectedAssetData removeObject:self.meituizipaiPreviewData[self.indexPath]];
                        sender.selected = NO;
                        [ZGPAViewModel aliertControllerTitle:[NSString stringWithFormat:@"只能选择%ld张图片",self.largestNumber - self.existingCount] viewController:self];
                        
                }
                
                
                [self updateNavigationBarButtonSelected:self.indexPath];
                self.allSelectedAssetNum = 0;
                self.allSelectedAssetNum = self.existingCount + self.meituizipaiSelectedAssetData.count;
        }
}

//导航返回按钮
-(void)navigationLeftButtonAction:(UIButton *)sender{
        if (self.isOriginalImage == YES) {
                [self.delegate selectedAssetDataArray:self.meituizipaiSelectedAssetData isOriginalImage: YES];

        }else{
                [self.delegate selectedAssetDataArray:self.meituizipaiSelectedAssetData isOriginalImage: NO];

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


-(void)initPickerBar:(ZGPhotoAlbumBarType)type{
        if (self.pickerBar) {
                [self.pickerBar removeFromSuperview];
        }
        
        if (self.isTabBar == YES){
                self.pickerBar = [[ZGPhotoAlbumPickerBar alloc] initWithFrame:CGRectMake(0, kPAMainScreenHeight - kPAMainToolsHeight, kPAMainScreenWidth, kPAMainToolsHeight) tabBarType:type];
                [self.pickerBar.leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchDown];
                [self.pickerBar.rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchDown];
                [_pickerBar.originalImageButton addTarget:self action:@selector(originalImageButtonAction:) forControlEvents:UIControlEventTouchDown];
                if (self.isOriginalImage == YES) {
                        self.pickerBar.originalImageButton.selected = YES;
                        [_pickerBar.originalImageButton setImage:[UIImage imageNamed:@"icon_navbar_image_green"] forState:UIControlStateSelected];
                }else{
                        self.pickerBar.originalImageButton.selected = NO;
                        [_pickerBar.originalImageButton setImage:[UIImage imageNamed:@"icon_navbar_album"] forState:UIControlStateNormal];
                                        }
                
                self.pickerBar.isHiden = YES;
                [self.view addSubview:self.pickerBar];
                
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
//工具栏左边按钮
-(void)leftButtonAction:(UIButton *)sender{
        if ( [tabBarRightButton isEqualToString: @"CircleOfFriends"]) {
                [ZGPAViewModel aliertControllerTitle:@"视频选择完成按钮--->朋友圈" viewController:self];
                
        }else{
                PHAsset *asset = self.meituizipaiPreviewData[self.indexPath];
                SNPhotoEditorsController *photoEditor = [SNPhotoEditorsController new];
                photoEditor.delegate = self;
                photoEditor.collectionTitle = self.folderName;
                photoEditor.mainAsset = asset;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:photoEditor];
                [self presentViewController:nav animated:YES completion:nil];
        }
}
//工具栏右边按钮
-(void)rightButtonAction:(UIButton *)sender{
        if ([tabBarRightButton isEqualToString:@"CircleOfFriends"]){//5朋友圈
               // 视频编辑
                ZGVCMainViewController *zgVC = [ZGVCMainViewController new];
                zgVC.vcURL = self.videoURL;
                zgVC.vcDelegate = self;
                zgVC.lengthNumber = self.maxCopVideoTimer;
                [self presentViewController:zgVC animated:YES completion:nil];
                
        }else if ([tabBarRightButton isEqualToString:@"CircleOfFriendsOK"]){//5朋友圈,
                [ZGPAViewModel aliertControllerTitle:@"已经选择了图片, 朋友圈发送已选图片" viewController:self];


        }else if ([tabBarRightButton isEqualToString:@"CollectingMeitiuzipaiVideo"]){// 6收藏
               PHAsset *asset = self.meituizipaiPreviewData[self.indexPath];
                if (asset.mediaType == PHAssetMediaTypeVideo) {
                        [ZGPAViewModel aliertControllerTitle:@"视频只能单个收藏" viewController:self];
                        //

                }else if (asset.mediaType == PHAssetMediaTypeImage){
                        [ZGPAViewModel aliertControllerTitle:@"图片可以设置限量收藏" viewController:self];
                        //
                }
        }else if ([tabBarRightButton isEqualToString:@"CollectingMeitiuzipaiVideoOK"]){// 6收藏
                [ZGPAViewModel aliertControllerTitle:@"已经选择了图片. 是否收藏已经选择的图片" viewController:self];

        }else{
                //self.meituizipaiSelectedAssetData;保存有选择的数据
                if (self.isOriginalImage == YES) {
                        [ZGPAViewModel aliertControllerTitle:@"聊天中发送图片(<原图>)||视频" viewController:self];
  
                }else{
                        [ZGPAViewModel aliertControllerTitle:@"聊天中发送图片||视频" viewController:self];
 
                }
               
                
        }
}


//更新工具栏按钮
-(void)updataPickerViewItem:(NSInteger)index{

               PHAsset *asset = self.meituizipaiPreviewData[index];
        if (asset.mediaType == PHAssetMediaTypeVideo) {
                PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
                options.version = PHImageRequestOptionsVersionCurrent;
                options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
                PHImageManager *manager = [PHImageManager defaultManager];
                [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                        
                        AVURLAsset *urlAsset = (AVURLAsset *)asset;
                        self.videoTimer = urlAsset.duration.value / urlAsset.duration.timescale;
                        self.videoURL = [[NSURL alloc] init];
                        self.videoURL = urlAsset.URL;
                }];
        }
        //更新导航栏和工具栏
        if (asset.mediaType == PHAssetMediaTypeVideo) {
                if (_photoAlibumStyle == ZGThumbnailsPreviewStyleSCircleOfFriends){//5朋友圈
                        if (self.meituizipaiSelectedAssetData.count != 0) {
                                [self initPickerBar:ZGPhotoAlbumBarTypeCollectingMeitiuzipaiVideo];
                                tabBarRightButton = @"CircleOfFriendsOK";

                        }else{
                                if(self.videoTimer < self.maxCopVideoTimer){
                                        [self initPickerBar:ZGPhotoAlbumBarTypeCircleOfFriendsMinVideo];
                                        
                                }else{
                                        [self initPickerBar:ZGPhotoAlbumBarTypeCircleOfFriendsVideo];
                                        
                                }
                                tabBarRightButton = @"CircleOfFriends";

                        }


                        [self initNavigationViewController:ZGPANavigationBarStyleMeituizipaiPreviewVideo];
                        
                        
                }else if (_photoAlibumStyle == ZGThumbnailsPreviewStyleCollection){// 6收藏
                        if (self.meituizipaiSelectedAssetData.count == 0) {
                                tabBarRightButton = @"CollectingMeitiuzipaiVideo";
                        }else{
                                tabBarRightButton = @"CollectingMeitiuzipaiVideoOK";
    
                        }
                        [self initPickerBar:ZGPhotoAlbumBarTypeCollectingMeitiuzipaiVideo ];
                        [self initNavigationViewController:ZGPANavigationBarStyleMeituizipaiPreviewVideo];
                        
                }else if (_photoAlibumStyle == ZGThumbnailsPreviewStyleChat){
                        
                        [self initPickerBar:ZGPhotoAlbumBarTypeChatMeitiuzipaiPreviewVideo ];
                        [self initNavigationViewController:ZGPANavigationBarStyleMeituizipaiPreview];
                        
                }else{
                        [self initPickerBar:ZGPhotoAlbumBarTypeCollectingMeitiuzipaiVideo ];
                        [self initNavigationViewController:ZGPANavigationBarStyleMeituizipaiPreview];
                }
        }else{
                if (_photoAlibumStyle == ZGThumbnailsPreviewStyleSCircleOfFriends){//5朋友圈
                        tabBarRightButton = @"CircleOfFriendsOK";
                        [self initPickerBar:ZGPhotoAlbumBarTypeCircleOfFriendsImage];
                        [self initNavigationViewController:ZGPANavigationBarStyleMeituizipaiPreview];
                        
                }else if (_photoAlibumStyle == ZGThumbnailsPreviewStyleCollection){// 6收藏
                        [self initPickerBar:ZGPhotoAlbumBarTypeCircleOfFriendsImage];
                        [self initNavigationViewController:ZGPANavigationBarStyleMeituizipaiPreview];
                        tabBarRightButton = @"CollectingMeitiuzipaiVideo";
                        
                }else{
                        [self initPickerBar:ZGPhotoAlbumBarTypeChatMeitiuzipaiImage ];
                        [self initNavigationViewController:ZGPANavigationBarStyleMeituizipaiPreview];
                        
                }
        }
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
//返回的URL
-(void)cuttingVideoAsset:(NSURL *)url{
//视频编辑完成之后直接发送, 没有发送按钮
        [ZGPAViewModel aliertControllerTitle:@"视频编辑完成之后直接发送, 没有发送按钮" viewController:self];


}
-(void)viewWillLayoutSubviews{
        self.myCollectionView.frame = CGRectMake(0,kPANavigationHeight, kPAMainScreenWidth, kPAMainScreenHeight - kPAMainToolsHeight - kPANavigationHeight);
        self.pickerBar.frame = CGRectMake(0, kPAMainScreenHeight - kPAMainToolsHeight, kPAMainScreenWidth, kPAMainToolsHeight);
        if (self.navigationBarStyle == ZGPANavigationBarStyleMeituizipaiPreview){//大图预览页面
                _navigationLeftButton.frame = CGRectMake(0, 0, kPANavigationHeight, kPANavigationHeight);
                _navigationRightButton.frame = CGRectMake(0, 0, kPANavigationHeight / 1.5, kPANavigationHeight / 1.5);
                _navigationRightButton.layer.borderColor = kPAColor(230, 230, 230, 1.0).CGColor;
                _navigationRightButton.layer.borderWidth = 1.0;
                _navigationRightButton.layer.cornerRadius = 14.666;
                _navigationRightButton.layer.masksToBounds = YES;
        }else{
                _navigationLeftButton.frame = CGRectMake(0, 0, kPANavigationHeight, kPANavigationHeight);
                _navigationRightButton.frame = CGRectMake(0, 0, kPANavigationHeight, kPANavigationHeight);
        }
}

-(BOOL)prefersStatusBarHidden
{
        return YES;// 返回YES表示隐藏，返回NO表示显示
}



@end
