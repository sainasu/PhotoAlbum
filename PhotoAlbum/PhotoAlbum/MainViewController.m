//
//  MainViewController.m
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/4.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "MainViewController.h"
#import "ZGPAViewModel.h"
#import "ZGPAHeader.h"
#import "ZGFolderViewController.h"
#import "ZGMeituizipaiPreviewVideoCell.h"
#import "ZGMeituizipaiPreviewImageCell.h"
#import "ZGMeituizipaiPreviewController.h"
#import "ZGThumbnailsPreviewController.h"
#define Kheight(a, b) kPAMainToolsHeight * a + 22 * b



static NSString * const CellReuseIdentify = @"CellReuseIdentify";
static NSString * const CellImageReuseIdentify = @"CellImageReuseIdentify";



@interface MainViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate >
@property(nonatomic, strong) UIAlertController*alertController;/**<#注释#>*/
@property(nonatomic, strong) UICollectionView *myCollectionView;/**<#注释#>*/
@property(nonatomic, strong) NSMutableArray *sendAssetArray;/**<#注释#>*/

@property(nonatomic, strong) UILabel *isOriginalImageLabel;/**<#注释#>*/
@property(nonatomic, strong) UIImageView *imageView;/**<#注释#>*/

@end

@implementation MainViewController
- (NSMutableArray *)sendAssetArray
{
        if (!_sendAssetArray) {
                _sendAssetArray = [[NSMutableArray alloc]init];
        }
        return _sendAssetArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示框" message:@"否认了应用程序访问相册, 是否前往设置" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *laterAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                // 普通按键
                [self dismissViewControllerAnimated: YES completion: nil ];
                
        }];
        UIAlertAction *neverAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                // 红色按键
                //用户已经明确否认了这一照片数据的应用程序访问
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url options:[NSDictionary dictionary] completionHandler:^(BOOL success) {
                        }];
                }
        }];
        [alertController addAction:laterAction];
        [alertController addAction:neverAction];
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusRestricted) {
                        // 此应用程序没有被授权访问的照片数据
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                }else if (status == PHAuthorizationStatusDenied){
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                }else if (status == PHAuthorizationStatusNotDetermined){
                        // 默认还没做出选择
                }else if (status == PHAuthorizationStatusAuthorized){
                        
                }
        }];

        

        [self initButtons];
        [self initCollectionView];
        self.view.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake(0,Kheight(4, 6) + kPANavigationHeight, kPAMainScreenWidth, kPAMainScreenHeight - (Kheight(4 , 6)));
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_imageView];

        //    注册监听者
        /**
         *  addObserver 注册监听者,一般都是控制器本身去监听一个通知
         *
         *  selector 当监听到通知的时候执行的方法
         *isOriginalImage
         *  name 通知的名字,要和发送的通知的对象的名字一致Screenshots
         */
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chooseToCompleteData:) name:@"chooseToComplete" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isOriginalImage:) name:@"isOriginalImage" object:nil];



}
//选择图片监听
-(void)chooseToCompleteData:(NSNotification *)notification{
        NSDictionary *dict = notification.userInfo;
        self.sendAssetArray = dict[@"dataAsset"];
        [self.myCollectionView reloadData];
}
//监听是否是原图
-(void)isOriginalImage:(NSNotification *)notification{
        NSDictionary *dict = notification.userInfo;
        UIButton *isOriginalImageButton = dict[@"Value"];
        if (isOriginalImageButton.selected == YES) {
                self.isOriginalImageLabel.text = @"发送原图";
        }else{
                self.isOriginalImageLabel.text = @"发送缩略图";

        }
}

-(void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:animated];
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
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,Kheight(4, 6) + kPANavigationHeight, kPAMainScreenWidth, kPAMainScreenHeight - (Kheight(4 , 6) + kPANavigationHeight)) collectionViewLayout:layout];
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        _myCollectionView.dataSource = self;
        _myCollectionView.delegate = self;
        [self.view addSubview:_myCollectionView];
        //注册
        [_myCollectionView registerClass:[ZGMeituizipaiPreviewVideoCell class] forCellWithReuseIdentifier:CellReuseIdentify];
        [_myCollectionView registerClass:[ZGMeituizipaiPreviewImageCell class] forCellWithReuseIdentifier:CellImageReuseIdentify];
        
}
#pragma mark - UICollectionViewDataSource method
//返回section 的数量
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
        return 1;
}

//返回对应section的item 的数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return self.sendAssetArray.count;
}
//创建和复用cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{


        
        ZGMeituizipaiPreviewImageCell *imageCell = (ZGMeituizipaiPreviewImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellImageReuseIdentify forIndexPath:indexPath];
        // 从asset中获得图片
        PHAsset *asset = self.sendAssetArray[indexPath.row];
        if (asset.hidden == NO) {//如果是隐藏的则不显示
                if (asset.mediaType == PHAssetMediaTypeVideo) {
                        ZGMeituizipaiPreviewVideoCell *cell = (ZGMeituizipaiPreviewVideoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentify forIndexPath:indexPath];
                        //如果是视频
                        cell.videoView.image = [ZGPAViewModel createAccessToImage:asset imageSize: CGSizeMake(kPAMainScreenWidth / 4, kPAMainScreenWidth / 4) contentMode:PHImageContentModeAspectFill];
                        cell.userInteractionEnabled = NO;
                        return cell;
                        
                }else if (asset.mediaType == PHAssetMediaTypeImage) {
                        imageCell.imageView.image = [ZGPAViewModel createAccessToImage:asset imageSize: CGSizeMake(kPAMainScreenWidth / 4, kPAMainScreenWidth / 4) contentMode:PHImageContentModeAspectFill];
                        return imageCell;
                }
        }
        return imageCell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        return CGSizeMake(kPAMainScreenWidth / 4, kPAMainScreenWidth / 4);
        
}



