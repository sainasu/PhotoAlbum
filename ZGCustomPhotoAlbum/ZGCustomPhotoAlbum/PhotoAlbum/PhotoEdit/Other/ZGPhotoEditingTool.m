//
//  ZGPhotoEditingTool.m
//  ZGPhotoEdit
//
//  Created by saina_barsud on 2017/12/8.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPhotoEditingTool.h"
#import "ZGPhotoEditHeader.h"
#import "ZGPhotoEditColorBar.h"
#import "ZGPhotoEditFilterBar.h"
#import "ZGPhotoEditMosaicBar.h"
@interface ZGPhotoEditingTool()<ZGPhotoEditColorBarDelegate, ZGPhotoEditFilterBarDelegate,ZGPhotoEditMosaicBarDelegate>
@property(nonatomic, strong) UIButton *darwButton;
@property(nonatomic, strong) UIButton *addImageButton;
@property(nonatomic, strong) UIButton *addTextButton;
@property(nonatomic, strong) UIButton *filderButton;
@property(nonatomic, strong) UIButton *mosaicButton;
@property(nonatomic, strong) UIButton *cropButton;
@property(nonatomic, strong) UIButton *button;

@property(nonatomic, strong) UIView *toolView; // 
@property(nonatomic, strong) UIView *subToolView; //
@property(nonatomic, strong) ZGPhotoEditColorBar *colorBar;
@property(nonatomic, strong) ZGPhotoEditFilterBar *filterBar; // 注释
@property(nonatomic, strong) ZGPhotoEditMosaicBar *mosaicBar;
@property(nonatomic, strong) UIImage *filterImage;



@end
@implementation ZGPhotoEditingTool

- (instancetype)initWithFrame:(CGRect)frame filterImage:(UIImage *)filterImage
{
        self = [super initWithFrame:frame];
        if (self) {
                self.backgroundColor = [UIColor clearColor];
                self.filterImage = filterImage;
                [self initToolView];
                [self initSubToolView];
        }
        return self;
}
- (void)initToolView{
        self.toolView = [[UIView alloc] init];
        self.toolView.backgroundColor = COLOR_PHOTO_EIDT_BAR;
        [self addSubview:self.toolView];
        // 涂鸦button
        self.darwButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.darwButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Bar_draw"] forState:UIControlStateNormal];
        [self.darwButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Bar_draw_selected"] forState:UIControlStateSelected];
        [self.darwButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.darwButton.tag = 0;
        [self.toolView addSubview:self.darwButton];
        //添加图片button
        self.addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addImageButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Bar_image"] forState:UIControlStateNormal];
        [self.addImageButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Bar_image_selected"] forState:UIControlStateSelected];
        [self.addImageButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.addImageButton.tag = 1;
        [self.toolView addSubview:self.addImageButton];
        //添加文字button
        self.addTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addTextButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Bar_text"] forState:UIControlStateNormal];
        [self.addTextButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Bar_text_selected"] forState:UIControlStateSelected];
        [self.addTextButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.addTextButton.tag = 2;
        [self.toolView addSubview:self.addTextButton];
        //滤镜button
        self.filderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.filderButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Bar_filter"] forState:UIControlStateNormal];
        [self.filderButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Bar_filter_selected"] forState:UIControlStateSelected];
        [self.filderButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.filderButton.tag = 3;
        [self.toolView addSubview:self.filderButton];
        //mosaicButton
        self.mosaicButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.mosaicButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Bar_mosaic"] forState:UIControlStateNormal];
        [self.mosaicButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Bar_mosaic_selected"] forState:UIControlStateSelected];
        [self.mosaicButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.mosaicButton.tag = 4;
        [self.toolView addSubview:self.mosaicButton];
        //截图button
        self.cropButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cropButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Bar_crop"] forState:UIControlStateNormal];
        [self.cropButton setBackgroundImage:[UIImage imageNamed:@"PhotoEdit_Bar_crop_selected"] forState:UIControlStateSelected];
        [self.cropButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.cropButton.tag = 5;
        [self.toolView addSubview:self.cropButton];
}
- (void)initSubToolView{
        self.subToolView = [[UIView alloc] init];
        self.subToolView.backgroundColor = COLOR_PHOTO_EIDT_BAR;
        self.subToolView.hidden = YES;
        [self addSubview:self.subToolView];
        self.colorBar = [[ZGPhotoEditColorBar alloc] init];
        self.colorBar.hidden = YES;
        self.colorBar.colorDelegate = self;
        [self.subToolView addSubview:self.colorBar];
        self.filterBar = [[ZGPhotoEditFilterBar alloc] initWithImage:self.filterImage];
        self.filterBar.hidden = YES;
        self.filterBar.filterDelegate = self;
        [self.subToolView addSubview:self.filterBar];;
        self.mosaicBar = [[ZGPhotoEditMosaicBar alloc] init];
        self.mosaicBar.hidden = YES;
        self.mosaicBar.mosaicDelegate = self;
        [self.subToolView addSubview:self.mosaicBar];
}

-(void)setBarType:(NSString *)barType{
        _barType = barType;
        if ([barType isEqualToString:@"colorBar"]) {
                self.colorBar.hidden = NO;
                self.filterBar.hidden = YES;
                self.mosaicBar.hidden = YES;
                self.subToolView.hidden = NO;

        }else if ([barType isEqualToString:@"filterBar"]){
                self.colorBar.hidden = YES;
                self.filterBar.hidden = NO;
                self.mosaicBar.hidden = YES;
                self.subToolView.hidden = NO;

        }else if ([barType isEqualToString:@"mosaicBar"]){
                self.colorBar.hidden = YES;
                self.filterBar.hidden = YES;
                self.mosaicBar.hidden = NO;
                self.subToolView.hidden = NO;
        }else{
                self.colorBar.hidden = YES;
                self.filterBar.hidden = YES;
                self.mosaicBar.hidden = YES;
                self.subToolView.hidden = YES;
        }
}

- (void)buttonAction:(UIButton *)button{
        if (button!= self.button) {
                self.button.selected = NO;
                button.selected = YES;
                self.button = button;
        }else{
                self.button.selected = YES;
        }
        switch (button.tag) {
                case 0:
                        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditingToolDelegate)]) {
                                [self.delegate photoEditingToolDrawAction:self];
                        }
                        break;
                case 1:
                        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditingToolDelegate)]) {
                                [self.delegate photoEditingToolAddImageAction:self];
                        }
                        break;
                case 2:
                        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditingToolDelegate)]) {
                                [self.delegate photoEditingToolAddTextAction:self];
                        }
                        break;
                case 3:
                        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditingToolDelegate)]) {
                                [self.delegate photoEditingToolFilderAction:self];
                        }
                        break;
                case 4:
                        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditingToolDelegate)]) {
                                [self.delegate photoEditingToolMosaicAction:self];
                        }
                        break;
                case 5:
                        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditingToolDelegate)]) {
                                [self.delegate photoEditingToolCropAction:self];
                        }

                        break;
                default:
                        break;
        }
}

