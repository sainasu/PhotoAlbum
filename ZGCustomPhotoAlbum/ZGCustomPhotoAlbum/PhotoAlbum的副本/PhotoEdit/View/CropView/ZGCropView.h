//
//  ZGCropView.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/11/2.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CropViewDelegate;

@interface ZGCropView : UIView
@property (nonatomic, weak) id<CropViewDelegate> delegate;

- (void)dismissCropLines;
@end
@protocol CropViewDelegate <NSObject>
- (void)cropEnded:(ZGCropView *)cropView;
- (void)cropMoved:(ZGCropView *)cropView;
@end
