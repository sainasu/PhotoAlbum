//
//  ZGPhotoEditNavigatioBar.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/23.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZGPhotoEditNavagationBarType) {
        ZGPhotoEditNavagationBarTypeNormal,
        ZGPhotoEditNavagationBarTypeMosaic,
        ZGPhotoEditNavagationBarTypeDraw
};


@protocol ZGPhotoEditNavigatioBarDelegate;
@interface ZGPhotoEditNavigatioBar : UIView
@property(nonatomic, assign) id<ZGPhotoEditNavigatioBarDelegate> navBarDelegate;
@property(nonatomic, assign) ZGPhotoEditNavagationBarType barType;  // 完成或发送按钮样式 默认值: ZGCustomAssetPickerReturnTypeSend

@end


@protocol ZGPhotoEditNavigatioBarDelegate <NSObject>
- (void)photoEditNavigatioBarDidFinish:(ZGPhotoEditNavigatioBar *)finish;
- (void)photoEditNavigatioBarDidCancel:(ZGPhotoEditNavigatioBar *)cancel;
- (void)photoEditNavigatioBarDidReset:(ZGPhotoEditNavigatioBar *)reset barType:(ZGPhotoEditNavagationBarType)barType;
- (void)photoEditNavigatioBarDidBack:(ZGPhotoEditNavigatioBar *)back barType:(ZGPhotoEditNavagationBarType)barType;

@end
