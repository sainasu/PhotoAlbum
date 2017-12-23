//
//  ZGPhotoEditTool.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/23.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZGPhotoEditToolDelegate;

@interface ZGPhotoEditTool : UIView
- (instancetype)initWithImage:(UIImage *)image;
@property(nonatomic, assign) id<ZGPhotoEditToolDelegate>  toolDelegate;
-(void)buttonsSelected:(UIButton *)btn;
- (void)cellSelected:(UIColor *)color;


@end
@protocol ZGPhotoEditToolDelegate <NSObject>
- (void)photoEditToolBrushColor:(UIColor *)color;
- (void)photoEditToolAddImage;
- (void)photoEditToolAddTextColor:(UIColor *)color;
- (void)photoEditToolAddText;

- (void)photoEditToolMosaicType:(NSString *)type;
- (void)photoEditToolFilterType:(NSString *)type;
- (void)photoEditToolFilterClick;
- (void)photoEditToolCrop;


@end
