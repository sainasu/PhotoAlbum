//
//  ZGEditPicturesController.m
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/30.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGEditPicturesController.h"
#import "SNPEViewModel.h"
#import "ZGPAViewModel.h"
#import "ZGCIPHeader.h"
#import "SNMosaicView.h"
#import "SNPEAddWord.h"
#import "SNPEDrawView.h"
#import "SNFilterScrollView.h"
#import "SNPEInputWordView.h"
#import "SNPEScreenshotView.h"
#import "SNPEAddImageView.h"

@interface ZGEditPicturesController ()<SNFilterToolVIewDelegate, SNFilterToolVIewDataSource, TweaButtonDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, SNEditTextDelegate, UIGestureRecognizerDelegate, SNMosaicViewDelegate>{
        //四周遮挡View
        UIView *_topView;
        UIView *_underView;
        UIView *_leftView;
        UIView *_rightView;
        int imageNumber;
        UIImage *_sendImage;
        int _incrementCount;
        NSInteger _addWordViewTag;
}
#pragma mark - Views
@property(nonatomic, strong) UIView *editPictresBarView;/**主工具栏*/
@property(nonatomic, strong) UIView *editPictresAssistantBarView;/**副工具栏*/
@property(nonatomic, strong) UIView *navigationToolsView;/**导航栏View*/
@property(nonatomic, strong) UIView *mainAdjustView;/**底层View*/
@property(nonatomic, strong) UIButton *selectedButton;/**公用button*/
@property(nonatomic, strong) UIButton *colorButton;/**颜色选项的选中状态*/
@property(nonatomic, strong) SNMosaicView *mosaicView;/**mosaic*/
@property(nonatomic, strong) SNPEDrawView *drawView;/**涂鸦*/
@property(nonatomic, strong) SNFilterScrollView *filterView;/**滤镜*/
@property(nonatomic, strong) SNPEScreenshotView *screenshotView;/**截图View*/
@property(nonatomic, strong) SNPEAddImageView *addImageView;/**添加图片View*/
@property(nonatomic, strong) SNPEAddWord *addWordView;/**添加文字View*/
@property(nonatomic, strong) SNPEInputWordView *inputView;/**输入View*/
#pragma mark - Data
@property(nonatomic, copy) NSString *isRemove;/**判断是否在截图*/
@property(nonatomic, copy) NSArray *filterImageArr;/**滤镜样式*/
@property(nonatomic, copy) NSMutableArray *mosaicArrA;/**mosaic图数组*/
@property(nonatomic, copy) NSMutableArray *mosaicArrB;/**mosaic图数组*/
@property(nonatomic, strong) UIImage *mainImage;/**<#注释#>*/
@property(nonatomic, copy) NSMutableArray *addImageArray;/**<#注释#>*/
@property(nonatomic, strong) NSMutableArray *addWordArray;/**<#注释#>*/


@end

@implementation ZGEditPicturesController
- (NSMutableArray *)addWordArray
{
        if (!_addWordArray) {
                _addWordArray = [[NSMutableArray alloc]init];
        }
        return _addWordArray;
}

- (NSMutableArray *)addImageArray
{
        if (!_addImageArray) {
                _addImageArray = [[NSMutableArray alloc]init];
        }
        return _addImageArray;
}

- (NSMutableArray *)mosaicArrA
{
        if (!_mosaicArrA) {
                _mosaicArrA = [[NSMutableArray alloc]init];
        }
        return _mosaicArrA;
}
- (NSMutableArray *)mosaicArrB
{
        if (!_mosaicArrB) {
                _mosaicArrB = [[NSMutableArray alloc]init];
        }
        return _mosaicArrB;
}


- (void)viewDidLoad {
        [super viewDidLoad];
        if (self.editPicturesAsset != nil) {
                self.mainImage = [ZGPAViewModel createAccessToImage:self.editPicturesAsset imageSize:CGSizeMake(self.editPicturesAsset.pixelWidth*0.5, self.editPicturesAsset.pixelHeight*0.5) contentMode:PHImageContentModeAspectFill];
        }else{
                self.mainImage = self.editImage;
        }
        
        
        //设置控制器属性
        self.view.backgroundColor = ZGCIP_COSTOM_COLOR(37, 37, 38, 1);
        self.isRemove = @"";
        //初始化子控件
        [self initWithSubViews];
        //初始化工具栏
        [self initMainToolView];
        //初始化导航栏
        [self initNavigationViewType:@"main"];
        
        
}
//初始化子View
-(void)initWithSubViews
{
        
        //获取到位置
        CGRect frame = [SNPEViewModel adjustTheUIInTheImage:self.mainImage oldImage:self.mainImage];
        //初始化底层View
        _mainAdjustView = [[UIView alloc] initWithFrame:frame];
        _mainAdjustView.backgroundColor = [UIColor whiteColor];
        _mainAdjustView.center = self.view.center;
        [self.view addSubview:_mainAdjustView];
        
        //初始化mosaicView
        _mosaicView = [[SNMosaicView alloc] initWithFrame:self.mainAdjustView.bounds image:self.mainImage];
        _mosaicView.center = self.view.center;
        _mosaicView.backgroundColor = [UIColor clearColor];
        _mosaicView.mosaicDelegate = self;
        [self.view addSubview:_mosaicView];
        
        //初始化涂鸦View
        _drawView = [[SNPEDrawView alloc] initWithFrame:_mosaicView.bounds];
        _drawView.backgroundColor = [UIColor clearColor];
        _drawView.center = self.view.center;
        [self.drawView setLineWith:6];
        [self.drawView setLineColor:[UIColor blackColor]];
        [self.view addSubview:_drawView];
        
        //初始化遮挡View
        [self initKeepOutViews:_mainAdjustView.bounds];
}
#pragma mark - 初始化遮挡View
-(void)initKeepOutViews:(CGRect)rect
{
        if (_topView) {
                [_topView removeFromSuperview];
                [_underView removeFromSuperview];
                [_leftView removeFromSuperview];
                [_rightView removeFromSuperview];
        }
        CGFloat width = rect.size.width;
        CGFloat height = rect.size.height;
        //上距
        CGFloat top = (ZGCIP_MAINSCREEN_HEIGHT - height) / 2;
        //下距
        CGFloat under = ZGCIP_MAINSCREEN_HEIGHT - top;
        //左距
        CGFloat left = (ZGCIP_MAINSCREEN_WIDTH - width) / 2;
        //右距
        CGFloat right = ZGCIP_MAINSCREEN_WIDTH - left;
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZGCIP_MAINSCREEN_WIDTH, top)];
        _topView.backgroundColor = ZGCIP_COSTOM_COLOR(37, 37, 38, 1.0);
        [self.view addSubview:_topView];
        _underView = [[UIView alloc] initWithFrame:CGRectMake(0, under, ZGCIP_MAINSCREEN_WIDTH, top)];
        _underView.backgroundColor = ZGCIP_COSTOM_COLOR(37, 37, 38, 1.0);
        [self.view addSubview:_underView];
        _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, left, ZGCIP_MAINSCREEN_HEIGHT)];
        _leftView.backgroundColor = ZGCIP_COSTOM_COLOR(37, 37, 38, 1.0);
        [self.view addSubview:_leftView];
        _rightView = [[UIView alloc] initWithFrame:CGRectMake(right, 0, left, ZGCIP_MAINSCREEN_HEIGHT)];
        _rightView.backgroundColor = ZGCIP_COSTOM_COLOR(37, 37, 38, 1.0);
        [self.view addSubview:_rightView];
}


