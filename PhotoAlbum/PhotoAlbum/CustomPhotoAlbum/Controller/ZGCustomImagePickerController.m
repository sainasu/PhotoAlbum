//
//  ZGCustomImagePickerController.m
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/30.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGCustomImagePickerController.h"

#import "ZGPAViewModel.h"
#import "ZGFolderTableViewCell.h"
#import "ZGCIPThumbnailsPreviewController.h"

@interface ZGCustomImagePickerController ()<UITableViewDelegate, UITableViewDataSource, ZGThumbnailsPreviewControllerDelegate>{
        NSMutableArray *assetArray ;
}
@property(nonatomic, strong) NSMutableArray *folderData;/**数据源*/
@property(nonatomic, strong) UITableView *tableView;/**<#注释#>*/



@end

@implementation ZGCustomImagePickerController

- (NSMutableArray *)folderData
{
        if (!_folderData) {
                _folderData = [[NSMutableArray alloc]init];
        }
        return _folderData;
}


- (void)viewDidLoad
{
        [super viewDidLoad];
        self.automaticallyAdjustsScrollViewInsets = false;
        [self loadCustomImagePickerControllerData];
        [self initNavigationViewController];
        [self initWithTableView];
}

- (void)initWithTableView
{
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,ZGCIP_NAVIGATION_HEIGHT + 20, ZGCIP_MAINSCREEN_WIDTH, ZGCIP_MAINSCREEN_HEIGHT - ZGCIP_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];

}
- (void)loadCustomImagePickerControllerData
{
        self.folderData = [ZGPAViewModel createAccessToCollections];
        if (self.selectType == ZGCPSelectTypeImage || self.whetherTheCrop == YES || self.selectType == ZGCPSelectTypeImageAndVideo) {
                NSMutableArray *array = [ZGPAViewModel accordingToTheCollectionTitleOfLodingPHAsset:self.folderData[0][0]];
                if (array.count == 0) {
                        [self dismissViewControllerAnimated:NO completion:nil];
                }else{
                        
                        [self pushThumbnailsPreviewParameter:self.folderData[0][0]  animated: NO];
                }
        }
        if (self.selectType == ZGCPSelectTypeVideo) {
                NSMutableArray *array = [ZGPAViewModel accordingToTheCollectionTitleOfLodingPHAsset:self.folderData[2][0]];
                if (array.count == 0) {
                        [self dismissViewControllerAnimated:NO completion:nil];
                }else{
                        
                        [self pushThumbnailsPreviewParameter:self.folderData[2][0]  animated: NO];
                }
                
        }
        
  
}




- (void)viewWillLayoutSubviews
{
        _tableView.frame = CGRectMake(0,ZGCIP_NAVIGATION_HEIGHT + 20, ZGCIP_MAINSCREEN_WIDTH, ZGCIP_MAINSCREEN_HEIGHT -20 -ZGCIP_NAVIGATION_HEIGHT);
}

