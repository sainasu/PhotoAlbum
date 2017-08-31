//
//  ZGMeituizipaiPreviewImageCell.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/7.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZGMeituizipaiPreviewImageCell : UICollectionViewCell<UIGestureRecognizerDelegate>
@property(nonatomic, strong) UIImageView *showImgView;/**<#注释#>*/

-(void)restore;

@end