#pragma mark - 初始化导航栏
/**
 初始化导航栏

 @param type 判断字符串
 */
- (void)initNavigationViewType:(NSString *)type
{
        if (_navigationToolsView) {
                [_navigationToolsView removeFromSuperview];
        }
        _navigationToolsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZGCIP_MAINSCREEN_WIDTH, ZGCIP_TABBAR_HEIGHT)];
        _navigationToolsView.backgroundColor = ZGCIP_COSTOM_COLOR(0, 0, 0, 1);
        //返回按钮
        UIButton *returnButton = [SNPEViewModel createBtnFrame:CGRectMake(0, 0, ZGCIP_TABBAR_HEIGHT, ZGCIP_TABBAR_HEIGHT) image:[UIImage imageNamed:@"PE_navbar_back"] SelectedImage:[UIImage imageNamed:@"PE_navbar_back"] target:self action:@selector(retunButtonAction)];
        [_navigationToolsView addSubview:returnButton];
        //保存按钮
        UIButton *saveButton = [SNPEViewModel createBtnFrame:CGRectMake(ZGCIP_MAINSCREEN_WIDTH - ZGCIP_TABBAR_HEIGHT, 0, ZGCIP_TABBAR_HEIGHT, ZGCIP_TABBAR_HEIGHT) image:[UIImage imageNamed:@"PE_navbar_ok"] SelectedImage:[UIImage imageNamed:@"PE_navbar_ok"] target:self action:@selector(saveButtonAction)];
        [_navigationToolsView addSubview:saveButton];
        
        //判断不同按钮点击事件: 更改副工具栏和导航栏
        if (self.editPictresAssistantBarView) {//如果等于assistantToolsView, 则删除.  重新初始化
                [self.editPictresAssistantBarView removeFromSuperview];
        }
        self.editPictresAssistantBarView = [[UIView alloc] initWithFrame:CGRectMake(0, ZGCIP_MAINSCREEN_HEIGHT - ZGCIP_TABBAR_HEIGHT - ZGCIP_PUBLIC_POP_TABBAR_HRIGHT, ZGCIP_MAINSCREEN_WIDTH, ZGCIP_PUBLIC_POP_TABBAR_HRIGHT + 3)];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.editPictresAssistantBarView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(3, 3)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.editPictresAssistantBarView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.editPictresAssistantBarView.layer.mask = maskLayer;
        self.editPictresAssistantBarView.layer.borderColor =ZGCIP_COSTOM_COLOR(226, 226, 226, 1).CGColor;
        self.editPictresAssistantBarView.layer.borderWidth = 1;
        self.editPictresAssistantBarView.backgroundColor = ZGCIP_COSTOM_COLOR(255, 255, 255, 0.98);
        
        CGFloat assistantW = ZGCIP_MAINSCREEN_WIDTH / 2;
        
        if ([type isEqualToString:@"pan"]) {
                //
                UIScrollView *scrollView = [SNPEViewModel initWithColorScrollViewBackgroundColor:ZGCIP_COSTOM_COLOR(255, 255, 255, 0.98) frame:CGRectMake(0, 0, ZGCIP_MAINSCREEN_WIDTH - ZGCIP_PUBLIC_POP_TABBAR_HRIGHT / 2, ZGCIP_PUBLIC_POP_TABBAR_HRIGHT) frameWidth:ZGCIP_PUBLIC_POP_TABBAR_HRIGHT addTarget:self action:@selector(colorAction:)];
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PE_MoreColor@2x_09"]];
                imageView.frame = CGRectMake(ZGCIP_MAINSCREEN_WIDTH - ZGCIP_PUBLIC_POP_TABBAR_HRIGHT / 2, ZGCIP_PUBLIC_POP_TABBAR_HRIGHT / 4 + ZGCIP_PUBLIC_POP_TABBAR_HRIGHT / 8, ZGCIP_PUBLIC_POP_TABBAR_HRIGHT / 4, ZGCIP_PUBLIC_POP_TABBAR_HRIGHT / 4);
                [self.editPictresAssistantBarView addSubview:imageView];
                [self.editPictresAssistantBarView addSubview:scrollView];
                [self.view addSubview:self.editPictresAssistantBarView];
                _drawView.userInteractionEnabled = YES;
                _mosaicView.userInteractionEnabled = NO;
                //后退按钮
                UIButton *backButton = [SNPEViewModel createBtnFrame:CGRectMake(assistantW - ZGCIP_TABBAR_HEIGHT - 22, 0, ZGCIP_TABBAR_HEIGHT, ZGCIP_TABBAR_HEIGHT) image:[UIImage imageNamed:@"PE_return"] SelectedImage:[UIImage imageNamed:@"PE_return"] target:self action:@selector(panBackButtonAction)];
                [_navigationToolsView addSubview:backButton];
                //清除按钮
                UIButton *clearButton = [SNPEViewModel createBtnFrame:CGRectMake(assistantW + ZGCIP_TABBAR_HEIGHT - 22, 0, ZGCIP_TABBAR_HEIGHT, ZGCIP_TABBAR_HEIGHT) image:[UIImage imageNamed:@"PE_reset"] SelectedImage:[UIImage imageNamed:@"PE_reset"] target:self action:@selector(panClearButtonAction)];
                [_navigationToolsView addSubview:clearButton];
                
                
        }else if ([type isEqualToString:@"mosaic"]){
                [self.view addSubview:self.editPictresAssistantBarView];
                _mosaicView.userInteractionEnabled = YES;
                _drawView.userInteractionEnabled = NO;
                //传统mosaic
                UIButton *mosaic1 = [SNPEViewModel createBtnFrame:CGRectMake(0, 0, 50, 50) image:[UIImage imageNamed:@"PE_tabbar_Mosaic"] SelectedImage:[UIImage imageNamed:@"PE_tabbar_Mosaic"] target:self action:@selector(mosaic1Action)];
                [self.editPictresAssistantBarView addSubview:mosaic1];
                //油画mosaic
                UIButton *mosaic2 = [SNPEViewModel createBtnFrame:CGRectMake(80, 0, 50, 50) image:[UIImage imageNamed:@"PE_mosaic_acrylic"] SelectedImage:[UIImage imageNamed:@"PE_mosaic_acrylic"] target:self action:@selector(mosaicClick)];
                [self.editPictresAssistantBarView addSubview:mosaic2];
                //smallMosaic
                UIButton *smallMosaic = [SNPEViewModel createBtnFrame:CGRectMake(160, 0, 50, 50) image:[UIImage imageNamed:@"PE_mosaic_small"] SelectedImage:[UIImage imageNamed:@"PE_mosaic_small"] target:self action:@selector(smallmosaicClick)];
                [self.editPictresAssistantBarView addSubview:smallMosaic];
                //smallMosaic
                UIButton *paintMosaic = [SNPEViewModel createBtnFrame:CGRectMake(240, 0, 50, 50) image:[UIImage imageNamed:@"PE_mosaic_paint"] SelectedImage:[UIImage imageNamed:@"PE_mosaic_paint"] target:self action:@selector(paintMosaicClick)];
                [self.editPictresAssistantBarView addSubview:paintMosaic];
                
                
                //后退按钮
                UIButton *backButton = [SNPEViewModel createBtnFrame:CGRectMake(assistantW - ZGCIP_TABBAR_HEIGHT - 22, 0, ZGCIP_TABBAR_HEIGHT, ZGCIP_TABBAR_HEIGHT) image:[UIImage imageNamed:@"PE_return"] SelectedImage:[UIImage imageNamed:@"PE_return"] target:self action:@selector(mosaicBackButtonAction)];
                [_navigationToolsView addSubview:backButton];
                //清除按钮
                UIButton *clearButton = [SNPEViewModel createBtnFrame:CGRectMake(assistantW + ZGCIP_TABBAR_HEIGHT - 22, 0, ZGCIP_TABBAR_HEIGHT, ZGCIP_TABBAR_HEIGHT) image:[UIImage imageNamed:@"PE_reset"] SelectedImage:[UIImage imageNamed:@"PE_reset"] target:self action:@selector(mosaicClearButtonAction)];
                [_navigationToolsView addSubview:clearButton];
                
                
                
                
        }else if ([type isEqualToString:@"filter"]){
                _drawView.userInteractionEnabled = NO;
                _mosaicView.userInteractionEnabled = NO;
        }
        [self.navigationController.navigationBar addSubview:_navigationToolsView];
        [self.view addSubview:self.editPictresBarView];
}
#pragma mark - 导航返回按钮点击事件
-(void)retunButtonAction
{
        [self.editPicturesDelegate editPicturesControllerDidCancel:self];
}
#pragma mark - 导航保存按钮点击事件
-(void)saveButtonAction{
        
        /*
         PHAsset : 一个PHAsset对象就代表一个资源文件,比如一张图片
         PHAssetCollection : 一个PHAssetCollection对象就代表一个相册
         
         */
        
        __block NSString *assetId = nil;
        // 1. 存储图片到"相机胶卷"
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{ // 这个block里保存一些"修改"性质的代码
                // 新建一个PHAssetCreationRequest对象, 保存图片到"相机胶卷"
                // 返回PHAsset(图片)的字符串标识
                assetId = [PHAssetCreationRequest creationRequestForAssetFromImage:[self saveImageAction]].placeholderForCreatedAsset.localIdentifier;
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (error) {
                
                        return;
                }
                
                PHAsset *asset = [ZGPAViewModel lastAsset];//获取
                [self.editPicturesDelegate editPicturesController:self photoEditorSaveImage:self.editPicturesAsset newAsset:asset];

        }];
}
-(UIImage *)saveImageAction{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        if (self.editPictresAssistantBarView) {
                [self.editPictresAssistantBarView removeFromSuperview];
        }
        //你需要的区域起点,宽,高;[SNPEViewModel adjustTheUIInTheImage:self.mainImage oldImage:self.mainImage];
        CGRect rect1 = CGRectMake(self.mainAdjustView.bounds.origin.x, _topView.bounds.size.height, self.mainAdjustView.bounds.size.width, self.mainAdjustView.bounds.size.height);
        
        self.editPictresAssistantBarView.hidden = YES;
        self.editPictresBarView.hidden = YES;
        
        UIGraphicsEndImageContext();
        UIGraphicsBeginImageContext(self.view.bounds.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGImageRef imageRef =image.CGImage;
        CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect1);
        _sendImage =[[UIImage alloc] initWithCGImage:imageRefRect];
        
        
        return _sendImage;
}
#pragma mark - 初始化main工具栏
-(void)initMainToolView{
        if (self.editPictresBarView) {
                [self.editPictresBarView removeFromSuperview];
        }
        self.editPictresBarView = [[UIView alloc] initWithFrame:CGRectMake(0, ZGCIP_MAINSCREEN_HEIGHT - ZGCIP_TABBAR_HEIGHT, ZGCIP_MAINSCREEN_WIDTH, ZGCIP_TABBAR_HEIGHT)];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.editPictresBarView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(3, 3)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.editPictresBarView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.editPictresBarView.layer.mask = maskLayer;
        self.editPictresBarView.layer.borderColor =ZGCIP_COSTOM_COLOR(226, 226, 226, 1.0).CGColor;
        self.editPictresBarView.layer.borderWidth = 1;
        self.editPictresBarView.backgroundColor = ZGCIP_COSTOM_COLOR(255, 255, 255, 0.98);
        //涂鸦按钮
        UIButton *panButton = [SNPEViewModel createBtnFrame:CGRectMake(ZGCIP_TABBAR_BUTTONS_SPACING(1), 0,ZGCIP_TABBAR_HEIGHT, ZGCIP_TABBAR_HEIGHT) image:[UIImage imageNamed:@"PE_tabbar_pan"] SelectedImage:[UIImage imageNamed:@"PE_tabbar_panS"] target:self action:@selector(panButtonAction:)];
        [self.editPictresBarView addSubview:panButton];
        //添加图片按按钮
        UIButton *photoButton = [SNPEViewModel createBtnFrame:CGRectMake(ZGCIP_TABBAR_BUTTONS_SPACING(3),0,  ZGCIP_TABBAR_HEIGHT, ZGCIP_TABBAR_HEIGHT) image:[UIImage imageNamed:@"PE_tabbar_photo"] SelectedImage:[UIImage imageNamed:@"PE_tabbar_photoS"] target:self action:@selector(photoButtonAction:)];
        [self.editPictresBarView addSubview:photoButton];
        //添加文本按钮
        UIButton *wordButton = [SNPEViewModel createBtnFrame:CGRectMake(ZGCIP_TABBAR_BUTTONS_SPACING(5),0,  ZGCIP_TABBAR_HEIGHT, ZGCIP_TABBAR_HEIGHT) image:[UIImage imageNamed:@"PE_tabbar_word"] SelectedImage:[UIImage imageNamed:@"PE_tabbar_wordS"] target:self action:@selector(wordButtonAction:)];
        [self.editPictresBarView addSubview:wordButton];
        //mosaic按钮
        UIButton *mosaicButton = [SNPEViewModel createBtnFrame:CGRectMake( ZGCIP_TABBAR_BUTTONS_SPACING(7),0, ZGCIP_TABBAR_HEIGHT, ZGCIP_TABBAR_HEIGHT) image:[UIImage imageNamed:@"PE_tabbar_Mosaic"] SelectedImage:[UIImage imageNamed:@"PE_tabbar_MosaicS"] target:self action:@selector(mosaicButtonAction:)];
        [self.editPictresBarView addSubview:mosaicButton];
        //滤镜按钮
        UIButton *filterButton = [SNPEViewModel createBtnFrame:CGRectMake(ZGCIP_TABBAR_BUTTONS_SPACING(9),0,  ZGCIP_TABBAR_HEIGHT, ZGCIP_TABBAR_HEIGHT) image:[UIImage imageNamed:@"PE_tabbar_filter"] SelectedImage:[UIImage imageNamed:@"PE_tabbar_filterS"] target:self action:@selector(filterButtonAction:)];
        [self.editPictresBarView addSubview:filterButton];
        //截图按钮
        UIButton *cutButton = [SNPEViewModel createBtnFrame:CGRectMake( ZGCIP_TABBAR_BUTTONS_SPACING(11),0, ZGCIP_TABBAR_HEIGHT, ZGCIP_TABBAR_HEIGHT) image:[UIImage imageNamed:@"PE_tabbar_ShotS"] SelectedImage:[UIImage imageNamed:@"PE_tabbar_Shot"] target:self action:@selector(cutButtonAction:)];
        [self.editPictresBarView addSubview:cutButton];
        [self.view addSubview:self.editPictresBarView];
}

