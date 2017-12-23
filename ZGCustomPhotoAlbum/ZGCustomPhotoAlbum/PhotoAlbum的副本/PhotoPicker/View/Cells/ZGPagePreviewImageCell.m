//
//  ZGPagePreviewImageCell.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/17.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPagePreviewImageCell.h"

@implementation ZGPagePreviewImageCell
- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                self.backgroundColor = [UIColor blackColor];
                self.imageView = [[ZGPagePreviewImageView alloc] init];
                self.imageView.contentMode = UIViewContentModeScaleAspectFit;
                self.imageView.imageViewDelegate = self;
                [self addSubview:self.imageView];
                
        }
        return self;
}
-(void)setImage:(UIImage *)image{
        _image = image;
        self.imageView.image = image;
}
-(void)layoutSubviews{
        self.imageView.frame = self.bounds;
}
- (void)resetView{
        [self.imageView resetView];
}
-(void)pagePreviewImageView:(ZGPagePreviewImageCell *)imageView{
        [self.imageCellDelegate pagePreviewImageCell:self];
}
@end
