//
//  ZGPhotoEditFilterBar.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/23.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZGPhotoEditFilterBarDelegate;
@interface ZGPhotoEditFilterBar : UIView
- (instancetype)initWithImage:(UIImage *)image;
@property(nonatomic, assign) id<ZGPhotoEditFilterBarDelegate>  filterDelegate;

@end
@protocol ZGPhotoEditFilterBarDelegate <NSObject>
- (void)photoEditFilterName:(NSString *)name;
@end

