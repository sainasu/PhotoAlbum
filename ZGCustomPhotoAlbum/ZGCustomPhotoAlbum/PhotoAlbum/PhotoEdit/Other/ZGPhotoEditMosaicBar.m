//
//  ZGPhotoEditMosaicBar.m
//  ZGPhotoEdit
//
//  Created by saina_barsud on 2017/12/19.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPhotoEditMosaicBar.h"
@interface ZGPhotoEditMosaicBar()
@property(nonatomic, strong) UIButton *mosaicButton;
@property(nonatomic, strong) UIButton *selectButton;

@property(nonatomic, strong) NSArray *buttonImages;
@property(nonatomic, strong) NSMutableArray *buttons;

@end
@implementation ZGPhotoEditMosaicBar


- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                self.buttonImages = [NSArray arrayWithObjects:
                                     @"PhotoEdit_Mosaic_orrgin",
                                     @"PhotoEdit_Mosaic_acrylic",
                                     @"PhotoEdit_Mosaic_jg",
                                     @"PhotoEdit_Mosaic_small",
                                     @"PhotoEdit_Mosaic_paint",
                                     @"PhotoEdit_Mosaic_smooth", nil];
                self.buttons = [NSMutableArray array];
                for (NSInteger i = 0; i < self.buttonImages.count; i++) {
                        self.mosaicButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        self.mosaicButton.tag = i;
                        [self.mosaicButton setBackgroundImage:[UIImage imageNamed:self.buttonImages[i]] forState:UIControlStateNormal];
                        //[self.mosaicButton setBackgroundImage:[UIImage imageNamed:self.buttonImages[i]] forState:UIControlStateSelected];
                        
                        [self.mosaicButton addTarget:self action:@selector(mosaicButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                        [self addSubview:self.mosaicButton];
                        [self.buttons addObject:self.mosaicButton];
                }
                UIButton *btn = self.buttons[0];
                btn.layer.borderColor = [UIColor whiteColor].CGColor;
                btn.layer.borderWidth = 1.0;
                
        }
        return self;
}
-(void)mosaicButtonAction:(UIButton *)button{
        
        for (NSInteger i = 0; i < self.buttons.count; i++) {
                UIButton *btn = self.buttons[i];
                if (btn.tag == button.tag) {
                        btn.layer.borderColor = [UIColor whiteColor].CGColor;
                        btn.layer.borderWidth = 1.0;
                }else{
                        btn.layer.borderColor = [UIColor clearColor].CGColor;
                        btn.layer.borderWidth = 0.0;
                }
        }
        
        if (self.mosaicDelegate && [self.mosaicDelegate conformsToProtocol:@protocol(ZGPhotoEditMosaicBarDelegate)]) {
                [self.mosaicDelegate photoEditMosaicType:self.buttonImages[button.tag]];
        }
}


-(void)layoutSubviews{
        CGFloat width = self.frame.size.width / 6;
        CGFloat height =  (self.frame.size.height - 34) * 0.5;
        for (int i = 0; i < self.buttons.count; i++) {
                UIButton *button = self.buttons[i];
                button.frame = CGRectMake(width * i + 17, height, 34, 34);
        }
        
        
        
}

@end
