//
//  ZGButtonBadge.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/11/23.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGButtonBadge.h"
@interface ZGButtonBadge()
@property (nonatomic, strong) UIView *numView;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIView *dotView;
@end
@implementation ZGButtonBadge
- (id)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                self.numView = [[UIView alloc] init];
                self.numView.layer.cornerRadius = 9;
                self.numView.backgroundColor = [UIColor redColor];
                [self addSubview:self.numView];
                
                self.numLabel = [[UILabel alloc] init];
                self.numLabel.textColor = [UIColor whiteColor];
                self.numLabel.textAlignment = NSTextAlignmentCenter;
                self.numLabel.font = [UIFont boldSystemFontOfSize:12.0];
                [self.numView addSubview:self.numLabel];
                
                self.dotView = [[UIView alloc] init];
                self.dotView.layer.cornerRadius = 5;
                self.dotView.backgroundColor = [UIColor redColor];
                [self addSubview:self.dotView];
                
                self.numView.hidden = YES;
                self.dotView.hidden = YES;
        }
        return self;
}

- (void)layoutSubviews
{
        [super layoutSubviews];
        self.numView.frame = CGRectMake(3, 3, 18, 18);
        self.numLabel.frame = CGRectMake(0, 0, 18, 18);
        self.dotView.frame = CGRectMake(8, 8, 10, 10);
}

//- (void)setBadge:(ZGNotificationValue)value
//{
//        if (value.count > 0) {
//                self.numLabel.text = [NSString stringWithFormat:@"%zi", value.count];
//                self.dotView.hidden = YES;
//                self.numView.hidden = NO;
//        } else if (value.extra) {
//                self.dotView.hidden = NO;
//                self.numView.hidden = YES;
//        } else {
//                self.dotView.hidden = YES;
//                self.numView.hidden = YES;
//        }
//}
@end
