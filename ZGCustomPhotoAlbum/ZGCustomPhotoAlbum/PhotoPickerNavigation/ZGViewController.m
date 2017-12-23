//
//  ZGViewController.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/14.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGViewController.h"
#import "ZGPhotoAlbumHeader.h"
#import "ZGNavigationController.h"
@interface ZGViewController ()<ZGNavigationTitleViewDelegate>

@end

@implementation ZGViewController

- (void)viewDidLoad
{
        [super viewDidLoad];
        self.view.backgroundColor = COLOR_FOR_BACKGROUND;
        self.interactivePopGestureEnabled = YES;
        self.navigationItem.title = [APP_NAME lowercaseString];
        
        if (self.navigationController && !self.tabBarController) {
                self.navigationController.navigationItem.hidesBackButton = YES;
                self.navigationItem.hidesBackButton = YES;
                self.navigationController.navigationBar.backItem.hidesBackButton = YES;
                
                ZGNavigationTitleView *titleView = [[ZGNavigationTitleView alloc] init];
                titleView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
                                             self.navigationController.navigationBar.frame.size.height);
                titleView.delegate = self;
                [titleView setLeftButtonsWithImageNames:[self imageNamesForLeftButtons]];
                self.navigationItem.titleView = titleView;
        }
        
}

- (void)viewWillAppear:(BOOL)animated
{
        [super viewWillAppear:animated];
        
}

- (void)viewDidAppear:(BOOL)animated
{
        [super viewDidAppear:animated];
        if (self.interactivePopGestureEnabled
            && self.navigationController
            && [self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                if (self.navigationController.viewControllers.count > 1) {
                        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
                } else {
                        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
                }
        }
}

- (void)viewWillDisappear:(BOOL)animated
{
        [super viewWillDisappear:animated];
        
}

- (BOOL)prefersStatusBarHidden
{
        return self.statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
        return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)destroy
{
        
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addObserver:(SEL)aSelector name:(NSNotificationName)aName
{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:aSelector name:aName object:nil];
}

- (void)dealloc
{
        [self destroy];
}

#pragma mark Navigate Items

- (CGFloat)contentHeight
{
        CGFloat height = [UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
        if (self.navigationController) {
                height -= self.navigationController.navigationBar.frame.size.height;
        } else {
                height -= 44;
        }
        if (self.tabBarController) {
                height -= self.tabBarController.tabBar.frame.size.height;
        }
        return height;
}

- (void)resignFirstResponderByView:(UIView *)view
{
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponder)];
        [view addGestureRecognizer:tap];
}

- (NSArray *)imageNamesForLeftButtons
{
        if (self.navigationController
            && self.navigationController.viewControllers.count > 1) {
                return @[@"icon_navbar_back"];
        }
        return nil;
}

- (ZGNavigationTitleView *)navigationTitleView
{
        if (self.tabBarController) {
                return (ZGNavigationTitleView *)self.tabBarController.navigationItem.titleView;
        }
        return (ZGNavigationTitleView *)self.navigationItem.titleView;
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden
{
        _statusBarHidden = statusBarHidden;
        [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - ZGNavigationTitleViewDelegate

- (void)navigationTitleView:(ZGNavigationTitleView *)titleView buttonClickedAtLeftIndex:(NSInteger)index
{
        if (index == 0) {
                [self resignFirstResponder];
                [self.navigationController popViewControllerAnimated:YES];
        }
}

- (void)navigationTitleView:(ZGNavigationTitleView *)titleView buttonClickedAtRightIndex:(NSInteger)index
{
        [self resignFirstResponder];
}



@end
