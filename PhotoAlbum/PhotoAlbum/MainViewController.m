//
//  MainViewController.m
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/4.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "MainViewController.h"
#import "ZGPAViewModel.h"
#import "ZGCIPHeader.h"
#import "ZGCustomImagePickerController.h"
#import "ZGMeituizipaiPreviewVideoCell.h"
#import "ZGMeituizipaiPreviewImageCell.h"
#import "ZGCIPNavigationController.h"
#define Kheight(a, b) ZGCIP_TABBAR_HEIGHT * a + 22 * b



static NSString * const CellReuseIdentify = @"CellReuseIdentify";
static NSString * const CellImageReuseIdentify = @"CellImageReuseIdentify";



@interface MainViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate ,ZGCustomImagePickerControllerDelegate>
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
       

}
-(void)customImagePickerController:(ZGCustomImagePickerController *)picker didFinishPickingImages:(NSMutableArray *)data isSendTheOriginalPictures:(BOOL)idOriginalPictures{
        [picker dismissViewControllerAnimated:YES completion:nil];
        self.sendAssetArray = data;
        [self.myCollectionView reloadData];
        if (idOriginalPictures == YES) {
                self.isOriginalImageLabel.text = @"发送原图";
        }else{
                self.isOriginalImageLabel.text = @"发送缩略图";
        }
}
//取消选择
- (void)customImagePickerControllerDidCancel:(ZGCustomImagePickerController *)picker{
        [picker dismissViewControllerAnimated:YES completion:^{
                
        }];
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
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,Kheight(4, 6) + ZGCIP_NAVIGATION_HEIGHT, ZGCIP_MAINSCREEN_WIDTH, ZGCIP_MAINSCREEN_HEIGHT - (Kheight(4 , 6) + ZGCIP_NAVIGATION_HEIGHT)) collectionViewLayout:layout];
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
                        cell.videoView.image = [ZGPAViewModel createAccessToImage:asset imageSize: CGSizeMake(ZGCIP_MAINSCREEN_WIDTH / 4, ZGCIP_MAINSCREEN_WIDTH / 4) contentMode:PHImageContentModeAspectFill];
                        cell.userInteractionEnabled = NO;
                        return cell;
                        
                }else if (asset.mediaType == PHAssetMediaTypeImage) {
                        imageCell.showImgView.image = [ZGPAViewModel createAccessToImage:asset imageSize: CGSizeMake(ZGCIP_MAINSCREEN_WIDTH / 4, ZGCIP_MAINSCREEN_WIDTH / 4) contentMode:PHImageContentModeAspectFill];
                        imageCell.userInteractionEnabled = NO;
                        return imageCell;
                }
        }
        return imageCell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
        return CGSizeMake(ZGCIP_MAINSCREEN_WIDTH / 4, ZGCIP_MAINSCREEN_WIDTH / 4);
        
}



-(void)initButtons{
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        UIButton *chatButton = [MainViewController initButtons:@"图与视频可合选, 图片与视频都可编辑" frame:CGRectMake(0, Kheight(0, 1), ZGCIP_MAINSCREEN_WIDTH, ZGCIP_TABBAR_HEIGHT) addTarget:self action:@selector(chatButtonAction)];
        [self.view addSubview:chatButton];
        UIButton *circleOfFriendsButton = [MainViewController initButtons:@"只能选择视频, 视频可编辑" frame:CGRectMake(0, Kheight(1, 2), ZGCIP_MAINSCREEN_WIDTH, ZGCIP_TABBAR_HEIGHT) addTarget:self action:@selector(circleOfFriendsButtonAction)];
        [self.view addSubview:circleOfFriendsButton];
        UIButton *bitmapButton = [MainViewController initButtons:@"只能选择图片, 按给定大小截图" frame:CGRectMake(0, Kheight(2, 3), ZGCIP_MAINSCREEN_WIDTH, ZGCIP_TABBAR_HEIGHT) addTarget:self action:@selector(bitmapButtonAction)];
        [self.view addSubview:bitmapButton];
        UIButton *collectionButton = [MainViewController initButtons:@"只能选择图片, 图片可以编辑" frame:CGRectMake(0, Kheight(3, 4), ZGCIP_MAINSCREEN_WIDTH, ZGCIP_TABBAR_HEIGHT) addTarget:self action:@selector(collectionButtonAction)];
        [self.view addSubview:collectionButton];
        
        _isOriginalImageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Kheight(4, 5), ZGCIP_MAINSCREEN_WIDTH, ZGCIP_TABBAR_HEIGHT)];
        self.isOriginalImageLabel.backgroundColor = [UIColor whiteColor];
        self.isOriginalImageLabel.textColor = [UIColor blackColor];
        [self.view addSubview:self.isOriginalImageLabel];

}

