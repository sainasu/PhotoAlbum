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

@end

@implementation ZGMeituizipaiPreviewImageCell
- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                self.cutViewFrame = frame;
                self.backgroundColor =[UIColor clearColor];
                self.imageView = [[UIImageView alloc] init];
                self.imageView.contentMode = UIViewContentModeScaleAspectFit;
                [self addSubview:self.imageView];
                self.cutViewTransfrom = self.transform;
                
                //捏合
                UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
                pinch.delegate = self;
                [self addGestureRecognizer:pinch];
                
        }
        return self;
}
// 缩放手势
- (void)pinch:(UIPinchGestureRecognizer *)recognizer{
        if (recognizer.state==UIGestureRecognizerStateBegan || recognizer.state==UIGestureRecognizerStateChanged) {
                UIView *view=[recognizer view]; //扩大、缩小倍数
                view.transform=CGAffineTransformScale(view.transform, recognizer.scale, recognizer.scale);
                recognizer.scale=1;
                if (view.frame.size.width < _cutViewFrame.size.width) {
                        [UIView animateWithDuration:0.2 animations:^{
                                view.transform = self.cutViewTransfrom;
                                recognizer.scale=1;

                        }];
                }
        }
}

-(void)restore{
        
                [UIView animateWithDuration:0.1 animations:^{
                        self.transform = self.cutViewTransfrom;
                }];
}



-(void)layoutSubviews{
        self.imageView.frame = CGRectMake(1, 1, self.frame.size.width - 2, self.frame.size.height - 2);
}
@end
