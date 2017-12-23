//
//  AlbumViewController.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/16.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "AlbumViewController.h"
#import "ZGAssetPreviewController.h"
#import "ZGAssetPickerModel.h"
@interface AlbumViewController ()<ZGCustomAssetsPickerControllerDelegate>

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.view.backgroundColor = [UIColor whiteColor];
        
        NSArray *array = [NSArray arrayWithObjects:@"最多9张,完成按钮", @"最多9张,发送按钮",  @"视频编辑(只有视屏)", @"图片编辑(只有图片)", @"截图（width x height）", @"有原图按钮(其他默认)",nil];
        for (NSInteger i = 0; i < array.count; i++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.backgroundColor = [UIColor blackColor];
                [button setTitle:array[i] forState:UIControlStateNormal];
                button.center = self.view.center;
                button.tag = i;
                [button addTarget:self action:@selector(photoAlbumAction:) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake((self.view.frame.size.width - 200) * 0.5, 50 + 70  * i, 200, 50);
                [self.view addSubview:button];
        }

        
}

- (void)photoAlbumAction :(UIButton *)button{
        ZGCustomAssetPickerController *assetPicker = [[ZGCustomAssetPickerController alloc] init];
        assetPicker.assetsPickerDelegate = self;

        if (button.tag == 0){
                assetPicker.returnType = ZGCustomImagePickerReturnTypeFinish;
                assetPicker.allowsImageEditing = NO;
                assetPicker.videoMaximumDuration = 240;
        }else if (button.tag == 1){
                assetPicker.returnType = ZGCustomImagePickerReturnTypeSend;
                assetPicker.allowsImageEditing = YES;
                assetPicker.videoMaximumDuration = 240;
        }else if (button.tag == 2){
                assetPicker.selectType = ZGCustomAssetPickerSelectTypeVideo;
                assetPicker.videoMaximumDuration = 240;
                assetPicker.allowsImageEditing = NO;
        }else if (button.tag == 3){
                assetPicker.selectType = ZGCustomAssetPickerSelectTypeImage;
                assetPicker.allowsImageEditing = YES;
        }else if (button.tag == 4){
                assetPicker.allowsCroping = YES;
                assetPicker.cropSize = CGSizeMake(414, 414);
        } else if (button.tag == 5) {
                assetPicker.allowsRawImageSelecting = YES;
                assetPicker.allowsImageEditing = YES;
                assetPicker.videoMaximumDuration = 240;

        }

        [self.navigationController presentViewController:assetPicker animated:YES completion:nil];

}
- (void)customAssetsPickerController:(ZGCustomAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets isOriginalImage:(BOOL)isOriginalImage{
        for (int i = 0; i < assets.count; i++) {
                NSLog(@"%d -- %@ ----- %zi", i ,assets[i], isOriginalImage);

        }

        [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)customAssetsPickerControllerDidCancel:(ZGCustomAssetPickerController *)picker{
        [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
