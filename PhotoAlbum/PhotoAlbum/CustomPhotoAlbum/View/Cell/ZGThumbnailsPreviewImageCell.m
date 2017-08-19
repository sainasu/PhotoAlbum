//
//  ZGThumbnailsPreviewImageCell.m
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/7.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGThumbnailsPreviewImageCell.h"
#import "ZGPAHeader.h"

@implementation ZGThumbnailsPreviewImageCell
- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                self.backgroundColor = [UIColor clearColor];
                
                self.imageView = [[UIImageView alloc] init];
                self.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [self addSubview:_imageView];
                //添加选择按钮
                _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
                _selectButton.layer.borderColor = kPAColor(230, 230, 230, 1.0).CGColor;
                _selectButton.layer.borderWidth = 1.0;
                _selectButton.layer.cornerRadius = 12.5;
                _selectButton.layer.masksToBounds = YES;
                [_selectButton setTitle:@"" forState:UIControlStateNormal];
                [_selectButton setTitleColor:kPAColor(230, 230, 230, 1.0) forState:UIControlStateNormal];
                [_selectButton setTitle:@"" forState:UIControlStateSelected];
                [_selectButton setTitleColor:kPAColor(230, 230, 230, 1.0) forState:UIControlStateSelected];
                _selectButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold"  size:20];
                [_selectButton setBackgroundImage:[UIImage imageNamed:@"icon_navbar_ok"] forState:UIControlStateNormal];
                [_selectButton setBackgroundImage:[UIImage imageNamed:@"video_record"] forState:UIControlStateSelected];
                
                [self addSubview:_selectButton];
        }
        return self;
}
-(void)layoutSubviews{
        CGFloat width = kPAMainScreenWidth / 4;
        _selectButton.frame = CGRectMake(width - 28, 3, 25, 25);
        self.imageView.frame = CGRectMake(1, 1, width - 2, width - 2);
}
@end