#pragma mark - 画笔按钮
-(void)panButtonAction:(UIButton *)sender{
        
        if (sender != _selectedButton){
                _selectedButton.selected = NO;
                _selectedButton = sender;
        }
        _selectedButton.selected = YES;
        [self initNavigationViewType:@"pan"];
}
//颜色选择
- (void)colorAction:(UIButton *)btn
{
        if (btn != self.colorButton){
                self.colorButton.selected = NO;
                self.colorButton = btn;
        }
        self.colorButton.selected = YES;
        UIColor *color = [btn backgroundColor];
        [self.drawView setLineColor:color];//涂鸦颜色
}
//返回
-(void)panBackButtonAction{
        [self.drawView undo];
}
//清除
-(void)panClearButtonAction{
        [self.drawView clear];
}

#pragma mark - 添加图片按钮
-(void)photoButtonAction:(UIButton *)sender{
        _drawView.userInteractionEnabled = NO;
        _mosaicView.userInteractionEnabled = NO;
        //打开相册获取图片
        // 1.判断相册是否可以打开
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
        // 2. 创建图片选择控制器
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        // 3. 设置打开照片相册类型(显示所有相簿)
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 4.设置代理
        ipc.delegate = self;
        // 5.modal出这个控制器
        [self presentViewController:ipc animated:YES completion:nil];
        
}
//添加图片 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
        // 销毁控制器
        [picker dismissViewControllerAnimated:YES completion:nil];
        //初始化addImageView
        UIImage *img = info[UIImagePickerControllerOriginalImage];
        CGFloat imageW = img.size.width;
        CGFloat imageH = img.size.height;
        CGRect imageRect;
        if (imageW > imageH) {
                imageRect = CGRectMake(0, 0, 150, 150 * (imageH / imageW));
        }else{
                imageRect = CGRectMake(0, 0, 150 * (imageW / imageH), 150);
        }
        
        SNPEAddImageView *addImageView = [[SNPEAddImageView alloc] initWithFrame:imageRect image:img];
        addImageView.center = self.view.center;
        addImageView.tag = self.addImageArray.count + 1000;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImageTapAction:)];
        tap.delegate = self;
        [addImageView addGestureRecognizer:tap];
        //长按
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        longPress.delegate = self;
        [addImageView addGestureRecognizer:longPress];
        
        
        [self.addImageArray addObject:addImageView];
        [self.view addSubview:addImageView];
        
}
-(void)addImageTapAction:(UITapGestureRecognizer *)tap{
        [self.view addSubview:tap.view];
}
//处理长按手势
- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
        
        //图片闪一下,然后将图片绘制到画板上面去
        [UIView animateWithDuration:0.25 animations:^{
                longPress.view.alpha = 0.1;
        } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.23 animations:^{
                        longPress.view.alpha = 1;
                } completion:^(BOOL finished) {
                        //开启位图上下文，将图片渲染到位图上下文
                        UIGraphicsBeginImageContextWithOptions( longPress.view.frame.size, NO, 0.0);
                        CGContextRef ctx = UIGraphicsGetCurrentContext();
                        [ longPress.view.layer  renderInContext:ctx];
                        UIGraphicsEndImageContext();
                        //移除
                        [longPress.view removeFromSuperview];
                        [self.addImageArray removeObject:longPress.view];
                }];
        }];
        
}

