//
//  ZGPhotoEditingController.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/23.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPhotoEditingController.h"
#import "ZGPhotoAlbumHeader.h"
#import "ZGPhotoEditModel.h"
#import "ZGPhotoEditNavigatioBar.h"
#import "ZGPhotoEditTool.h"
#import "ZGPhotoEditCropView.h"
#import "ZGPhotoEditPaintView.h"
#import "ZGPhotoEditAddView.h"
#import "ZGPhotoEditDrawView.h"
#import "ZGPhotoEditInputView.h"

@interface ZGPhotoEditingController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, ZGPhotoEditNavigatioBarDelegate, ZGPhotoEditToolDelegate, ZGPhotoEditCropViewDelegate,UIGestureRecognizerDelegate,ZGPhotoEditDrawViewDelegate, ZGPhotoEditInputViewDelegate, ZGPhotoEditPaintViewDelegate, ZGPhotoEditAddViewDelegate>

@property(nonatomic, strong) ZGPhotoEditNavigatioBar *navigationBar;
@property(nonatomic, strong) ZGPhotoEditTool *tool;
@property(nonatomic, strong) ZGPhotoEditCropView *cropView;
@property(nonatomic, strong) ZGPhotoEditPaintView *paintView;
@property(nonatomic, strong) ZGPhotoEditDrawView *drawView;
@property(nonatomic, strong) ZGPhotoEditInputView *inuptTextView;

@property(nonatomic, strong) NSMutableArray *paintViewArray;  // 存放mosaic与draw公同绘画次数， 以便删除
@property(nonatomic, strong) NSMutableArray *addImageArray; // 存放天假的图片和文字的View， 以便操作
@property(nonatomic, assign) NSInteger addViewTag;
@property(nonatomic, assign) BOOL  isInuptView;
@property(nonatomic, assign) BOOL  isDoubleClick;

@property(nonatomic, strong) UIImage *image;
@property(nonatomic, assign) CGRect  cropFrame;

@end

@implementation ZGPhotoEditingController
- (NSMutableArray *)addImageArray
{
        if (!_addImageArray) {
                _addImageArray = [[NSMutableArray alloc]init];
        }
        return _addImageArray;
}
- (NSMutableArray *)paintViewArray
{
        if (!_paintViewArray) {
                _paintViewArray = [[NSMutableArray alloc]init];
        }
        return _paintViewArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        self.view.backgroundColor = COLOR_FOR_PHOTO_EDIT_BACKGROUND;
        [self initSubViews];
        
        [self initNavigationBar];
        
        [self initPhotoEditTool];
        
}
-(void)setPhotoAsset:(PHAsset *)photoAsset{
        _photoAsset = photoAsset;
        self.image  = [ZGPhotoEditModel obtainImage:_photoAsset imageSize:CGSizeMake(_photoAsset.pixelWidth * 0.3 * [UIScreen mainScreen].scale, _photoAsset.pixelHeight *  0.3 * [UIScreen mainScreen].scale)];
}


