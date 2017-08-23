//
//  ZGThumbnailsPreviewController.m
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/4.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGThumbnailsPreviewController.h"
#import "ZGPAViewModel.h"
#import "ZGThumbnailsPreviewImageCell.h"
#import "ZGThumbnailsPreviewVideoCell.h"
#import "ZGMeituizipaiPreviewController.h"

static NSString * const CellReuseIdentify = @"CellReuseIdentify";
static NSString * const CellImageReuseIdentify = @"CellImageReuseIdentify";

static NSString * const SupplementaryViewHeaderIdentify = @"SupplementaryViewHeaderIdentify";
static NSString * const SupplementaryViewFooterIdentify = @"SupplementaryViewFooterIdentify";


@interface ZGThumbnailsPreviewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate , ZGMeituizipaiPreviewControllerDelegate>{
         UICollectionView *_myCollectionView;
        
}
@property(nonatomic, strong) NSMutableArray *thumbnailsPerviewData;/**小图预览数据源*/
@property(nonatomic, strong) NSMutableArray *thumbnailsSelectedAsset;/**选择的数据源*/
@property(nonatomic, strong) ZGMeituizipaiPreviewController *previewController;/**<#注释#>*/
@property(nonatomic, assign) NSInteger  allSelectedAssetNum;/**<#注释#>*/
@property(nonatomic, strong) NSMutableDictionary *updataAssets;/**<#注释#>*/
@property(nonatomic, assign) BOOL isOriginalImage;/**是否是原图*/
@property(nonatomic, strong) NSString *pickerViewType;/**区分按钮*/


@end

@implementation ZGThumbnailsPreviewController
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
        
        self.thumbnailsPerviewData = [ZGPAViewModel accordingToTheCollectionTitleOfLodingPHAsset:self.folderTitel];

        [self initCollectionView];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.thumbnailsPerviewData.count - 1 inSection:0];
        
        if (self.thumbnailsPerviewData.count == 0) {
                [self dismissViewControllerAnimated:YES completion:nil];
        }else{
        //滚动到最底部
        [_myCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        }
        self.allSelectedAssetNum = 0;
        self.allSelectedAssetNum = self.selectedNumber + self.thumbnailsSelectedAsset.count;
        
        self.previewController = [ZGMeituizipaiPreviewController new];
        self.previewController.delegate = self;
        self.previewController.minCopVideoTimer = self.minCopVideoTimer;
        self.previewController.maxCopVideoTimer = self.maxCopVideoTimer;
        self.previewController.CutViewSize = self.CutViewSize;

        
}

