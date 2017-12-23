//
//  ZGPhotoContentView.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/11/2.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPhotoContentView.h"

@implementation ZGPhotoContentView

- (instancetype)initWithFrame:(CGRect)frame Image:(UIImage *)image
{
        self = [super initWithFrame:frame];
        if (self) {
                _image = image;
                _imageView = [[UIImageView alloc] initWithImage:image];
                _imageView.frame = frame;
                _imageView.contentMode = UIViewContentModeScaleAspectFill;
                _imageView.userInteractionEnabled = YES;
                [self addSubview:_imageView];
                
                
        }
        return self;
}
- (void)layoutSubviews
{
        [super layoutSubviews];
        self.imageView.frame = self.bounds;
}

@end
