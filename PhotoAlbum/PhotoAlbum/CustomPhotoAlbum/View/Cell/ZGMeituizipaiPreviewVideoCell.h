//
//  ZGMeituizipaiPreviewVideoCell.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/7.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol  ZGPAVideoCollectionCellDelegate <NSObject>

-(void)hiddenViewsAciton:(NSString *)sender;

@end
@interface ZGMeituizipaiPreviewVideoCell : UICollectionViewCell

@property(nonatomic, strong) UIImageView *videoView;/**<#注释#>*/
@property (nonatomic, assign) id<ZGPAVideoCollectionCellDelegate>cellDelegate;//代理属性
@property(nonatomic, strong)AVPlayer *player;/**<#注释#>*/
@property(nonatomic, strong) NSString *url;/**<#注释#>*/
@property(nonatomic, strong) UIButton *playButton;/**<#注释#>*/

-(void)initVideoView:(NSString *)url;

@end
