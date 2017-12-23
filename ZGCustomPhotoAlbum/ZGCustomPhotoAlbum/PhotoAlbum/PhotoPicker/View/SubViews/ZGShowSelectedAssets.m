//
//  ZGShowSelectedAssets.m
//  ZGCustomPhotoAlbum
//
//  Created by saina_barsud on 2017/11/24.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGShowSelectedAssets.h"
#import "ZGPhotoAlbumHeader.h"
#import "ZGShowSelectedAssetCell.h"
@interface ZGShowSelectedAssets() <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>{
        ZGShowSelectedAssetCell *_selecteCell;
        UIView *_foolView ;
}
@property(nonatomic, strong) NSMutableArray *assets;
@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ZGShowSelectedAssets



- (instancetype)initWithFrame:(CGRect)frame selectedAssets:(NSMutableArray *)assets showType:(ZGSelectedAssetsShowType)showType
{
        self = [super initWithFrame:frame];
        if (self) {
                self.assets = [NSMutableArray arrayWithArray:assets];
                self.showType = showType;
//                self.backgroundColor = COLOR_FOR_ASSET_POCKER_BACKGROUND;
               
                
                UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                layout.itemSize = CGSizeMake(HEIGHT_PHOTO_EIDT_BAR_TOOL * 1.5 - 10.f, HEIGHT_PHOTO_EIDT_BAR_TOOL * 1.5 - 10.f);
                layout.sectionInset = UIEdgeInsetsMake(5.f, 5.f, 5.f, 5.f);
                self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
                self.collectionView.backgroundColor = COLOR_FOR_NAV_BAR_TRANLUCENT;
                self.collectionView.dataSource = self;
                self.collectionView.delegate = self;
                self.collectionView.bounces = YES;
                self.collectionView.alwaysBounceHorizontal = YES;

                [self addSubview:self.collectionView];
                UILongPressGestureRecognizer *longPerss = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPerssAction:)];
                [self.collectionView addGestureRecognizer:longPerss];

                //注册
                [self.collectionView registerClass:[ZGShowSelectedAssetCell class] forCellWithReuseIdentifier:@"showSelectedAssetCell"];
                
                _foolView = [[UIView alloc]init];
                _foolView.backgroundColor = COLOR_FOR_BORDER;
                [self addSubview:_foolView];
        }
        return self;
}

-(void)layoutSubviews{
        self.collectionView.frame = self.bounds;
        _foolView.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
        
        UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.layer.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(PHOTO_EIDT_BAR_CORNER_RADIUS, PHOTO_EIDT_BAR_CORNER_RADIUS)];
        CAShapeLayer * maskLayer = [CAShapeLayer new];
        maskLayer.frame = self.layer.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
}

- (void)longPerssAction:(UILongPressGestureRecognizer *)longPress{
        switch (longPress.state) {
                case UIGestureRecognizerStateBegan:
                { //手势开始
                        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];//判断手势落点位置是否在row上
                        if (indexPath == nil) break;
                        ZGShowSelectedAssetCell *cell = (ZGShowSelectedAssetCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                        [self bringSubviewToFront:cell];
                        [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];//iOS9方法 移动cell
                }
                        break;
                case UIGestureRecognizerStateChanged:
                { // 手势改变
                        [self.collectionView updateInteractiveMovementTargetPosition:[longPress locationInView:self.collectionView]];// iOS9方法 移动过程中随时更新cell位置
                }
                        break;
                case UIGestureRecognizerStateEnded:
                { // 手势结束
                        [self.collectionView endInteractiveMovement];// iOS9方法 移动结束后关闭cell移动
                        
                }
                        break;
                default: //手势其他状态
                        [self.collectionView cancelInteractiveMovement];
                        break;
        }
}

