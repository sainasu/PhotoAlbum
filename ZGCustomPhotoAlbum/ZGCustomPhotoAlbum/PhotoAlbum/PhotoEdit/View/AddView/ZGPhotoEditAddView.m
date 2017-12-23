//
//  ZGPhotoEditAddView.m
//  ZGPhotoEdit
//
//  Created by saina_barsud on 2017/12/14.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPhotoEditAddView.h"
@interface ZGPhotoEditAddView()<UIGestureRecognizerDelegate>{
         CGFloat _lastScale;
}

@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIButton *removeButton;


@end
@implementation ZGPhotoEditAddView

- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                self.backgroundColor = [UIColor clearColor];
                self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, frame.size.width - 30, frame.size.height - 30)];
                [self addSubview:self.imageView];
                
                self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 30, frame.size.height - 30)];
                self.contentLabel.numberOfLines = 0;
                [self addSubview:self.contentLabel];
                
                self.removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
                self.removeButton.frame = CGRectMake(frame.size.width - 30, 0, 30, 30);
                [self.removeButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Tool_Remove"] forState:UIControlStateNormal];
                [self.removeButton addTarget:self action:@selector(removeBUttonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:self.removeButton];
                
                //添加手势
                [self addGestureRecognizer];

                
        }
        return self;
}
- (void)removeBUttonAction:(UIButton *)button{
        [self removeFromSuperview];
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditAddViewDelegate)]) {
                [self.delegate addImageViewRemoveButton:self];
        }
}
-(void)setTextColot:(UIColor *)textColot{
        _textColot = textColot;
        self.contentLabel.textColor = textColot;
}
-(void)setContent:(id)content{
        _content = content;
         if ([content isMemberOfClass:NSClassFromString(@"UIImage")]){
                 self.contentLabel.hidden = YES;
                 self.imageView.image = (UIImage *)content;
         }else{
                 self.imageView.hidden = YES;
                 self.contentLabel.text = content;
                 self.contentLabel.textColor = self.textColot;
         }
}
-(void)setIsHiddenRemoveButton:(BOOL)isHiddenRemoveButton{
        _isHiddenRemoveButton = isHiddenRemoveButton;
        self.removeButton.hidden = isHiddenRemoveButton;
}


#pragma mark - 添加手势
- (void)addGestureRecognizer
{
        //添加手势,拖拽
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        pan.delegate = self;
        [self addGestureRecognizer:pan];
        //旋转
        UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotate:)];
        rotate.delegate = self;
        [self addGestureRecognizer:rotate];
        //双击
        UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleClick:)];
        doubleTap.numberOfTapsRequired = 2;
        doubleTap.delegate = self;
        [self addGestureRecognizer:doubleTap];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        tap.numberOfTapsRequired = 1;
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        [tap requireGestureRecognizerToFail:doubleTap];
        
}
/// 双击
-(void)doubleClick:(UITapGestureRecognizer *)tap{
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditAddViewDelegate)]) {
                [self.delegate addImageViewGestureRecognizer:tap];
        }
        if (![_content isKindOfClass:[UIImage class]]) {
                if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditAddViewDelegate)]) {
                        [self.delegate addImageViewDoubleClick:self content:self.contentLabel.text textColor:self.contentLabel.textColor];
                }
        }
}
/// dan
-(void)tap:(UITapGestureRecognizer *)tap{
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditAddViewDelegate)]) {
                [self.delegate addImageViewGestureRecognizer:tap];
        }
}
/// 处理拖拽手势
- (void)pan:(UIPanGestureRecognizer *)pan{
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditAddViewDelegate)]) {
                [self.delegate addImageViewGestureRecognizer:pan];
        }
        CGPoint offSet = [pan translationInView:pan.view];
        self.transform = CGAffineTransformTranslate(self.transform, offSet.x, offSet.y);
        [pan setTranslation:CGPointZero inView:pan.view];
        
}
/// 处理旋转手势
- (void)rotate:(UIRotationGestureRecognizer *)rotate{
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditAddViewDelegate)]) {
                [self.delegate addImageViewGestureRecognizer:rotate];
        }
        self.transform = CGAffineTransformRotate(self.transform, rotate.rotation) ;
        rotate.rotation = 0;
}

/// 是否允许多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
        return YES;
}
@end