-(void)layoutSubviews{
        CGFloat width = self.bounds.size.width;
        CGFloat sacls = (width - 30) / 6;
        self.toolView.frame = CGRectMake(0, HEIGHT_PHOTO_EIDT_BAR_TOOL, width, HEIGHT_PHOTO_EIDT_BAR_TOOL_X);
        self.darwButton.frame = CGRectMake(17 + sacls * 0,0,  HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        self.addImageButton.frame = CGRectMake(17 + sacls * 1,0,  HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        self.addTextButton.frame = CGRectMake(17 + sacls * 2,  0,  HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        self.filderButton.frame = CGRectMake(17 + sacls * 3,  0,  HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        self.mosaicButton.frame = CGRectMake(17 + sacls * 4,0,  HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        self.cropButton.frame = CGRectMake(17 + sacls * 5, 0, HEIGHT_PHOTO_EIDT_BAR_TOOL, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        self.subToolView.frame = CGRectMake(0, 0, width, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        self.mosaicBar.frame = CGRectMake(0, 0, width, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        self.colorBar.frame = CGRectMake(0, 0, width, HEIGHT_PHOTO_EIDT_BAR_TOOL);
        self.filterBar.frame = CGRectMake(0, 0, width, HEIGHT_PHOTO_EIDT_BAR_TOOL);
}
- (void)photoEditFilterName:(NSString *)name{
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditingToolDelegate)]) {
                [self.delegate photoEditTool:self filterType:name];
        }
}
- (void)photoEditMosaicType:(NSString *)type{
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditingToolDelegate)]) {
                [self.delegate photoEditTool:self mosaicType:type];
        }
}
- (void)photoEditColorViewSelectedColor:(UIColor *)color isDraw:(BOOL)draw{
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGPhotoEditingToolDelegate)]) {
                [self.delegate photoEditTool:self brushColor:color];
        }
}



@end
