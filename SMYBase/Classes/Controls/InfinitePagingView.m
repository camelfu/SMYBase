//
//  InfinitePagingView.m
//  InfinitePagingView
//
//  Created by SHIGETA Takuji
//

/*
 The MIT License (MIT)
 Copyright (c) 2012 SHIGETA Takuji
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "InfinitePagingView.h"

@interface InfinitePagingView ()

@property (nonatomic, assign) NSInteger currentPageIndex;

@end

@implementation InfinitePagingView {
    UIScrollView *_innerScrollView;
    NSMutableArray *_pageViews;
}

@synthesize pageSize = _pageSize, pageViews = _pageViews;
@synthesize scrollDirection = _scrollDirection;
@synthesize currentPageIndex = _currentPageIndex;
@synthesize delegate;

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (nil == _innerScrollView) {
        _currentPageIndex = 0;
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        CGRect bounds = CGRectZero;
        bounds.size = frame.size;
        _innerScrollView = [[UIScrollView alloc] initWithFrame:bounds];
        _innerScrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        _innerScrollView.delegate = self;
        _innerScrollView.backgroundColor = [UIColor clearColor];
        _innerScrollView.clipsToBounds = NO;
        _innerScrollView.pagingEnabled = YES;
        _innerScrollView.scrollEnabled = YES;
        _innerScrollView.showsHorizontalScrollIndicator = NO;
        _innerScrollView.showsVerticalScrollIndicator = NO;
        _innerScrollView.scrollsToTop = NO;
        _innerScrollView.bounces = NO;
        _scrollDirection = InfinitePagingViewHorizonScrollDirection;
        [self addSubview:_innerScrollView];
        self.pageSize = frame.size;
    }
}

- (void)dealloc {
    /**
     nil delegate in ARC to prevent Core Animation Retain which lead to crash if view
     that use InfinitePagingView deallocates while animating to next page.
     */
    
    _innerScrollView.delegate = nil;
}

#pragma mark - Public methods

- (NSInteger)nextPageIndex {
    CGRect bounds = self.bounds;
    CGPoint pointMiddle = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    pointMiddle = [_innerScrollView convertPoint:pointMiddle fromView:self];
    
    CGRect frame;
    NSInteger index = self.currentPageIndex;
    for (NSInteger i = 0; i < _pageViews.count; i++, index++) {
        if (index >= _pageViews.count) {
            index = 0;
        }
        frame = [_pageViews[index] frame];
        if (_scrollDirection == InfinitePagingViewHorizonScrollDirection) {
            if (CGRectGetMaxX(frame) >= pointMiddle.x && CGRectGetMinX(frame) < pointMiddle.x) {
                return index;
            }
        } else {
            if (CGRectGetMaxY(frame) >= pointMiddle.y && CGRectGetMinY(frame) < pointMiddle.y) {
                return index;
            }
        }
    }
    return self.currentPageIndex;
}

- (void)setPageSize:(CGSize)pageSize {
    if (fabs(pageSize.width - _pageSize.width) < 1 && fabs(pageSize.height - _pageSize.height) < 1) {
        return;
    }
    _pageSize = pageSize;
    CGRect frame = CGRectZero;
    for (UIView *pageView in _pageViews) {
        frame = pageView.frame;
        frame.size = self.pageSize;
        pageView.frame = frame;
    }
}

- (void)addPageView:(UIView *)pageView {
    if (!pageView) {
        return;
    }
    if (nil == _pageViews) {
        _pageViews = [NSMutableArray array];
    }
    [_pageViews addObject:pageView];
    [_innerScrollView addSubview:pageView];
    CGRect frame = pageView.frame;
    frame.size = self.pageSize;
    pageView.frame = frame;
    [self layoutPages];
    [self autoPlayNext];
}

- (void)insertPageView:(UIView *)pageView atIndex:(NSInteger)index {
    if (nil == _pageViews) {
        _pageViews = [NSMutableArray array];
    }
    if (!pageView || index < 0 || index >= _pageViews.count) {
        return;
    }
    [_pageViews insertObject:pageView atIndex:index];
    [_innerScrollView addSubview:pageView];
    [self layoutPages];
    [self autoPlayNext];
}

- (void)removeAllPageViews {
    [_pageViews removeAllObjects];
    [_innerScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self layoutPages];
    [self autoPlayNext];
}

- (UIView *)pageViewAtIndex:(NSInteger)index {
    if (index < 0 || index >= _pageViews.count) {
        return nil;
    }
    return [_pageViews objectAtIndex:index];
}

- (void)scrollToPreviousPage {
    [self scrollToPage:self.currentPageIndex - 1 animated:YES];
}

- (void)scrollToNextPage {
    [self scrollToPage:self.currentPageIndex + 1 animated:YES];
}

- (void)scrollToPage:(NSInteger)pageIndex animated:(BOOL)bAnimated {
    if (pageIndex == self.currentPageIndex || _pageViews.count < 2) {
        return;
    }
    [self layoutPages];
    if (pageIndex < 0) {
        pageIndex = _pageViews.count - 1;
    } else if (pageIndex >= _pageViews.count) {
        pageIndex = 0;
    }
    if (bAnimated) {
        CGPoint pointOffset = [(UIView *)[_pageViews objectAtIndex:pageIndex] frame].origin;
        pointOffset.y = _innerScrollView.contentOffset.y;
        [_innerScrollView setContentOffset:pointOffset animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.currentPageIndex = pageIndex;
            [self layoutPages];
            if ([self.delegate respondsToSelector:@selector(pagingViewDidChangePageIndex:)]) {
                [self.delegate pagingViewDidChangePageIndex:self];
            }
            [self autoPlayNext];
        });
    } else {
        self.currentPageIndex = pageIndex;
        [self layoutPages];
        if ([self.delegate respondsToSelector:@selector(pagingViewDidChangePageIndex:)]) {
            [self.delegate pagingViewDidChangePageIndex:self];
        }
        [self autoPlayNext];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutPages];
}

