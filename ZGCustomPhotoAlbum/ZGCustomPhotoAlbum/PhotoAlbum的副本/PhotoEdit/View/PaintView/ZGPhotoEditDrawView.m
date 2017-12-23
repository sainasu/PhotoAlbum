//
//  ZGPhotoEditDrawView.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/11/6.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPhotoEditDrawView.h"
#import "ZGPhotoEditModel.h"
#import "ZGBezierPath.h"
#import "ZGPhotoAlbumHeader.h"
@interface ZGPhotoEditDrawView ()/** 当前绘制的路径 */
@property (nonatomic, strong) UIBezierPath *path;

//保存当前绘制的所有路径
@property (nonatomic, strong) NSMutableArray *allPathArray;
@property(nonatomic, strong) UIView *topView;
@property(nonatomic, strong) UIView *bottomView;






@end

@implementation ZGPhotoEditDrawView
- (NSMutableArray *)allPathArray {
        
        if (_allPathArray == nil) {
                _allPathArray = [NSMutableArray array];
        }
        return _allPathArray;
}
- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                //添加手势
                UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
                [self addGestureRecognizer:pan];
                self.userInteractionEnabled = NO;
               
                self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)];
                self.topView.backgroundColor = COLOR_FOR_PHOTO_EDIT_BACKGROUND;
                [self addSubview:self.topView];
                
                self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, frame.size.width, 0)];
                self.bottomView.backgroundColor = COLOR_FOR_PHOTO_EDIT_BACKGROUND;
                [self addSubview:self.bottomView];
               
        }
        return self;
}
-(void)setKeepOffFrame:(CGRect)keepOffFrame{
        _keepOffFrame = keepOffFrame;
        [self layoutSubviews];
}
-(void)layoutSubviews{
        if (_keepOffFrame.size.height == 0 && _keepOffFrame.size.width == 0) {
                self.topView.frame = CGRectMake(0, 0, self.frame.size.width, 0);
                self.bottomView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 0);
        }else{
                self.topView.frame = CGRectMake(0, -1, self.frame.size.width, _keepOffFrame.origin.y + 1);
                self.bottomView.frame = CGRectMake(0, _keepOffFrame.origin.y + _keepOffFrame.size.height, self.frame.size.width, self.frame.size.height - (_keepOffFrame.origin.y + _keepOffFrame.size.height));
        }
}

//清屏
- (void)clearScreen {
        //清空所有的路径
        [self.allPathArray removeAllObjects];
        //重绘
        [self setNeedsDisplay];
        
}

//撤销
- (void)revokeScreen {
        //删除最后一个路径
        [self.allPathArray removeLastObject];
        //重绘
        [self setNeedsDisplay];
}
-(void)setLineColor:(UIColor *)lineColor{
        _lineColor = lineColor;
}
-(void)setLineWidth:(CGFloat)lineWidth{
        _lineWidth = lineWidth;
}
- (void)pan:(UIPanGestureRecognizer *)pan {
        
        //获取的当前手指的点
        CGPoint curP = [pan locationInView:self];
        //判断手势的状态
        if(pan.state == UIGestureRecognizerStateBegan) {
                //创建路径
                ZGBezierPath *path = [[ZGBezierPath alloc] init];
                self.path = path;
                //设置起点
                [path moveToPoint:curP];
                //设置线的宽度
                if (self.lineWidth == 0) {
                        self.lineWidth = 8.0;
                }
                [path setLineWidth:self.lineWidth];
                //设置线的颜色
                if (self.lineColor == nil) {
                        self.lineColor = [UIColor blackColor];
                }
                path.color = self.lineColor;
                path.lineCapStyle = kCGLineCapRound;//线条拐弯
                path.lineJoinStyle = kCGLineJoinRound;// 终点处理
                [self.allPathArray addObject:path];
                
        } else if(pan.state == UIGestureRecognizerStateChanged) {
                
                //绘制一根线到当前手指所在的点
                [self.path addLineToPoint:curP];
                //重绘
                [self setNeedsDisplay];
        }
        if (pan.state == UIGestureRecognizerStateEnded) {
                [self.delegate darwView:self];
        }
        
}
-(void)drawRect:(CGRect)rect {
        
        //绘制保存的所有路径
        for (ZGBezierPath *path in self.allPathArray) {
                //判断取出的路径真实类型
                if([path isKindOfClass:[UIImage class]]) {
                        UIImage *image = (UIImage *)path;
                        [image drawInRect:rect];
                }else {
                        [path.color set];
                        [path stroke];
                }
        }
}

@end
