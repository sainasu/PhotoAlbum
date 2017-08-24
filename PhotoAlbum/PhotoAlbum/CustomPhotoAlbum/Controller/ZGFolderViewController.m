//
//  ZGFolderViewController.m
//  PhotoAlbum
//
//  Created by saina_su on 2017/8/4.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGFolderViewController.h"
#import "ZGPAViewModel.h"
#import "ZGFolderTableViewCell.h"

@interface ZGFolderViewController ()<UITableViewDelegate, UITableViewDataSource>{
        NSMutableArray *assetArray ;
}
@property(nonatomic, strong) NSMutableArray *folderData;/**数据源*/
@property(nonatomic, strong) UITableView *tableView;/**<#注释#>*/

@end

@implementation ZGFolderViewController

- (NSMutableArray *)folderData
{
        if (!_folderData) {
                _folderData = [[NSMutableArray alloc]init];
        }
        return _folderData;
}

-(void)viewWillAppear:(BOOL)animated{
        [super viewWillAppear:animated];
              
}

- (void)viewDidLoad {
        [super viewDidLoad];
        self.automaticallyAdjustsScrollViewInsets = false;

        [self initNavigationViewController];
        self.folderData = [ZGPAViewModel createAccessToCollections];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,kPANavigationHeight + 20, kPAMainScreenWidth, kPAMainScreenHeight - kPANavigationHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];

        [self pushParameter:self.folderData[0][0]  animated: NO];
}

- (void)viewWillLayoutSubviews
{
        _tableView.frame = CGRectMake(0,kPANavigationHeight + 20, kPAMainScreenWidth, kPAMainScreenHeight -20 -kPANavigationHeight);
}

-(void)initNavigationViewController{
        //设置导航标题
       // self.navigationItem.title = @"相册组";
        //设置标题颜色
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        //设置状态栏
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        //设置导航栏颜色
        self.navigationController.navigationBar.barTintColor = kPANavigationViewColor;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        //返回按钮
        UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [btnBack setBackgroundImage:[UIImage imageNamed:@"icon_navbar_close"] forState:UIControlStateNormal];
        
        [btnBack addTarget:self action:@selector(navigationRightButtonAction) forControlEvents:UIControlEventTouchDown];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
        self.navigationItem.rightBarButtonItem = item;

        
}
-(void)navigationRightButtonAction{
        [self dismissViewControllerAnimated: YES completion: nil ];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.folderData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
        static NSString *cellIndetifier = @"cell";
        ZGFolderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
        if (cell == nil) {
                cell = [[ZGFolderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndetifier];
        }
        //cell选中效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
        // 是否要原图
        CGSize size = CGSizeMake(kPAFolderCellHeight, kPAFolderCellHeight);
        // 从asset中获得图片
        UIImage *image = [[UIImage alloc] init];
        assetArray = [NSMutableArray array];
        NSString *title = nil;
        title = self.folderData[indexPath.row][0];
        assetArray = self.folderData[indexPath.row][1];
        
        //判断数组中是否有值
        if (assetArray.count == 0) {
                image = [UIImage imageNamed:@"icon_navbar_album"];
        }else{
                PHAsset *asset = assetArray[indexPath.section];
                if (asset.mediaType == PHAssetMediaTypeVideo) {
                        //如果是视频
                        image = [ZGPAViewModel createAccessToImage:asset imageSize:size contentMode:PHImageContentModeAspectFill];
                }else if (asset.mediaType == PHAssetMediaTypeImage) {
                        //如果是图片
                        image = [ZGPAViewModel createAccessToImage:asset imageSize:size contentMode:PHImageContentModeAspectFill];
                }
        }
        cell.userView.image = image;
        cell.userLabel.text = [NSString stringWithFormat:@"%@(%lu)",title,(unsigned long)assetArray.count];
        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

        if ([self.folderData[indexPath.row][1] count] != 0) {
                [self pushParameter:self.folderData[indexPath.row][0] animated:YES];
        }
}

-(void)pushParameter:(NSString *)title animated:(BOOL)animated{
        //把带有数据的asssetArr传到下一个界面
        ZGThumbnailsPreviewController *tpVC = [ZGThumbnailsPreviewController new];
        tpVC.folderTitel = title;
        tpVC.selectedNumber = self.selectedNumber;
        tpVC.isPicturesAndVideoCombination = self.isPicturesAndVideoCombination;
        tpVC.optionalMaximumNumber = self.optionalMaximumNumber;
        tpVC.selectedNumber = self.selectedNumber;
        tpVC.whetherToEditPictures = self.whetherToEditPictures;
        tpVC.whetherToEditVideo = self.whetherToEditVideo;
        tpVC.whetherTheScreenshots = self.whetherTheScreenshots;
        tpVC.screenshotsSize = self.screenshotsSize;
        tpVC.maximumTimeVideo = self.maximumTimeVideo;

        [self.navigationController pushViewController:tpVC animated:animated];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return kPAFolderCellHeight;
}


@end
