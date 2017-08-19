//
//  SNPEDrawView.m
//  SN_ImageEditor
//
//  Created by saina_su on 2017/7/10.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "SNPEDrawView.h"
#import "SNPEBezierPath.h"
@interface SNPEDrawView()
/** 当前绘制的路径 */
@property (nonatomic, strong) UIBezierPath *path;

//保存当前绘制的所有路径
@property (nonatomic, strong) NSMutableArray *allPathArray;

//当前路径的线宽
@property (nonatomic, assign) CGFloat width;

//当前路径的颜色
@property (nonatomic, strong) UIColor *color;

@end

@implementation SNPEDrawView

- (NSMutableArray *)allPathArray {
        
        if (_allPathArray == nil) {
                _allPathArray = [NSMutableArray array];
        }
        return _allPathArray;
}

/**
 *      1:一般一次性设置的内容都放在初始化方法init中或是awakefromNib中
 2：添加拖拽pan手势用于绘图
 */

- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                //添加手势
                UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
                [self addGestureRecognizer:pan];
                self.userInteractionEnabled = NO;
                
        }
        return self;
}

/**
 *清屏:清屏就是要移除所有的路径，此时删除大数组中的所有的路径就可以，在调用setNeedsDisplay，进行重绘，此时数组中没有了任何一条路径，所以就会清空上下文
 */
//清屏
- (void)clear {
        //清空所有的路径
        [self.allPathArray removeAllObjects];
        //重绘
        [self setNeedsDisplay];
        
}

/**
 *撤销：即是取出路径数组中的最后一个路径删除，并调用setNeedsDisplay
 */
//撤销
- (void)undo {
        //删除最后一个路径
        [self.allPathArray removeLastObject];
        //重绘
        [self setNeedsDisplay];
}

//设置线的宽度
- (void)setLineWith:(CGFloat)lineWidth {
        self.width = lineWidth;
}

//设置线的颜色
/**
 *    设置线的颜色，应该考虑到当没有设置颜色的时候，或传入的参数为空值的时候，所以要考虑以上两点，所以要设置线的默认颜色，一次性设置，在init或是awakefromNib中去设置
 *
 *    param color
 */
- (void)setLineColor:(UIColor *)color {
        self.color = color;
}

#pragma mark -- drawview的pan拖拽手势，画线
/**
 *2:在拖拽手势方法中：1：绘制UIBezierPath路径：开始设置起点，change的时候添加联系，并调用setNeedsDisplay，异步调用drawRect方法  2：定义一个全局数组，用于保存所有的路径，最后需要遍历数组，将所有路径取出来，绘制到上下文中 3：只有在自定义view中才能重写drawRect方法，且drawRect方法配合setNeedsDisplay使用，此方法必须由系统调用才会生成与view相关联的上下文，其中路径可以在其他方法中绘制，但是最后将路径绘制到上下文中的时候就必须在drawRect方法中实现[phath stroke];或是[path fill];
 
 2:什么情况下自定义类或是控件:1：当发现系统原始的功能,没有办法瞒足自己需求时,这个时候,要自定义类.继承系统原来的东西.再去添加属性自己的东西. 2：在begin方法中每次都创建一个全新的路径，因为在一次绘制的时候begin方法只执行一次，将每一次创建的路径都保存在大数组中，在drawrect中遍历，得到路径去绘制。其中颜色的绘制必须在drawrect上下文中绘制，否则不会显示，因为路径path没有保存color，但是线宽有保存，所以自定义类MyBezierPath继承UIBezierPath，提供color属性，就是为了保存color，在draw遍历时取出path后，直接设置路径颜色。
 */

- (void)pan:(UIPanGestureRecognizer *)pan {
        
        //获取的当前手指的点
        CGPoint curP = [pan locationInView:self];
        //判断手势的状态
        if(pan.state == UIGestureRecognizerStateBegan) {
                //创建路径
                SNPEBezierPath *path = [[SNPEBezierPath alloc] init];
                self.path = path;
                //设置起点
                [path moveToPoint:curP];
                //设置线的宽度
                [path setLineWidth:self.width];
                //设置线的颜色
                //什么情况下自定义类:当发现系统原始的功能,没有办法瞒足自己需求时,这个时候,要自定义类.继承系统原来的东西.再去添加属性自己的东西.
                path.color = self.color;
                path.lineCapStyle = kCGLineCapRound;//线条拐弯
                path.lineJoinStyle = kCGLineJoinRound;// 终点处理
                [self.allPathArray addObject:path];
                
        } else if(pan.state == UIGestureRecognizerStateChanged) {
                
                //绘制一根线到当前手指所在的点
                [self.path addLineToPoint:curP];
                //重绘
                [self setNeedsDisplay];
        }
        
}


/**
 * 1：当遍历的时候，若是数组中含有的不只是同一种类型的对象，在遍历的时候可以每个对象指定同一个类型的对象，再根据iskindofclass来判断对象具体是那种类型。
 2：当画图片的时候：直接用image调用[image drawInRect:rect];或是drawpoint
 *
 */
-(void)drawRect:(CGRect)rect {
        
        //绘制保存的所有路径
        for (SNPEBezierPath *path in self.allPathArray) {
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
