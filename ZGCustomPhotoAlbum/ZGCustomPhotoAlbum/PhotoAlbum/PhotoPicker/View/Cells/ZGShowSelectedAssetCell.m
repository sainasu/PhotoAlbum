//
//  ZGShowSelectedAssetCell.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/12/4.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGShowSelectedAssetCell.h"
#import "ZGPhotoAlbumHeader.h"
@interface ZGShowSelectedAssetCell()
@property(nonatomic, strong) UILabel *videoLable;

@end

@implementation ZGShowSelectedAssetCell
- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                self.imageView = [[UIImageView alloc] initWithFrame:frame];
                self.imageView.contentMode = UIViewContentModeScaleAspectFill;
                self.imageView.clipsToBounds = YES;
                [self addSubview:self.imageView];
                
                self.videoLable = [[UILabel alloc] init];
                self.videoLable.textColor = COLOR_FOR_BORDER;
                [self addSubview:self.videoLable];

                
        }
        return self;
}
-(void)layoutSubviews{
        self.imageView.frame = CGRectMake(1, 1, self.bounds.size.width - 2, self.bounds.size.height - 2);
        self.videoLable.frame = CGRectMake(10, self.imageView.frame.size.height / 1.5, self.imageView.frame.size.width , self.imageView.frame.size.height / 2.5);
        
}
-(void)setAssetDuration:(NSInteger)assetDuration{
        _assetDuration = assetDuration;
        self.videoLable.hidden = (assetDuration == 0);
        self.videoLable.text = [NSString stringWithFormat:@"%02zi:%02zi",(assetDuration / 60) % 60, assetDuration % 60];

}



@end
