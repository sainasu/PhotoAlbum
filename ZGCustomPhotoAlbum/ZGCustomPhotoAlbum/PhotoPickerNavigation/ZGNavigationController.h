//
//  ZGNavigationController.h
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/14.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZGNavigationController : UINavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController translucent:(BOOL)translucent;
- (BOOL)popToViewControllerClass:(Class)clazz animated:(BOOL)animated;

@end
