//
//  ZGPhotoEditImageView.m
//  ZGPhotoEdit
//
//  Created by saina_barsud on 2017/12/8.
//  Copyright © 2017年 saina. All rights reserved.
//
/*
 1. 涂鸦功能:
 2. mosaic功能:
 操作在另一个View上
 3. filter功能:
 4. 添加图片:
 5. 添加文字:
 6. crop之后改变遮挡View的位置:
 */


#import "ZGPhotoEditImageView.h"
#import "ZGPhotoEditModel.h"
#import "ZGPhotoEditAddView.h"
#import "ZGPhotoEditMosaicView.h"

@interface ZGPhotoEditImageView()<ZGPhotoEditDrawViewDelegate, ZGPhotoEditAddViewDelegate, UIGestureRecognizerDelegate , ZGPhotoEditMosaicViewDelegate>{
        CGFloat _lastScale;

}
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) ZGPhotoEditDrawView *drawView; /// 涂鸦View
@property(nonatomic, strong) ZGPhotoEditMosaicView *mosaicView; /// mosaicView
@property(nonatomic, strong) ZGPhotoEditAddView *addView; // <#注释#>

@property(nonatomic, strong) NSMutableArray *pathArray; // 保存涂鸦与mosaic的操作顺序
@property(nonatomic, strong) NSMutableArray *addViewArray;// 保存添加的图片与文字

@property(nonatomic, strong) UIImage *mosaicImgae; // 转换为mosaic的图片


// 遮盖View
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *rightView;
// 保存截图之后的frame
@property(nonatomic, assign) CGRect cropRect;




@end
@implementation ZGPhotoEditImageView
- (NSMutableArray *)pathArray
{
        if (!_pathArray) {
                _pathArray = [[NSMutableArray alloc]init];
        }
        return _pathArray;
}

- (NSMutableArray *)addViewArray
{
        if (!_addViewArray) {
                _addViewArray = [[NSMutableArray alloc]init];
        }
        return _addViewArray;
}


- (instancetype)initWithFrame:(CGRect)frame editImage:(UIImage *)image
{
        self = [super initWithFrame:frame];
        if (self) {
                // 转为mosaic图片
                self.mosaicImgae = [ZGPhotoEditModel transToMosaicImage:image blockLevel:15.0];
                self.imageView = [[UIImageView alloc] initWithImage:self.mosaicImgae];
                [self addSubview:self.imageView];
                // 初始化mosaicView
                self.mosaicView = [[ZGPhotoEditMosaicView alloc] initWithFrame:frame Image:image];
                self.mosaicView.paintDelegate = self;
                [self addSubview:self.mosaicView];
                
                self.addView = [[ZGPhotoEditAddView alloc] init];
                [self initSubViews];
        }
        return self;
}
- (void)initSubViews
{
        // 初始化涂鸦View
        self.drawView = [[ZGPhotoEditDrawView alloc] init];
        self.drawView.delegate = self;
        
        [self addSubview:self.drawView];
        // 遮盖View 按照截图之后的尺寸, 把图片隐藏
        self.topView = [[UIView alloc] initWithFrame:CGRectZero];
        self.topView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.topView];
        self.bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        self.bottomView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.bottomView];
        self.leftView = [[UIView alloc] initWithFrame:CGRectZero];
        self.leftView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.leftView];
        self.rightView = [[UIView alloc] initWithFrame:CGRectZero];
        self.rightView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.rightView];
}

#pragma mark - setter

-(void)setPinch:(UIPinchGestureRecognizer *)pinch{
        _pinch = pinch;
}
-(void)setReplaceSubViewFrame:(CGRect)replaceSubViewFrame{
        _replaceSubViewFrame = replaceSubViewFrame;
        self.cropRect = replaceSubViewFrame;
        self.topView.frame = CGRectMake(0, -2, self.frame.size.width, replaceSubViewFrame.origin.y);
        self.bottomView.frame = CGRectMake(0, replaceSubViewFrame.origin.y + replaceSubViewFrame.size.height, self.frame.size.width , self.frame.size.height - replaceSubViewFrame.origin.y - replaceSubViewFrame.size.height + 2);
        self.leftView.frame = CGRectMake(0, replaceSubViewFrame.origin.y - 2, replaceSubViewFrame.origin.x, replaceSubViewFrame.size.height + 4);
        self.rightView.frame = CGRectMake(replaceSubViewFrame.origin.x + replaceSubViewFrame.size.width, replaceSubViewFrame.origin.y - 2, self.frame.size.width - replaceSubViewFrame.origin.x - replaceSubViewFrame.size.width, replaceSubViewFrame.size.height + 4);
}
#pragma mark -  Custom method(自定义方法)