#pragma mark - 初始化navigationBar
- (void)initNavigationBar{
        self.navigationBar = [[ZGPhotoEditNavigatioBar alloc] init];
        self.navigationBar.navBarDelegate = self;
        [self.view addSubview:self.navigationBar];
}
#pragma mark - 初始化Tool
- (void)initPhotoEditTool{
        __block UIImage *image = [[UIImage alloc] init];
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        [[PHImageManager defaultManager] requestImageForAsset:self.photoAsset targetSize:CGSizeMake(HEIGHT_PHOTO_EIDT_BAR_TOOL * [UIScreen mainScreen].scale, HEIGHT_PHOTO_EIDT_BAR_TOOL * [UIScreen mainScreen].scale) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                image = result;
                self.tool = [[ZGPhotoEditTool alloc] initWithImage:image];
                self.tool.toolDelegate = self;
                [self.view addSubview:self.tool];
        }];
}
#pragma mark - 初始化子视图
- (void)initSubViews{
        
        CGRect frame = [ZGPhotoEditModel obtainFrame:self.image  frame:self.view.frame];
        self.paintView = [[ZGPhotoEditPaintView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) Image:self.image];
        self.cropFrame = self.paintView.frame;
        [self.paintView userInteractionStop];
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGRAct:)];
        panGR.delegate = self;
        [self.paintView setUserInteractionEnabled:YES];
        [self.paintView  addGestureRecognizer:panGR];
        self.paintView.center = self.view.center;

        self.paintView.paintDelegate = self;
        [self.view addSubview:self.paintView];
        
        self.drawView = [[ZGPhotoEditDrawView alloc] initWithFrame:self.paintView.bounds];
        self.drawView.backgroundColor = [UIColor clearColor];
        self.drawView.delegate = self;//
        self.drawView.center = self.paintView.center;
        [self.view addSubview:self.drawView];
        
        self.cropView = [[ZGPhotoEditCropView alloc] initWithFrame:self.view.bounds image:_image];
        self.cropView.hidden = YES;
        self.cropView.cropDelegate = self;
        [self.view addSubview:self.cropView];
        
        self.inuptTextView = [[ZGPhotoEditInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        self.inuptTextView.inputDelegate = self;
        self.isInuptView = NO;
        [self.view addSubview:self.inuptTextView];
        


}
-(void)viewWillLayoutSubviews{
        CGFloat width =  self.view.frame.size.width;
        CGFloat height =  self.view.frame.size.height;
        self.navigationBar.frame = CGRectMake(0, 0, width, HEIGHT_PHOTO_EIDT_BAR_NAV_X);
        self.tool.frame = CGRectMake(0, height - HEIGHT_PHOTO_EIDT_BAR_TOOL_X - HEIGHT_PHOTO_EIDT_BAR_TOOL, width, HEIGHT_PHOTO_EIDT_BAR_TOOL_X + HEIGHT_PHOTO_EIDT_BAR_TOOL);
        self.cropView.frame = self.view.bounds;
}
#pragma mark - UITouch
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        if (!self.isInuptView) {
                if (self.cropView.hidden == NO) {
                        self.navigationBar.hidden = YES;
                        self.tool.hidden = YES;
                }else{
                        self.navigationBar.hidden = !self.navigationBar.hidden;
                        self.tool.hidden = !self.tool.hidden;
                }
        }
}
#pragma mark - UIGestureRecognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
        if (self.drawView.userInteractionEnabled == YES){
                return NO;
        }
        if (self.paintView.isMosaic == YES){
                return NO;
        }
        if (self.isInuptView == YES) {
                return NO;
        }
        
        return YES;
        
}
- (void)panGRAct: (UIPanGestureRecognizer *)recognizer{
//        if (self.paintView.frame.size.height > self.view.frame.size.height) {
                CGPoint translation = [recognizer translationInView:self.view];
                CGPoint newCenter = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
                newCenter.x = self.paintView.center.x;
//                newCenter.y = MAX(self.view.frame.size.height - recognizer.view.frame.size.height / 2, newCenter.y);
//                newCenter.y = MIN(recognizer.view.frame.size.height / 2, newCenter.y);
                recognizer.view.center = newCenter;
                [recognizer setTranslation:CGPointZero inView:self.view];
                self.drawView.center = self.paintView.center;
        for (ZGPhotoEditAddView *addView in self.addImageArray) {
                addView.center = CGPointMake(addView.center.x, addView.center.y + translation.y);
        }

//        }
}
- (BOOL)prefersStatusBarHidden
{
        return YES;
}
#pragma mark - ZGPhotoEditToolDelegate
- (void)photoEditToolBrushColor:(UIColor *)color{
        self.navigationBar.barType = ZGPhotoEditNavagationBarTypeDraw;
        if (color == nil) {
                color = UIColorFromHex(0xffffff,1.0);
        }
        self.drawView.lineColor = color;
        self.drawView.userInteractionEnabled = YES;
}
- (void)photoEditToolAddImage{
        self.navigationBar.barType = ZGPhotoEditNavagationBarTypeNormal;
        [self.paintView userInteractionStop];
        self.drawView.userInteractionEnabled = NO;
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
        //  销毁控制器
        [picker dismissViewControllerAnimated:YES completion:nil];
        // 初始化addImageView
        UIImage *img = info[UIImagePickerControllerOriginalImage];
        CGFloat scole = 150 / img.size.width;
        
        ZGPhotoEditAddView *imageView = [[ZGPhotoEditAddView alloc] initWithFrame:CGRectMake(0, 0, img.size.width * scole, img.size.height * scole)];
        imageView.image = img;
        imageView.tag = self.addImageArray.count + 100;
        imageView.addDelegate = self;
        [self.addImageArray addObject:imageView];
        imageView.center = self.view.center;
        [self.view addSubview:imageView];
}


