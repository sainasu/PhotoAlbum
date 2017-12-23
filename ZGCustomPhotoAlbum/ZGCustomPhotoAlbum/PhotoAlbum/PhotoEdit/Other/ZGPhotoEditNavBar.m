//
//  ZGPhotoEditNavBar.m
//  ZGPhotoEdit
//
//  Created by saina_barsud on 2017/12/11.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPhotoEditNavBar.h"
#import "ZGPhotoEditHeader.h"
@interface ZGPhotoEditNavBar()
@property(nonatomic, strong) UIButton *returnButton;
@property(nonatomic, strong) UIButton *finishButton;
@property(nonatomic, strong) UIButton *clearButton;
@property(nonatomic, strong) UIButton *undoButton;
@end
@implementation ZGPhotoEditNavBar

- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                self.backgroundColor = COLOR_PHOTO_EIDT_BAR;
                [self initializationSubViews];
        }
        return self;
}
- (void)initializationSubViews{
        self.returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.returnButton.tag = 1001;
        [self.returnButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Nav_Close2"] forState:UIControlStateNormal];
        [self.returnButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.returnButton];
        self.finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.finishButton.tag = 1002;
        [self.finishButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Nav_Save"] forState:UIControlStateNormal];
        [self.finishButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.finishButton];
        self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.clearButton.tag = 1003;
        [self.clearButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Nav_Recovery"] forState:UIControlStateNormal];
        [self.clearButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.clearButton];
        self.undoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.undoButton.tag = 1004;
        [self.undoButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Nav_Back"] forState:UIControlStateNormal];
        [self.undoButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.undoButton];
        
        
        
}
- (void)buttonAction:(UIButton *)button{
        switch (button.tag) {
                case 1001:
                        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditNavBarDelegate)]) {
                                [self.delegate photoEditNavBarReturnButton:self];
                        }
                        break;
                case 1002:
                        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditNavBarDelegate)]) {
                                [self.delegate photoEditNavBarFinishButton:self];
                        }

                        break;
                case 1003:
                        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditNavBarDelegate)]) {
                                [self.delegate photoEditNavBarClearButton:self];
                        }

                        break;
                case 1004:
                        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditNavBarDelegate)]) {
                                [self.delegate photoEditNavBarUndoButton:self];
                        }

                        break;
                        
                default:
                        break;
        }
}
-(void)layoutSubviews{
        
        CGFloat height = self.bounds.size.height;
        CGFloat width = self.bounds.size.width;
        self.finishButton.frame = CGRectMake(width - HEIGHT_PHOTO_EIDT_BAR_NAV - 10,height - HEIGHT_PHOTO_EIDT_BAR_NAV , HEIGHT_PHOTO_EIDT_BAR_NAV, HEIGHT_PHOTO_EIDT_BAR_NAV);
        self.returnButton.frame = CGRectMake(10, height - HEIGHT_PHOTO_EIDT_BAR_NAV, HEIGHT_PHOTO_EIDT_BAR_NAV, HEIGHT_PHOTO_EIDT_BAR_NAV);
        self.undoButton.frame = CGRectMake(width / 2 - HEIGHT_PHOTO_EIDT_BAR_NAV * 1.3 , height - HEIGHT_PHOTO_EIDT_BAR_NAV, HEIGHT_PHOTO_EIDT_BAR_NAV, HEIGHT_PHOTO_EIDT_BAR_NAV);
        self.clearButton.frame = CGRectMake(width / 2 + HEIGHT_PHOTO_EIDT_BAR_NAV * 0.3, height - HEIGHT_PHOTO_EIDT_BAR_NAV, HEIGHT_PHOTO_EIDT_BAR_NAV, HEIGHT_PHOTO_EIDT_BAR_NAV);
        
}





@end