//初始化CollectionView
-(void)initCollectionView{
        if (_myCollectionView) {
                [_myCollectionView removeFromSuperview];
        }
        self.automaticallyAdjustsScrollViewInsets = NO;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake((self.view.frame.size.width - 20)/3.0, 0);
        if (self.barType) {
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
#pragma mark - UICollectionViewDataSource method
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

                        if (_photoAlibumStyle == ZGThumbnailsPreviewStyleChat) {//好友
                                cell.selectButton.selected = NO;
                                cell.selectButton.hidden = NO;
                        }else if (_photoAlibumStyle == ZGThumbnailsPreviewStyleAvatar){//2头像  ==  3相册封面  == 4摇一摇头像
                                cell.userInteractionEnabled = NO;
                                cell.alpha = 0.3;
                                cell.selectButton.hidden = YES;
                        }else if (_photoAlibumStyle == ZGThumbnailsPreviewStyleSCircleOfFriends){//5朋友圈
                                cell.selectButton.hidden = YES;
                        }else if (_photoAlibumStyle == ZGThumbnailsPreviewStyleCollection){// 6收藏
                                cell.selectButton.hidden = YES;
                        }else if (_photoAlibumStyle == ZGThumbnailsPreviewStyleBitmap){//7对话框背景  == 8添加表情
                                cell.userInteractionEnabled = NO;
                                cell.alpha = 0.3;
                                cell.selectButton.hidden = YES;
                        }

                                               return cell;
                        
                }else if (asset.mediaType == PHAssetMediaTypeImage) {
                

                        [imageCell.selectButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchDown];
                        imageCell.selectButton.tag = 1000 + indexPath.row;//tag值可以确定cell的位置
                        //如果是图片
                        imageCell.imageView.image = [ZGPAViewModel createAccessToImage:asset imageSize: CGSizeMake(kPAMainScreenWidth / 4, kPAMainScreenWidth / 4) contentMode:PHImageContentModeAspectFill];
                        imageCell.selectButton.selected = NO;
                        
                        if (_photoAlibumStyle == ZGThumbnailsPreviewStyleChat) {
                        //好友
                                imageCell.selectButton.selected = NO;
                                imageCell.selectButton.hidden = NO;
                                
                        }else if (_photoAlibumStyle == ZGThumbnailsPreviewStyleAvatar){
                        //2头像  ==  3相册封面  == 4摇一摇头像
                                imageCell.selectButton.hidden = YES;
                                
                        }else if (_photoAlibumStyle == ZGThumbnailsPreviewStyleSCircleOfFriends){
                        //5朋友圈
                                imageCell.selectButton.selected = NO;
                                imageCell.selectButton.hidden = NO;
                                
                        }else if (_photoAlibumStyle == ZGThumbnailsPreviewStyleCollection){
                        //6收藏
                                imageCell.selectButton.selected = NO;
                                imageCell.selectButton.hidden = NO;
                                
                        }else if (_photoAlibumStyle == ZGThumbnailsPreviewStyleBitmap){
                        //7对话框背景  == 8添加表情
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
        if (self.allSelectedAssetNum < self.largestNumber) {
                if (btn.selected == YES) {
                        [self.thumbnailsSelectedAsset addObject:self.thumbnailsPerviewData[btn.tag - 1000]];
                }else{
                        //删除对应的PHAsset
                        [self.thumbnailsSelectedAsset removeObject:self.thumbnailsPerviewData[btn.tag - 1000]];
                }
        }else{
                //删除最后添加的
                [self.thumbnailsSelectedAsset addObject:self.thumbnailsPerviewData[btn.tag - 1000]];
                [self.thumbnailsSelectedAsset removeObject:self.thumbnailsPerviewData[btn.tag - 1000]];
                btn.selected = NO;

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
        self.allSelectedAssetNum = self.selectedNumber + self.thumbnailsSelectedAsset.count;
        if (self.thumbnailsSelectedAsset.count == 0) {
                [self.pickerBar isHiden:YES];
                if (self.photoAlibumStyle == ZGThumbnailsPreviewStyleSCircleOfFriends || self.photoAlibumStyle == ZGThumbnailsPreviewStyleCollection) {
                        for (NSInteger i = 0; i < self.thumbnailsPerviewData.count; i++) {
                                PHAsset *asset = self.thumbnailsPerviewData[i];
                                if (asset.mediaType == PHAssetMediaTypeVideo) {
                                        
                                        ZGThumbnailsPreviewVideoCell *cell =  (ZGThumbnailsPreviewVideoCell *)[_myCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                                        cell.alpha = 1.0;
                                        cell.userInteractionEnabled = YES;
                                }
                        }

                }
        }else{
                [self.pickerBar isHiden:NO];
                if (self.photoAlibumStyle == ZGThumbnailsPreviewStyleSCircleOfFriends || self.photoAlibumStyle == ZGThumbnailsPreviewStyleCollection) {
                        for (NSInteger i = 0; i < self.thumbnailsPerviewData.count; i++) {
                                PHAsset *asset = self.thumbnailsPerviewData[i];
                                if (asset.mediaType == PHAssetMediaTypeVideo) {
                                        
                                        ZGThumbnailsPreviewVideoCell *cell =  (ZGThumbnailsPreviewVideoCell *)[_myCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                                        cell.alpha = 0.3;
                                        cell.userInteractionEnabled = NO;
                                }
                        }

                }
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
        self.previewController = [ZGMeituizipaiPreviewController new];
        self.previewController.delegate = self;
        self.previewController.meituizipaiSelectdAsset = asset;
        self.previewController.folderName = self.folderTitel;
        self.previewController.indexPathRow = indexPath.row;
        self.previewController.updataMeituizipaiAssets = self.updataAssets;
        self.previewController.largestNumber = self.largestNumber;
        self.previewController.minCopVideoTimer = self.minCopVideoTimer;
        self.previewController.maxCopVideoTimer = self.maxCopVideoTimer;
        self.previewController.CutViewSize = self.CutViewSize;
        self.previewController.isOriginalImage = self.isOriginalImage;
        if (_photoAlibumStyle == ZGThumbnailsPreviewStyleChat) {
        //聊天
                if (asset.mediaType == PHAssetMediaTypeVideo) {
                        self.previewController.navigationBarStyle = ZGPANavigationBarStyleMeituizipaiPreview;
                        self.previewController.barType = ZGPhotoAlbumBarTypeCollectingMeitiuzipaiVideo;
                }else{
                        self.previewController.navigationBarStyle = ZGPANavigationBarStyleMeituizipaiPreview;
                        self.previewController.barType = ZGPhotoAlbumBarTypeChatMeitiuzipaiImage;
                }
                self.previewController.photoAlibumStyle = ZGThumbnailsPreviewStyleChat;
                self.previewController.isTabBar = YES;
                self.previewController.meituizipaiSelectedAssetData = self.thumbnailsSelectedAsset;
                self.previewController.existingCount = self.selectedNumber;
                

        }else if (_photoAlibumStyle == ZGThumbnailsPreviewStyleAvatar){
        //2头像  ==  3相册封面  == 4摇一摇头像
                self.previewController.navigationBarStyle = ZGPANavigationBarStyleMeituizipaiPreviewOneImage;
                self.previewController.isTabBar = NO;


        }else if (_photoAlibumStyle == ZGThumbnailsPreviewStyleSCircleOfFriends){
        //5朋友圈
                if (asset.mediaType == PHAssetMediaTypeVideo) {
                        self.previewController.navigationBarStyle = ZGPANavigationBarStyleMeituizipaiPreviewVideo;
                        self.previewController.barType = ZGPhotoAlbumBarTypeCircleOfFriendsVideo;

                }else{
                        self.previewController.navigationBarStyle = ZGPANavigationBarStyleMeituizipaiPreview;
                        self.previewController.barType = ZGPhotoAlbumBarTypeCircleOfFriendsImage;
                }
                self.previewController.photoAlibumStyle = ZGThumbnailsPreviewStyleSCircleOfFriends;
                self.previewController.isTabBar = YES;
                self.previewController.meituizipaiSelectedAssetData = self.thumbnailsSelectedAsset;
                self.previewController.existingCount = self.selectedNumber;


        }else if (_photoAlibumStyle == ZGThumbnailsPreviewStyleCollection){
        //== 6收藏
                if (asset.mediaType == PHAssetMediaTypeVideo) {
                        self.previewController.navigationBarStyle = ZGPANavigationBarStyleMeituizipaiPreviewVideo;
                        self.previewController.barType = ZGPhotoAlbumBarTypeCollectingMeitiuzipaiVideo;
                        
                }else{
                        self.previewController.navigationBarStyle = ZGPANavigationBarStyleMeituizipaiPreview;
                        self.previewController.barType = ZGPhotoAlbumBarTypeCircleOfFriendsImage;
                }
                self.previewController.photoAlibumStyle = ZGThumbnailsPreviewStyleCollection;
                self.previewController.isTabBar = YES;
                self.previewController.meituizipaiSelectedAssetData = self.thumbnailsSelectedAsset;
                self.previewController.existingCount = self.selectedNumber;

                
        }else if (_photoAlibumStyle == ZGThumbnailsPreviewStyleBitmap){
        //7对话框背景  == 8添加表情
                self.previewController.navigationBarStyle = ZGPANavigationBarStyleMeituizipaiPreviewOneImage;
                self.previewController.isTabBar = NO;
                self.previewController.photoAlibumStyle = ZGThumbnailsPreviewStyleBitmap;

        }
        
        
        [self.navigationController pushViewController:self.previewController animated:YES];
}
#pragma mark - ZGMeituizipaiPreviewControllerDelegate
-(void)selectedAssetDataArray:(NSMutableArray *)sender isOriginalImage:(BOOL)isOriginal{
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

}
-(void)newAsset:(PHAsset *)asset oldAsset:(PHAsset *)oldAsset{
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


}
-(void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:animated];


        
}
-(void)initPickerBar{
        if (_pickerBar) {
                [_pickerBar removeFromSuperview];
        }
        
        if (self.barType) {
        
                if (self.photoAlibumStyle == ZGThumbnailsPreviewStyleCollection) {
                        _pickerBar = [[ZGPhotoAlbumPickerBar alloc] initWithFrame:CGRectMake(0, kPAMainScreenHeight - kPAMainToolsHeight, kPAMainScreenWidth, kPAMainToolsHeight) tabBarType:ZGPhotoAlbumBarTypeCircleOfFriendsThumbnails];
                      [_pickerBar.rightButton addTarget:self action:@selector(rightCollectionButtonAction) forControlEvents:UIControlEventTouchDown];
                      
                }else if (self.photoAlibumStyle == ZGThumbnailsPreviewStyleSCircleOfFriends ) {
                        _pickerBar = [[ZGPhotoAlbumPickerBar alloc] initWithFrame:CGRectMake(0, kPAMainScreenHeight - kPAMainToolsHeight, kPAMainScreenWidth, kPAMainToolsHeight) tabBarType:ZGPhotoAlbumBarTypeCircleOfFriendsThumbnails];
                        [_pickerBar.rightButton addTarget:self action:@selector(rightCircleOfFriendsButtonAction) forControlEvents:UIControlEventTouchDown];
                        
                }else{
                _pickerBar = [[ZGPhotoAlbumPickerBar alloc] initWithFrame:CGRectMake(0, kPAMainScreenHeight - kPAMainToolsHeight, kPAMainScreenWidth, kPAMainToolsHeight) tabBarType:ZGPhotoAlbumBarTypeChatThumbnails];
                [_pickerBar.rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchDown];
                }
                
                [_pickerBar.leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchDown];
                [_pickerBar.originalImageButton addTarget:self action:@selector(originalImageButtonAction:) forControlEvents:UIControlEventTouchDown];
                if (self.isOriginalImage == YES) {
                        self.pickerBar.originalImageButton.selected = YES;
                        [_pickerBar.originalImageButton setImage:[UIImage imageNamed:@"icon_navbar_image_green"] forState:UIControlStateSelected];
                }else{
                        self.pickerBar.originalImageButton.selected = NO;
                        [_pickerBar.originalImageButton setImage:[UIImage imageNamed:@"icon_navbar_album"] forState:UIControlStateNormal];
                }

                [self.view addSubview:_pickerBar];
        }
        
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
//g工具栏按钮
-(void)leftButtonAction{
        self.previewController = [ZGMeituizipaiPreviewController new];
        self.previewController.delegate = self;
        self.previewController.folderName = @"ZGMeituizipaiPreviewController";
        self.previewController.indexPathRow = 0;
        self.previewController.meituizipaiSelectedAssetData = self.thumbnailsSelectedAsset;
        self.previewController.existingCount = self.selectedNumber;
        self.previewController.largestNumber = self.largestNumber;
        self.previewController.minCopVideoTimer = self.minCopVideoTimer;
        self.previewController.maxCopVideoTimer = self.maxCopVideoTimer;
        self.previewController.CutViewSize = self.CutViewSize;
        self.previewController.isOriginalImage = self.isOriginalImage;

        if (_photoAlibumStyle == ZGThumbnailsPreviewStyleChat) {
                self.previewController.navigationBarStyle = ZGPANavigationBarStyleMeituizipaiPreview;
                self.previewController.barType = ZGPhotoAlbumBarTypeChatMeitiuzipaiImage;
                self.previewController.photoAlibumStyle = ZGThumbnailsPreviewStyleChat;
                self.previewController.isTabBar = YES;
                
        }else if (_photoAlibumStyle == ZGThumbnailsPreviewStyleSCircleOfFriends){
                self.previewController.navigationBarStyle = ZGPANavigationBarStyleMeituizipaiPreview;
                self.previewController.barType = ZGPhotoAlbumBarTypeCircleOfFriendsImage;
                self.previewController.photoAlibumStyle = ZGThumbnailsPreviewStyleSCircleOfFriends;
                self.previewController.isTabBar = YES;
                
                
        }else if (_photoAlibumStyle == ZGThumbnailsPreviewStyleCollection){
                self.previewController.navigationBarStyle = ZGPANavigationBarStyleMeituizipaiPreview;
                self.previewController.barType = ZGPhotoAlbumBarTypeCircleOfFriendsImage;
                self.previewController.photoAlibumStyle = ZGThumbnailsPreviewStyleCollection;
                self.previewController.isTabBar = YES;
        }
        [self.navigationController pushViewController:self.previewController animated:YES];

}
-(void)rightButtonAction{

       
                //self.meituizipaiSelectedAssetData;保存有选择的数据
                if (self.isOriginalImage == YES) {
                        [ZGPAViewModel aliertControllerTitle:@"聊天中发送图片(<原图>)||视频" viewController:self];
                
                }else{
                        [ZGPAViewModel aliertControllerTitle:@"聊天中发送图片||视频" viewController:self];
                
                }
        
        //self.thumbnailsSelectedAsset;保存有选择的数据
}
-(void)rightCircleOfFriendsButtonAction{
        [ZGPAViewModel aliertControllerTitle:@"小图预览：朋友圈选择完成" viewController:self];

}
-(void)rightCollectionButtonAction{
        [ZGPAViewModel aliertControllerTitle:@"小图预览：完成收藏" viewController:self];
}

- (void)viewWillLayoutSubviews
{
        if (self.barType) {
                _myCollectionView.frame = CGRectMake(0,20 + kPANavigationHeight, kPAMainScreenWidth, kPAMainScreenHeight - kPAMainToolsHeight - 15 - kPANavigationHeight) ;
        }else{
                _myCollectionView.frame = CGRectMake(0,20 + kPANavigationHeight, kPAMainScreenWidth, kPAMainScreenHeight - 15 - kPANavigationHeight) ;
        }
        _pickerBar.frame = CGRectMake(0, kPAMainScreenHeight - kPAMainToolsHeight, kPAMainScreenWidth, kPAMainToolsHeight);

}

//设置导航标题
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
        [self dismissViewControllerAnimated: YES completion: nil ];
}
-(void)navigationLeftButtonAction{
        [self.navigationController popViewControllerAnimated:YES];
}

@end
