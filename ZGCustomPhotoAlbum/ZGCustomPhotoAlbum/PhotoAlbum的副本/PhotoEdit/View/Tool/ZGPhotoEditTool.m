//
//  ZGPhotoEditTool.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/23.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPhotoEditTool.h"
#import "ZGPhotoEditColorBar.h"
#import "ZGPhotoEditFilterBar.h"
#import "ZGPhotoAlbumHeader.h"
#import "ZGPhotoEditMosaicBar.h"
@interface ZGPhotoEditTool ()<ZGPhotoEditColorBarDelegate, ZGPhotoEditFilterBarDelegate, ZGPhotoEditMosaicBarDelegate>{
        UIButton *_drawButton;
        UIButton *_photoButton;
        UIButton *_textButton;
        UIButton *_mosaicButton;
        UIButton *_filterButton;
        UIButton *_cropButton;
        UIView * _dividingLine;
        UIView *_view;
}
@property(nonatomic, strong) UIButton *clickButton;
@property(nonatomic, strong) UIImage *photo;
@property(nonatomic, strong) UIColor *textColor;
@property(nonatomic, strong) UIColor *brushColor;
@property(nonatomic, strong) NSString *mosaicType;
@property(nonatomic, strong) NSString *filterType;




@property(nonatomic, strong) ZGPhotoEditColorBar *drawColorBar;
@property(nonatomic, strong) ZGPhotoEditColorBar *textColorBar;
@property(nonatomic, strong) ZGPhotoEditFilterBar *filterBar;
@property(nonatomic, strong) ZGPhotoEditMosaicBar *mosaicBar;

@end

@implementation ZGPhotoEditTool

- (instancetype)initWithImage:(UIImage *)image
{
        self = [super init];
        if (self) {
                self.backgroundColor = [UIColor clearColor];
                _view = [[UIView alloc] init];
                _view.backgroundColor = COLOR_FOR_PHOTO_EDIT_TOOL;
                [self addSubview:_view];
                _dividingLine = [[UIView alloc] init];
                _dividingLine.backgroundColor = COLOR_FOR_PHOTO_EDIT_TOOL;
                _dividingLine.hidden = YES;
                [self addSubview:_dividingLine];

                self.photo = [[UIImage alloc] init];
                self.photo = image;
               
                [self initButtons];
                [self initSubTools];
                
                
                
        }
        return self;
}

- (void)cellSelected:(UIColor *)color{
        [self.textColorBar cellSelected:color];
        self.textColorBar.hidden = NO;
        _dividingLine.hidden = NO;
        self.drawColorBar.hidden = YES;
}
- (void)buttonsSelected:(UIButton *)btn{
        self.textColorBar.hidden = YES;
        self.drawColorBar.hidden = YES;
        _dividingLine.hidden = YES;
        self.filterBar.hidden = YES;
        self.mosaicBar.hidden = YES;
        if (btn.tag == 2) {
                _photoButton.selected = YES;
                if (_photoButton!= self.clickButton) {
                        self.clickButton.selected = NO;
                        _photoButton.selected = YES;
                        self.clickButton = _photoButton;
                }else{
                        self.clickButton.selected = YES;
                }
        }else if (btn.tag == 3){
                _textButton.selected = YES;
                if (_textButton!= self.clickButton) {
                        self.clickButton.selected = NO;
                        _textButton.selected = YES;
                        self.clickButton = _textButton;
                }else{
                        self.clickButton.selected = YES;
                }
                
        }
}