#pragma mark - 添加文字按钮
-(void)wordButtonAction:(UIButton *)sender{
        _drawView.userInteractionEnabled = NO;
        _mosaicView.userInteractionEnabled = NO;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        if (self.inputView) {
                [self.inputView removeFromSuperview];
        }
        self.inputView = [[SNPEInputWordView alloc] initWithFrame:CGRectMake(0, 0 , ZGCIP_MAINSCREEN_WIDTH, ZGCIP_MAINSCREEN_HEIGHT)];
        self.inputView.textView.keyboardType = UIKeyboardTypeDefault;
        self.inputView.delegate = self;
        [self.view addSubview:self.inputView];
}
#pragma mark - 添加文字的代理
//取消
- (void)customImagePickerControllerDidCancel:(SNPEInputWordView *)inputWordView
{
        if ([self.isRemove isEqualToString: @"addWordViewTwoTapAction"]) {
                [self.view addSubview:self.addWordArray[_addWordViewTag]];
        }
        [inputWordView removeFromSuperview];
}
//确认
- (void)inputWordView:(SNPEInputWordView *)inputWordView didFinishContent:(NSString *)content textColor:(UIColor *)color;
{
        if (![content  isEqual: @""]) {
                UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 0)];
                label3.font = [UIFont systemFontOfSize:15];
                label3.numberOfLines = 0;
                label3.text = content;
                CGSize size = [label3 sizeThatFits:CGSizeMake(label3.frame.size.width, MAXFLOAT)];
                self.addWordView = [[SNPEAddWord alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) word:content color:color];
                self.addWordView.center = self.view.center;
                _incrementCount ++;
                self.addWordView.tag = _incrementCount;
                [self.addWordArray addObject:self.addWordView];
                
                //单击手势
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addWordTapAction:)];
                tap.delegate = self;
                tap.numberOfTapsRequired = 1;
                [self.addWordView addGestureRecognizer:tap];
                //长按
                UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(wrodlongPress:)];
                longPress.delegate = self;
                [self.addWordView addGestureRecognizer:longPress];
                //双击手势
                UITapGestureRecognizer *twoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addWordViewTwoTapAction:)];
                twoTap.numberOfTapsRequired = 2;
                twoTap.delegate = self;
                [self.addWordView addGestureRecognizer:twoTap];
                if ([self.isRemove isEqualToString: @"addWordViewTwoTapAction"]) {
                        [self.addWordArray[_addWordViewTag] removeFromSuperview];
                }
                
                [self.view addSubview:self.addWordView];
        }
        [inputWordView removeFromSuperview];
}
//单击
-(void)addWordTapAction:(UITapGestureRecognizer *)tap{
        [self.view addSubview:tap.view];
        NSInteger tag = tap.view.tag;
        if (self.addWordView.tag == tag) {
                self.addWordView.backgroundColor= [UIColor whiteColor];
                double delayInSeconds = 2.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        //执行事件
                        self.addWordView.backgroundColor = [UIColor clearColor];
                });

                
        }else{
                self.addWordView.backgroundColor = [UIColor clearColor];
        }

        
        
}
//双击手势
-(void)addWordViewTwoTapAction:(UITapGestureRecognizer *)twoTap{
        NSInteger tag = twoTap.view.tag;
        _addWordViewTag = tag - 1;
        _drawView.userInteractionEnabled = NO;
        _mosaicView.userInteractionEnabled = NO;
        self.isRemove = @"addWordViewTwoTapAction";
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        if (self.inputView) {
                [self.inputView removeFromSuperview];
        }
        self.inputView = [[SNPEInputWordView alloc] initWithFrame:CGRectMake(0, 0 , ZGCIP_MAINSCREEN_WIDTH, ZGCIP_MAINSCREEN_HEIGHT)];
        self.inputView.textView.keyboardType = UIKeyboardTypeDefault;
        self.inputView.delegate = self;
        self.addWordView = self.addWordArray[_addWordViewTag];
        self.inputView.textView.text = self.addWordView.label.text;
       // self.inputView.textView.textColor = _addWordView.label.textColor;
        [self.view addSubview:self.inputView];
        
        
}

