//
//  ZGPhotoEditColorCell.m
//  ZGPhotoEdit
//
//  Created by saina_barsud on 2017/12/19.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPhotoEditColorCell.h"

@implementation ZGPhotoEditColorCell
- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                self.colorView = [[UIView alloc] init];
                self.colorView.layer.masksToBounds = YES;
                [self addSubview:_colorView];
                
        }
        return self;
}
-(void)layoutSubviews{
        self.colorView.frame = CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.height - 4);
        self.colorView.layer.cornerRadius = (self.frame.size.height - 4) / 2;
}

@end