- (void)initSubTools{
        self.drawColorBar = [[ZGPhotoEditColorBar alloc] init];
        self.drawColorBar.hidden = YES;
        self.drawColorBar.colorDelegate = self;
        self.drawColorBar.isBack = YES;
        [_dividingLine addSubview:self.drawColorBar];
       
        self.textColorBar = [[ZGPhotoEditColorBar alloc] init];
        self.textColorBar.hidden = YES;
        self.textColorBar.colorDelegate = self;
        self.textColorBar.isBack = NO;
        [_dividingLine addSubview:self.textColorBar];

        self.filterBar = [[ZGPhotoEditFilterBar alloc] initWithImage:self.photo];
        self.filterBar.hidden = YES;
        self.filterBar.filterDelegate = self;
        [_dividingLine addSubview:self.filterBar];
        
        self.mosaicBar = [[ZGPhotoEditMosaicBar alloc] init];
        self.mosaicBar.hidden = YES;
        self.mosaicBar.mosaicDelegate = self;
        [_dividingLine addSubview:self.mosaicBar];
        

}
#pragma mark - ZGPhotoEditColorBarDelegate
- (void)photoEditColorViewSelectedColor:(UIColor *)color isDraw:(BOOL)draw{
        if (draw) {
                self.brushColor = color;
                if (self.toolDelegate && [self.toolDelegate conformsToProtocol:@protocol(ZGPhotoEditToolDelegate)]) {
                        [self.toolDelegate photoEditToolBrushColor:color];
                }
        }else{
                self.textColor = color;
                if (self.toolDelegate && [self.toolDelegate conformsToProtocol:@protocol(ZGPhotoEditToolDelegate)]) {
                        [self.toolDelegate photoEditToolAddTextColor:color];
                }

        }
}
#pragma mark - ZGPhotoEditFilterBarDelegate
-(void)photoEditFilterName:(NSString *)name{
        self.filterType = name;
        if (self.toolDelegate && [self.toolDelegate conformsToProtocol:@protocol(ZGPhotoEditToolDelegate)]) {
                [self.toolDelegate photoEditToolFilterType:name];
        }
}
#pragma mark - ZGPhotoEditMosaicBarDelegate
-(void)photoEditMosaicType:(NSString *)type{
        self.mosaicType = type;
        if (self.toolDelegate && [self.toolDelegate conformsToProtocol:@protocol(ZGPhotoEditToolDelegate)]) {
                [self.toolDelegate photoEditToolMosaicType:type];
        }
}
- (void)initButtons{
        _drawButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_drawButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Bar_draw"] forState:UIControlStateNormal];
        [_drawButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Bar_draw_selected"] forState:UIControlStateSelected];
        [_drawButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_drawButton setTag:1];
        [_view addSubview:_drawButton];
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_photoButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Bar_image"] forState:UIControlStateNormal];
        [_photoButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Bar_image_selected"] forState:UIControlStateSelected];
        [_photoButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_photoButton setTag:2];
        [_view addSubview:_photoButton];
        _textButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_textButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Bar_text"] forState:UIControlStateNormal];
        [_textButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Bar_text_selected"] forState:UIControlStateSelected];
        [_textButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_textButton setTag:3];
        [_view addSubview:_textButton];
        _mosaicButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mosaicButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Bar_mosaic"] forState:UIControlStateNormal];
        [_mosaicButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Bar_mosaic_selected"] forState:UIControlStateSelected];
        [_mosaicButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_mosaicButton setTag:4];
        [_view addSubview:_mosaicButton];
        _filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_filterButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Bar_filter"] forState:UIControlStateNormal];
        [_filterButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Bar_filter_selected"] forState:UIControlStateSelected];
        [_filterButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_filterButton setTag:5];
        [_view addSubview:_filterButton];
        _cropButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cropButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Bar_crop"] forState:UIControlStateNormal];
        [_cropButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Bar_crop_selected"] forState:UIControlStateSelected];
        [_cropButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cropButton setTag:6];
        [_view addSubview:_cropButton];

}

- (void)buttonClick:(UIButton *) btn{
                if (btn!= self.clickButton) {
                        self.clickButton.selected = NO;
                        btn.selected = YES;
                        self.clickButton = btn;
                }else{
                        self.clickButton.selected = YES;
                }
        self.textColorBar.hidden = YES;
        self.drawColorBar.hidden = YES;
        _dividingLine.hidden = YES;
        self.filterBar.hidden = YES;
        self.mosaicBar.hidden = YES;


        if (btn.tag == 1) {
                self.drawColorBar.hidden = NO;
                _dividingLine.hidden = NO;
                if (self.toolDelegate && [self.toolDelegate conformsToProtocol:@protocol(ZGPhotoEditToolDelegate)]) {
                        [self.toolDelegate photoEditToolBrushColor:self.brushColor];
                }
        }else if (btn.tag == 2) {
                if (self.toolDelegate && [self.toolDelegate conformsToProtocol:@protocol(ZGPhotoEditToolDelegate)]) {
                        [self.toolDelegate photoEditToolAddImage];
                }
        }else if (btn.tag == 3) {
                self.textColorBar.hidden = NO;
                _dividingLine.hidden = NO;
                if (self.toolDelegate && [self.toolDelegate conformsToProtocol:@protocol(ZGPhotoEditToolDelegate)]) {
                        [self.toolDelegate photoEditToolAddText];
                }
        }else if (btn.tag == 4) {
                self.mosaicBar.hidden = NO;
                _dividingLine.hidden = NO;
                if (self.toolDelegate && [self.toolDelegate conformsToProtocol:@protocol(ZGPhotoEditToolDelegate)]) {
                        [self.toolDelegate photoEditToolMosaicType:self.mosaicType];
                }
        }else if (btn.tag == 5) {
                self.filterBar.hidden = NO;
                _dividingLine.hidden = NO;
                if (self.toolDelegate && [self.toolDelegate conformsToProtocol:@protocol(ZGPhotoEditToolDelegate)]) {
                        if (self.filterType == nil) {
                                self.filterType = @"OriginImage";
                        }
                        [self.toolDelegate photoEditToolFilterClick];
                }
        }else if (btn.tag == 6) {
                if (self.toolDelegate && [self.toolDelegate conformsToProtocol:@protocol(ZGPhotoEditToolDelegate)]) {
                        [self.toolDelegate photoEditToolCrop];

                }

        }
}
-(void)layoutSubviews{

        CGFloat width = self.bounds.size.width;
        _view.frame = CGRectMake(0, HEIGHT_PHOTO_EIDT_BAR_TOOL , width, HEIGHT_PHOTO_EIDT_BAR_TOOL_X);
        
        _dividingLine.frame = CGRectMake(0, 0 , width, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        CGFloat x = width / 12;
        CGFloat w = HEIGHT_PHOTO_EIDT_BAR_TOOL / 2 ;
        _drawButton.frame = CGRectMake(x - w , 0, HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        _photoButton.frame = CGRectMake(x  * 3 - w, 0, HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        _textButton.frame = CGRectMake(x * 5- w , 0, HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        _filterButton.frame = CGRectMake(x * 7 - w , 0, HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        _mosaicButton.frame = CGRectMake(x * 9 - w, 0, HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        _cropButton.frame = CGRectMake(x * 11- w , 0, HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        
        self.textColorBar.frame =  CGRectMake(0, 0, width, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        self.drawColorBar.frame =  CGRectMake(0, 0, width, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        self.filterBar.frame =  CGRectMake(0, 0, width, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        self.mosaicBar.frame =  CGRectMake(0, 0, width, HEIGHT_PHOTO_EIDT_BAR_TOOL);

}

@end
