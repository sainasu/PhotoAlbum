//
//  ZGCutView.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/8.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZGCutView;

@protocol ZGPAImageCropperDelegate <NSObject>

- (void)imageCropper:(ZGCutView *)cropperViewController didFinished:(UIImage *)editedImage;

@end

@interface ZGCutView : UIView

- (instancetype)initWithFrame:(CGRect)frame Image:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@property (nonatomic, assign) CGRect cropFrame;
@property (nonatomic, assign) id<ZGPAImageCropperDelegate> delegate;
//保存
- (void)confirm;
@end