-(void)initButtons{
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        UIButton *chatButton = [MainViewController initButtons:@"图与视频可合选, 图片可以编辑" frame:CGRectMake(0, Kheight(0, 1), kPAMainScreenWidth, kPAMainToolsHeight) addTarget:self action:@selector(chatButtonAction)];
        [self.view addSubview:chatButton];
        UIButton *circleOfFriendsButton = [MainViewController initButtons:@"图与视频单选, 视频与图片均可编辑" frame:CGRectMake(0, Kheight(1, 2), kPAMainScreenWidth, kPAMainToolsHeight) addTarget:self action:@selector(circleOfFriendsButtonAction)];
        [self.view addSubview:circleOfFriendsButton];
        UIButton *bitmapButton = [MainViewController initButtons:@"只能选择图片, 按给定大小截图" frame:CGRectMake(0, Kheight(2, 3), kPAMainScreenWidth, kPAMainToolsHeight) addTarget:self action:@selector(bitmapButtonAction)];
        [self.view addSubview:bitmapButton];
        UIButton *collectionButton = [MainViewController initButtons:@"图与视频单选, 图片可以编辑" frame:CGRectMake(0, Kheight(3, 4), kPAMainScreenWidth, kPAMainToolsHeight) addTarget:self action:@selector(collectionButtonAction)];
        [self.view addSubview:collectionButton];
        
        _isOriginalImageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Kheight(4, 5), kPAMainScreenWidth, kPAMainToolsHeight)];
        self.isOriginalImageLabel.backgroundColor = [UIColor whiteColor];
        self.isOriginalImageLabel.textColor = [UIColor blackColor];
        [self.view addSubview:self.isOriginalImageLabel];

}

//图与视频可合选, 图片可以编辑
-(void)chatButtonAction{

        ZGFolderViewController *folderC = [ZGFolderViewController new];
        folderC.isPicturesAndVideoCombination = YES;
        folderC.optionalMaximumNumber = 9;
        folderC.selectedNumber = 0;
        folderC.whetherToEditPictures = YES;
        folderC.whetherToEditVideo = NO;
        folderC.whetherTheScreenshots = NO;
        folderC.isSendTheOriginalPictures = YES;
        folderC.fromViewController = [MainViewController new];

        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:folderC];
        [self presentViewController:nav animated: YES completion:nil];
        
}
//图与视频单选, 视频与图片都可编辑
-(void)circleOfFriendsButtonAction{
        ZGFolderViewController *folderC = [ZGFolderViewController new];
        folderC.isPicturesAndVideoCombination = NO;
        folderC.optionalMaximumNumber = 9;
        folderC.selectedNumber = 0;
        folderC.whetherToEditPictures = YES;
        folderC.whetherToEditVideo = YES;
        folderC.maximumTimeVideo = 15;
        folderC.whetherTheScreenshots = NO;
        folderC.fromViewController = [MainViewController new];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:folderC];
        [self presentViewController:nav animated: YES completion:nil];
        

}
//只能选择图片, 按屏幕大小截图
-(void)bitmapButtonAction{
        ZGFolderViewController *folderC = [ZGFolderViewController new];
        folderC.whetherTheScreenshots = YES;
        folderC.fromViewController = [MainViewController new];
        folderC.screenshotsSize = CGSizeMake(kPAMainScreenWidth,kPAMainScreenWidth);
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:folderC];
        [self presentViewController:nav animated: YES completion:nil];
}
//图与视频单选, 图可编辑
-(void)collectionButtonAction{
        ZGFolderViewController *folderC = [ZGFolderViewController new];
        folderC.isPicturesAndVideoCombination = NO;
        folderC.optionalMaximumNumber = 9;
        folderC.selectedNumber = 0;
        folderC.whetherToEditPictures = YES;
        folderC.whetherToEditVideo = NO;
        folderC.whetherTheScreenshots = NO;
        folderC.fromViewController = [MainViewController new];

        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:folderC];
        [self presentViewController:nav animated: YES completion:nil];
}
+(UIButton *)initButtons:(NSString *)titel frame:(CGRect)frame addTarget:(nullable id)target action:(nonnull SEL)action{
        UIButton *createButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [createButton setTitle:titel forState:UIControlStateNormal];
        [createButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        createButton.frame = frame;
        createButton.backgroundColor = [UIColor cyanColor];
        [createButton addTarget:target action:action forControlEvents:UIControlEventTouchDown];
        return createButton;
}

//移除通知
-(void)dealloc{
        
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        
}


@end
