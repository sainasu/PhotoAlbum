//
//  ZGPhotoAlbumPickerBar.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/4.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ZGPhotoAlbumBarType) {
        ZGPhotoAlbumBarTypeChatThumbnails = 0,//聊天小图:览预按钮   原图按钮   发送按钮
        ZGPhotoAlbumBarTypeChatMeitiuzipaiImage = 1,//聊天大图:编辑按钮    原图按钮   发送按钮
        ZGPhotoAlbumBarTypeChatMeitiuzipaiPreviewVideo = 2,  //好友发送视频  发送按钮
        ZGPhotoAlbumBarTypeCircleOfFriendsThumbnails = 3,//朋友圈小图:预览按钮    完成按钮
        ZGPhotoAlbumBarTypeCircleOfFriendsImage =4,//朋友圈(收藏)大图:编辑按钮   完成按钮
        ZGPhotoAlbumBarTypeCircleOfFriendsVideo =5,//朋友圈大图:文本提示   编辑按钮
        ZGPhotoAlbumBarTypeCollectingMeitiuzipaiVideo = 6,//收藏:     完成按钮
        ZGPhotoAlbumBarTypeCircleOfFriendsMinVideo =7,//朋友圈大图:文本提示   编辑按钮

};


@interface ZGPhotoAlbumPickerBar : UIView

@property (nonatomic, assign) ZGPhotoAlbumBarType barType;

- (instancetype)initWithFrame:(CGRect)frame tabBarType:(ZGPhotoAlbumBarType)type;

@property(nonatomic, strong) UIButton *leftButton;/**预览按钮*/
@property(nonatomic, strong) UIButton *rightButton;/**发送按钮*/
@property(nonatomic, strong) UIButton *originalImageButton;/**<#注释#>*/
@property(nonatomic, assign) CGFloat  timer;/**<#注释#>*/
@property(nonatomic, assign) CGFloat  maxTimer;/**<#注释#>*/
-(void)isHiden:(BOOL)hiden;


@property(nonatomic, assign) BOOL  isHiden;/**<#注释#>*/



@end
