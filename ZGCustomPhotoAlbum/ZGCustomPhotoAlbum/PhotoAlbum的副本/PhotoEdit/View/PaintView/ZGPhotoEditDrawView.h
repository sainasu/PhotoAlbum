//
//  ZGPhotoEditDrawView.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/11/6.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZGPhotoEditDrawViewDelegate;

@interface ZGPhotoEditDrawView : UIView
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property(nonatomic, assign) id<ZGPhotoEditDrawViewDelegate>  delegate;

- (void)clearScreen;
- (void)revokeScreen;
@property(nonatomic, assign) CGRect  keepOffFrame;




@end
@protocol ZGPhotoEditDrawViewDelegate <NSObject>
- (void)darwView:(ZGPhotoEditDrawView *)darwView;

@end
