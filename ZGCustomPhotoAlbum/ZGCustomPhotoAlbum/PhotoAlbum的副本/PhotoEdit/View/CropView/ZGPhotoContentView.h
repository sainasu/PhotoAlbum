//
//  ZGPhotoContentView.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/11/2.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZGPhotoContentView : UIView
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
- (instancetype)initWithFrame:(CGRect)frame Image:(UIImage *)image;
@end
