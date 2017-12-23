//
//  ZGPhotoEditingController.m
//  ZGPhotoEdit
//
//  Created by saina_barsud on 2017/12/8.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPhotoEditingController.h"
#import "ZGPhotoEditCollectionView.h"
#import "ZGPhotoEditHeader.h"
#import "ZGPhotoEditingTool.h"
#import "ZGPhotoEditNavBar.h"
#import "ZGPhotoEditCropView.h"
#import "ZGPhotoEditInputView.h"
#import "ZGPhotoEditModel.h"


@interface ZGPhotoEditingController ()< UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZGPhotoEditingToolDelegate, ZGPhotoEditNavBarDelegate, ZGPhotoEditCollectionViewDelegate, ZGPhotoEditCropViewDelegate, ZGPhotoEditInputViewDelegate>
@property(nonatomic, strong) ZGPhotoEditCollectionView *collectionView; // 滚动视图, 用于缩放图片
@property(nonatomic, strong) ZGPhotoEditingTool *toolBar; // 工具栏
@property(nonatomic, strong) ZGPhotoEditNavBar *navBar; // 导航栏
@property(nonatomic, strong) ZGPhotoEditCropView *cropView;  // 截图view
@property(nonatomic, strong) ZGPhotoEditInputView *inuptTextView; // <#注释#>
@property(nonatomic, assign) BOOL  isDoubleCilic;/**<#注释#>*/
@property(nonatomic, assign) CGRect  cropRect;/**<#注释#>*/
@property(nonatomic, assign) BOOL  isCropView;/**<#注释#>*/
@property(nonatomic, strong) UIImage *editImage;



@end

@implementation ZGPhotoEditingController
-(void)setPhotoAsset:(PHAsset *)photoAsset{
        _photoAsset = photoAsset;
        self.editImage  = [ZGPhotoEditModel obtainImage:_photoAsset imageSize:CGSizeMake(_photoAsset.pixelWidth * 0.3 * [UIScreen mainScreen].scale, _photoAsset.pixelHeight *  0.3 * [UIScreen mainScreen].scale)];

}

- (void)viewDidLoad {
    [super viewDidLoad];
        self.view.backgroundColor = [UIColor blackColor];
        self.collectionView = [[ZGPhotoEditCollectionView alloc] initWithFrame:CGRectZero editImage:self.editImage];
        self.collectionView.delegate = self;
        [self.view addSubview:self.collectionView];
        
        self.toolBar = [[ZGPhotoEditingTool alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - HEIGHT_PHOTO_EIDT_BAR_TOOL_X - HEIGHT_PHOTO_EIDT_BAR_TOOL, self.view.bounds.size.width, HEIGHT_PHOTO_EIDT_BAR_TOOL_X + HEIGHT_PHOTO_EIDT_BAR_TOOL) filterImage:self.editImage];
        self.toolBar.delegate = self;
        [self.view addSubview:self.toolBar];
        
        self.navBar = [[ZGPhotoEditNavBar alloc] init];
        self.navBar.delegate = self;
        [self.view addSubview:self.navBar];
        
        self.cropView = [[ZGPhotoEditCropView alloc] initWithFrame:self.view.bounds image:self.editImage];
        self.cropView.hidden = YES;
        self.cropView.cropDelegate = self;
        [self.view addSubview:self.cropView];
        
        self.inuptTextView = [[ZGPhotoEditInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        self.inuptTextView.inputDelegate = self;
        [self.view addSubview:self.inuptTextView];
        [self.collectionView drawView:@"nil" color:[UIColor clearColor] mosaicType:nil];
        if (self.isCropView == NO) {
                self.cropRect = [ZGPhotoEditModel obtainFrame:self.editImage frame:[UIScreen mainScreen].bounds];
        }

}

#pragma mark - ZGPhotoEditCollectionViewDelegate
- (void)collectionViewTouchesBegen:(ZGPhotoEditCollectionView *)view{
        // 开始触摸时隐藏
        [UIView animateWithDuration:0.2 animations:^{
                self.toolBar.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, HEIGHT_PHOTO_EIDT_BAR_TOOL_X + HEIGHT_PHOTO_EIDT_BAR_TOOL);
                self.navBar.frame = CGRectMake(0, -HEIGHT_PHOTO_EIDT_BAR_NAV_X, self.view.bounds.size.width, HEIGHT_PHOTO_EIDT_BAR_NAV_X);
        }];
        
}
- (void)collectionViewTouchesEnded:(ZGPhotoEditCollectionView *)view{
        // 结束触摸时显示
        [UIView animateWithDuration:0.6 animations:^{
                self.toolBar.frame = CGRectMake(0, self.view.bounds.size.height - HEIGHT_PHOTO_EIDT_BAR_TOOL_X - HEIGHT_PHOTO_EIDT_BAR_TOOL, self.view.bounds.size.width, HEIGHT_PHOTO_EIDT_BAR_TOOL_X + HEIGHT_PHOTO_EIDT_BAR_TOOL);
                self.navBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, HEIGHT_PHOTO_EIDT_BAR_NAV_X);
        }];
}
- (void)collectionViewDoubleClick:(ZGPhotoEditCollectionView *)view content:(NSString *)content textColor:(UIColor *)color{
        [self inuptViewAnimate:0.3 isInput:YES y:0];
        self.inuptTextView.text = content;
        self.inuptTextView.color = color;
        self.isDoubleCilic = YES;
}

