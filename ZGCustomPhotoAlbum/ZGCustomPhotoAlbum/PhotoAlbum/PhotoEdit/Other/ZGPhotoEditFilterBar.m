//
//  ZGPhotoEditFilterBar.m
//  ZGPhotoEdit
//
//  Created by saina_barsud on 2017/12/19.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPhotoEditFilterBar.h"
#import "ZGPhotoEditFilterCell.h"
#import "ZGPhotoEditHeader.h"
#import "ZGPhotoEditModel.h"
@interface ZGPhotoEditFilterBar()< UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSArray *filderArray;
@property(nonatomic, strong) UIImage *image;


@end
@implementation ZGPhotoEditFilterBar

- (instancetype)initWithImage:(UIImage *)image
{
        self = [super init];
        if (self) {
                self.backgroundColor = [UIColor clearColor];
                self.image = [[UIImage alloc] init];
                self.image = image;
                // 图片数组_filterImageArr
                
                self.filderArray = [NSArray arrayWithObjects:
                                    @"OriginImage",
                                    @"CIPhotoEffectProcess",
                                    @"CIPhotoEffectChrome",
                                    @"CIPhotoEffectTransfer",
                                    @"CIPhotoEffectFade",
                                    @"CIPhotoEffectInstant",
                                    @"CIPhotoEffectTonal",
                                    @"CIPhotoEffectMono",
                                    @"CIPhotoEffectNoir",
                                    @"CISepiaTone",
                                    @"CILinearToSRGBToneCurve",
                                    @"CIColorInvert",
                                    nil];
                [self initCollectionView];
        }
        return self;
}
-(void)initCollectionView{
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake( self.frame.size.height, self.frame.size.height);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView .backgroundColor = [UIColor clearColor];
        self.collectionView .dataSource = self;
        self.collectionView .delegate = self;
        self.collectionView .bounces = YES;
        self.collectionView .showsHorizontalScrollIndicator = NO;
        [self addSubview:self.collectionView];
        
        [self.collectionView registerClass:[ZGPhotoEditFilterCell class] forCellWithReuseIdentifier:@"ZGPhotoEditFilterCell"];
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0  inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        
        
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return self.filderArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        
        ZGPhotoEditFilterCell *cell = (ZGPhotoEditFilterCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ZGPhotoEditFilterCell" forIndexPath:indexPath];
        if (cell.isSelected) {
                cell.backgroundColor = [UIColor whiteColor];
        }else{
                cell.backgroundColor = [UIColor clearColor];
        }
        cell.imageView.image = [ZGPhotoEditModel fliterEvent:self.filderArray[indexPath.row] image:self.image];
        return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        ZGPhotoEditFilterCell *cell = (ZGPhotoEditFilterCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        if (self.filterDelegate && [self.filterDelegate conformsToProtocol:@protocol(ZGPhotoEditFilterBarDelegate)]) {
                [self.filterDelegate photoEditFilterName:self.filderArray[indexPath.row]];
        }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
        ZGPhotoEditFilterCell *cell =  (ZGPhotoEditFilterCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
}
- (CGSize)collectionView: (UICollectionView *)collectionView layout: (UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath *)indexPath{
        return CGSizeMake(self.frame.size.height, self.frame.size.height);
}

-(void)layoutSubviews{
        self.collectionView.frame = self.bounds;
}


@end

