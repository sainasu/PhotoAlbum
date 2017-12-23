//
//  ZGVideoToolView.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/19.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZGPhotoAlbumHeader.h"
@protocol ZGVideoToolViewDelegate;

@interface ZGVideoToolView : UIView

@property (nonatomic, assign) id<ZGVideoToolViewDelegate> videoToolDelegate;

@end


@protocol ZGVideoToolViewDelegate <NSObject>
- (void)videoToolViewEditCancel:(ZGVideoToolView *)tool;
- (void)videoToolViewEditFinish:(ZGVideoToolView *)tool;
@end