- (void)photoEditToolAddText{
        self.navigationBar.barType = ZGPhotoEditNavagationBarTypeNormal;
        [self.paintView userInteractionStop];
        self.drawView.userInteractionEnabled = NO;
        self.isDoubleClick = NO;
        [self inuptViewAnimate:0.3 isInput:YES y:0];
        self.inuptTextView.color = [UIColor whiteColor];
        self.inuptTextView.text = nil;
        [self.view addSubview:self.inuptTextView];
}

- (void)photoEditToolAddTextColor:(UIColor *)color{
        for (ZGPhotoEditAddView *view in self.addImageArray) {
                if (view.tag == self.addViewTag) {
                        view.color = color;
                }
        }
}
- (void)photoEditToolMosaicType:(NSString *)type{
        self.navigationBar.barType = ZGPhotoEditNavagationBarTypeMosaic;
        self.paintView.userInteractionEnabled = YES;
        self.drawView.userInteractionEnabled = NO;
        if ([type isEqualToString:@"PhotoEdit_Mosaic_orrgin"]) {
                self.paintView.mosaicImage = nil;
        }else{
                self.paintView.mosaicImage = [UIImage imageNamed:type];
        }
}
- (void)photoEditToolFilterType:(NSString *)type{
        self.paintView.filterType = type;
        self.drawView.userInteractionEnabled = NO;

}
- (void)photoEditToolFilterClick{
        self.navigationBar.barType = ZGPhotoEditNavagationBarTypeNormal;
        [self.paintView userInteractionStop];
        self.drawView.userInteractionEnabled = NO;

}
- (void)photoEditToolCrop{
        self.navigationBar.barType = ZGPhotoEditNavagationBarTypeNormal;
        self.navigationBar.hidden = YES;
        [self.paintView userInteractionStop];
        self.drawView.userInteractionEnabled = NO;
        self.tool.hidden = YES;
        self.drawView.keepOffFrame = CGRectMake(0, 0, 0, 0);
        self.cropView.image = [self cropViewimage];
        self.drawView.keepOffFrame = CGRectZero;

        self.cropView.hidden = NO;
        [self.view addSubview:self.cropView];
}
- (UIImage *)cropViewimage{
        // 保存上次记录
        CGAffineTransform transform = self.paintView.transform;
        CGRect frame = self.paintView.frame;
        CGRect imageRect = [ZGPhotoEditModel obtainFrame:self.image  frame:self.view.frame];
        CGFloat sclaeW = imageRect.size.width / frame.size.width;
        CGFloat sclaeH = imageRect.size.height / frame.size.height;
        // 还原到最初
        self.paintView.transform = CGAffineTransformScale(transform, sclaeW, sclaeH);
        self.paintView.center = self.view.center;
        self.drawView.transform = self.paintView.transform;
        self.drawView.center = self.paintView.center;
        // 获取截图
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage =UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImage * drawImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([viewImage CGImage], self.paintView.frame)];
        
        
        // 还原上次记录
        self.paintView.transform = transform;
        self.paintView.frame = frame;
        self.drawView.transform = self.paintView.transform;
        self.drawView.center = self.paintView.center;
        return drawImage;
}
#pragma mark - ZGPhotoEditInputViewDelegate
-(void)inputView:(ZGPhotoEditInputView *)inputView didFinishContent:(NSString *)content textColor:(UIColor *)color{
        if (self.isDoubleClick == YES) {
                for (ZGPhotoEditAddView *view in self.addImageArray) {
                        if (self.addViewTag == view.tag) {
                                [view removeFromSuperview];
                        }
                }
        }
        if (![ZGPhotoEditModel isEmpty:content]) {// 判断是否为空  或者全部为空格
                CGFloat height =  [ZGPhotoEditModel getHeightByWidth:200 title:content font:[UIFont systemFontOfSize:15]];
                ZGPhotoEditAddView *textView = [[ZGPhotoEditAddView alloc] initWithFrame:CGRectMake(0, 0, 200 + 20,height + 20)];
                textView.content = content;
                textView.tag = self.addImageArray.count + 100;
                textView.center = self.view.center;
                textView.color = color;
                textView.addDelegate = self;
                self.addViewTag = textView.tag;
                [self.addImageArray addObject:textView];
                [self.view addSubview:textView];
        }
        [self.tool cellSelected:color];
        [self inuptViewAnimate:0.3 isInput:NO y:self.view.frame.size.height];
        
}
-(void)inputViewDidCancel:(ZGPhotoEditInputView *)inputView{
        [self inuptViewAnimate:0.3 isInput:NO y:self.view.frame.size.height];
        if (self.isDoubleClick == YES) {
                for (ZGPhotoEditAddView *view in self.addImageArray) {
                        if (self.addViewTag == view.tag) {
                                view.hidden = NO;
                        }
                }
        }
}
- (void) inuptViewAnimate:(CGFloat)duration isInput:(BOOL)input y:(CGFloat)y{
        [UIView animateWithDuration:duration animations:^{
                self.inuptTextView.frame = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height);
                self.tool.hidden = input;
                self.navigationBar.hidden = input;
                self.isInuptView = input;
        }];
}

