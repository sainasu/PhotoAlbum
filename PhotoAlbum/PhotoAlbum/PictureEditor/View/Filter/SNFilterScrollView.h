//
//  SNFilterScrollView.h
//  SN_ImageEditor
//
//  Created by saina_su on 2017/7/6.
//  Copyright © 2017年 saina. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * 实现滚动视图, 显示不同效果
 其代理方法中, 按照点击的Cell, 实现不同滴滤镜效果 返回效果视图给mosaicView
 */
@class SNFilterScrollView;
@protocol SNFilterToolVIewDelegate <UIScrollViewDelegate>

@required
- (NSInteger)numberOfPageInPageScrollView:(SNFilterScrollView* )pageScrollView;
@optional
- (CGSize)sizeCellForPageScrollView:(SNFilterScrollView*)pageScrollView;
- (void)pageScrollView:(SNFilterScrollView *)pageScrollView didTapPageAtIndex:(NSInteger)index;
@end

@protocol SNFilterToolVIewDataSource <UIScrollViewDelegate>
@required
- (UIView*)pageScrollView:(SNFilterScrollView *)pageScrollView viewForRowAtIndex:(int)index;
@end

@interface SNFilterScrollView : UIScrollView
@property (nonatomic, assign) CGSize  cellSize;

@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, strong) UIImageView* backgroundView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray* visibleCell;
@property (nonatomic, strong) NSMutableSet* cacheCells;
@property (nonatomic, weak) NSMutableDictionary* visibleCellsMap;
@property (nonatomic, assign) CGFloat pageViewWith;

@property (nonatomic, weak) id<SNFilterToolVIewDataSource> dataSource;
@property (nonatomic, weak) id<SNFilterToolVIewDelegate> delegate;

- (void)reloadData;
- (UIView*)viewForRowAtIndex:(NSInteger)index;
@end
