//
//  ZGCustomAssetPickerBar.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/14.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZGCustomImagePickerReturnType) {
        ZGCustomImagePickerReturnTypeSend,
        ZGCustomImagePickerReturnTypeFinish
};
typedef NS_ENUM(NSInteger, ZGCustomImagePickerActionType) {
        ZGCustomImagePickerActionTypePreview,
        ZGCustomImagePickerActionTypeEdit
};

@protocol ZGCustomAssetsPickerBarDelegate;

@interface ZGCustomAssetPickerBar : UIView

@property (nonatomic, assign) id<ZGCustomAssetsPickerBarDelegate> pickerBarDelegate;


@property(nonatomic, assign)ZGCustomImagePickerActionType actionType;
@property(nonatomic, assign) ZGCustomImagePickerReturnType returnType;
@property(nonatomic, assign) NSUInteger count;
@property(nonatomic, assign) NSUInteger videoMaximumDuration;
@property(nonatomic, assign) NSUInteger videoDuration;
@property(nonatomic, assign) BOOL allowsImageEditing;

@property(nonatomic, strong) UIButton *originalImageButton;

- (instancetype)initWithFrame:(CGRect)frame returnType:(ZGCustomImagePickerReturnType)retrunType actionType:(ZGCustomImagePickerActionType)actionType;


@end

@protocol ZGCustomAssetsPickerBarDelegate <NSObject>

- (void)assetsPickerBarRetrunButton:(UIButton *)retrunButton;
- (void)assetsPickerBarActionButton:(UIButton *)ActionButton;
@end