#pragma mark - UICollectionViewDataSource
/// 返回对应section的item 的数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return self.assets.count;
}
/// 创建和复用cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        ZGShowSelectedAssetCell *cell = (ZGShowSelectedAssetCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"showSelectedAssetCell" forIndexPath:indexPath];
        PHAsset *asset = self.assets[indexPath.row];
        CGFloat imageWidth = self.frame.size.height;
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = NO;
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        options.version = PHImageRequestOptionsVersionCurrent;
        options.networkAccessAllowed = YES;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(imageWidth, imageWidth) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                cell.imageView.image = result;// 从asset中获得图片
        }];
        cell.assetDuration = (NSUInteger)round(asset.duration);
        return cell;
}
#pragma mark - UICollectionViewDelegate
/// Cell被点击调用该方法
- (void)collectionView: (UICollectionView *)collectionView didSelectItemAtIndexPath: (NSIndexPath *)indexPath{
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGShowSelectedAssetsDelegate)]){
                [self.delegate showSelectedAssetsView:self clickCellAtIndextPath:self.assets[indexPath.row]];
        }
        self.currentIndex = indexPath.row;
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
        return YES;// 返回YES允许row移动
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
        PHAsset *asset = self.assets[sourceIndexPath.row];  //取出移动row数据
        [self.assets removeObject:asset]; //从数据源中移除该数据
        [self.assets insertObject:asset atIndex:destinationIndexPath.row];   //将数据插入到数据源中的目标位置
        if (self.delegate && [self.delegate conformsToProtocol:@protocol(ZGShowSelectedAssetsDelegate)]){ //调用代理
                [self.delegate showSelectedAssetsView:self moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
        }
        
}

#pragma mark - 当前下标
-(void)setCurrentIndex:(NSInteger)currentIndex{
        _currentIndex = currentIndex;
        for (NSInteger i = 0; i < self.assets.count; i++) {
                ZGShowSelectedAssetCell *cell = (ZGShowSelectedAssetCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.selected = NO;
                cell.backgroundColor = [UIColor clearColor];
        }
        if (currentIndex != -1) {
                ZGShowSelectedAssetCell *cell = (ZGShowSelectedAssetCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
                cell.selected = YES;
                cell.backgroundColor = [UIColor whiteColor];
//                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }

        
}

#pragma mark - 取消的下标
-(void)setCancelIndex:(NSInteger)cancelIndex{
        _cancelIndex = cancelIndex;
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:cancelIndex inSection:0]]];
        ZGShowSelectedAssetCell *cell = (ZGShowSelectedAssetCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:cancelIndex inSection:0]];
        cell.imageView.alpha = 0.2f;
        
}
#pragma mark - 取消时操作
-(void)setCancelAsset:(PHAsset *)cancelAsset{
        _cancelAsset = cancelAsset;
        if (self.showType == ZGSelectedAssetsShowTypeCellAction) { //直接添加到数组中, 刷新UI
                [self.assets removeObject:cancelAsset];

                dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionView reloadData];
                });
                
        }else if (self.showType == ZGSelectedAssetsShowTypePreviewAction){ //操作对应位置的cell
                ZGShowSelectedAssetCell *cell = (ZGShowSelectedAssetCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[self.assets indexOfObject:cancelAsset] inSection:0]];
                cell.imageView.alpha = 0.2f;
        }
}
#pragma mark - 选择时操作
-(void)setSelectedAsset:(PHAsset *)selectedAsset{
        _selectedAsset = selectedAsset;
        if (self.showType == ZGSelectedAssetsShowTypeCellAction) { //如果是点击cell： 直接把selectedAsset添加到assets数组中；
                [self.assets addObject:_selectedAsset];
                dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionView reloadData];
                });
                
        }else if (self.showType == ZGSelectedAssetsShowTypePreviewAction){ // 若是预览按钮： 把对应的cell.alpha = 1.0f;
                ZGShowSelectedAssetCell *cell = (ZGShowSelectedAssetCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[self.assets indexOfObject:selectedAsset] inSection:0]];
                cell.imageView.alpha = 1.0f;
        }
}

@end