#pragma mark - ZGPhotoEditAddViewDelegate
-(void)addViewTap:(ZGPhotoEditAddView *)addView tapAction:(NSInteger)tag;
{
        self.drawView.userInteractionEnabled = NO;
        self.paintView.userInteractionEnabled = NO;
        self.addViewTag = tag;
        for (ZGPhotoEditAddView *view in self.addImageArray) {
                [view stopTimer];
                if (tag == view.tag) {
                        [view startCountDown];
                        [self.view addSubview:view];
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                        if (view.image == nil) {
                                button.tag = 3;
                                [self.tool buttonsSelected:button];
                                if (view.color == nil) {
                                        [self.tool cellSelected:[UIColor blackColor]];
                                }else{
                                        [self.tool cellSelected:view.color];
                                }
                                self.navigationBar.barType = ZGPhotoEditNavagationBarTypeNormal;
                        }else{
                                button.tag = 2;
                                [self.tool buttonsSelected:button];
                        }
                }
        }
}
-(void)addViewDoubleTap:(ZGPhotoEditAddView *)addView tapAction:(NSInteger)tag;
{
        self.drawView.userInteractionEnabled = NO;
        self.paintView.userInteractionEnabled = NO;
        self.isDoubleClick = YES;
        self.addViewTag = tag;
        for (ZGPhotoEditAddView *view in self.addImageArray) {
                [view stopTimer];
                if (tag == view.tag) {
                        [view startCountDown];
                        [self.view addSubview:view];
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                        if (view.image == nil) {
                                button.tag = 3;
                                [self.tool buttonsSelected:button];
                                if (view.color == nil) {
                                        [self.tool cellSelected:[UIColor blackColor]];
                                        self.inuptTextView.color = [UIColor blackColor];
                                }else{
                                        [self.tool cellSelected:view.color];
                                        self.inuptTextView.color = view.color;
                                }
                                self.navigationBar.barType = ZGPhotoEditNavagationBarTypeNormal;
                                [self inuptViewAnimate:0.3 isInput:YES y:0];
                                self.inuptTextView.text = view.content;
                                view.hidden = YES;
                                
                        }else{
                                button.tag = 2;
                                [self.tool buttonsSelected:button];
                        }
                }
        }
}
- (void)addViewRemoveFromSuperview:(ZGPhotoEditAddView *)addView{
        self.drawView.userInteractionEnabled = NO;
        self.paintView.userInteractionEnabled = NO;
        [addView removeFromSuperview];
        [self.addImageArray removeObject:addView];
}

