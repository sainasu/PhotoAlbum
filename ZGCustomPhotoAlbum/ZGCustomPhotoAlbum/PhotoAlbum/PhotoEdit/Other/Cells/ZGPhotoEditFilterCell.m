//
//  ZGPhotoEditFilterCell.m
//  ZGPhotoEdit
//
//  Created by saina_barsud on 2017/12/19.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPhotoEditFilterCell.h"

@implementation ZGPhotoEditFilterCell

- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                self.imageView = [[UIImageView alloc]init];
                self.imageView.contentMode = UIViewContentModeScaleAspectFill;
                self.imageView.clipsToBounds = YES;
                
                [self addSubview:self.imageView];
        }
        return self;
}


-(void)layoutSubviews{
        self.imageView.frame = CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.height - 4);
}

@end