//处理长按手势
- (void)wrodlongPress:(UILongPressGestureRecognizer *)longPress
{
        
        //图片闪一下,然后将图片绘制到画板上面去
        [UIView animateWithDuration:0.25 animations:^{
                longPress.view.alpha = 0.1;
        } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.23 animations:^{
                        longPress.view.alpha = 1;
                } completion:^(BOOL finished) {
                        //开启位图上下文，将图片渲染到位图上下文
                        UIGraphicsBeginImageContextWithOptions( longPress.view.frame.size, NO, 0.0);
                        CGContextRef ctx = UIGraphicsGetCurrentContext();
                        [ longPress.view.layer  renderInContext:ctx];
                        UIGraphicsEndImageContext();
                        //移除
                        [longPress.view removeFromSuperview];
                        [self.addImageArray removeObject:longPress.view];
                }];
        }];
        
}


#pragma mark - mosaic按钮
-(void)mosaicButtonAction:(UIButton *)sender{
        if (sender != _selectedButton){
                _selectedButton.selected = NO;
                _selectedButton = sender;
        }
        _selectedButton.selected = YES;
        [self initNavigationViewType:@"mosaic"];
        
}
//返回
-(void)mosaicBackButtonAction{
        
        [self.mosaicView undo];
}
//清除
-(void)mosaicClearButtonAction{
        
        [self.mosaicView clear];
}
//原始mosaic
-(void)mosaic1Action{
        [self.mosaicView setMosaicImage:nil];
}
//油画mosaic
-(void)mosaicClick{
        [self.mosaicView setMosaicImage:[UIImage imageNamed:@"PE_mosaic_jg"]];
}
-(void)smallmosaicClick{
        [self.mosaicView setMosaicImage:[UIImage imageNamed:@"PE_mosaic_small"]];
}
-(void)paintMosaicClick{
        [self.mosaicView setMosaicImage:[UIImage imageNamed:@"PE_mosaic_acrylic"]];
}
#pragma mark - 滤镜按钮
-(void)filterButtonAction:(UIButton *)sender{
        if (sender != _selectedButton){
                _selectedButton.selected = NO;
                _selectedButton = sender;
        }
        _selectedButton.selected = YES;
        [self initNavigationViewType:@"filter"];
        //图片数组
        _filterImageArr = [NSArray arrayWithObjects:
                           @"OriginImage",
                           @"CIPhotoEffectProcess",
                           @"CIPhotoEffectChrome",
                           @"CIPhotoEffectTransfer",
                           @"CIPhotoEffectFade",
                           @"CIPhotoEffectInstant",
                           @"CIPhotoEffectTonal",
                           @"CIPhotoEffectMono",
                           @"CIPhotoEffectNoir",
                           @"CISRGBToneCurveToLinear",
                           @"CIVignetteEffect",
                           nil];
        self.filterView = [[SNFilterScrollView alloc] initWithFrame:CGRectMake(0, 0, ZGCIP_MAINSCREEN_WIDTH, ZGCIP_PUBLIC_POP_TABBAR_HRIGHT)];
        self.filterView.scrollViewDelegate = self;
        self.filterView.dataSource = self;
        self.filterView.padding = 10;
        [self.filterView reloadData];
        
        [self.editPictresAssistantBarView addSubview:self.filterView];
        [self.view addSubview:self.editPictresAssistantBarView];
        _drawView.userInteractionEnabled = NO;
        _mosaicView.userInteractionEnabled = NO;
        
        [self.mosaicArrA addObject:self.mosaicView.MyImageViewA.image];
        [self.mosaicArrB addObject:self.mosaicView.MyImageView.image];
        
}
#pragma mark - filter代理
- (NSInteger)numberOfPageInPageScrollView:(SNFilterScrollView*)pageScrollView{
        return [self.filterImageArr count];
}
- (UIView*)pageScrollView:(SNFilterScrollView*)pageScrollView viewForRowAtIndex:(int)index{
        
        UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZGCIP_PUBLIC_POP_TABBAR_HRIGHT, ZGCIP_PUBLIC_POP_TABBAR_HRIGHT)];
        cell.backgroundColor = [UIColor cyanColor];
        UIImageView *imagView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ZGCIP_PUBLIC_POP_TABBAR_HRIGHT, ZGCIP_PUBLIC_POP_TABBAR_HRIGHT)];
        imagView.image = [UIImage imageNamed:self.filterImageArr[index]];
        [cell addSubview:imagView];
        return cell;
}
- (CGSize)sizeCellForPageScrollView:(SNFilterScrollView*)pageScrollView{
        return CGSizeMake(ZGCIP_PUBLIC_POP_TABBAR_HRIGHT, ZGCIP_PUBLIC_POP_TABBAR_HRIGHT);
}
- (void)pageScrollView:(SNFilterScrollView *)pageScrollView didTapPageAtIndex:(NSInteger)index{
        [self fliterEvent:[self.filterImageArr objectAtIndex:index]];
        
}
// 滤镜处理事件
- (void)fliterEvent:(NSString *)filterName{
        
        
        if ([filterName isEqualToString:@"OriginImage"]) {
                _mosaicView.MyImageView.image = [self.mosaicArrB lastObject];
                _mosaicView.MyImageViewA.image =[self.mosaicArrA lastObject];
        }else{
                //将UIImage转换成CIImage
                CIImage *ciImage = [[CIImage alloc] initWithImage:[self.mosaicArrA lastObject]];
                //创建滤镜
                CIFilter *filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
                //已有的值不改变，其他的设为默认值
                [filter setDefaults];
                //获取绘制上下文
                CIContext *context = [CIContext contextWithOptions:nil];
                //渲染并输出CIImage
                CIImage *outputImage = [filter outputImage];
                //创建CGImage句柄
                CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
                //获取图片
                UIImage *image = [UIImage imageWithCGImage:cgImage];
                //释放CGImage句柄
                CGImageRelease(cgImage);
                _mosaicView.MyImageViewA.image = image;
                
                CIImage *mosaicImage = [[CIImage alloc] initWithImage:[self.mosaicArrB lastObject]];
                CIFilter *filter1 = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, mosaicImage, nil];
                //已有的值不改变，其他的设为默认值
                [filter1 setDefaults];
                //获取绘制上下文
                CIContext *context1 = [CIContext contextWithOptions:nil];
                //渲染并输出CIImage
                CIImage *outputImage1 = [filter1 outputImage];
                //创建CGImage句柄
                CGImageRef cgImage1 = [context1 createCGImage:outputImage1 fromRect:[outputImage1 extent]];
                //获取图片
                UIImage *image1 = [UIImage imageWithCGImage:cgImage1];
                //释放CGImage句柄
                CGImageRelease(cgImage1);
                _mosaicView.MyImageView.image = image1;
        }
}