-(void)undo{
        if (self.pathArray.count > 0) {
                NSString *lastObject = self.pathArray.lastObject;
                [self.pathArray removeLastObject];
                if ([lastObject isEqualToString:@"draw"]) {
                        [self.drawView undo];
                }else if ([lastObject isEqualToString:@"mosaic"]) {
                        [self.mosaicView backAction];
                }
        }
}
-(void)clear{
        if (self.pathArray.count > 0) {
                //darw
                [self.drawView clear];
                // mosaic
                [self.mosaicView resetAvtion];
        }
}

-(void)isDrawView:(NSString *)isView  color:(UIColor *)color mosaicType:(NSString *)mosaic{
        
        if ([isView isEqualToString:@"draw"]) {
                [self.drawView setUserInteractionEnabled:YES];// 涂鸦操作
                self.drawView.lineColor = color;
                [self.mosaicView setUserInteractionEnabled:NO];
        }else if ([isView isEqualToString:@"mosaic"]){
                [self.mosaicView setUserInteractionEnabled:YES];
                if ([mosaic isEqualToString:@"PhotoEdit_Mosaic_orrgin"]) {
                        self.mosaicView.mosaicImage = nil;
                }else{
                        self.mosaicView.mosaicImage = [UIImage imageNamed:mosaic];
                }

                [self.drawView setUserInteractionEnabled:NO];// 涂鸦操作
        }else{
                [self.mosaicView setUserInteractionEnabled:NO];
                [self.drawView setUserInteractionEnabled:NO];

        }
}
- (void)addContent:(id)content isOldLabel:(BOOL)isOldLabel textColor:(UIColor *)textColor{
        CGSize size;
        BOOL isAddSunView;
        // 获取size
        if ([content isKindOfClass:NSClassFromString(@"UIImage")]) {
                UIImage *image = (UIImage *)content;
                CGFloat scale = 150 / image.size.height;
                size = CGSizeMake(image.size.width * scale, image.size.height * scale);
                isAddSunView = YES;
        }else{
                if (![ZGPhotoEditModel isEmpty:content]) {// 判断是否为空  或者全部为空格
                       // 获取字符串的长度
                        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 0)];
                        label.numberOfLines = 0;
                        label.text = content;
                       CGSize labelSize = [label sizeThatFits:CGSizeMake(label.frame.size.width, MAXFLOAT)];
                        size = CGSizeMake(labelSize.width + 40, labelSize.height + 40);
                        isAddSunView = YES;
                }else{
                        isAddSunView = NO;

                }
        }
        if (isAddSunView) {
                if (isOldLabel == YES) {
                        [self.addView removeFromSuperview];
                        [self.addViewArray removeObject:self.addView];
                }
                //创建addImageView
                ZGPhotoEditAddView *addView = [[ZGPhotoEditAddView alloc] initWithFrame:CGRectMake(self.cropRect.origin.x + 10, self.cropRect.origin.y + 10, size.width, size.height)];
                addView.content = content;
                addView.delegate = self;
                addView.textColot = textColor;
                addView.tag = self.addViewArray.count + 100;
                //捏合
                UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
                pinch.delegate = self;
                [addView addGestureRecognizer:pinch];
                [self.pinch requireGestureRecognizerToFail:pinch];
                [self addSubview:addView];
                [self.addViewArray addObject:addView];
                // 添加View时， 其他view隐藏删除按钮
                for (ZGPhotoEditAddView *view in self.addViewArray) {
                        if (addView.tag == view.tag) {
                                view.isHiddenRemoveButton = NO;
                                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
                                        addView.isHiddenRemoveButton = YES;
                                }];
                                [timer fireDate];
                        }else{
                                view.isHiddenRemoveButton = YES;
                        }
                }
        }
}

