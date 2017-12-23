//
//  ZGCropPictureController.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/18.
//  Copyright © 2017年 saina. All rights reserved.

#import "ZGCropPictureController.h"
#import "ZGCropPictureModel.h"
#import "ZGCropPictureView.h"
#import "ZGNavigationTitleView.h"

#define LINIT_RATIO 2.5

@interface ZGCropPictureController ()<ZGNavigationTitleViewDelegate, ZGCropPictureViewDelegate>

@property(nonatomic, strong) ZGCropPictureView *cropView;
@property(nonatomic, strong) PHAsset *returnAsset;
@property(nonatomic, assign) CGRect  cropFrame;


@end

@implementation ZGCropPictureController
- (void)viewDidLoad {
    [super viewDidLoad];
       
        [[self navigationTitleView] setRightButtonsWithImageNames:@[@"icon_navbar_ok"]];
        [[self navigationTitleView] setLeftButtonsWithImageNames:@[@"icon_navbar_close"]];
        [self navigationTitleView].delegate = self;
        self.view.backgroundColor = [UIColor blackColor];
        

        self.cropView = [[ZGCropPictureView alloc] initWithFrame:self.view.bounds cropImage:self.cropPictureImage cropSize:self.cropPictureSize  isRound:self.isRound];
        self.cropView.delegate = self;
        [self.view addSubview:self.cropView];
        
        
        
}
#pragma mark - ZGCropPictureViewDelegate
-(void)cropPictureView:(ZGCropPictureView *)cropPicture cropViewFrame:(CGRect)frame{
        self.cropFrame = frame;

}

#pragma mark - ZGNavigationTitleViewDelegate
- (void)navigationTitleView:(ZGNavigationTitleView *)titleView buttonClickedAtLeftIndex:(NSInteger)index{
        if (self.cropPictureDelegate && [self.cropPictureDelegate conformsToProtocol:@protocol(ZGCropPictureControllerDelegate)]) {
                [self.cropPictureDelegate cropPictureControllerDidCancel:self];
        }

}
- (void)navigationTitleView:(ZGNavigationTitleView *)titleView buttonClickedAtRightIndex:(NSInteger)index{
        
        UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
        UIGraphicsBeginImageContext(screenWindow.frame.size);//全屏截图，包括window
        [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage =UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGRect cropRect = CGRectMake(self.cropFrame.origin.x + 1, self.cropFrame.origin.y + 45, self.cropFrame.size.width - 2, self.cropFrame.size.height - 2);
        UIImage * image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([viewImage CGImage], cropRect)];
        //
        CGFloat width = self.cropPictureImage.size.width / self.view.frame.size.width;
        CGFloat height =self.cropPictureImage.size.height / self.view.frame.size.height;
        CGFloat sclae = MAX(width, height);
        CGSize size = CGSizeMake(image.size.width * sclae, image.size.height * sclae);
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        UIImageWriteToSavedPhotosAlbum(scaledImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        UIGraphicsEndImageContext();
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
        if (!error) {
                if (self.cropPictureDelegate && [self.cropPictureDelegate conformsToProtocol:@protocol(ZGCropPictureControllerDelegate)]) {
                        [self.cropPictureDelegate cropPictureController:self didFinishCropingPictureAsset:[ZGCropPictureModel lastAsset]];
                }
        }else{
                if (self.cropPictureDelegate && [self.cropPictureDelegate conformsToProtocol:@protocol(ZGCropPictureControllerDelegate)]) {
                        [self.cropPictureDelegate cropPictureControllerDidCancel:self];
                }
        }
}
-(void)viewDidLayoutSubviews{
        self.statusBarHidden = YES;
}




@end
