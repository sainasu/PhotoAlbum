//
//  ZGAssetPreviewCell.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/17.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGAssetPreviewCell.h"
#import "ZGPhotoAlbumHeader.h"
@interface ZGAssetPreviewCell()
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIButton *countButton;
@property(nonatomic, strong) UILabel *videoLable;
@end
@implementation ZGAssetPreviewCell
- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                self.backgroundColor = COLOR_FOR_ASSET_POCKER_BACKGROUND;
                self.layer.borderColor = COLOR_FOR_ASSET_POCKER_BACKGROUND.CGColor;
                self.layer.borderWidth = 2;
                self.imageView = [[UIImageView alloc] init];
                self.imageView.contentMode = UIViewContentModeScaleAspectFill;
                self.imageView.clipsToBounds = YES;
                [self addSubview:self.imageView];
                
                self.countButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.countButton setTintColor:[UIColor whiteColor]];
                [self.countButton setBackgroundImage:[UIImage imageNamed:@"PhotoAlbum_Bar_Asset"] forState:UIControlStateNormal];
                [self.countButton setBackgroundImage:[UIImage imageNamed:@"PhotoAlbum_Bar_Asset_selected"] forState:UIControlStateSelected];
                [self.countButton addTarget:self action:@selector(countButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                self.countButton.hidden = YES;
                [self addSubview:self.countButton];
                
                self.videoLable = [[UILabel alloc] init];
                self.videoLable.textColor = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0];
                self.videoLable.hidden = YES;
                [self addSubview:self.videoLable];
        }
        return self;
}
- (void)countButtonAction:(UIButton *)btn{
        self.countButton.selected = !self.countButton.selected;
        [self.cellImageDelegate assetPreviewCell:self actionButton:self.countButton];
}
-(void)setVideoDuration:(NSUInteger)videoDuration{
        _videoDuration = videoDuration;
        self.videoLable.hidden = !videoDuration;
        self.videoLable.text = [NSString stringWithFormat:@"%02zi:%02zi",(videoDuration / 60) % 60, videoDuration % 60];
}
- (void)setImage:(UIImage *)image{
        _image = image;
        self.imageView.image = image;
}
- (void)setCount:(NSInteger)count{
        _count = count;
        if (count == -1) {
                self.countButton.hidden = YES;
        }else if (count > 0) {
                self.countButton.hidden = NO;
                self.countButton.selected = YES;
                [self.countButton setTitle:[NSString stringWithFormat:@"%zi",count] forState:UIControlStateSelected];
        }else if (count == 0){
                self.countButton.hidden = NO;
                self.countButton.selected = NO;
        }
        
}
- (void)layoutSubviews{
        CGFloat widch = self.frame.size.width / 4;
        self.imageView.frame = self.bounds;
        self.countButton.frame = CGRectMake(widch * 3 - 5, 5, widch, widch);
        self.videoLable.frame = CGRectMake(5, widch * 3 - 5, widch * 3, widch);
}

@end