#pragma mark - Private methods

- (void)autoPlayNext {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollToNextPage) object:nil];
    if (self.autoPlay && _pageViews.count > 1) {
        [self performSelector:@selector(scrollToNextPage) withObject:nil afterDelay:self.intervalTime > 0 ? self.intervalTime : 4];
    }
}

- (void)layoutPages {
    [self.layer removeAllAnimations];
    CGRect frame, bounds = self.bounds;
    frame.size = self.pageSize;
    frame.origin = CGPointMake(CGRectGetMinX(bounds) + (bounds.size.width - self.pageSize.width) / 2,
                               CGRectGetMinY(bounds) + (bounds.size.height - self.pageSize.height) / 2);
    _innerScrollView.frame = frame;
    // 设置scrollView的contentSize
    NSInteger cnt = _pageViews.count;
    if (cnt < 1) {
        _innerScrollView.contentSize = self.pageSize;
        return;
    }
    CGSize sizeContent;
    if (_scrollDirection == InfinitePagingViewHorizonScrollDirection) {
        sizeContent = CGSizeMake(self.pageSize.width * cnt, self.pageSize.height);
    } else {
        sizeContent = CGSizeMake(self.pageSize.width, self.pageSize.height * cnt);
    }
    _innerScrollView.contentSize = sizeContent;
    // 当前页面
    NSInteger index = self.currentPageIndex;
    if (index >= _pageViews.count) {
        self.currentPageIndex = 0;
        index = 0;
    }
    UIView *view  = [_pageViews objectAtIndex:index];
    // 让当前页面处于scrollView的中间位置
    CGPoint ptCenter = CGPointMake(sizeContent.width / 2, sizeContent.height / 2);
    if (cnt % 2 == 0) {
        ptCenter = CGPointMake(self.pageSize.width * (cnt - 1) / 2, sizeContent.height / 2);
        if (_scrollDirection == InfinitePagingViewVerticalScrollDirection) {
            ptCenter = CGPointMake(self.pageSize.width / 2, sizeContent.height * (cnt - 1) / 2);
        }
    }
    view.center = ptCenter;
    // 让一半数量的位于当前页面之后的页面依次跟随当前页面放置
    for (NSInteger i = 0; i < (NSInteger)(_pageViews.count / 2); i++) {
        index++;
        if (index > cnt - 1) {// 循环到开始
            index -= cnt;
        }
        if (_scrollDirection == InfinitePagingViewHorizonScrollDirection) {
            ptCenter.x += self.pageSize.width;
        } else {
            ptCenter.y += self.pageSize.height;
        }
        view = [_pageViews objectAtIndex:index];
        view.center = ptCenter;
    }
    index = self.currentPageIndex;
    ptCenter = [(UIView *)[_pageViews objectAtIndex:self.currentPageIndex] center];
    for (NSInteger i = (NSInteger)(_pageViews.count / 2.0 - 0.3); i > 0; i--) {
        index--;
        if (index < 0) {
            index += cnt;
        }
        if (index == self.currentPageIndex) {
            break;
        }
        if (_scrollDirection == InfinitePagingViewHorizonScrollDirection) {
            ptCenter.x -= self.pageSize.width;
        } else {
            ptCenter.y -= self.pageSize.height;
        }
        view = [_pageViews objectAtIndex:index];
        view.center = ptCenter;
    }
    // 滚动scrollView，使当前页面居中显示
    ptCenter = [(UIView *)[_pageViews objectAtIndex:self.currentPageIndex] center];
    if (_scrollDirection == InfinitePagingViewHorizonScrollDirection) {
        [_innerScrollView setContentOffset:CGPointMake(ptCenter.x - self.pageSize.width / 2, _innerScrollView.contentOffset.y) animated:NO];
    } else {
        [_innerScrollView setContentOffset:CGPointMake(0, ptCenter.y - self.pageSize.height / 2)  animated:NO];
    }
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self layoutPages];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollToNextPage) object:nil];
    if ([self.delegate respondsToSelector:@selector(pagingView:willBeginDragging:)]) {
        [self.delegate pagingView:self willBeginDragging:_innerScrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(pagingView:didScroll:)]) {
        [self.delegate pagingView:self didScroll:_innerScrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.delegate respondsToSelector:@selector(pagingView:didEndDragging:)]) {
        [self.delegate pagingView:self didEndDragging:_innerScrollView];
    }
    if (!decelerate) {
        self.currentPageIndex = self.nextPageIndex;
        [self layoutPages];
        [self autoPlayNext];
        if ([self.delegate respondsToSelector:@selector(pagingViewDidChangePageIndex:)]) {
            [self.delegate pagingViewDidChangePageIndex:self];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(pagingView:willBeginDecelerating:)]) {
        [self.delegate pagingView:self willBeginDecelerating:_innerScrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentPageIndex = self.nextPageIndex;
    [self layoutPages];
    [self autoPlayNext];
    if ([self.delegate respondsToSelector:@selector(pagingViewDidChangePageIndex:)]) {
        [self.delegate pagingViewDidChangePageIndex:self];
    }
}

@end
