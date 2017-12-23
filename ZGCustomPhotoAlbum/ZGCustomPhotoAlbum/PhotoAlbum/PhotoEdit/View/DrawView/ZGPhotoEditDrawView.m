//
//  ZGPhotoEditDrawView.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/11/6.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPhotoEditDrawView.h"
#import "ZGPhotoEditDrawStroke.h"



@interface ZGPhotoEditDrawView (){
        CGMutablePathRef currentPath;
}
@property (nonatomic, strong) NSMutableArray *stroks;
@end

@implementation ZGPhotoEditDrawView
- (id)initWithFrame:(CGRect)frame {
        self = [super initWithFrame:frame];
        if (self) {
                _stroks = [[NSMutableArray alloc] initWithCapacity:1];
                self.backgroundColor = [UIColor clearColor];
                self.userInteractionEnabled = NO;
        }
        return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditDrawViewDelegate)]) {
                [self.delegate darwViewTouchesBegen:self];
        }
        UITouch *touch = [touches anyObject];
        currentPath = CGPathCreateMutable();
        ZGPhotoEditDrawStroke *stroke = [[ZGPhotoEditDrawStroke alloc] init];
        stroke.path = currentPath;
        stroke.blendMode = _isEarse ? kCGBlendModeDestinationIn : kCGBlendModeNormal;
        stroke.strokeWidth = _isEarse ? 20.0 : 5.0; // 如果是橡皮擦宽为20 ,否则为5.0
        stroke.lineColor = _isEarse ? [UIColor clearColor] : _lineColor;
        [_stroks addObject:stroke];
        CGPoint point = [touch locationInView:self];
        CGPathMoveToPoint(currentPath, NULL, point.x, point.y);
        
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        CGPathAddLineToPoint(currentPath, NULL, point.x, point.y);
        [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditDrawViewDelegate)]) {
                [self.delegate darwViewTouchesEnded:self];
        }
}


- (void)drawRect:(CGRect)rect {
        CGContextRef context = UIGraphicsGetCurrentContext();
        for (ZGPhotoEditDrawStroke *stroke in _stroks) {
                [stroke strokeWithContext:context];
        }
}


- (void)dealloc {
        CGPathRelease(currentPath);
}
- (void)clear {
        _isEarse = NO;
        [_stroks removeAllObjects];
        [self setNeedsDisplay];
}
- (void)undo {
        _isEarse = NO;
        [_stroks removeLastObject];
        [self setNeedsDisplay];
}
-(void)setLineColor:(UIColor *)lineColor{
        _isEarse = NO;
        _lineColor = lineColor;
        [self setNeedsDisplay];

}
@end
