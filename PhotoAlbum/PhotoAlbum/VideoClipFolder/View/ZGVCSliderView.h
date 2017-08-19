//
//  ZGVCSliderView.h
//  VideoClip
//
//  Created by saina_su on 2017/8/14.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZGVCSliderViewDelegate <NSObject>

-(void)playTheStartTime:(CGFloat)startTime endTime:(CGFloat )endTime;

@end

@interface ZGVCSliderView : UIView
- (instancetype)initWithFrame:(CGRect)frame  videoAsset:(NSURL *)movieURL videoLength:(CGFloat)length;

@property(nonatomic, assign) id<ZGVCSliderViewDelegate>  sliderDelegate;/**<#注释#>*/

-(void) initWithAnimate:(CGFloat)timer;


@end
