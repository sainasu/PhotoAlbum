//
//  ZGNavigationController.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/14.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGNavigationController.h"
#import "ZGPhotoAlbumHeader.h"

@interface ZGNavigationController ()

@end

@implementation ZGNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
        return [self initWithRootViewController:rootViewController translucent:NO];
}

- (id)initWithRootViewController:(UIViewController *)rootViewController translucent:(BOOL)translucent
{
        self = [super initWithRootViewController:rootViewController];
        if (self) {
                self.navigationBarHidden = NO;
                NSMutableDictionary *attr = [[NSMutableDictionary alloc] init];
                [attr setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
                self.navigationBar.titleTextAttributes = attr;
                if (translucent) {
                        self.navigationBar.translucent = YES;
                        self.navigationBar.shadowImage = [[UIImage alloc] init];
                        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
                        self.navigationBar.alpha = 0.5;
                } else {
                        self.navigationBar.barTintColor = COLOR_FOR_NAV_BAR;
                        self.navigationBar.shadowImage = [[UIImage alloc] init];
                        [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
                        self.navigationBar.translucent = NO;
                }
        }
        return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
        self.interactivePopGestureRecognizer.enabled = NO;
        [super pushViewController:viewController animated:animated];
        self.interactivePopGestureRecognizer.delegate = nil;
}

- (BOOL)popToViewControllerClass:(Class)clazz animated:(BOOL)animated
{
        UIViewController *popToController = nil;
        for (UIViewController *controller in self.viewControllers) {
                if ([NSStringFromClass([controller class]) isEqualToString:NSStringFromClass(clazz)]) {
                        popToController = controller;
                        break;
                }
        }
        if (popToController) {
                [self popToViewController:popToController animated:animated];
                return YES;
        }
        return NO;
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
        if ([viewControllerToPresent isKindOfClass:[UINavigationController class]]) {
                [super presentViewController:viewControllerToPresent animated:flag completion:completion];
        } else {
                ZGNavigationController *navController = [[ZGNavigationController alloc] initWithRootViewController:viewControllerToPresent];
                [super presentViewController:navController animated:flag completion:completion];
        }
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
        if (self.viewControllers.count > 0) {
                return [self.viewControllers lastObject];
        }
        return nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
        return UIStatusBarStyleLightContent;
}


@end