#pragma mark - ZGPhotoEditingToolDelegate - 涂鸦
- (void)photoEditingToolDrawAction:(ZGPhotoEditingTool *)tool{
        [self.collectionView drawView:@"draw" color:[UIColor whiteColor] mosaicType:nil];
        self.toolBar.barType = @"colorBar";
}
- (void)photoEditTool:(ZGPhotoEditingTool *)tool brushColor:(UIColor *)color{
        [self.collectionView drawView:@"draw" color:color mosaicType:nil];
}

#pragma mark - ZGPhotoEditingToolDelegate - 添加图片
- (void)photoEditingToolAddImageAction:(ZGPhotoEditingTool *)tool{
        self.toolBar.barType = @"nil";

        //  1.判断相册是否可以打开
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
        //  2. 创建图片选择控制器
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        //  3. 设置打开照片相册类型(显示所有相簿)
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.delegate = self;
        [self presentViewController:ipc animated:YES completion:nil];
}
// 添加图片 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
        //  销毁控制器
        [picker dismissViewControllerAnimated:YES completion:nil];
        // 初始化addImageView
        UIImage *img = info[UIImagePickerControllerOriginalImage];
        self.collectionView.addImage = img;

}
#pragma mark - ZGPhotoEditingToolDelegate - 添加文字
- (void)photoEditingToolAddTextAction:(ZGPhotoEditingTool *)tool{
        [self inuptViewAnimate:0.3 isInput:YES y:0];
        self.inuptTextView.text = @"";
        self.toolBar.barType = @"nil";
        self.inuptTextView.color = [UIColor whiteColor];
        self.isDoubleCilic = NO;
        // 弹出输入框
}
- (void)photoEditTool:(ZGPhotoEditingTool *)tool textColor:(UIColor *)color{
        
}

- (void)inuptViewAnimate:(CGFloat)duration isInput:(BOOL)input y:(CGFloat)y{
        [UIView animateWithDuration:duration animations:^{
                self.inuptTextView.frame = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height);
                self.toolBar.hidden = input;
                self.navBar.hidden = input;
                
        }];
}
#pragma mark - ZGPhotoEditingToolDelegate - 滤镜
- (void)photoEditingToolFilderAction:(ZGPhotoEditingTool *)tool{
        self.toolBar.barType = @"filterBar";
        [self.collectionView drawView:@"nil" color:[UIColor clearColor] mosaicType:nil];

}
- (void)photoEditTool:(ZGPhotoEditingTool *)tool filterType:(NSString *)type{
        self.collectionView.filterType = type;
}

