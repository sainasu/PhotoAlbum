//
//  ZGCustomNavigationBar.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/17.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGCustomNavigationBar.h"
#import "ZGPhotoAlbumHeader.h"

@interface ZGCustomNavigationBar()
@property(nonatomic, strong) UIButton *rightButton;
@property(nonatomic, strong) UIButton *leftButton;

@end
@implementation ZGCustomNavigationBar
- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                self.backgroundColor = COLOR_FOR_NAV_BAR_TRANLUCENT;
                self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.rightButton setImage:[UIImage imageNamed:@"PhotoAlbum_Bar_Asset"] forState:UIControlStateNormal];
                [self.rightButton setImage:[UIImage imageNamed:@"PhotoAlbum_NavBar_selected"] forState:UIControlStateSelected];
                [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:self.rightButton];
                
                self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.leftButton setBackgroundImage:[UIImage imageNamed:@"icon_navbar_back"] forState:UIControlStateNormal];
                [self.leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:self.leftButton];
        }
        return self;
}
- (void)rightButtonClick:(UIButton *)btn{
        btn.selected = !btn.selected;
        if (self.navigationBarDelegate && [self.navigationBarDelegate conformsToProtocol:@protocol(ZGCustomNavigationBarDelegate)]) {
                [self.navigationBarDelegate navigationBarReightButton:btn];
        }
}
- (void)leftButtonClick:(UIButton *)btn{
        if (self.navigationBarDelegate && [self.navigationBarDelegate conformsToProtocol:@protocol(ZGCustomNavigationBarDelegate)]) {
                [self.navigationBarDelegate navigationBarLeftButton:btn];
        }
}

-(void)setCount:(NSInteger)count{
        _count = count;
        if (count > 0) {
                self.rightButton.selected = YES;
        }else{
                self.rightButton.selected = NO;
        }
}
-(void)setVideoDuration:(NSUInteger)videoDuration{
        _videoDuration = videoDuration;
        self.rightButton.hidden = (_videoDuration > _videoMaximumDuration);
}

-(void)layoutSubviews{
        self.leftButton.frame = CGRectMake(10, self.frame.size.height - HEIGHT_PHOTO_EIDT_BAR_NAV, HEIGHT_PHOTO_EIDT_BAR_NAV, HEIGHT_PHOTO_EIDT_BAR_NAV);
        self.rightButton.frame = CGRectMake( self.frame.size.width - HEIGHT_PHOTO_EIDT_BAR_NAV - 10, self.frame.size.height - HEIGHT_PHOTO_EIDT_BAR_NAV, HEIGHT_PHOTO_EIDT_BAR_NAV, HEIGHT_PHOTO_EIDT_BAR_NAV);
}

@end
