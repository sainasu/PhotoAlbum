//
//  ZGPhotoAlbumPickerBar.m
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/4.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPhotoAlbumPickerBar.h"
#import "ZGPAHeader.h"


@interface ZGPhotoAlbumPickerBar ()
@property(nonatomic, strong) UIView *backgroundView1;/**<#注释#>*/
@property(nonatomic, strong) UIView *backgroundView2;/**<#注释#>*/

@property(nonatomic, strong) UILabel *hintLabel;/**<#注释#>*/

@end

@implementation ZGPhotoAlbumPickerBar

- (instancetype)initWithFrame:(CGRect)frame  tabBarType:(ZGPhotoAlbumBarType)type
{
        self = [super initWithFrame:frame];
        if (self) {
                self.backgroundColor = [UIColor blackColor];
                //聊天小图:览预按钮   原图按钮   发送按钮icon_navbar_send@3x
                _leftButton = [[UIButton alloc] init];
                _hintLabel = [[UILabel alloc] init];
                _originalImageButton = [[UIButton alloc] init];
                _hintLabel.backgroundColor = [UIColor clearColor];
                [self.leftButton setImage:[UIImage imageNamed:@"icon_navbar_review"] forState:UIControlStateNormal];
                [self addSubview:self.leftButton];
                _rightButton = [[UIButton alloc] init];
                [self.rightButton setImage:[UIImage imageNamed:@"icon_navbar_send"] forState:UIControlStateNormal];
                [self addSubview:self.rightButton];
                self.barType = type;
                if (type == ZGPhotoAlbumBarTypeChatThumbnails) {
                        //聊天小图:览预按钮   原图按钮   发送按钮
                        [self.leftButton setImage:[UIImage imageNamed:@"icon_navbar_review"] forState:UIControlStateNormal];
                        [self.rightButton setImage:[UIImage imageNamed:@"icon_navbar_send"] forState:UIControlStateNormal];
                        [self.originalImageButton setImage:[UIImage imageNamed:@"icon_navbar_album"] forState:UIControlStateNormal];
                        [self addSubview:self.originalImageButton];
                }else if (type == ZGPhotoAlbumBarTypeChatMeitiuzipaiImage){
                        //聊天大图:编辑按钮    原图按钮   发送按钮
                        [self.leftButton setImage:[UIImage imageNamed:@"icon_navbar_edit"] forState:UIControlStateNormal];
                        [self.rightButton setImage:[UIImage imageNamed:@"icon_navbar_send"] forState:UIControlStateNormal];
                        [self.originalImageButton setImage:[UIImage imageNamed:@"icon_navbar_album"] forState:UIControlStateNormal];
                        [self addSubview:self.originalImageButton];
                }else if (type == ZGPhotoAlbumBarTypeChatMeitiuzipaiPreviewVideo){
                        self.leftButton.hidden = YES;
                        //好友发送视频  发送按钮
                        [_rightButton setImage:[UIImage imageNamed:@"icon_navbar_send"] forState:UIControlStateNormal];
                        
                }else if (type == ZGPhotoAlbumBarTypeCircleOfFriendsThumbnails){
                        //朋友圈小图:预览按钮    完成按钮
                        [self.leftButton setImage:[UIImage imageNamed:@"icon_navbar_review"] forState:UIControlStateNormal];
                        [self.rightButton setImage:[UIImage imageNamed:@"icon_navbar_ok"] forState:UIControlStateNormal];
                }else if (type == ZGPhotoAlbumBarTypeCircleOfFriendsImage){
                        //朋友圈(收藏)大图:编辑按钮   完成按钮
                        [self.leftButton setImage:[UIImage imageNamed:@"icon_navbar_edit"] forState:UIControlStateNormal];
                        [self.rightButton setImage:[UIImage imageNamed:@"icon_navbar_ok"] forState:UIControlStateNormal];
                        
                }else if (type == ZGPhotoAlbumBarTypeCircleOfFriendsVideo){
                       
                        self.leftButton.hidden = YES;
                        //朋友圈大图:文本提示   编辑按钮
                        [self.rightButton setImage:[UIImage imageNamed:@"icon_navbar_edit"] forState:UIControlStateNormal];
                       
                }else if(type == ZGPhotoAlbumBarTypeCollectingMeitiuzipaiVideo){
                        self.leftButton.hidden = YES;
                       //收藏:     完成按钮
                        [self.rightButton setImage:[UIImage imageNamed:@"icon_navbar_ok"] forState:UIControlStateNormal];
                }else if (ZGPhotoAlbumBarTypeCircleOfFriendsMinVideo){
                
                        [self.leftButton setImage:[UIImage imageNamed:@"icon_navbar_ok"] forState:UIControlStateNormal];
                        [self.rightButton setImage:[UIImage imageNamed:@"icon_navbar_edit"] forState:UIControlStateNormal];

                        
                }
                
                self.backgroundView1 = [[UIView alloc] init];
                self.backgroundView1.backgroundColor = kPAColor(0, 0, 0, 0.7);
                [self addSubview:self.backgroundView1];
                self.backgroundView2 = [[UIView alloc] init];
                self.backgroundView2.backgroundColor = kPAColor(0, 0, 0, 0.7);
                [self addSubview:self.backgroundView2];

                
        }
        return self;
}


-(void)layoutSubviews
{
        self.leftButton.frame = CGRectMake(0, 0, kPAMainToolsHeight, kPAMainToolsHeight);
        self.rightButton.frame = CGRectMake(self.frame.size.width - kPAMainToolsHeight, 0, kPAMainToolsHeight, kPAMainToolsHeight);
        self.backgroundView1.frame = CGRectMake( 0, 0, kPAMainToolsHeight, kPAMainToolsHeight);
        self.backgroundView2.frame = CGRectMake(self.frame.size.width - kPAMainToolsHeight, 0, kPAMainToolsHeight, kPAMainToolsHeight);

        self.originalImageButton.frame = CGRectMake(kPAMainScreenWidth / 2 - kPAMainToolsHeight / 2, 0, kPAMainToolsHeight, kPAMainToolsHeight);
        self.hintLabel.frame = CGRectMake(0, 0, self.frame.size.width - kPAMainToolsHeight, kPAMainToolsHeight);
}
-(void)setIsHiden:(BOOL)isHiden{
        if (isHiden == YES) {
                [self.backgroundView1 removeFromSuperview];
                [self.backgroundView2 removeFromSuperview];
        }
}

//这当View动画
-(void)isHiden:(BOOL)hiden;
{
        if (hiden == NO) {
                [UIView animateWithDuration:0.02 animations:^{
                        self.backgroundView1.frame = CGRectMake( 0, - 100, kPAMainToolsHeight, kPAMainToolsHeight);
                        self.backgroundView2.frame = CGRectMake(self.frame.size.width - kPAMainToolsHeight, -100, kPAMainToolsHeight, kPAMainToolsHeight);
                }];

        }else{
                [UIView animateWithDuration:0.02 animations:^{
                        self.backgroundView1.frame = CGRectMake( 0, 0, kPAMainToolsHeight, kPAMainToolsHeight);
                        self.backgroundView2.frame = CGRectMake(self.frame.size.width - kPAMainToolsHeight, 0, kPAMainToolsHeight, kPAMainToolsHeight);
                }];
   
        }
}


@end
