//
//  ZGCIPNavigationController.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/9/5.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZGCIPNavigationController : UINavigationController
- (id)initWithRootViewController:(UIViewController *)rootViewController translucent:(BOOL)translucent;

- (BOOL)popToViewControllerClass:(Class)clazz animated:(BOOL)animated;

@end
