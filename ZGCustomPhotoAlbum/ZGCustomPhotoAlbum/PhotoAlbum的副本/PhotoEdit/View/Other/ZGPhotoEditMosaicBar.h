//
//  ZGPhotoEditMosaicBar.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/24.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZGPhotoEditMosaicBarDelegate;
@interface ZGPhotoEditMosaicBar : UIView

@property(nonatomic, assign)id<ZGPhotoEditMosaicBarDelegate>  mosaicDelegate;

@end
@protocol ZGPhotoEditMosaicBarDelegate <NSObject>
- (void)photoEditMosaicType:(NSString *)type;

@end