#pragma mark - ZGPhotoEditNavigatioBarDelegate
- (void)photoEditNavigatioBarDidFinish:(ZGPhotoEditNavigatioBar *)finish{
        
        for (ZGPhotoEditAddView *imageView in self.addImageArray) {
                [imageView stopTimer];
        }
        self.navigationBar.hidden = YES;
        self.tool.hidden = YES;
        if (self.photoDelegate && [self.photoDelegate conformsToProtocol:@protocol(ZGPhotoEditingControllerDelegate)]) {
                UIImage *image = [self cropImage];
                NSMutableArray *imageIds = [NSMutableArray array];
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                        PHAssetChangeRequest *reuqest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                        [imageIds addObject:reuqest.placeholderForCreatedAsset.localIdentifier];
                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                        if (success){
                                //成功后取相册中的图片对象
                                PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
                                [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                        *stop = YES;
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                [self.photoDelegate photoEditController:self didFinishEditAsset:obj];
                                        });
                                }];
                        }
                }];
        }
}
- (UIImage *)cropImage{
        CGAffineTransform transform = self.paintView.transform;
        CGRect frame = self.paintView.frame;
        CGRect imageRect = [ZGPhotoEditModel obtainFrame:self.image  frame:self.view.frame];
        CGFloat sclaeW = imageRect.size.width / frame.size.width;
        CGFloat sclaeH = imageRect.size.height / frame.size.height;
        // 还原到最初
        self.paintView.transform = CGAffineTransformScale(transform, sclaeW, sclaeH);
        self.paintView.center = self.view.center;
        self.drawView.transform = self.paintView.transform;
        self.drawView.center = self.paintView.center;
        self.drawView.keepOffFrame = CGRectMake(0, 0, 0, 0);
        
        // 获取截图
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage =UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImage * drawImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([viewImage CGImage], CGRectMake(self.paintView.frame.origin.x + self.cropFrame.origin.x, self.paintView.frame.origin.y + self.cropFrame.origin.y, self.cropFrame.size.width, self.cropFrame.size.height))];
        
        // 改变剪切的image的大小；
        CGFloat sclae = self.image.size.width / self.view.frame.size.width;
        CGSize size = CGSizeMake(drawImage.size.width * sclae, drawImage.size.height * sclae);
        UIGraphicsBeginImageContext(size);
        [drawImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaledImage;
}
- (void)photoEditNavigatioBarDidCancel:(ZGPhotoEditNavigatioBar *)cancel{
        if (self.photoDelegate && [self.photoDelegate conformsToProtocol:@protocol(ZGPhotoEditingControllerDelegate)]) {
                [self.photoDelegate photoEditControllerDidCancel:self];
        }
}
- (void)photoEditNavigatioBarDidReset:(ZGPhotoEditNavigatioBar *)reset barType:(ZGPhotoEditNavagationBarType)barType{
        [self.paintView resetAvtion];
        [self.drawView clearScreen];
        [self.paintViewArray removeAllObjects];
}
- (void)photoEditNavigatioBarDidBack:(ZGPhotoEditNavigatioBar *)back barType:(ZGPhotoEditNavagationBarType)barType{
        NSString *string = self.paintViewArray.lastObject;
        if ([string isEqualToString:@"YES"]) {
                [self.paintViewArray removeLastObject];
                [self.paintView backAction];
        }else if ([string isEqualToString:@"NO"]) {
                [self.paintViewArray removeLastObject];
                [self.drawView revokeScreen];
        }
}
#pragma mark - ZGPhotoEditDrawViewDelegate
- (void)darwView:(ZGPhotoEditDrawView *)darwView{
        [self.paintViewArray addObject:@"NO"];
}
#pragma mark - ZGPhotoEditPaintViewDelegate
- (void)paintView:(ZGPhotoEditPaintView *)paintView{
        [self.paintViewArray addObject:@"YES"];
}
#pragma mark - ZGPhotoEditCropViewDelegate
- (void)photoEditCropViewDidFinish:(ZGPhotoEditCropView *)cropView centerPoint:(CGPoint)point cropFrame:(CGRect)frame transform:(CGAffineTransform)transform cropImageFrame:(CGRect)cropImageFrame{
        
        self.cropFrame = cropImageFrame; // 截图位置(用于保存图片)
        cropView.hidden = YES;
        self.navigationBar.hidden = NO;
        self.tool.hidden = NO;
        CGFloat sclaeW = self.view.frame.size.width / (frame.size.width * 1.1);
        self.paintView.transform = CGAffineTransformMakeScale(sclaeW + transform.a - 1, sclaeW + transform.a - 1);
        self.paintView.center = CGPointMake(point.x * self.paintView.transform.a , point.y * self.paintView.transform.a);

        //设定涂鸦视图的位置
        self.drawView.keepOffFrame = cropImageFrame;
        self.drawView.transform = self.paintView.transform;
        self.drawView.center = self.paintView.center;
        for (ZGPhotoEditAddView *imageView in self.addImageArray) {
        //移动添加的图片和文字的位置
        imageView.center = CGPointMake((imageView.center.x + point.x * (transform.a + sclaeW - 1)) / 2, (imageView.center.y + point.y * (transform.a + sclaeW - 1)) / 2);
        imageView.transform = self.paintView.transform;
        }
        
        
        
}
- (void)photoEditCropViewDidCancel:(ZGPhotoEditCropView *)cropView cropImageFrame:(CGRect)cropImageFrame{
        self.drawView.keepOffFrame = cropImageFrame;
        cropView.hidden = YES;
        self.navigationBar.hidden = NO;
        self.tool.hidden = NO;
}

@end
