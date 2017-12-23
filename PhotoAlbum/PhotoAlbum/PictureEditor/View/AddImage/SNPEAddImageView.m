//
//  SNPEAddImageView.m
//  SN_ImageEditor
//
//  Created by saina_su on 2017/7/10.
//  Copyright © 2017年 saina. All rights reserved.

#define MaxSCale 2.0  //最大缩放比例
#define MinScale 0.2  //最小缩放比例

#import "SNPEAddImageView.h"

@interface SNPEAddImageView()<UIGestureRecognizerDelegate>{
        CGFloat _lastScale;
}

@end


@implementation SNPEAddImageView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
        self = [super initWithFrame:frame];
        if (self) {
                self.backgroundColor = [UIColor clearColor];
                //添加手势
                [self addGestureRecognizer];
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                imageView.frame = CGRectMake(0, 0, self.frame.size.width - 3, self.frame.size.height - 3);
                imageView.backgroundColor = [UIColor blackColor];
                imageView.center = self.center;
                [self addSubview:imageView];
                
        }
        return self;
}
//添加手势
- (void)addGestureRecognizer
{

        //点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
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
        
       }
//处理拖拽手势
- (void)pan:(UIPanGestureRecognizer *)pan
{
        CGPoint offSet = [pan translationInView:pan.view];
        self.transform = CGAffineTransformTranslate(self.transform, offSet.x, offSet.y);
        
        [pan setTranslation:CGPointZero inView:pan.view];
        
        if (pan.state == UIGestureRecognizerStateEnded){
        }
        
}

//处理捏合手势
- (void)pinch:(UIPinchGestureRecognizer  *)recognizer
{
        if(recognizer.state == UIGestureRecognizerStateBegan) {
                // Reset the last scale, necessary if there are multiple objects with different scales
                //获取最后的比例
                _lastScale = [recognizer scale];
        }
        
        if (recognizer.state == UIGestureRecognizerStateBegan ||
            recognizer.state == UIGestureRecognizerStateChanged) {
                //获取当前的比例
                CGFloat currentScale = [[[recognizer view].layer valueForKeyPath:@"transform.scale"] floatValue];
                
                // Constants to adjust the max/min values of zoom
                //设置最大最小的比例
                const CGFloat kMaxScale = 1.5;
                const CGFloat kMinScale = 0.3;
                //设置
                //假设上次比例是1 这次比例是4 这是放大
                //newScale = 4
                //最小 min(4,3/4) 就是3/4
                //最大 max(3/4,1/4) 就是3/4   4*3/4 = 3
                
                //假设上次比例是3 这次比例是1/2 这是缩小
                //newScale = -3/2
                //最小 min(-3/2,3/1/2) = 就是-3/2
                //最大 max(-3/2,1/1/2) = 就是2  1/2*2 = 1
                //获取上次比例减去想去得到的比例
                CGFloat newScale = 1 -  (_lastScale - [recognizer scale]);
                newScale = MIN(newScale, kMaxScale / currentScale);
                newScale = MAX(newScale, kMinScale / currentScale);
                CGAffineTransform transform = CGAffineTransformScale([[recognizer view] transform], newScale, newScale);
                [recognizer view].transform = transform;  
                // Store the previous scale factor for the next pinch gesture call  
                //获取最后比例 下次再用  
                _lastScale = [recognizer scale];  
        }
         if (recognizer.state == UIGestureRecognizerStateEnded){
        }

}
//点击
- (void)tapAction:(UITapGestureRecognizer *)tap
{
        if (tap.state == UIGestureRecognizerStateEnded) {
        }
}



//处理旋转手势
- (void)rotate:(UIRotationGestureRecognizer *)rotate
{
        self.transform = CGAffineTransformRotate(self.transform, rotate.rotation) ;
        rotate.rotation = 0;
        if (rotate.state == UIGestureRecognizerStateEnded){
        }

}



//是否允许多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
        
        return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        [self.delegate addImageViewTouchesBegan:touches];
}
@end
