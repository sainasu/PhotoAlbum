//
//  ZGMeituizipaiPreviewImageCell.m
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/7.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGMeituizipaiPreviewImageCell.h"



@interface ZGMeituizipaiPreviewImageCell()
@property(nonatomic, assign) CGAffineTransform cutViewTransfrom;/**<#注释#>*/
@property(nonatomic, assign) CGRect  cutViewFrame;/**<#注释#>*/
@property(nonatomic, assign) CGFloat  scale;/**<#注释#>*/
@property(nonatomic, assign) BOOL  isDoubleGesture;/**<#注释#>*/

@end

@implementation ZGMeituizipaiPreviewImageCell
- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                self.cutViewFrame = frame;
                self.backgroundColor =[UIColor clearColor];
                self.showImgView = [[UIImageView alloc] init];
                self.showImgView.contentMode = UIViewContentModeScaleAspectFit;
                self.showImgView.clipsToBounds = YES;
                [self addSubview:self.showImgView];
                self.cutViewTransfrom = self.transform;
                
                //捏合
                UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
                pinch.delegate = self;
                [self addGestureRecognizer:pinch];
                //双击手势
                UITapGestureRecognizer *doubelGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleGesture:)];
                doubelGesture.numberOfTapsRequired = 2;
                [self addGestureRecognizer:doubelGesture];
               
        }
        return self;
}
//双击手势
-(void)doubleGesture:(UITapGestureRecognizer *)sender
{
        UIView *view=[sender view]; //扩大、缩小倍数

        if (self.isDoubleGesture == NO) {
                if (view.frame.size.width > self.frame.size.width || view.frame.size.height > self.frame.size.height) {
                [UIView animateWithDuration:0.3 animations:^{
                        self.transform = self.cutViewTransfrom;
                }];
                        self.isDoubleGesture = NO;
                        return;
                }
                [UIView animateWithDuration:0.3 animations:^{
                        view.transform=CGAffineTransformScale(view.transform, 2, 2);
                }];
                               self.isDoubleGesture = YES;
        }else{
                [UIView animateWithDuration:0.3 animations:^{
                        self.transform = self.cutViewTransfrom;

                }];
                 self.isDoubleGesture = NO;
        }
        if (sender.state==UIGestureRecognizerStateBegan){
                UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
                //添加手势,拖拽
                pan.delegate = self;
                [self addGestureRecognizer:pan];
                

        }
        
}
// 缩放手势
- (void)pinch:(UIPinchGestureRecognizer *)recognizer
{
        if (recognizer.state==UIGestureRecognizerStateBegan || recognizer.state==UIGestureRecognizerStateChanged) {
                UIView *view=[recognizer view]; //扩大、缩小倍数
                view.transform=CGAffineTransformScale(view.transform, recognizer.scale, recognizer.scale);
                recognizer.scale=1;
                self.isDoubleGesture = YES;
                if (view.frame.size.width < _cutViewFrame.size.width) {
                        [UIView animateWithDuration:0.2 animations:^{
                                view.transform = self.cutViewTransfrom;
                                recognizer.scale=1;
                                self.isDoubleGesture = NO;
                        }];
                }
        }
        if (recognizer.state==UIGestureRecognizerStateBegan){
                UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
                //添加手势,拖拽
                pan.delegate = self;
                [self addGestureRecognizer:pan];
                
                
        }

}
//处理拖拽手势
- (void)pan:(UIPanGestureRecognizer *)pan
{
        UIView *view=[pan view];
        if (view.frame.size.width <= _cutViewFrame.size.width){
                [self removeGestureRecognizer:pan];

        }else if (view.frame.size.width > _cutViewFrame.size.width) {
                CGPoint offSet = [pan translationInView:pan.view];
                self.transform = CGAffineTransformTranslate(self.transform, offSet.x, offSet.y);
                [pan setTranslation:CGPointZero inView:pan.view];
                self.isDoubleGesture = YES;
        
        }else {
                [self removeGestureRecognizer:pan];

        }
}


- (void)restore
{
        
        [UIView animateWithDuration:0.1 animations:^{
                self.transform = self.cutViewTransfrom;
        }];
}



-(void)layoutSubviews{
        self.showImgView.frame = CGRectMake(1, 1, self.frame.size.width - 2, self.frame.size.height - 2);
}
@end
