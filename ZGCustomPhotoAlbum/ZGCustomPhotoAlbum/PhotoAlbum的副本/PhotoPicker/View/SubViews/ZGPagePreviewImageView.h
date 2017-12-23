//
//  ZGPagePreviewImageView.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/17.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZGPagePreviewImageViewDelegate;


@interface ZGPagePreviewImageView : UIImageView
- (void)resetView;

@property(nonatomic, assign) id<ZGPagePreviewImageViewDelegate>  imageViewDelegate;


@end

@protocol ZGPagePreviewImageViewDelegate <NSObject>
- (void)pagePreviewImageView:(ZGPagePreviewImageView *)imageView;

@end