//图与视频可合选, 图片和视频都可以编辑
-(void)chatButtonAction{

        ZGCustomImagePickerController *folderC = [ZGCustomImagePickerController new];
        folderC.selectType = ZGCPSelectTypeImageAndVideo;
        folderC.maySelectMaximumCount = 9;
        folderC.selectedCount = 0;
        folderC.maximumTimeVideo = 15;
        folderC.whetherToEditPictures = YES;
        folderC.whetherTheCrop = NO;
        folderC.isSendTheOriginalPictures = YES;
        folderC.customImagePickerDelegate = self;
        folderC.sendButtonImage = [UIImage imageNamed:@"icon_navbar_send_blue"];
        ZGCIPNavigationController *nav = [[ZGCIPNavigationController alloc] initWithRootViewController:folderC];
        [self presentViewController:nav animated: YES completion:nil];
        
}
//只选择视屏, 视频可编辑
-(void)circleOfFriendsButtonAction{
        ZGCustomImagePickerController *folderC = [ZGCustomImagePickerController new];
        folderC.selectType = ZGCPSelectTypeVideo;
        folderC.maySelectMaximumCount = 9;
        folderC.selectedCount = 0;
        folderC.whetherToEditPictures = NO;
        folderC.maximumTimeVideo = 15;
        folderC.whetherTheCrop = NO;
        folderC.customImagePickerDelegate = self;
        folderC.sendButtonImage = [UIImage imageNamed:@"icon_navbar_ok"];

        ZGCIPNavigationController *nav = [[ZGCIPNavigationController alloc] initWithRootViewController:folderC];
        [self presentViewController:nav animated: YES completion:nil];
        

}
//只能选择图片, 按屏幕大小截图
-(void)bitmapButtonAction{
        ZGCustomImagePickerController *folderC = [ZGCustomImagePickerController new];
        folderC.whetherTheCrop = YES;
        folderC.customImagePickerDelegate = self;
        folderC.cropSize = CGSizeMake(ZGCIP_MAINSCREEN_WIDTH,ZGCIP_MAINSCREEN_WIDTH);
        
        ZGCIPNavigationController *nav = [[ZGCIPNavigationController alloc] initWithRootViewController:folderC];
        [self presentViewController:nav animated: YES completion:nil];
}
//只选择图片, 图可编辑
-(void)collectionButtonAction{
        ZGCustomImagePickerController *folderC = [ZGCustomImagePickerController new];
        folderC.selectType = ZGCPSelectTypeImage;
        folderC.maySelectMaximumCount = 5;
        folderC.selectedCount = 0;
        folderC.whetherToEditPictures = YES;
        folderC.whetherTheCrop = NO;
        folderC.customImagePickerDelegate = self;
        folderC.sendButtonImage = [UIImage imageNamed:@"icon_navbar_ok"];

        ZGCIPNavigationController *nav = [[ZGCIPNavigationController alloc] initWithRootViewController:folderC];
        [self presentViewController:nav animated: YES completion:nil];
}
+(UIButton *)initButtons:(NSString *)titel frame:(CGRect)frame addTarget:(nullable id)target action:(nonnull SEL)action{
        UIButton *createButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [createButton setTitle:titel forState:UIControlStateNormal];
        [createButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        createButton.frame = frame;
        createButton.backgroundColor = [UIColor cyanColor];
        [createButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        return createButton;
}

//移除通知
-(void)dealloc{
        
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        
}


@end
