//
//  ZGVCMainViewController.h
//  VideoClip
//
//  Created by saina_su on 2017/8/14.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>



@protocol ZGVCMainViewControllerDelegate <NSObject>
//返回截取好的视频
-(void)cuttingVideoAsset:(PHAsset *)asset;

@end


@interface ZGVCMainViewController : UIViewController

@property(nonatomic, weak) id<ZGVCMainViewControllerDelegate>  vcDelegate;
@property(nonatomic, strong) NSURL *vcURL;/**需要参数URL*/
@property(nonatomic, assign) CGFloat lengthNumber;/**参数: 截取的长度*/
@property(nonatomic, assign) BOOL  isPicturesAndVideoCombination;
@property(nonatomic, strong) UIViewController *fromViewController;/**来自哪儿个控制器*/


@end