- (void)initNavigationViewController
{
        //设置导航标题
        // self.navigationItem.title = @"相册组";
        //设置标题颜色
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        //设置状态栏
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        //设置导航栏颜色
        self.navigationController.navigationBar.barTintColor = ZGCIP_NAVIGATION_COLOR;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        //返回按钮
        UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [btnBack setBackgroundImage:[UIImage imageNamed:@"icon_navbar_close"] forState:UIControlStateNormal];
        
        [btnBack addTarget:self action:@selector(navigationRightButtonAction) forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
        self.navigationItem.rightBarButtonItem = item;
        
        
}
- (void)navigationRightButtonAction
{
        [self.customImagePickerDelegate customImagePickerControllerDidCancel:self];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.folderData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
        static NSString *cellIndetifier = @"cell";
        ZGFolderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
        if (cell == nil) {
                cell = [[ZGFolderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndetifier];
        }
        //cell选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
        
        // 从asset中获得图片
        UIImage *image = [[UIImage alloc] init];
        assetArray = [NSMutableArray array];
        NSString *title = nil;
        title = self.folderData[indexPath.row][0];
        assetArray = self.folderData[indexPath.row][1];
        
        //判断数组中是否有值
        if (assetArray.count == 0) {
                image = [UIImage imageNamed:@"icon_navbar_album"];
        }else{
                PHAsset *asset = assetArray[indexPath.section];
                if (asset.mediaType == PHAssetMediaTypeVideo) {
                        //如果是视频
                        image = [ZGPAViewModel createAccessToImage:asset imageSize:CGSizeMake(ZGCIP_CUSTOM_IMAGE_PICKER_CELL_HEIGHT, ZGCIP_CUSTOM_IMAGE_PICKER_CELL_HEIGHT) contentMode:PHImageContentModeAspectFill];
                }else if (asset.mediaType == PHAssetMediaTypeImage) {
                        //如果是图片
                        image = [ZGPAViewModel createAccessToImage:asset imageSize:CGSizeMake(ZGCIP_CUSTOM_IMAGE_PICKER_CELL_HEIGHT, ZGCIP_CUSTOM_IMAGE_PICKER_CELL_HEIGHT) contentMode:PHImageContentModeAspectFill];
                }
        }
        cell.userView.image = image;
        cell.userLabel.text = [NSString stringWithFormat:@"%@(%lu)",title,(unsigned long)assetArray.count];
        return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        //判断文件夹中
        if ([self.folderData[indexPath.row][1] count] != 0) {
                NSMutableArray *array = [ZGPAViewModel accordingToTheCollectionTitleOfLodingPHAsset:self.folderData[indexPath.row][0]];
                
                if (self.selectType == ZGCPSelectTypeVideo) {//只选视频
                        for (PHAsset *asset in array) {
                                if (asset.mediaType == PHAssetMediaTypeVideo){
                                        [self pushThumbnailsPreviewParameter:self.folderData[indexPath.row][0] animated:YES];
                                        return;
                                }
                        }
                }
                if (self.selectType == ZGCPSelectTypeImageAndVideo) {//图片和视频合选
                        for (PHAsset *asset in array) {
                                if (asset.mediaType == PHAssetMediaTypeImage) {
                                        [self pushThumbnailsPreviewParameter:self.folderData[indexPath.row][0] animated:YES];
                                        return;
                                }else if (asset.mediaType == PHAssetMediaTypeVideo){
                                        [self pushThumbnailsPreviewParameter:self.folderData[indexPath.row][0] animated:YES];
                                        return;
                                }
                        }
                }
                if (self.selectType == ZGCPSelectTypeImage || self.whetherTheCrop == YES) {//只选择图片
                        for (PHAsset *asset in array) {
                                if (asset.mediaType == PHAssetMediaTypeImage) {
                                        [self pushThumbnailsPreviewParameter:self.folderData[indexPath.row][0] animated:YES];
                                        return;
                                }
                        }
                }
        }
}

- (void)pushThumbnailsPreviewParameter:(NSString *)title animated:(BOOL)animated
{
        //把带有数据的asssetArr传到下一个界面
        ZGCIPThumbnailsPreviewController *tpVC = [ZGCIPThumbnailsPreviewController new];
        tpVC.folderTitel = title;
        tpVC.thumbnailsPreviewDelegate = self;
        tpVC.selectedCount = self.selectedCount;
        tpVC.selectType = self.selectType;
        if (self.sendButtonImage == nil) {
                self.sendButtonImage = [UIImage imageNamed:@"icon_navbar_ok"];
        }
        tpVC.sendButtonImage = self.sendButtonImage;
        if (self.maySelectMaximumCount == 0) {
                self.maySelectMaximumCount = 9;
        }
        tpVC.maySelectMaximumCount = self.maySelectMaximumCount;
        tpVC.selectedCount = self.selectedCount;
        tpVC.whetherToEditPictures = self.whetherToEditPictures;
        tpVC.whetherTheCrop = self.whetherTheCrop;
        if (self.cropSize.width == 0 || self.cropSize.height == 0) {
                self.cropSize = [UIScreen mainScreen].bounds.size;
        }
        tpVC.cropSize = self.cropSize;
        if (self.maximumTimeVideo == 0) {
                self.maximumTimeVideo = 15;//
        }
        tpVC.maximumTimeVideo = self.maximumTimeVideo;
        tpVC.isSendTheOriginalPictures = self.isSendTheOriginalPictures;
        
        [self.navigationController pushViewController:tpVC animated:animated];
        
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return ZGCIP_CUSTOM_IMAGE_PICKER_CELL_HEIGHT;
}

#pragma mark - thumbnailsPreviewDelegate
- (void)thumbnailsPreviewController:(ZGCIPThumbnailsPreviewController *)thumbnails didFinishPickingImages:(NSMutableArray *)array isOriginalImage:(BOOL)original{
        
        [self.customImagePickerDelegate customImagePickerController:self didFinishPickingImages:array isSendTheOriginalPictures:original];
        if (thumbnails) {
                [thumbnails.navigationController popViewControllerAnimated:NO];
        }
}
- (void)thumbnailsPreviewControllerDidCancel:(ZGCIPThumbnailsPreviewController *)picker{
        [self.customImagePickerDelegate customImagePickerControllerDidCancel:self];
        if (picker) {
                [picker.navigationController  popViewControllerAnimated:NO];
        }
}
//设置为YES允许旋转，可以不设置下面的，但是一定要支持横竖屏才行，但往往不会这么设置，因为会对整个项目产生影响，而我们需要横屏的界面就那么几个。（需要横屏的一定要设为YES，否则即使设置下面的也是不能横屏的）
-(BOOL)shouldAutorotate
{
        return NO;
}

@end
