//
//  SNMosaicView.m
//  SN_ImageEditor
//
//  Created by saina_su on 2017/7/3.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "SNMosaicView.h"
#import "SNPEViewModel.h"


@interface SNMosaicView()
@property(nonatomic, strong) UIImage *image;/**mosaic图片*/
@property(nonatomic, strong) UIImage *bgImage;/**背景图片*/


@property(nonatomic, strong) NSMutableArray *pathArray;/**<#注释#>*/
@property(nonatomic, strong) NSMutableArray *pointArray;/**<#注释#>*/

/**
 *注释
 */
@property(nonatomic, strong) UIBezierPath *path;


@end

@implementation SNMosaicView
- (NSMutableArray *)pathArray
{
        if (!_pathArray) {
                _pathArray = [[NSMutableArray alloc]init];
                
        }
        return _pathArray;
}


- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
        self = [super initWithFrame:frame];
        if (self) {
                self.userInteractionEnabled = NO;
                self.frame = frame;
                [self setOpaque:NO];
                self.bgImage = image;
                const CGRect rect = [SNPEViewModel adjustTheUIInTheImage:image oldImage:image];
                UIGraphicsBeginImageContext(rect.size);  //size 为CGSize类型，即你所需要的图片尺寸
                [image drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
                UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                NSInteger level = 15 * (image.size.height / rect.size.height);
                self.MyImageView = [[UIImageView alloc] initWithImage:[SNPEViewModel transToMosaicImage:self.bgImage blockLevel:level]];
                self.MyImageView.frame =CGRectMake(0, -20, scaledImage.size.width + 50, scaledImage.size.height);
                self.MyImageView.contentMode = UIViewContentModeScaleAspectFill;
                self.MyImageView.center = self.center;
                [self addSubview:_MyImageView];

                self.MyImageViewA = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scaledImage.size.width, scaledImage.size.height)];
                self.MyImageViewA.userInteractionEnabled = YES;
                self.MyImageViewA.clipsToBounds = YES;
                self.MyImageViewA.image = image;
                self.MyImageViewA.center = self.center;
                self.MyImageViewA.contentMode = UIViewContentModeScaleAspectFill;

                [self addSubview:_MyImageViewA];
        }
        return self;
}
-(void)setMosaicImage:(UIImage *)image{
        if (image == nil) {
                self.image = nil;
        }else{
                self.image  = [SNPEViewModel imageByScalingAndCroppingForSize:CGSizeMake(40, 90) withSourceImage:image];
        }
}

#pragma mark CoreGraphics methods
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
        [self.mosaicDelegate hidenNavigationViewAndPickerView:YES];
        UITouch *touch = [touches anyObject];
        if([touch view] == self.MyImageViewA){
                ISENBALE = YES;
        }
        
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
        if(ISENBALE){
                UITouch *touch = touches.anyObject;
                CGPoint currentPoint = [touch locationInView:self.MyImageViewA];
                CGPoint prevLocation = [touch previousLocationInView:self.MyImageViewA];
                
                if (self.image == nil) {
                        UIGraphicsBeginImageContext(self.MyImageViewA.bounds.size);
                        [self.MyImageViewA.image drawInRect:self.MyImageViewA.bounds];
                        CGContextClearRect(UIGraphicsGetCurrentContext(), CGRectMake(currentPoint.x-15, currentPoint.y-15, 40, 40));

                }else if (self.image != nil){
                        //取色渲染图片
                        UIImage *image = [SNPEViewModel textureWithTintColor:[SNPEViewModel colorAtPixel:currentPoint view:self.MyImageViewA.image] image:self.image];
                        //
                        UIGraphicsBeginImageContextWithOptions(self.MyImageViewA.bounds.size, NO, 0);
                        //
                        [self.MyImageViewA.image drawInRect:self.MyImageViewA.bounds];
                        //设置中心点
                        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
                        //判断旋转方
                        CGFloat myPI = [self determineTheDirection:currentPoint prevLocation:prevLocation];
                        
                        CGContextRotateCTM(UIGraphicsGetCurrentContext(), myPI);
                        //添加图片
                        [image drawInRect:CGRectMake(-15, -30, 40, 90)];
                }
                CGImageRef cgimage = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
                UIImage * image = [UIImage imageWithCGImage:cgimage];
                UIGraphicsEndImageContext();
                CGImageRelease(cgimage);
                self.pointArray = [NSMutableArray array];
                [self.pointArray addObject:[UIImage imageWithData:UIImageJPEGRepresentation(image, 0.5)]];
                self.MyImageViewA.image = image;
        }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
        [self.mosaicDelegate hidenNavigationViewAndPickerView:NO];
        [self addLA];
        ISENBALE = NO;
}
-(void)addLA{
        NSArray *array=[NSArray arrayWithArray:_pointArray];
        [self.pathArray addObject:array];
        self.pointArray = nil;
}

-(CGFloat)determineTheDirection:(CGPoint)currentPoint prevLocation:(CGPoint)prevLocation{

        CGFloat residueX = currentPoint.x - prevLocation.x;
        CGFloat residueY = currentPoint.y - prevLocation.y;
        
        CGFloat myPI = 0;
        if (residueY > 0 && residueX > 0){
                //上右
                myPI = M_PI * 1.7;
        }else if (residueY > 0 && residueX < 0){
                //上左
                myPI = M_PI / 4;
        }else if (residueY < 0 && residueX > 0){
                //下有
                myPI = M_PI *1.3;
        }else if (residueY < 0 && residueX < 0){
                //下左
                myPI = M_PI * 1.6;
        }else if (residueY > 0) {
                //向上
                myPI = M_PI / 180;
        } else if (residueY < 0){
                //向下
                myPI = M_PI;
        }else if (residueX > 0) {
                //向右
                myPI = M_PI / 2;
        } else if (residueX < 0){
                //向左
                myPI = M_PI * 1.3;
        }
                return myPI;
}
-(void)clear{
        [self.pathArray removeAllObjects];
        self.MyImageViewA.image = self.bgImage;
        [self setNeedsDisplay];
        
}

-(void)undo{
        if (self.pathArray.count <= 1) {
                [self.pathArray removeAllObjects];
                self.MyImageViewA.image = self.bgImage;
        }else{
                [self.pathArray removeLastObject];
                self.MyImageViewA.image = [self.pathArray lastObject];
        }
        [self setNeedsDisplay];
}
-(void)drawRect:(CGRect)rect {

        for (NSArray *arr in self.pathArray) {
        //绘制保存的所有路径
                for (UITouch *bezierPath in arr) {
                //判断取出的路径真实类型
                        if([bezierPath isKindOfClass:[UIImage class]]) {
                                UIImage *image = (UIImage *)bezierPath;
                                [image drawInRect:rect];
                               
                        }
                }
        }

}
-(void)dealloc{
        self.pointArray = nil;
        self.MyImageView = nil;
        self.MyImageViewA = nil;
        self.pathArray = nil;
        self.path = nil;
}

@end

