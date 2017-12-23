//
//  ZGVideoToolView.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/19.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGVideoToolView.h"
@interface ZGVideoToolView()
@property(nonatomic, strong) UIButton *cancelButton;
@property(nonatomic, strong) UIButton *finishButton;

@end
@implementation ZGVideoToolView

- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                self.backgroundColor = COLOR_FOR_NAV_BAR_TRANLUCENT;
                
                self.cancelButton  = [UIButton buttonWithType:UIButtonTypeCustom];
                self.cancelButton.tag = 1;
                [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"icon_navbar_close"] forState:UIControlStateNormal];
                [self.cancelButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:self.cancelButton];
                self.finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
                self.finishButton.tag = 2;
                [self.finishButton setBackgroundImage:[UIImage imageNamed:@"icon_navbar_ok"] forState:UIControlStateNormal];
                [self.finishButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:self.finishButton];

        }
        return self;
}
- (void)buttonAction:(UIButton *)action{
        action.enabled = NO;
        if (action.tag == 1) {
                if (self.videoToolDelegate && [self.videoToolDelegate conformsToProtocol:@protocol(ZGVideoToolViewDelegate)]) {
                        [self.videoToolDelegate videoToolViewEditCancel:self];
                }
        }else if (action.tag == 2){
                if (self.videoToolDelegate && [self.videoToolDelegate conformsToProtocol:@protocol(ZGVideoToolViewDelegate)]) {
                        [self.videoToolDelegate videoToolViewEditFinish:self];
                }
        }
}
-(void)layoutSubviews{
        UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.layer.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(PHOTO_EIDT_BAR_CORNER_RADIUS, PHOTO_EIDT_BAR_CORNER_RADIUS)];
        CAShapeLayer * maskLayer = [CAShapeLayer new];
        maskLayer.frame = self.layer.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        CGFloat width = self.frame.size.width;
        self.cancelButton.frame = CGRectMake(0, 0, HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        self.finishButton.frame = CGRectMake(width - HEIGHT_PHOTO_EIDT_BAR_TOOL, 0, HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL);
}

@end
