//
//  ZGFolderTableViewCell.h
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/7.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZGFolderTableViewCell : UITableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property(nonatomic, strong) UIImageView *userView;/**<#注释#>*/
@property(nonatomic, strong)UILabel *userLabel;/**<#注释#>*/


@end
