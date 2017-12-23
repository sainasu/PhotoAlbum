//
//  ZGCustomAssetPickerController.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/14.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGCustomAssetPickerController.h"
#import "ZGAssetPreviewController.h"
#import "ZGAssetPickerModel.h"


#define PHOTO_ALNEM_HIEGHT 25

@interface ZGCustomAssetPickerController ()<UITableViewDelegate, UITableViewDataSource,ZGAssetPreviewControllerDelegate, ZGNavigationTitleViewDelegate>
@property(nonatomic, strong) NSMutableArray *photoAlnumsData;
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation ZGCustomAssetPickerController
- (NSMutableArray *)foderDataSource
{
        if (!_photoAlnumsData) {
                _photoAlnumsData = [[NSMutableArray alloc]init];
        }
        return _photoAlnumsData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        [self navigationTitleView].delegate = self;

        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if(status == PHAuthorizationStatusAuthorized) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [[self navigationTitleView] setRightButtonsWithImageNames:@[@"icon_navbar_close"]];

                                self.photoAlnumsData = [ZGAssetPickerModel obtainPhotoAlbums:CGSizeMake(PHOTO_ALNEM_HIEGHT * ([UIScreen mainScreen].scale * 2), PHOTO_ALNEM_HIEGHT * ([UIScreen mainScreen].scale * 2)) selectType:self.selectType];
                                if (self.selectType == ZGCustomAssetPickerSelectTypeVideo) {
                                        [self pushTotalPreviewControllerAnimated:NO PhotoAlbumTitle:self.photoAlnumsData[4][0]];
                                }else{
                                        [self pushTotalPreviewControllerAnimated:NO PhotoAlbumTitle:self.photoAlnumsData[0][0]];//直接跳转到AssetTotalPerview控制器
                                }
                                [self initWithAssetPickerControllerSubViews];
                                
                        });
                } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                                [[self navigationTitleView] setRightButtonsWithImageNames:@[@"icon_navbar_close"]];
                                UILabel *lable  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * 0.8, 80)];
                                lable.font = [UIFont systemFontOfSize:16];
                                lable.numberOfLines = 0;
                                lable.text = @"请在iPhone的“设置 -> 隐私 -> 照片”选项中， 允许Bainu访问你的手机相册。";
                                lable.center = CGPointMake(self.view.center.x, self.view.center.y * 0.5);
                                [self.view addSubview:lable];
                                if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied){
                                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"message:@"是否前往开启相册权限" preferredStyle:UIAlertControllerStyleAlert];
                                        [alertController addAction:[UIAlertAction actionWithTitle:@"确定"style:UIAlertActionStyleDestructive handler:^(UIAlertAction*_Nonnullaction) {
                                                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                                        [[UIApplication sharedApplication] openURL:url];
                                                }
                                        }]];
                                        [alertController addAction:[UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:^(UIAlertAction*_Nonnullaction) {
                                                if (self.assetsPickerDelegate && [self.assetsPickerDelegate conformsToProtocol:@protocol(ZGCustomAssetsPickerControllerDelegate)]) {
                                                        [self.assetsPickerDelegate customAssetsPickerControllerDidCancel:self];
                                                }
                                        }]];
                                        [self presentViewController:alertController animated:YES completion:^{
                                        }];
                                }
                        });
                }
        }];
}

- (void)navigationTitleView:(ZGNavigationTitleView *)titleView buttonClickedAtRightIndex:(NSInteger)index{
        if (self.assetsPickerDelegate && [self.assetsPickerDelegate conformsToProtocol:@protocol(ZGCustomAssetsPickerControllerDelegate)]) {
                [self.assetsPickerDelegate customAssetsPickerControllerDidCancel:self];
        }

}

