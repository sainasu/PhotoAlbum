//
//  SNPEAddWord.m
//  SN_ImageEditor
//
//  Created by saina_su on 2017/7/10.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "SNPEAddWord.h"

@implementation SNPEAddWord

- (instancetype)initWithFrame:(CGRect)frame word:(NSString *)word color:(UIColor *)color
{
        self = [super initWithFrame:frame];
        if (self) {
                self.backgroundColor = [UIColor clearColor];
                //添加手势
                [self addGestureRecognizer];
                
                _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 10000)];
                _label.text = word;
                _label.textColor = color;
                _label.center = self.center;
                _label.font = [UIFont systemFontOfSize:15];
                _label.numberOfLines = 0;

                [self addSubview:_label];
                
        }
        return self;
}
-(void)layoutSubviews{
        CGSize size = [_label sizeThatFits:CGSizeMake(_label.frame.size.width, MAXFLOAT)];
        _label.frame = CGRectMake(0, 0, _label.frame.size.width, size.height);

}
//添加手势
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
        
        //长按
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        longPress.delegate = self;
        [self addGestureRecognizer:longPress];
        
}

//处理捏合手势
- (void)pinch:(UIPinchGestureRecognizer  *)pinch
{
        CGFloat scale = pinch.scale;
        self.transform = CGAffineTransformScale(self.transform, scale, scale);
        //每次形变之后都要复位
        pinch.scale = 1;
        if (pinch.state == UIGestureRecognizerStateEnded){
        }
        
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

//处理旋转手势
- (void)rotate:(UIRotationGestureRecognizer *)rotate
{
        self.transform = CGAffineTransformRotate(self.transform, rotate.rotation) ;
        rotate.rotation = 0;
        if (rotate.state == UIGestureRecognizerStateEnded){
        }
        
}

//处理长按手势
- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
        if (longPress.state == UIGestureRecognizerStateBegan) {
                //图片闪一下,然后将图片绘制到画板上面去
                [UIView animateWithDuration:0.25 animations:^{
                        self.alpha = 0.1;
                } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.23 animations:^{
                                self.alpha = 1;
                        } completion:^(BOOL finished) {
                                //开启位图上下文，将图片渲染到位图上下文
                                UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
                                CGContextRef ctx = UIGraphicsGetCurrentContext();
                                [self.layer  renderInContext:ctx];
                                UIGraphicsEndImageContext();
                                //移除
                                [self removeFromSuperview];
                        }];
                }];
        }else if (longPress.state == UIGestureRecognizerStateEnded){
        }
}

//是否允许多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
        
        return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        [self.addTextDelegate addWordViewTouchesBegan:touches];
       
}


@end