#pragma mark - 截图按钮
-(void)cutButtonAction:(UIButton *)sender{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        if (self.editPictresAssistantBarView) {
                [self.editPictresAssistantBarView removeFromSuperview];
        }
        
        UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
        UIGraphicsBeginImageContext(screenWindow.frame.size);//全屏截图，包括window
        [self.mosaicView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage =UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //你需要的区域起点,宽,高;
        CGRect rect1 = [SNPEViewModel adjustTheUIInTheImage:self.mainImage oldImage:self.mainImage];
        UIImage * mosaicImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([viewImage CGImage], rect1)];
        //画笔页面的截图
        UIGraphicsBeginImageContext(_drawView.frame.size);
        [_drawView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *dView =UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImage * drawImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([dView CGImage], rect1)];
        
        
        UIImage *resultingImage = [[UIImage alloc] init];
        if (self.addImageArray.count != 0 || self.addWordArray.count != 0) {
                UIView *view = [[UIView alloc] init];
                UIGraphicsBeginImageContext(mosaicImage.size);
                [mosaicImage drawInRect:CGRectMake(0, 0, mosaicImage.size.width, mosaicImage.size.height)];
                [drawImage drawInRect:CGRectMake(0, 0, mosaicImage.size.width, mosaicImage.size.height)];
                
                for (view in self.addImageArray) {
                        view.backgroundColor = [UIColor clearColor];

                        UIGraphicsBeginImageContext(view.frame.size);
                        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
                        UIImage *addImage =UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        UIImage *addView2 = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([addImage CGImage], rect1)];
                        CGFloat imageY =  view.frame.origin.y - _mosaicView.frame.origin.y;
                        [addView2 drawInRect:CGRectMake(view.frame.origin.x , imageY, view.frame.size.width, view.frame.size.height)];
                }
                for (view in self.addWordArray) {
                        view.backgroundColor = [UIColor clearColor];

                        UIGraphicsBeginImageContext(view.frame.size);
                        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
                        UIImage *addImage =UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        UIImage *addView2 = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([addImage CGImage], rect1)];
                        CGFloat imageY =  view.frame.origin.y - _mosaicView.frame.origin.y;
                        [addView2 drawInRect:CGRectMake(view.frame.origin.x , imageY, view.frame.size.width, view.frame.size.height)];
                }

                resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
        }else{
                UIGraphicsBeginImageContext(mosaicImage.size);
                [mosaicImage drawInRect:CGRectMake(0, 0, mosaicImage.size.width, mosaicImage.size.height)];
                [drawImage drawInRect:CGRectMake(0, 0, mosaicImage.size.width, mosaicImage.size.height)];
                resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
        }
        
        
        //初始化截图View414, 660
        if (_screenshotView) {
                [_screenshotView removeFromSuperview];
        }
        self.screenshotView = [[SNPEScreenshotView alloc] initWithFrame:[UIScreen mainScreen].bounds image:resultingImage maxRotationAngle:0];
        self.screenshotView.backgroundColor = [UIColor blackColor];
        self.screenshotView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.screenshotView.delegate = self;
        [self.view addSubview:self.screenshotView];
        
        _drawView.userInteractionEnabled = NO;
        _mosaicView.userInteractionEnabled = NO;
        
        
}
//截图 取消按钮代理
-(void)buttonIsclick:(id)sender{
        /**
         *  截图取消的时候容易出错
         */
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.editPictresBarView.hidden = NO;
        [self.screenshotView removeFromSuperview];
        
        
}
//截图 保存按钮代理
-(void)buttonIsDone:(id)sendet{
        
        //截图的方法
        CGAffineTransform transform = CGAffineTransformIdentity;
        // translate
        CGPoint translation = [self.screenshotView photoTranslation];
        //平移
        transform = CGAffineTransformTranslate(transform, translation.x, translation.y);
        //旋转
        transform = CGAffineTransformRotate(transform, self.screenshotView.angle);
        // scale x' = a*x + c*y + tx   y' = x*b + y*d + ty
        CGAffineTransform t = self.screenshotView.photoContentView.transform;
        CGFloat xScale =  sqrt(t.a * t.a + t.c * t.c + t.tx);
        CGFloat yScale = sqrt(t.b * t.b + t.d * t.d + t.ty);
        //缩放
        transform = CGAffineTransformScale(transform, xScale, yScale);
        
        //
        CGImageRef imageRef = [self newTransformedImage:transform
                                            sourceImage:self.mainImage.CGImage
                                             sourceSize:self.mainImage.size
                                      sourceOrientation:self.mainImage.imageOrientation
                                            outputWidth:self.mainImage.size.width
                                               cropSize:self.screenshotView.cropView.frame.size
                                          imageViewSize:self.screenshotView.photoContentView.bounds.size];
        
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        /**
         *  传进来的image的大小比原来的self.mainImage的大小大， 那么返回来的尺寸则比缩放之后的要大
         所以截图之后的_mainAdjustView的frame大。KeepOutViews的位置是跟随_mainAdjustView的；
         
         *****解决方案*****：
         
         */
        
        
        //3 移动mosaic、涂鸦、添加图片的View；
        self.mosaicView.transform = transform;
        self.addWordView.transform = self.mosaicView.transform;
        self.addImageView.transform = self.mosaicView.transform;
        self.drawView.transform = self.mosaicView.transform;
        
        //1 获取到frame
        CGRect frame = [SNPEViewModel adjust:image oldImage:self.mainImage];
        
        _mainAdjustView.frame = frame;
        _mainAdjustView.center = self.view.center;
        
        
        [self KeepOutViews:_mainAdjustView.frame];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.editPictresBarView.hidden = NO;
        [self.screenshotView removeFromSuperview];
}
#pragma mark - 调整遮挡View
-(void)KeepOutViews:(CGRect)rect{
        CGFloat width = rect.size.width;
        CGFloat height = rect.size.height;
        //上距
        CGFloat top = (ZGCIP_MAINSCREEN_HEIGHT - height) / 2;
        //下距
        CGFloat under = ZGCIP_MAINSCREEN_HEIGHT - top;
        //左距
        CGFloat left = (ZGCIP_MAINSCREEN_WIDTH - width) / 2;
        //右距
        CGFloat right = ZGCIP_MAINSCREEN_WIDTH - left;
        _topView.frame = CGRectMake(0, 0, ZGCIP_MAINSCREEN_WIDTH, top);
        _underView.frame = CGRectMake(0, under, ZGCIP_MAINSCREEN_WIDTH, top);
        _leftView.frame = CGRectMake(0, 0, left, ZGCIP_MAINSCREEN_HEIGHT);
        _rightView.frame = CGRectMake(right, 0, left, ZGCIP_MAINSCREEN_HEIGHT);
}


