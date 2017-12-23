//
//  ZGPhotoEditMosaicView.m
//  ZGPhotoEdit
//
//  Created by saina_barsud on 2017/12/19.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPhotoEditMosaicView.h"
#import "ZGPhotoEditModel.h"
@interface ZGPhotoEditMosaicView(){
        
}
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) NSMutableArray *pathArray;
@property(nonatomic, strong) UIImage *image;

@end
@implementation ZGPhotoEditMosaicView

- (NSMutableArray *)pathArray
{
        if (!_pathArray) {
                _pathArray = [[NSMutableArray alloc]init];
        }
        return _pathArray;
}
- (instancetype)initWithFrame:(CGRect)frame Image:(UIImage *)image
{
        self = [super initWithFrame:frame];
        if (self) {
                
                self.image = image;
                self.imageView = [[UIImageView alloc] initWithImage:image];
                self.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [self addSubview:self.imageView];
                
                
        }
        return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        if (self.paintDelegate && [self.paintDelegate conformsToProtocol:@protocol(ZGPhotoEditMosaicViewDelegate)]) {
                [self.paintDelegate paintViewTouchesBegen:self];
        }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
        [super touchesMoved:touches withEvent:event];
                CGFloat scale = [UIScreen mainScreen].scale;
                UIGraphicsBeginImageContextWithOptions(self.imageView.frame.size, NO, scale);
                [self.imageView.image drawInRect:self.imageView.bounds];
                UITouch *touch = [touches anyObject];
                CGPoint point = [touch locationInView:touch.view];
                if (_mosaicImage != nil) {
                        //取色渲染图片
                        UIImage *image = [ZGPhotoEditModel textureWithTintColor:[ZGPhotoEditModel colorAtPixel:point view:self.image] image:self.mosaicImage];
                        //设置中心点
                        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), point.x, point.y);
                        CGContextSetLineJoin(UIGraphicsGetCurrentContext(), kCGLineJoinRound);
                        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
                        
                        //添加图片
                        [image drawInRect:CGRectMake( -30 , -30 , 30 *scale, 30 * scale)];
                }else if (_mosaicImage == nil) {
                        CGContextRef context = UIGraphicsGetCurrentContext();
                        CGContextSetLineJoin(context, kCGLineJoinRound);
                        CGContextSetLineCap(context, kCGLineCapRound);
                        CGRect rect = CGRectMake(point.x - 10 * scale, point.y - 10 * scale, 10 *scale, 10 * scale);
                        CGContextClip(context);
                        CGContextClearRect(context, rect);
                }
                CGImageRef cgimage = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
                UIImage * image = [UIImage imageWithCGImage:cgimage];
                UIGraphicsEndImageContext();
                CGImageRelease(cgimage);
                // 取出会之后的图片赋值给image
                self.imageView.image = image;
                // 关闭图形上下文
                UIGraphicsEndImageContext();
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        [super touchesEnded:touches withEvent:event];
        [self.pathArray addObject:[UIImage imageWithData: UIImagePNGRepresentation(self.imageView.image)]];
        if (self.paintDelegate && [self.paintDelegate conformsToProtocol:@protocol(ZGPhotoEditMosaicViewDelegate)]) {
                [self.paintDelegate paintViewTouchesEnded:self];
        }
        
}
-(void)setMosaicImage:(UIImage *)mosaicImage{
        _mosaicImage = mosaicImage;
}

-(void)setFilterType:(NSString *)filterType{
        _filterType = filterType;        
        if (self.pathArray.count == 0) {
                self.imageView.image =[ZGPhotoEditModel fliterEvent:self.filterType image:self.image];
        }else{
                self.imageView.image =[ZGPhotoEditModel fliterEvent:self.filterType image:self.pathArray.lastObject];
        }
}
- (void)resetAvtion{
        [self.pathArray removeAllObjects];
        if (self.filterType == nil) {
                self.imageView.image = self.image;
        }else{
                self.imageView.image =[ZGPhotoEditModel fliterEvent:self.filterType image:self.image];
        }
        [self setNeedsDisplay];
}
- (void)backAction{
        if (self.pathArray.count <= 1) {
                [self.pathArray removeAllObjects];
                if (self.filterType == nil) {
                        self.imageView.image = self.image;
                }else{
                        self.imageView.image =[ZGPhotoEditModel fliterEvent:self.filterType image:self.image];
                }
        }else{
                [self.pathArray removeLastObject];
                if (self.filterType == nil) {
                        self.imageView.image = self.pathArray.lastObject;
                }else{
                        self.imageView.image =[ZGPhotoEditModel fliterEvent:self.filterType image:self.pathArray.lastObject];
                }
        }
        [self setNeedsDisplay];
}

-(void)layoutSubviews{
        self.imageView.frame = self.bounds;
}
@end
