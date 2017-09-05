//
//  ZGPhotoAlbumPickerBar.m
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/4.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPhotoAlbumPickerBar.h"
#import "ZGCIPHeader.h"


@interface ZGPhotoAlbumPickerBar ()
@property(nonatomic, strong) UIView *backgroundView1;/**<#注释#>*/
@property(nonatomic, strong) UIView *backgroundView2;/**<#注释#>*/
@property(nonatomic, strong) UILabel *hintLabel;/**<#注释#>*/

@end

@implementation ZGPhotoAlbumPickerBar

- (instancetype)initWithFrame:(CGRect)frame isOldPickerBar:(BOOL)isOld
{
        self = [super initWithFrame:frame];
        if (self) {
                self.backgroundColor = ZGCIP_CROP_VIDEO_TABBAR_COLOR;
                //聊天小图:览预按钮   原图按钮   发送按钮icon_navbar_send@3x
                _leftButton = [[UIButton alloc] init];
                _hintLabel = [[UILabel alloc] init];
                _originalImageButton = [[UIButton alloc] init];
                [self addSubview:self.originalImageButton];

                _hintLabel.backgroundColor = [UIColor clearColor];
                [self.leftButton setImage:[UIImage imageNamed:@"icon_navbar_review"] forState:UIControlStateNormal];
                [self addSubview:self.leftButton];
                _rightButton = [[UIButton alloc] init];
                [self.rightButton setImage:[UIImage imageNamed:@"icon_navbar_send_blue"] forState:UIControlStateNormal];
                [self addSubview:self.rightButton];
                if (isOld == YES) {
                        [self.leftButton setImage:[UIImage imageNamed:@"icon_navbar_review"] forState:UIControlStateNormal];
                        [self.rightButton setImage:[UIImage imageNamed:@"icon_navbar_send_blue"] forState:UIControlStateNormal];
                        [self.originalImageButton setImage:[UIImage imageNamed:@"icon_navbar_album"] forState:UIControlStateNormal];
                }
                self.backgroundView1 = [[UIView alloc] init];
                self.backgroundView1.backgroundColor = ZGCIP_COSTOM_COLOR(44, 46, 67, 0.7);
                [self addSubview:self.backgroundView1];
                self.backgroundView2 = [[UIView alloc] init];
                self.backgroundView2.backgroundColor = ZGCIP_COSTOM_COLOR(44, 46, 67, 0.7);
                [self addSubview:self.backgroundView2];
                

                
        }
        return self;
}


-(void)layoutSubviews
{
        self.leftButton.frame = CGRectMake(0, 0, ZGCIP_TABBAR_HEIGHT, ZGCIP_TABBAR_HEIGHT);
        self.rightButton.frame = CGRectMake(self.frame.size.width - ZGCIP_TABBAR_HEIGHT, 0, ZGCIP_TABBAR_HEIGHT, ZGCIP_TABBAR_HEIGHT);
        self.backgroundView1.frame = CGRectMake( 0, 0, ZGCIP_TABBAR_HEIGHT, ZGCIP_TABBAR_HEIGHT);
        self.backgroundView2.frame = CGRectMake(self.frame.size.width - ZGCIP_TABBAR_HEIGHT, 0, ZGCIP_TABBAR_HEIGHT, ZGCIP_TABBAR_HEIGHT);

        self.originalImageButton.frame = CGRectMake(ZGCIP_MAINSCREEN_WIDTH / 2 - ZGCIP_TABBAR_HEIGHT / 2, 0, ZGCIP_TABBAR_HEIGHT, ZGCIP_TABBAR_HEIGHT);
        self.hintLabel.frame = CGRectMake(0, 0, self.frame.size.width - ZGCIP_TABBAR_HEIGHT, ZGCIP_TABBAR_HEIGHT);
}
-(void)setIsHiden:(BOOL)isHiden{
        if (isHiden == YES) {
                [self.backgroundView1 removeFromSuperview];
                [self.backgroundView2 removeFromSuperview];
        }
}

//这当View动画
-(void)isHiden:(BOOL)hiden;
{
        if (hiden == NO) {
                [UIView animateWithDuration:0.02 animations:^{
                        self.backgroundView1.frame = CGRectMake( 0, - 100, ZGCIP_TABBAR_HEIGHT, ZGCIP_TABBAR_HEIGHT);
                        self.backgroundView2.frame = CGRectMake(self.frame.size.width - ZGCIP_TABBAR_HEIGHT, -100, ZGCIP_TABBAR_HEIGHT, ZGCIP_TABBAR_HEIGHT);
                }];

        }else{
                [UIView animateWithDuration:0.02 animations:^{
                        self.backgroundView1.frame = CGRectMake( 0, 0, ZGCIP_TABBAR_HEIGHT, ZGCIP_TABBAR_HEIGHT);
                        self.backgroundView2.frame = CGRectMake(self.frame.size.width - ZGCIP_TABBAR_HEIGHT, 0, ZGCIP_TABBAR_HEIGHT, ZGCIP_TABBAR_HEIGHT);
                }];
   
        }
}


@end