#pragma mark - ZGPhotoEditingToolDelegate - mosaic
- (void)photoEditingToolMosaicAction:(ZGPhotoEditingTool *)tool{
        self.toolBar.barType = @"mosaicBar";
        [self.collectionView drawView:@"mosaic" color:[UIColor clearColor] mosaicType:@"PhotoEdit_Mosaic_orrgin"];

}
- (void)photoEditTool:(ZGPhotoEditingTool *)tool mosaicType:(NSString *)type;{
        [self.collectionView drawView:@"mosaic" color:[UIColor clearColor] mosaicType:type];

}
#pragma mark - ZGPhotoEditingToolDelegate - 截图
- (void)photoEditingToolCropAction:(ZGPhotoEditingTool *)tool{
        self.toolBar.barType = @"nil";
        [self.collectionView drawView:@"tool" color:[UIColor clearColor] mosaicType:nil];
        
        
        
        // 获取截图
        CGRect rect = [ZGPhotoEditModel obtainFrame:self.editImage frame:[UIScreen mainScreen].bounds];
        self.collectionView.cropEndedFrame = rect;
        if (self.isCropView == NO) {
                self.cropRect = rect;
        }
        UIGraphicsBeginImageContext(self.collectionView.imageView.frame.size);
        [self.collectionView.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage =UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.cropView.hidden = NO;
        self.cropView.image = viewImage;
}

#pragma mark - ZGPhotoEditInputViewDelegate
-(void)inputView:(ZGPhotoEditInputView *)inputView didFinishContent:(NSString *)content textColor:(UIColor *)color{
        
        [self inuptViewAnimate:0.3 isInput:NO y:self.view.frame.size.height];
        [self.collectionView addContent:content isOldLabel:self.isDoubleCilic textColor:color];
}
-(void)inputViewDidCancel:(ZGPhotoEditInputView *)inputView{
        [self inuptViewAnimate:0.3 isInput:NO y:self.view.frame.size.height];

}

#pragma mark - ZGPhotoEditCropViewDelegate
// 完成截图
- (void)photoEditCropViewDidFinish:(ZGPhotoEditCropView *)cropView transform:(CGAffineTransform)transform  cropImageFrame:(CGRect)cropImageFrame{
        cropView.hidden = YES;
        self.collectionView.cropEndedFrame = cropImageFrame;
        self.cropRect = cropImageFrame;
        self.isCropView = YES;
}
// 取消截图
- (void)photoEditCropViewDidCancel:(ZGPhotoEditCropView *)cropView cropImageFrame:(CGRect)cropImageFrame{
        self.cropView.hidden = YES;
        self.collectionView.cropEndedFrame = self.cropRect;
}

#pragma mark - ZGPhotoEditNavBarDelegate
- (void)photoEditNavBarReturnButton:(ZGPhotoEditNavBar *)returnButton{
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditingControllerDelegate)]) {
                [self.delegate photoEditControllerDidCancel:self];
        }
}
- (void)photoEditNavBarFinishButton:(ZGPhotoEditNavBar *)finishButton{
        UIGraphicsBeginImageContext(self.collectionView.imageView.frame.size);
        [self.collectionView.imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage =UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 获取截图
        
        UIImage * drawImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([viewImage CGImage], CGRectMake(self.cropRect.origin.x,  self.cropRect.origin.y, self.cropRect.size.width, self.cropRect.size.height))];
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditingControllerDelegate)]) {
                NSMutableArray *imageIds = [NSMutableArray array];
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                        PHAssetChangeRequest *reuqest = [PHAssetChangeRequest creationRequestForAssetFromImage:drawImage];
                        [imageIds addObject:reuqest.placeholderForCreatedAsset.localIdentifier];
                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                        if (success){
                                //成功后取相册中的图片对象
                                PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
                                [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                        *stop = YES;
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [self.delegate photoEditController:self didFinishEditAsset:obj];

                                        });
                                }];
                        }
                }];
        }
}
- (void)photoEditNavBarClearButton:(ZGPhotoEditNavBar *)clearButton{
        [self.collectionView clearAllOperations];

}
- (void)photoEditNavBarUndoButton:(ZGPhotoEditNavBar *)undoButton{
        [self.collectionView undoOneStep];

}
#pragma mark - Setter方法
-(void)setEditImage:(UIImage *)editImage{
        _editImage = editImage;
}
#pragma mark - Controller Fonction
-(BOOL)prefersStatusBarHidden{
        return YES; // 在返回的控制器中调用本方法(YES隐藏, NO显示) 设置状态栏
}
-(void)viewWillLayoutSubviews{
        self.collectionView.frame = self.view.bounds;
        self.toolBar.frame = CGRectMake(0, self.view.bounds.size.height - HEIGHT_PHOTO_EIDT_BAR_TOOL_X - HEIGHT_PHOTO_EIDT_BAR_TOOL, self.view.bounds.size.width, HEIGHT_PHOTO_EIDT_BAR_TOOL_X + HEIGHT_PHOTO_EIDT_BAR_TOOL);
        self.navBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, HEIGHT_PHOTO_EIDT_BAR_NAV_X);
}


@end
