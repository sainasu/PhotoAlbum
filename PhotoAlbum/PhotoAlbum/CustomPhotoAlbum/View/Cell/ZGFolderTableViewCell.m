//
//  ZGFolderTableViewCell.m
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/7.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGFolderTableViewCell.h"
#import "ZGCIPHeader.h"
@implementation ZGFolderTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
 {
          // NSLog(@"cellForRowAtIndexPath");
             static NSString *identifier = @"cell";
             // 1.缓存中取
             ZGFolderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
             // 2.创建
             if (cell == nil) {
                        cell = [[ZGFolderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                    }
             return cell;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        if (self) {
                self.contentView.backgroundColor = [UIColor whiteColor];
                self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                self.layer.borderColor = [UIColor colorWithRed:100 / 255.0 green:100 / 255.0 blue:100 / 255.0 alpha:0.8].CGColor;
                self.layer.borderWidth = 0.3;
                [self makeView];

        }
        return self;
}
-(void)layoutSubviews{
        self.userLabel.frame = CGRectMake(ZGCIP_CUSTOM_IMAGE_PICKER_CELL_HEIGHT, ZGCIP_CUSTOM_IMAGE_PICKER_CELL_HEIGHT / 2 - 20, ZGCIP_MAINSCREEN_WIDTH / 3, 40);
        self.userView.frame = CGRectMake(0, 0, ZGCIP_CUSTOM_IMAGE_PICKER_CELL_HEIGHT, ZGCIP_CUSTOM_IMAGE_PICKER_CELL_HEIGHT);

}
//自建View
- (void)makeView{
        
        //
        self.userView = [[UIImageView alloc] init];
        self.userView.contentMode = UIViewContentModeScaleToFill;
        self.userView.backgroundColor = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:0.8];
        [self.contentView addSubview:self.userView];
        
        self.userLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.userLabel];
        
}

@end
