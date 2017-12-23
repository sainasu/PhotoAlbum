//
//  ZGPhotoEditColorBar.m
//  ZGPhotoEdit
//
//  Created by saina_barsud on 2017/12/19.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "ZGPhotoEditColorBar.h"
#import "ZGPhotoEditColorCell.h"
#import "ZGPhotoEditHeader.h"
@interface ZGPhotoEditColorBar()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *colorView;
@property(nonatomic, strong) NSArray *colorsArray;

@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) UIImageView *arrowImageView;



@end

@implementation ZGPhotoEditColorBar

- (instancetype)init
{
        self = [super init];
        if (self) {
                self.backgroundColor = [UIColor clearColor];
                self.arrowImageView = [[UIImageView alloc] init];
                self.arrowImageView.image = [UIImage imageNamed:@"PhotoEdit_Tool_More"];
                self.arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
                [self addSubview:self.arrowImageView];
                
                
                //创建每个色块
                self.colorsArray = [NSArray arrayWithObjects:
                                    COLOR_PHOTO_EIDT(0xffffff),
                                    COLOR_PHOTO_EIDT(0xc0c0c0),
                                    COLOR_PHOTO_EIDT(0x5e5e5e),
                                    COLOR_PHOTO_EIDT(0x000000),
                                    COLOR_PHOTO_EIDT(0xff6119),
                                    COLOR_PHOTO_EIDT(0xffa21d),
                                    COLOR_PHOTO_EIDT(0x8eff00),
                                    COLOR_PHOTO_EIDT(0x28fa77),
                                    COLOR_PHOTO_EIDT(0x54e7df),
                                    COLOR_PHOTO_EIDT(0x47c3fd),
                                    COLOR_PHOTO_EIDT(0x485eff),
                                    COLOR_PHOTO_EIDT(0xc33cff),
                                    COLOR_PHOTO_EIDT(0xff3880),
                                    COLOR_PHOTO_EIDT(0xff150c) , nil];
                
                [self initColorView];
                
                
        }
        return self;
}

-(void)initColorView{
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // layout.itemSize = CGSizeMake( self.frame.size.height, self.frame.size.height);
        self.colorView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.colorView .backgroundColor = [UIColor clearColor];
        self.colorView .dataSource = self;
        self.colorView .delegate = self;
        self.colorView .bounces = YES;
        self.colorView .showsHorizontalScrollIndicator = NO;
        [self addSubview:self.colorView];
        
        [self.colorView registerClass:[ZGPhotoEditColorCell class] forCellWithReuseIdentifier:@"ColorCell"];
        [self.colorView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0  inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return self.colorsArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        ZGPhotoEditColorCell *cell = (ZGPhotoEditColorCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ColorCell" forIndexPath:indexPath];
        if (cell.isSelected) {
                cell.backgroundColor = [UIColor whiteColor];
        }else{
                cell.backgroundColor = [UIColor clearColor];
        }
        cell.layer.cornerRadius = cell.frame.size.height / 2;
        cell.layer.masksToBounds = YES;
        cell.colorView.backgroundColor =  self.colorsArray[indexPath.row];
        return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        ZGPhotoEditColorCell *cell = (ZGPhotoEditColorCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [self shakeToShow:cell];
        cell.backgroundColor = [UIColor whiteColor];
        if (self.colorDelegate && [self.colorDelegate conformsToProtocol:@protocol(ZGPhotoEditColorBarDelegate)]) {
                [self.colorDelegate photoEditColorViewSelectedColor:cell.colorView.backgroundColor isDraw:self.isBack];
        }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
        ZGPhotoEditColorCell *cell =  (ZGPhotoEditColorCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
}


- (void) shakeToShow:(UIView*)aView{
        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.duration = 0.15;// 动画时间
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.2)]];
        // 这三个数字，我只研究了前两个，所以最后一个数字我还是按照它原来写1.0；前两个是控制view的大小的；
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.2)]];
        animation.values = values;
        [aView.layer addAnimation:animation forKey:nil];
        
}
- (CGSize)collectionView: (UICollectionView *)collectionView layout: (UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath: (NSIndexPath *)indexPath{
        return CGSizeMake(self.frame.size.height / 1.8, self.frame.size.height / 1.8);
}

- (void)cellSelected:(UIColor *)color{
        for (NSInteger i = 0; i < self.colorsArray.count; i++) {
                ZGPhotoEditColorCell *cell = (ZGPhotoEditColorCell *)[self.colorView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                UIColor *cellColor = self.colorsArray[i];
                if (color == cellColor) {
                        [self shakeToShow:cell];
                        cell.backgroundColor = [UIColor whiteColor];
                }else{
                        cell.backgroundColor = [UIColor clearColor];
                }
        }
}

-(void)layoutSubviews{
        self.colorView.frame = CGRectMake(10, 0, self.frame.size.width - 40, self.frame.size.height);
        self.arrowImageView.frame = CGRectMake(self.colorView.frame.size.width + 15, (self.frame.size.height - 15) * 0.5, 15, 15);
        
}


@end