- (void)filterType:(NSString *)type{
        self.mosaicView.filterType = type;
        self.imageView.image = [ZGPhotoEditModel fliterEvent:type image:self.mosaicImgae];
        
}
#pragma mark - UIGestureRecognizerAction
/// 处理捏合手势
- (void)pinch:(UIPinchGestureRecognizer  *)recognizer{
        if(recognizer.state == UIGestureRecognizerStateBegan) {
                //获取最后的比例
                _lastScale = [recognizer scale];
        }
        if (recognizer.state == UIGestureRecognizerStateBegan ||
            recognizer.state == UIGestureRecognizerStateChanged) {
                //获取当前的比例
                CGFloat currentScale = [[[recognizer view].layer valueForKeyPath:@"transform.scale"] floatValue];
                //设置最大最小的比例
                const CGFloat kMaxScale = 2.0;
                const CGFloat kMinScale = 0.7;
                //获取上次比例减去想去得到的比例
                CGFloat newScale = 1 -  (_lastScale - [recognizer scale]);
                newScale = MIN(newScale, kMaxScale / currentScale);
                newScale = MAX(newScale, kMinScale / currentScale);
                CGAffineTransform transform = CGAffineTransformScale([[recognizer view] transform], newScale, newScale);
                [recognizer view].transform = transform;
                //获取最后比例 下次再用
                _lastScale = [recognizer scale];
        }
}
#pragma mark - ZGPhotoEditAddViewDelegate
- (void)addImageViewRemoveButton:(ZGPhotoEditAddView *)view{
        [view removeFromSuperview];
        [self.addViewArray removeObject:view];
}
- (void)addImageViewDoubleClick:(ZGPhotoEditAddView *)view content:(NSString *)content textColor:(UIColor *)color{
        self.addView = view;
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditImageViewDelegate)]) {
                [self.delegate  imageViewDoubleClick:self content:content textColor:color];
        }
}
- (void)addImageViewGestureRecognizer:(UIGestureRecognizer *)ges{
        ZGPhotoEditAddView *addView = (ZGPhotoEditAddView *)ges.view;
        self.addView = (ZGPhotoEditAddView *)ges.view;
        [self addSubview:addView]; // 添加到最上面
        for (ZGPhotoEditAddView *view in self.addViewArray) {
                if (ges.view.tag == view.tag) { // 如果tag值相同, 则显示删除按钮, 否则隐藏
                        view.isHiddenRemoveButton = NO;
                }else{
                        view.isHiddenRemoveButton = YES;
                }
        }
        if (ges.state == UIGestureRecognizerStateEnded) { // 手势识别结束时, 设定定时器,1.5s 后隐藏掉删除按钮
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
                        addView.isHiddenRemoveButton = YES;
                }];
                [timer fireDate];
        }
}
//self要实现UIGestureRecognizerDelegate协议，其中就有gestureRecognizer:shouldReceiveTouch:方法
#pragma mark - ZGPhotoEditDrawViewDelegate
- (void)darwViewTouchesEnded:(ZGPhotoEditDrawView *)darwView{
        [self.pathArray addObject:@"draw"];
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditImageViewDelegate)]) {
                [self.delegate  imageViewTouchesEnded:self];
        }
}
- (void)darwViewTouchesBegen:(ZGPhotoEditDrawView *)darwView{
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditImageViewDelegate)]) {
                [self.delegate imageViewTouchesBegen:self];
        }
        // 涂鸦操作时隐藏掉删除按钮
        for (ZGPhotoEditAddView *addView in self.addViewArray) {
                addView.isHiddenRemoveButton = YES;
        }
        
}
#pragma mark - ZGPhotoEditMosaicViewDelegate
/// 结束触摸屏幕(用于隐藏导航栏和工具栏)
- (void)paintViewTouchesEnded:(ZGPhotoEditMosaicView *)darwView{
        [self.pathArray addObject:@"mosaic"];
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditImageViewDelegate)]) {
                [self.delegate  imageViewTouchesEnded:self];
        }

}
/// 开始触摸屏幕(用于隐藏导航栏和工具栏)
- (void)paintViewTouchesBegen:(ZGPhotoEditMosaicView *)darwView{
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditImageViewDelegate)]) {
                [self.delegate imageViewTouchesBegen:self];
        }
        // 涂鸦操作时隐藏掉删除按钮
        for (ZGPhotoEditAddView *addView in self.addViewArray) {
                addView.isHiddenRemoveButton = YES;
        }
}
#pragma mark - layoutSubviews
-(void)layoutSubviews{
        self.imageView.frame = self.bounds;
        self.drawView.frame = self.bounds;
        self.mosaicView.frame = self.bounds;
}




@end
