//
//  ZGCIPViewController.m
//  PhotoAlbum
//
//  Created by saina_su on 2017/9/5.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGCIPViewController.h"
#import "ZGCIPNavigationController.h"
#import "ZGCIPHeader.h"
@interface ZGCIPViewController ()

@end

@implementation ZGCIPViewController

- (void)viewDidLoad {
        [super viewDidLoad];
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = [UIColor colorWithRed:247/255.0 green:248/255.0 blue:250/255.0 alpha:1.0];
        self.interactivePopGestureEnabled = YES;
        self.navigationItem.title = [@"相册" lowercaseString];//lowercaseString = 小写的字符串
        
        //添加左上角按钮
        UIImage *image = [self imageForLeftButton];
        if (image) {
                [self addLeftButton:image];
        }
}

-(void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:animated];
        //自动页面时长统计, 结束记录某个页面展示时长
}

-(void)viewDidAppear:(BOOL)animated{
        [super viewDidAppear:animated];
        if (self.interactivePopGestureEnabled && self.navigationController &&[self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                if (self.navigationController.viewControllers.count > 1) {
                        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
                }else{
                        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
                }
        }
}

-(void)viewWillDisappear:(BOOL)animated{
        [super viewWillDisappear:animated];
        //自动页面时长统计, 结束记录某个页面展示时长
}

#pragma mark -设置状态栏
-(BOOL)prefersStatusBarHidden{
        return self.statusBarHidden;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
        return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
        [[NSURLCache sharedURLCache] removeAllCachedResponses];//清除所有缓存的响应
}
-(void)destroy{
        
}
-(void)dealloc{
        [self destroy];
}


#pragma mark - navagation items
-(CGFloat)contentHeight{
        CGFloat height = [UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
        if (self.navigationController) {
                height -= self.navigationController.navigationBar.frame.size.height;
        }else{
                height -= 44;
        }
        
        if (self.tabBarController) {
                height -= self.tabBarController.tabBar.frame.size.height;
        }
        
        return height;
}
//辞职第一响应者的观点
-(void)resignFirstResponderByView:(UIView *)view{
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponder)];
        [view addGestureRecognizer:tap];
        
}

-(UIImage *)imageForLeftButton{
        if (self.navigationController && self.navigationController.viewControllers.count >1) {
                return [UIImage imageNamed:@"icon_navbar_back"];
        }
        return nil;
}

-(void)addLeftButton:(UIImage *)image{
        [self addLeftButtons:[NSArray arrayWithObjects:image, nil]];
}
-(void)addLeftButtons:(NSArray *)images{
        if (images.count <= 0) {
                return;
        }
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = -15;
        NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:spaceItem, nil];
        for (NSInteger i = 0; i < images.count; i++) {
                
                UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
                leftButton.frame = CGRectMake(0, 0, 44, 44);
                leftButton.tag = i;
                [leftButton setBackgroundImage:[images objectAtIndex:i] forState:UIControlStateNormal];
                [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
                [items addObject:leftItem];
        }
        if (self.tabBarController) {
                self.tabBarController.navigationItem.leftBarButtonItems = items;
        }else{
                self.navigationItem.leftBarButtonItems = items;
        }
}
-(void)leftButtonAction:(id)sender{
        [self resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
}
-(void)addRightButton:(UIImage *)image{
        [self addRightButtons:[NSArray arrayWithObjects:image, nil]];
}
-(void)addRightButtons:(NSArray *)images{
        if (images.count <= 0) {
                return;
        }
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = -15;
        NSMutableArray *items = [NSMutableArray arrayWithObjects:spaceItem, nil];
        for (NSInteger i = 0; i < images.count; i++) {
                UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
                rightButton.frame = CGRectMake(0, 0, 44, 44);
                rightButton.tag = i;
                [rightButton setBackgroundImage:[images objectAtIndex:i] forState:UIControlStateNormal];
                [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
                [items addObject:rightItem];
        }
        if (self.tabBarController) {
                self.tabBarController.navigationItem.rightBarButtonItems = items;
        }else{
                self.navigationItem.rightBarButtonItems = items;
        }
        
}
-(void)addRightButtonSelectdImage:(UIImage *)selectdImage normalImage:(UIImage *)normalImage{
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = -15;
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, 44, 44);
        [rightButton setImage:selectdImage forState:UIControlStateNormal];
        [rightButton setImage:normalImage forState:UIControlStateSelected];
        [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        
        if (self.tabBarController) {
                self.tabBarController.navigationItem.rightBarButtonItem = rightItem;
        }else{
                self.navigationItem.rightBarButtonItem = rightItem;
        }
}

-(void)rightButtonAction:(id)sender{
        [self resignFirstResponder];
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden
{
        _statusBarHidden = statusBarHidden;
        [self setNeedsStatusBarAppearanceUpdate];
}


@end
