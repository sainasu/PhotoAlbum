//
//  ZGPhotoEditNavigatioBar.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/23.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPhotoEditNavigatioBar.h"
#import "ZGPhotoAlbumHeader.h"
@interface ZGPhotoEditNavigatioBar (){
        UIButton *_cancelButton;
        UIButton *_finishButton;
        UIButton *_backButton;
        UIButton *_resetButton;
}

@end
@implementation ZGPhotoEditNavigatioBar
- (instancetype)init
{
        self = [super init];
        if (self) {
                self.backgroundColor = COLOR_FOR_PHOTO_EDIT_TOOL;
                _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [_cancelButton setBackgroundImage:[UIImage imageNamed:@"icon_navbar_close"] forState:UIControlStateNormal];
                [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_cancelButton];
                _finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [_finishButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Nav_Save"] forState:UIControlStateNormal];
                [_finishButton addTarget:self action:@selector(finishButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:_finishButton];
                _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [_backButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Nav_Back"] forState:UIControlStateNormal];
                [_backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
                _backButton.hidden = YES;
                [self addSubview:_backButton];
                _resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [_resetButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Nav_Recovery"] forState:UIControlStateNormal];
                [_resetButton addTarget:self action:@selector(resetButtonAction) forControlEvents:UIControlEventTouchUpInside];
                _resetButton.hidden = YES;
                [self addSubview:_resetButton];

                

                
        }
        return self;
}
-(void)cancelButtonAction:(UIButton *)button{
        button.enabled = NO;
        if (self.navBarDelegate && [self.navBarDelegate conformsToProtocol:@protocol(ZGPhotoEditNavigatioBarDelegate)]) {
                [self.navBarDelegate photoEditNavigatioBarDidCancel:self];
        }
        
}
-(void)finishButtonAction:(UIButton *)button{
        button.enabled = NO;
        if (self.navBarDelegate && [self.navBarDelegate conformsToProtocol:@protocol(ZGPhotoEditNavigatioBarDelegate)]) {
                [self.navBarDelegate photoEditNavigatioBarDidFinish:self];
        }
}
-(void)backButtonAction{
        if (self.navBarDelegate && [self.navBarDelegate conformsToProtocol:@protocol(ZGPhotoEditNavigatioBarDelegate)]) {
                [self.navBarDelegate photoEditNavigatioBarDidBack:self  barType:self.barType];
        }
        
}
-(void)resetButtonAction{
        if (self.navBarDelegate && [self.navBarDelegate conformsToProtocol:@protocol(ZGPhotoEditNavigatioBarDelegate)]) {
                [self.navBarDelegate photoEditNavigatioBarDidReset:self barType:self.barType];
        }
        
}
-(void)setBarType:(ZGPhotoEditNavagationBarType)barType{
        _barType = barType;
        if (_barType != ZGPhotoEditNavagationBarTypeNormal) {
                _resetButton.hidden = NO;
                _backButton.hidden = NO;
        }else{
                _resetButton.hidden = YES;
                _backButton.hidden = YES;
        }
}

-(void)layoutSubviews{
        CGFloat height = self.frame.size.height;
        CGFloat width = self.frame.size.width;
        _cancelButton.frame = CGRectMake(10, height - HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        _finishButton.frame = CGRectMake(width - HEIGHT_PHOTO_EIDT_BAR_TOOL - 10, height - HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        
        _resetButton.frame = CGRectMake(width / 2 + HEIGHT_PHOTO_EIDT_BAR_TOOL * 0.5, height - HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        _backButton.frame = CGRectMake(width / 2 - HEIGHT_PHOTO_EIDT_BAR_TOOL * 1.5, height - HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL);
}



@end
