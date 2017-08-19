//
//  ZGVCPickerView.m
//  VideoClip
//
//  Created by saina_su on 2017/8/14.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGVCPickerView.h"

@implementation ZGVCPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.leftButton setImage:[UIImage imageNamed:@"icon_navbar_back"] forState:UIControlStateNormal];
                [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self addSubview:self.leftButton];
                self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.rightButton setImage:[UIImage imageNamed:@"icon_navbar_ok"] forState:UIControlStateNormal];
                [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self addSubview:self.rightButton];
                
                
        }
        return self;
}

-(void)layoutSubviews{
        self.leftButton.frame = CGRectMake(20, 0, self.frame.size.height, self.frame.size.height);
        self.rightButton.frame = CGRectMake(self.frame.size.width - self.frame.size.height - 20, 0, self.frame.size.height, self.frame.size.height);
}
@end
