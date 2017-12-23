//
//  ZGPhotoEditAddView.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/11/7.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPhotoEditAddView.h"

@interface ZGPhotoEditAddView()<UIGestureRecognizerDelegate>{
        CGFloat _lastScale;
        UIButton *_button;
}

@property(nonatomic,strong)NSTimer *timer; // timer
@property(nonatomic,assign)int countDown; // 倒数计时用
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *label;

@end

@implementation ZGPhotoEditAddView
- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                self.backgroundColor = [UIColor clearColor];
                self.userInteractionEnabled = YES;
                self.layer.borderColor = [UIColor whiteColor].CGColor;
      
                
                self.imageView = [[UIImageView alloc] initWithImage:self.image];
                self.imageView.hidden = YES;
                [self addSubview:self.imageView];
                
                self.label = [[UILabel alloc] init];
                self.label.hidden = YES;
                self.label.font = [UIFont systemFontOfSize:15];
                self.label.backgroundColor = [UIColor clearColor];
                self.label.numberOfLines = 0;
                [self addSubview:self.label];
                
                [self initSubViews];
                //添加手势
                [self addGestureRecognizer];
                [self startCountDown];

        }
        return self;
}
-(void)setImage:(UIImage *)image{
        _image = image;
        if (image) {
                self.imageView.hidden = NO;
                self.label.hidden = YES;
                self.imageView.image = image;
        }
}
-(void)setContent:(NSString *)content{
        _content = content;
        if (content) {
                self.label.hidden = NO;
                self.imageView.hidden = YES;
                self.label.text = content;
        }
}
-(void)setColor:(UIColor *)color{
        _color = color;
        self.label.textColor = color;
}

#pragma mark - timer
-(void)startCountDown {
        _countDown = 1.5; // 倒数计时用
        if (_timer) {
                [_timer invalidate];
        }
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES]; // 需要加入手动RunLoop，需要注意的是在NSTimer工作期间self是被强引用的
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes]; // 使用NSRunLoopCommonModes才能保证RunLoop切换模式时，NSTimer能正常工作。
}
- (void)stopTimer {
        if (_timer) {
                [_timer invalidate];
        }
}
-(void)timerFired:(NSTimer *)timer {
        if (_countDown == 0) {
                [self stopTimer];
                self.layer.borderColor = [UIColor clearColor].CGColor;
                self.layer.borderWidth = 1.0;
                _button.hidden = YES;
        }else{
                _countDown -=1;
        }
}

#pragma mark - 初始化子视图
- (void)initSubViews{
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(self.frame.size.width - 20, 1, 18, 18);
        _button.layer.masksToBounds = YES;
        _button.layer.cornerRadius = 9.0;
        [_button setBackgroundColor:[UIColor blackColor]];
        [_button setImage:[UIImage imageNamed:@"icon_navbar_close"] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonActionClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
}
-(void)buttonActionClick{
        if (self.addDelegate && [self.addDelegate conformsToProtocol:@protocol(ZGPhotoEditAddViewDelegate)]) {
                [self.addDelegate addViewRemoveFromSuperview:self];
        }
}
-(void)layoutSubviews{
        [super layoutSubviews];
        self.imageView.frame = CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 20);
        self.label.frame = CGRectMake(10, 10, self.frame.size.width - 20,self.frame.size.height - 20);
        _button.frame = CGRectMake(self.frame.size.width - 20, 1, 18, 18);
        _button.layer.masksToBounds = YES;
        _button.layer.cornerRadius = 9.0;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1.0;
}
#pragma mark - 添加手势
- (void)addGestureRecognizer
{
        //添加手势,拖拽
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        pan.delegate = self;
        [self addGestureRecognizer:pan];
        
        //捏合
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
        pinch.delegate = self;
        [self addGestureRecognizer:pinch];
        
        //旋转
        UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotate:)];
        rotate.delegate = self;
        [self addGestureRecognizer:rotate];
        //单击
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired = 1;
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        //双击
        UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleClick:)];
        doubleTap.numberOfTapsRequired = 2;
        doubleTap.delegate = self;
        [self addGestureRecognizer:doubleTap];
        //
        [tap requireGestureRecognizerToFail:doubleTap];

        
        
}
-(void)doubleClick:(UITapGestureRecognizer *)tap{
        if (_content != nil) {
                if (self.addDelegate && [self.addDelegate conformsToProtocol:@protocol(ZGPhotoEditAddViewDelegate)]) {
                        [self.addDelegate addViewDoubleTap:self tapAction:tap.view.tag];
                }
        }
        if (tap.state == UIGestureRecognizerStateEnded) {
                [self startCountDown];
        }
}
-(void)tapAction:(UITapGestureRecognizer *)tap{
        if (self.addDelegate && [self.addDelegate conformsToProtocol:@protocol(ZGPhotoEditAddViewDelegate)]) {
                [self.addDelegate addViewTap:self tapAction:tap.view.tag];
        }
        if (tap.state == UIGestureRecognizerStateEnded || tap.state == UIGestureRecognizerStateCancelled) {
                [self startCountDown];
        }
}
//处理拖拽手势
- (void)pan:(UIPanGestureRecognizer *)pan{
        CGPoint offSet = [pan translationInView:pan.view];
        self.transform = CGAffineTransformTranslate(self.transform, offSet.x, offSet.y);
        [pan setTranslation:CGPointZero inView:pan.view];
        if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
                [self startCountDown];
        }
}

//处理捏合手势
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
                const CGFloat kMinScale = 0.5;
                //获取上次比例减去想去得到的比例
                CGFloat newScale = 1 -  (_lastScale - [recognizer scale]);
                newScale = MIN(newScale, kMaxScale / currentScale);
                newScale = MAX(newScale, kMinScale / currentScale);
                CGAffineTransform transform = CGAffineTransformScale([[recognizer view] transform], newScale, newScale);
                [recognizer view].transform = transform;
                //获取最后比例 下次再用
                _lastScale = [recognizer scale];
        }
        if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
                [self startCountDown];
        }

        
}
//处理旋转手势
- (void)rotate:(UIRotationGestureRecognizer *)rotate{

        self.transform = CGAffineTransformRotate(self.transform, rotate.rotation) ;
        rotate.rotation = 0;
        if (rotate.state == UIGestureRecognizerStateEnded || rotate.state == UIGestureRecognizerStateCancelled) {
                [self startCountDown];
        }
}
//是否允许多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
        return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1.0;
        _button.hidden = NO;
}
@end
