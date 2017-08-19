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

#define Kheight kPAMainScreenHeight / 8

@interface MainViewController ()
@property(nonatomic, strong) UIAlertController*alertController;/**<#注释#>*/

@end

@implementation MainViewController
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

        
        self.view.backgroundColor = [UIColor whiteColor];
        UIButton *chatButton = [MainViewController initButtons:@"图与视频可合选, 图片可以编辑" frame:CGRectMake(0, Kheight, kPAMainScreenWidth, kPAMainToolsHeight) addTarget:self action:@selector(chatButtonAction)];
        [self.view addSubview:chatButton];
        UIButton *AvatarButton = [MainViewController initButtons:@"只能选择图片, 选择完成之后截图(高宽等比)" frame:CGRectMake(0, Kheight * 2, kPAMainScreenWidth, kPAMainToolsHeight) addTarget:self action:@selector(AvatarButtonAction)];
        [self.view addSubview:AvatarButton];
        UIButton *CircleOfFriendsButton = [MainViewController initButtons:@"图与视频单选, 视频与图片都可编辑" frame:CGRectMake(0, Kheight * 3, kPAMainScreenWidth, kPAMainToolsHeight) addTarget:self action:@selector(CircleOfFriendsButtonAction)];
        [self.view addSubview:CircleOfFriendsButton];
        UIButton *BitmapButton = [MainViewController initButtons:@"只能选择图片, 按屏幕大小截图" frame:CGRectMake(0, Kheight * 4, kPAMainScreenWidth, kPAMainToolsHeight) addTarget:self action:@selector(BitmapButtonAction)];
        [self.view addSubview:BitmapButton];
        UIButton *collectionButton = [MainViewController initButtons:@"图与视频单选, 图可编辑" frame:CGRectMake(0, Kheight * 5, kPAMainScreenWidth, kPAMainToolsHeight) addTarget:self action:@selector(collectionButtonAction)];
        [self.view addSubview:collectionButton];


}
//图与视频可合选, 图片可以编辑
-(void)chatButtonAction{
        ZGFolderViewController *folderC = [ZGFolderViewController new];
        folderC.thumbnailsPreviewStyle = ZGThumbnailsPreviewStyleChat;
        folderC.isInitializationPickerBar = YES;
        folderC.largestNum = 9;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:folderC];
        [self presentViewController:nav animated: YES completion:nil];
        
}
//只能选择图片, 选择完成之后截图(高宽等比)

-(void)AvatarButtonAction{
        ZGFolderViewController *folderC = [ZGFolderViewController new];
         folderC.thumbnailsPreviewStyle = ZGThumbnailsPreviewStyleAvatar;
        folderC.isInitializationPickerBar = NO;
        folderC.largestNum = 9;
        folderC.CutViewSize = CGSizeMake(kPAMainScreenWidth, kPAMainScreenWidth);

        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:folderC];
        [self presentViewController:nav animated: YES completion:nil];
}
//图与视频单选, 视频与图片都可编辑
-(void)CircleOfFriendsButtonAction{
        ZGFolderViewController *folderC = [ZGFolderViewController new];
        folderC.thumbnailsPreviewStyle = ZGThumbnailsPreviewStyleSCircleOfFriends;
        folderC.selectedNum = 3;
        folderC.largestNum = 9;
        folderC.minCopVideoTimer =  1.0;
        folderC.maxCopVideoTimer = 15;
        folderC.isInitializationPickerBar = YES;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:folderC];
        [self presentViewController:nav animated: YES completion:nil];
        

}
//只能选择图片, 按屏幕大小截图
-(void)BitmapButtonAction{
        ZGFolderViewController *folderC = [ZGFolderViewController new];
        folderC.thumbnailsPreviewStyle = ZGThumbnailsPreviewStyleBitmap;
        folderC.isInitializationPickerBar = NO;
        folderC.largestNum = 9;
        folderC.CutViewSize = CGSizeMake(kPAMainScreenWidth *(1- (kPANavigationHeight / kPAMainScreenHeight)), kPAMainScreenHeight* (1- (kPANavigationHeight / kPAMainScreenHeight)));

        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:folderC];
        [self presentViewController:nav animated: YES completion:nil];
}
//图与视频单选, 图可编辑
-(void)collectionButtonAction{
        ZGFolderViewController *folderC = [ZGFolderViewController new];
        folderC.thumbnailsPreviewStyle = ZGThumbnailsPreviewStyleCollection;
        folderC.selectedNum = 5;
        folderC.largestNum = 9;
        folderC.isInitializationPickerBar = YES;
        
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



@end