-(void) initWithAssetPickerControllerSubViews{
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        
}
#pragma mark - UITableViewDelegate \ UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.photoAlnumsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.separatorInset = UIEdgeInsetsZero;
        NSMutableArray *dataArray = self.photoAlnumsData[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", dataArray[0], dataArray[1]];
        cell.imageView.image = dataArray[2];

        return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSMutableArray *dataArray = self.photoAlnumsData[indexPath.row];
        if (![dataArray[1] isEqualToString:@"0"]) {
                [self pushTotalPreviewControllerAnimated:YES PhotoAlbumTitle:dataArray[0]];
        }
}
-(void)pushTotalPreviewControllerAnimated:(BOOL)anima PhotoAlbumTitle:(NSString *)title{
        ZGAssetPreviewController *totalPreview = [ZGAssetPreviewController new];
        totalPreview.previewDelegate = self;
        totalPreview.selectType = self.selectType;
        totalPreview.returnType = self.returnType;
        totalPreview.allowsRawImageSelecting = self.allowsRawImageSelecting;
        //可选最大数：如大于9 或等于0， 则默认为9
        if (self.maximumCount > 9 || self.maximumCount == 0) {
                totalPreview.maximumCount = 9;
        }else{
                totalPreview.maximumCount = self.maximumCount;
        }
        
        //已选择数：大于可选择最大数， 则默认为0
        if (self.selectedCount >= self.maximumCount) {
                totalPreview.selectedCount = 0;
        }else{
                totalPreview.selectedCount = self.selectedCount;
        }
        //没有默认值
        totalPreview.allowsImageEditing = self.allowsImageEditing;
        
       
        //只有当 allowsCroping = YES时有效
        if (self.cropSize.width == 0 || self.cropSize.height == 0) {
                self.cropSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);
        }
        totalPreview.cropSize = self.cropSize;

        //videoMaximumDuration >=1  时可以截取视屏， 默认值为15s,
        if (self.videoMaximumDuration <= 1 || self.videoMaximumDuration > 300) {
                totalPreview.videoMaximumDuration = 300;
        }else{
                totalPreview.videoMaximumDuration = self.videoMaximumDuration;

        }
        // 截图：allowsCroping == YES 且 self.selectType != ZGCustomImagePickerSelectTypeVideo时 = yes， 默认为NO
        if (self.selectType != ZGCustomAssetPickerSelectTypeVideo && self.allowsCroping == YES ) {
                totalPreview.allowsCroping = YES;
                
        }else{
                totalPreview.allowsCroping = NO;
                
        }
        if (totalPreview.allowsCroping == YES) {
                totalPreview.selectType = ZGCustomAssetPickerSelectTypeImage;
                totalPreview.maximumCount = 1;
        }
        totalPreview.photoAlbumTitle = title;
        [self.navigationController pushViewController:totalPreview animated:anima];
        
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return PHOTO_ALNEM_HIEGHT * [UIScreen mainScreen].scale;
}


#pragma mark - ZGAssetPreviewControllerDelegate
-(void)assetsPreviewControllerDidCancel:(ZGAssetPreviewController *)picker{
        if (self.assetsPickerDelegate && [self.assetsPickerDelegate conformsToProtocol:@protocol(ZGCustomAssetsPickerControllerDelegate)]) {
                [self.assetsPickerDelegate customAssetsPickerControllerDidCancel:self];
        }
        [picker dismissViewControllerAnimated:NO completion:nil];
}
-(void)assetsPreviewController:(ZGAssetPreviewController *)picker didFinishPickingAssets:(NSArray *)assets isOriginalImage:(BOOL)isOriginalImage{
        if (self.assetsPickerDelegate && [self.assetsPickerDelegate conformsToProtocol:@protocol(ZGCustomAssetsPickerControllerDelegate)]) {
                [self.assetsPickerDelegate customAssetsPickerController:self didFinishPickingAssets:assets isOriginalImage:isOriginalImage];
        }
        [picker dismissViewControllerAnimated:NO completion:nil];
}

-(void)viewWillLayoutSubviews{
        _tableView.frame = self.view.bounds;
}


@end