- (CGImageRef)newTransformedImage:(CGAffineTransform)transform
                      sourceImage:(CGImageRef)sourceImage
                       sourceSize:(CGSize)sourceSize
                sourceOrientation:(UIImageOrientation)sourceOrientation
                      outputWidth:(CGFloat)outputWidth
                         cropSize:(CGSize)cropSize
                    imageViewSize:(CGSize)imageViewSize{
        CGImageRef source = [SNPEViewModel newScaledImage:sourceImage
                                          withOrientation:sourceOrientation
                                                   toSize:sourceSize
                                              withQuality:kCGInterpolationNone];
        
        CGFloat aspect = cropSize.height / cropSize.width;
        CGSize outputSize = CGSizeMake(outputWidth, outputWidth * aspect);
        
        CGContextRef context = CGBitmapContextCreate(NULL,
                                                     outputSize.width,
                                                     outputSize.height,
                                                     CGImageGetBitsPerComponent(source),
                                                     0,
                                                     CGImageGetColorSpace(source),
                                                     CGImageGetBitmapInfo(source));
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        CGContextFillRect(context, CGRectMake(0, 0, outputSize.width, outputSize.height));
        
        CGAffineTransform uiCoords = CGAffineTransformMakeScale(outputSize.width / cropSize.width,
                                                                outputSize.height / cropSize.height);
        uiCoords = CGAffineTransformTranslate(uiCoords, cropSize.width/2.0, cropSize.height / 2.0);
        uiCoords = CGAffineTransformScale(uiCoords, 1.0, -1.0);
        CGContextConcatCTM(context, uiCoords);
        
        CGContextConcatCTM(context, transform);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CGContextDrawImage(context, CGRectMake(-imageViewSize.width/2.0,
                                               -imageViewSize.height/2.0,
                                               imageViewSize.width,
                                               imageViewSize.height)
                           , source);
        
        CGImageRef resultRef = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        CGImageRelease(source);
        return resultRef;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        if ([self.isRemove isEqualToString:@"remove"]) {
                CGPoint point = [[touches anyObject] locationInView:self.view];
                point = [_addImageView.layer convertPoint:point fromLayer:self.view.layer];
                
                if ([_addImageView.layer containsPoint:point]) {
                        
                }
                [self.navigationController setNavigationBarHidden:YES animated:YES];
                [UIView animateWithDuration:0.5 animations:^{
                        self.editPictresBarView.frame = CGRectMake(0, ZGCIP_MAINSCREEN_HEIGHT, ZGCIP_MAINSCREEN_WIDTH, ZGCIP_TABBAR_HEIGHT);
                        self.editPictresAssistantBarView.frame = CGRectMake(0, ZGCIP_MAINSCREEN_HEIGHT, ZGCIP_MAINSCREEN_WIDTH, ZGCIP_PUBLIC_POP_TABBAR_HRIGHT + 3);
                }];
        }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        if ([self.isRemove isEqualToString:@"remove"]) {
                [self.navigationController setNavigationBarHidden:NO animated:YES];
                [UIView animateWithDuration:0.5 animations:^{
                        self.editPictresBarView.frame = CGRectMake(0, ZGCIP_MAINSCREEN_HEIGHT - ZGCIP_TABBAR_HEIGHT, ZGCIP_MAINSCREEN_WIDTH, ZGCIP_TABBAR_HEIGHT);
                        self.editPictresAssistantBarView.frame = CGRectMake(0, ZGCIP_MAINSCREEN_HEIGHT - ZGCIP_TABBAR_HEIGHT - ZGCIP_PUBLIC_POP_TABBAR_HRIGHT, ZGCIP_MAINSCREEN_WIDTH, ZGCIP_PUBLIC_POP_TABBAR_HRIGHT + 3);
                }];
        }
        
}
#pragma mark - MosaicViewDelegate
-(void)hidenNavigationViewAndPickerView:(BOOL)hiden{
        if (hiden == YES) {
                [self.navigationController setNavigationBarHidden:YES animated:YES];
                [UIView animateWithDuration:0.5 animations:^{
                        self.editPictresBarView.frame = CGRectMake(0, ZGCIP_MAINSCREEN_HEIGHT, ZGCIP_MAINSCREEN_WIDTH, ZGCIP_TABBAR_HEIGHT);
                        self.editPictresAssistantBarView.frame = CGRectMake(0, ZGCIP_MAINSCREEN_HEIGHT, ZGCIP_MAINSCREEN_WIDTH, ZGCIP_PUBLIC_POP_TABBAR_HRIGHT + 3);
                }];
        }else{
                [self.navigationController setNavigationBarHidden:NO animated:YES];
                [UIView animateWithDuration:0.5 animations:^{
                        self.editPictresBarView.frame = CGRectMake(0, ZGCIP_MAINSCREEN_HEIGHT - ZGCIP_TABBAR_HEIGHT, ZGCIP_MAINSCREEN_WIDTH, ZGCIP_TABBAR_HEIGHT);
                        self.editPictresAssistantBarView.frame = CGRectMake(0, ZGCIP_MAINSCREEN_HEIGHT - ZGCIP_TABBAR_HEIGHT - ZGCIP_PUBLIC_POP_TABBAR_HRIGHT, ZGCIP_MAINSCREEN_WIDTH, ZGCIP_PUBLIC_POP_TABBAR_HRIGHT + 3);
                }];
                
        }
}

-(BOOL)prefersStatusBarHidden
{
        return YES;// 返回YES表示隐藏，返回NO表示显示
}

-(void)dealloc{
        self.self.editPictresBarView = nil;
        self.self.editPictresAssistantBarView = nil;
        self.navigationToolsView = nil;
        self.mainAdjustView = nil;
        self.selectedButton = nil;
        self.colorButton = nil;
        self.mosaicView = nil;
        self.drawView = nil;
        self.filterView = nil;
        self.screenshotView = nil;
        self.addWordView = nil;
        self.addImageView = nil;
        self.inputView = nil;
}

@end
