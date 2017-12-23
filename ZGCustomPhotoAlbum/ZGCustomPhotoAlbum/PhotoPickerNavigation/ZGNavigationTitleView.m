//
//  ZGNavigationTitleView.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/10/18.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGNavigationTitleView.h"
#import "ZGPhotoAlbumHeader.h"
@interface ZGNavigationTitleView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIActivityIndicatorView *connectingView;
@property (nonatomic, strong) UIImageView *disconnectedView;
@end
@implementation ZGNavigationTitleView
- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                self.titleLabel = [[UILabel alloc] init];
                self.titleLabel.text = [APP_NAME lowercaseString];
                self.titleLabel.textColor = [UIColor whiteColor];
                self.titleLabel.font = [UIFont systemFontOfSize:18.0];
                self.titleLabel.textAlignment = NSTextAlignmentCenter;
                [self addSubview:self.titleLabel];
                
                self.connectingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                [self addSubview:self.connectingView];
                
                self.disconnectedView = [[UIImageView alloc] init];
                self.disconnectedView.contentMode = UIViewContentModeCenter;
                self.disconnectedView.image = [UIImage imageNamed:@"chat_icon_warning"];
                self.disconnectedView.hidden = YES;
                [self addSubview:self.disconnectedView];
        }
        return self;
}

- (void)layoutSubviews
{
        CGFloat imageOffset = ([UIScreen mainScreen].bounds.size.width - self.frame.size.width) / 4;
        imageOffset = MIN(imageOffset, 4.0);
        
        for (UIView *view in self.subviews) {
                if ([view isKindOfClass:[ZGButtonBadge class]]) {
                        ZGButtonBadge *button = (ZGButtonBadge *) view;
                        if (button.customTag == 0) {
                                button.frame = CGRectMake(button.tag * self.frame.size.height,
                                                          0,
                                                          self.frame.size.height,
                                                          self.frame.size.height);
                                button.imageEdgeInsets = UIEdgeInsetsMake(0, -imageOffset, 0, imageOffset);
                        } else if (button.customTag == 1) {
                                button.frame = CGRectMake(self.frame.size.width - (button.tag + 1) * self.frame.size.height,
                                                          0,
                                                          self.frame.size.height,
                                                          self.frame.size.height);
                                button.imageEdgeInsets = UIEdgeInsetsMake(0, imageOffset, 0, -imageOffset);
                        }
                }
        }
        CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(self.frame.size.width, 44)];
        CGFloat width = size.width;
        self.titleLabel.frame = CGRectMake((self.frame.size.width - width) / 2, 0, width, self.frame.size.height);
        self.connectingView.center = CGPointMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 5 + self.connectingView.frame.size.width / 2, self.frame.size.height / 2);
        self.disconnectedView.frame = CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width + 5, (self.frame.size.height - 20) / 2, 20, 20);
}

- (void)setLeftButtonsWithImageNames:(NSArray *)imageNames
{
        for (UIView *view in self.subviews) {
                if ([view isKindOfClass:[ZGButtonBadge class]]) {
                        ZGButtonBadge *button = (ZGButtonBadge *) view;
                        if (button.customTag == 0) {
                                [button removeFromSuperview];
                        }
                }
        }
        if (imageNames && imageNames.count > 0) {
                for (NSInteger i = 0; i < imageNames.count; i++) {
                        ZGButtonBadge *button = [[ZGButtonBadge alloc] init];
                        [button setImage:[UIImage imageNamed:[imageNames objectAtIndex:i]] forState:UIControlStateNormal];
                        button.customTag = 0;
                        button.tag = i;
                        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                        [self addSubview:button];
                }
        }
}

- (void)setRightButtonsWithImageNames:(NSArray *)imageNames
{
        for (UIView *view in self.subviews) {
                if ([view isKindOfClass:[ZGButtonBadge class]]) {
                        ZGButtonBadge *button = (ZGButtonBadge *) view;
                        if (button.customTag == 1) {
                                [button removeFromSuperview];
                        }
                }
        }
        if (imageNames && imageNames.count > 0) {
                for (NSInteger i = 0; i < imageNames.count; i++) {
                        ZGButtonBadge *button = [[ZGButtonBadge alloc] init];
                        [button setImage:[UIImage imageNamed:[imageNames objectAtIndex:i]] forState:UIControlStateNormal];
                        button.customTag = 1;
                        button.tag = i;
                        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                        [self addSubview:button];
                }
        }
}


- (void)setButtonEnabled:(BOOL)enabled onLeftIndex:(NSInteger)index
{
        for (UIView *view in self.subviews) {
                if ([view isKindOfClass:[ZGButtonBadge class]]) {
                        ZGButtonBadge *button = (ZGButtonBadge *) view;
                        if (button.customTag == 0 && button.tag == index) {
                                button.enabled = enabled;
                                break;
                        }
                }
        }
}

- (void)setButtonEnabled:(BOOL)enabled onRightIndex:(NSInteger)index
{
        for (UIView *view in self.subviews) {
                if ([view isKindOfClass:[ZGButtonBadge class]]) {
                        ZGButtonBadge *button = (ZGButtonBadge *) view;
                        if (button.customTag == 1 && button.tag == index) {
                                button.enabled = enabled;
                                break;
                        }
                }
        }
}

- (void)setConnectStatus:(ZGNavigationTitleViewStatus)connectStatus
{
        _connectStatus = connectStatus;
        if (connectStatus == ZGNavigationTitleViewConnected) {
                [self.connectingView stopAnimating];
                self.disconnectedView.hidden = YES;
        } else if (connectStatus == ZGNavigationTitleViewConnecting) {
                [self.connectingView startAnimating];
                self.disconnectedView.hidden = YES;
        } else if (connectStatus == ZGNavigationTitleViewDisconnected) {
                [self.connectingView stopAnimating];
                self.disconnectedView.hidden = NO;
        }
}

- (IBAction)buttonClicked:(ZGButtonBadge *)button
{
        if (button.customTag == 0) {
                if (self.delegate
                    && [self.delegate respondsToSelector:@selector(navigationTitleView:buttonClickedAtLeftIndex:)]) {
                        [self.delegate navigationTitleView:self buttonClickedAtLeftIndex:button.tag];
                }
        } else if (button.customTag == 1) {
                if (self.delegate
                    && [self.delegate respondsToSelector:@selector(navigationTitleView:buttonClickedAtRightIndex:)]) {
                        [self.delegate navigationTitleView:self buttonClickedAtRightIndex:button.tag];
                }
        }
}



@end
