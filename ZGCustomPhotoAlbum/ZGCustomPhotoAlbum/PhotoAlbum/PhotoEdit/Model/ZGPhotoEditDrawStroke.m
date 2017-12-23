//
//  ZGPhotoEditDrawStroke.m
//  ZGPhotoEdit
//
//  Created by saina_barsud on 2017/12/11.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPhotoEditDrawStroke.h"

@implementation ZGPhotoEditDrawStroke


- (void)strokeWithContext:(CGContextRef)context {
        CGContextSetStrokeColorWithColor(context, [_lineColor CGColor]);
        CGContextSetLineWidth(context, _strokeWidth);
        CGContextSetBlendMode(context, _blendMode);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextBeginPath(context);
        CGContextAddPath(context, _path);
        CGContextStrokePath(context);
}

@end
