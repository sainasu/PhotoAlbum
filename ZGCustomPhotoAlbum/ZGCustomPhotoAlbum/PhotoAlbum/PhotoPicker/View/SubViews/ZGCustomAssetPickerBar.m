//
//  ZGCustomAssetPickerBar.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/14.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGCustomAssetPickerBar.h"
#import "ZGPhotoAlbumHeader.h"

@interface ZGCustomAssetPickerBar ()
@property(nonatomic, strong) UIButton *retrunButton;
@property(nonatomic, strong) UIButton *actionButton;



@end

@implementation ZGCustomAssetPickerBar

- (instancetype)initWithFrame:(CGRect)frame returnType:(ZGCustomImagePickerReturnType)retrunType actionType:(ZGCustomImagePickerActionType)actionType
{
        self = [super initWithFrame:frame];
        if (self) {
                self.backgroundColor = COLOR_FOR_NAV_BAR_TRANLUCENT;
                self.returnType = retrunType;
                self.actionType = actionType;
                
                // retrunButton
                self.retrunButton = [UIButton buttonWithType:UIButtonTypeCustom];
                self.retrunButton.tag = 1;
                if (retrunType == ZGCustomImagePickerReturnTypeSend) {
                        [self.retrunButton setImage:[UIImage imageNamed:@"PhotoAlbum_Bar_Send" ] forState:UIControlStateNormal];
                }else if (retrunType == ZGCustomImagePickerReturnTypeFinish){
                        [self.retrunButton setImage:[UIImage imageNamed:@"PhotoEdit_Nav_Save" ] forState:UIControlStateNormal];
                }
                [self.retrunButton addTarget:self action:@selector(buttonsAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:self.retrunButton];
                
                // actionButton
                self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
                self.actionButton.tag = 2;
                if (actionType == ZGCustomImagePickerActionTypeEdit) {
                        [self.actionButton setImage:[UIImage imageNamed:@"PhotoAlbum_Bar_Edit"] forState:UIControlStateNormal];
                }else if (actionType == ZGCustomImagePickerActionTypePreview){
                        [self.actionButton setBackgroundImage:[UIImage imageNamed:@"PhotoAlbum_Bar_Asset_selected"] forState:UIControlStateNormal];
                        self.actionButton.hidden = YES;
                }
                [self.actionButton addTarget:self action:@selector(buttonsAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:self.actionButton];
                
                //originalImageButton
                self.originalImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
                self.originalImageButton.tag = 3;
                [self.originalImageButton setImage:[UIImage imageNamed:@"PhotoAlbum_rawImage"] forState:UIControlStateNormal];
                [self.originalImageButton setImage:[UIImage imageNamed:@"PhotoAlbum_rawImage_selected"] forState:UIControlStateSelected];
                [self.originalImageButton addTarget:self action:@selector(buttonsAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:self.originalImageButton];
                
        }
        return self;
}
-(void)setAllowsImageEditing:(BOOL)allowsImageEditing{
        _allowsImageEditing = allowsImageEditing;
        self.actionButton.hidden = !allowsImageEditing;
}
-(void)buttonsAction:(UIButton *)btn{
        if (btn.tag == 1) {
                if (self.pickerBarDelegate && [self.pickerBarDelegate conformsToProtocol:@protocol(ZGCustomAssetsPickerBarDelegate)]) {
                        [self.pickerBarDelegate assetsPickerBarRetrunButton:btn];
                }
        }else if (btn.tag == 2){
                if (self.pickerBarDelegate && [self.pickerBarDelegate conformsToProtocol:@protocol(ZGCustomAssetsPickerBarDelegate)]) {
                        [self.pickerBarDelegate assetsPickerBarActionButton:btn];
                }
        }else if (btn.tag == 3){
                self.originalImageButton.selected = !self.originalImageButton.selected;
        }
}
-(void)setCount:(NSUInteger)count{
        _count = count;
        if (self.actionType == ZGCustomImagePickerActionTypePreview){
                self.actionButton.hidden = (count == 0);
//                self.actionButton.titleLabel.font = [UIFont systemFontOfSize:22.0f];
                [self.actionButton setTitle:[NSString stringWithFormat:@"%zi", count] forState:UIControlStateNormal];
        }
        self.retrunButton.enabled = !(count == 0 && self.actionType == ZGCustomImagePickerActionTypePreview) ;
        self.actionButton.enabled = !(count == 0 && self.actionType == ZGCustomImagePickerActionTypePreview);
}
-(void)setVideoDuration:(NSUInteger)videoDuration{
        _videoDuration = videoDuration;
        self.retrunButton.hidden = (_videoDuration > _videoMaximumDuration);
        if (self.allowsImageEditing == NO) {
                self.actionButton.hidden = (_videoDuration == 0);
        }
}


-(void)layoutSubviews{
        
        CGFloat width = self.frame.size.width;
        CGFloat height = HEIGHT_PHOTO_EIDT_BAR_TOOL;
        self.retrunButton.frame = CGRectMake(width - height ,0, height, height);
        self.actionButton.frame = CGRectMake(0, 0,  height, height);
        if (self.actionType == ZGCustomImagePickerActionTypePreview) {
                UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.layer.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(PHOTO_EIDT_BAR_CORNER_RADIUS, PHOTO_EIDT_BAR_CORNER_RADIUS)];
                CAShapeLayer * maskLayer = [CAShapeLayer new];
                maskLayer.frame = self.layer.bounds;
                maskLayer.path = maskPath.CGPath;
                self.layer.mask = maskLayer;
                self.actionButton.frame = CGRectMake(height * 0.2,  height * 0.2, height * 0.6, height * 0.6);
        }
        self.originalImageButton.frame = CGRectMake((width - height) * 0.5, 0, height, height);
}



@end
