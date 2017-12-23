//
//  ZGCropPictureView.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/11/22.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZGCropPictureViewDelegate;
@interface ZGCropPictureView : UIView
- (instancetype)initWithFrame:(CGRect)frame cropImage:(UIImage *)cropImage cropSize:(CGSize)cropSize isRound:(BOOL)round;

@property(nonatomic, assign) id<ZGCropPictureViewDelegate>  delegate;

@end
@protocol ZGCropPictureViewDelegate <NSObject>
- (void)cropPictureView:(ZGCropPictureView *)cropPicture cropViewFrame:(CGRect)frame;

@end
