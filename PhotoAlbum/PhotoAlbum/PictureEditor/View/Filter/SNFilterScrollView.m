//
//  SNFilterScrollView.m
//  SN_ImageEditor
//
//  Created by saina_su on 2017/7/6.
//  Copyright © 2017年 saina. All rights reserved.
//

#import "SNFilterScrollView.h"

@interface SNFilterScrollView()

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) NSMutableArray * viewsInPage;
@property (nonatomic, assign) NSInteger numberOfCell;

@end

@implementation SNFilterScrollView

- (id)initWithFrame:(CGRect)frame
{
        self = [super initWithFrame:frame];
        if (self) {
                // Initialization code
                [self initializeValue];
                [self reloadData];
        }
        return self;
}

- (void)initializeValue
{
        self.clipsToBounds = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.autoresizesSubviews = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.multipleTouchEnabled = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        [self addGestureRecognizer:self.tapGesture];
}

- (void)reloadData
{
        if (!self.scrollViewDelegate || ![self.scrollViewDelegate respondsToSelector:@selector(numberOfPageInPageScrollView:)]) {
                return;
        }
        if (!self.scrollViewDelegate || ![self.scrollViewDelegate respondsToSelector:@selector(pageScrollView:viewForRowAtIndex:)]) {
                return;
        }
        _cellSize.width = 80;
        if ([self.scrollViewDelegate respondsToSelector:@selector(sizeCellForPageScrollView:)]) {
                _cellSize = [self.scrollViewDelegate sizeCellForPageScrollView:self];
        }
        
        _numberOfCell = [self.scrollViewDelegate numberOfPageInPageScrollView:self];
        
        //    float startX = self.leftRightOffset;
        float startX = 0;
        //    float topY   = (self.frame.size.height - _cellSize.height)/2;
        float topY = 0;
        [[self subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
        
        self.viewsInPage = nil;
        self.viewsInPage = [NSMutableArray array];
        
        for (int i = 0; i < _numberOfCell; i ++) {
                UIView * cell = [self.dataSource pageScrollView:self viewForRowAtIndex:i];
                cell.frame = CGRectMake(startX, topY, _cellSize.width, _cellSize.height);
                [self addSubview:cell];
                startX += self.padding + _cellSize.width;
                [self.viewsInPage addObject:cell];
        }
        
        float scrollViewSizeWith = startX - self.padding + (self.frame.size.width - _cellSize.width)/2;
        self.contentSize = CGSizeMake(scrollViewSizeWith - self.bounds.size.width / 3,  0.01);
}

- (UIView*)viewForRowAtIndex:(NSInteger)index
{
        if (index < self.viewsInPage.count) {
                return self.viewsInPage[index];
        }
        return nil;
}

#pragma mark - Properties

- (NSMutableArray*)viewsInPage
{
        if (!_viewsInPage) {
                _viewsInPage = [NSMutableArray array];
        }
        return _viewsInPage;
}

- (UITapGestureRecognizer*)tapGesture
{
        if (!_tapGesture) {
                _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
                [_tapGesture setNumberOfTapsRequired:1];
                [_tapGesture setNumberOfTouchesRequired:1];
        }
        return _tapGesture;
}



- (CGFloat)padding{
        if (!_padding) {
                return 10;
        }
        return _padding;
}

#pragma mark - Action

- (void)handleTapGesture:(UITapGestureRecognizer*)tapGesture
{
        CGPoint tapPoint = [tapGesture locationInView:self];
        
        float topY   = (self.frame.size.height - _cellSize.height)/2;
        BOOL yInCell = NO;
        if (tapPoint.y > topY && tapPoint.y < self.frame.size.height-topY){
                yInCell = YES;
        }
        int xInCellNumber = tapPoint.x /(_cellSize.width + self.padding);
        BOOL xInCell = NO;
        if (tapPoint.x > ((_cellSize.width + self.padding) * xInCellNumber)
            && tapPoint.x <  ((_cellSize.width + self.padding) * xInCellNumber) + _cellSize.width) {
                xInCell = YES;
        }
        if (xInCellNumber < 0 || xInCellNumber >= _numberOfCell) {
                xInCell = NO;
        }
        if (yInCell && xInCell) {
                self.selectedIndex = xInCellNumber;
                [self.scrollViewDelegate pageScrollView:self didTapPageAtIndex:xInCellNumber];
                //        [UIView animateWithDuration:0.3 animations:^{
                //            [self setContentOffset:CGPointMake((_cellSize.width + self.padding) * xInCellNumber, 0)];
                //        }];
        }
}


@end
