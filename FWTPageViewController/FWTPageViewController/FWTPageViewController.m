//
//  FWTPageViewController.m
//  FWTPageViewController
//
//  Created by Marco Meschini on 8/17/12.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "FWTPageViewController.h"
#import <objc/runtime.h>

static char const * const pageNumberKey = "pageNumberKey";

@interface FWTPageViewController ()
{
    NSMutableSet *_recycledPages, *_visiblePages;
    
    // these values are stored off before we start rotation so we adjust our content offset appropriately during rotation
    int           firstVisiblePageIndexBeforeRotation;
    CGFloat       percentScrolledIntoFirstVisiblePage;
}
@property (nonatomic, readwrite, retain) UIScrollView *pagingScrollView;
@property (nonatomic, retain) NSMutableSet *recycledPages, *visiblePages;

//
- (void)tilePages;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;

//
- (CGSize)contentSizeForPagingScrollView;
- (NSNumber *)pageNumberForPage:(UIView *)page;
- (void)setPageNumber:(NSNumber *)pageNumber forPage:(UIView *)page;
- (void)updateCurrentPage;

@end

@implementation FWTPageViewController
@synthesize pagingScrollView = _pagingScrollView;
@synthesize recycledPages = _recycledPages;
@synthesize visiblePages = _visiblePages;
@synthesize numberOfPages = _numberOfPages;
@synthesize currentPage = _currentPage;
@synthesize dataSource = _dataSource;

- (void)dealloc
{
    self.dataSource = nil;
    self.recycledPages = nil;
    self.visiblePages = nil;
    self.pagingScrollView = nil;
    [super dealloc];
}

#pragma mark - Overrides
- (id)init
{
    if ((self = [super init]))
    {
        self.numberOfPages = 0;
        self.currentPage = 0;
    }
    
    return self;
}

- (void)loadView
{
    //
    [super loadView];
    
    //
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //
    self.pagingScrollView.frame = self.view.bounds;
    self.pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    
    for (UIView *pageView in [self visiblePages])
    {
        NSInteger pageNumber = [self pageNumberForPage:pageView].integerValue;
        pageView.frame = [self frameForPageAtIndex:pageNumber];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.pagingScrollView = nil;
    self.recycledPages = nil;
    self.visiblePages = nil;
}

#pragma mark - Getters
- (UIScrollView *)pagingScrollView
{
    if (!self->_pagingScrollView)
    {
        self->_pagingScrollView = [[UIScrollView alloc] init];
        self->_pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self->_pagingScrollView.pagingEnabled = YES;
        self->_pagingScrollView.backgroundColor = [UIColor clearColor];
        self->_pagingScrollView.showsVerticalScrollIndicator = NO;
        self->_pagingScrollView.showsHorizontalScrollIndicator = NO;
        self->_pagingScrollView.delegate = self;
    }
    
    return self->_pagingScrollView;
}

- (NSMutableSet *)recycledPages
{
    if (!self->_recycledPages)
        self->_recycledPages = [[NSMutableSet alloc] init];
    
    return self->_recycledPages;
}

- (NSMutableSet *)visiblePages
{
    if (!self->_visiblePages)
        self->_visiblePages = [[NSMutableSet alloc] init];
    
    return self->_visiblePages;
}

#pragma mark - Tiling and page configuration
- (void)tilePages
{
    // Calculate which pages are visible
    CGRect visibleBounds = self.pagingScrollView.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, self.numberOfPages - 1);
    
    // Recycle no-longer-visible pages
    for (UIView *pageView in self.visiblePages)
    {
        NSInteger pageNumber = [self pageNumberForPage:pageView].integerValue;
        if (pageNumber < firstNeededPageIndex || pageNumber > lastNeededPageIndex)
        {
            //
            [self.recycledPages addObject:pageView];
            [self setPageNumber:nil forPage:pageView];
            [pageView removeFromSuperview];
        }
    }
    [self.visiblePages minusSet:self.recycledPages];
    
    // add missing pages
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++)
    {
        if (![self isDisplayingPageForIndex:index])
        {
            UIView *pageView = [self.dataSource pageViewController:self pageForIndex:index];
            if (pageView)
            {
                //
                [self.visiblePages addObject:pageView];
                [self setPageNumber:[NSNumber numberWithInteger:index] forPage:pageView];
                [self.pagingScrollView addSubview:pageView];
                pageView.frame = [self frameForPageAtIndex:index];
            }
        }
    }
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    __block BOOL foundPage = NO;
    [self.visiblePages enumerateObjectsUsingBlock:^(UIView *pageView, BOOL *stop) {
        
        NSInteger pageNumber = [self pageNumberForPage:pageView].integerValue;
        if (pageNumber == index)
        {
            foundPage = YES;
            *stop = YES;
        }
    }];
    
    return foundPage;
}

#pragma mark - ScrollView delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tilePages];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateCurrentPage];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updateCurrentPage];
}

#pragma mark -
#pragma mark View controller rotation methods
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // here, our pagingScrollView bounds have not yet been updated for the new interface orientation. So this is a good
    // place to calculate the content offset that we will need in the new orientation
    CGFloat offset = self.pagingScrollView.contentOffset.x;
    CGFloat pageWidth = self.pagingScrollView.bounds.size.width;
    
    if (offset >= 0)
    {
        firstVisiblePageIndexBeforeRotation = floorf(offset / pageWidth);
        percentScrolledIntoFirstVisiblePage = (offset - (firstVisiblePageIndexBeforeRotation * pageWidth)) / pageWidth;
    }
    else
    {
        firstVisiblePageIndexBeforeRotation = 0;
        percentScrolledIntoFirstVisiblePage = offset / pageWidth;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // recalculate contentSize based on current orientation
    self.pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    
    // adjust frames and configuration of each visible page
    for (UIView *pageView in [self visiblePages])
    {
        NSInteger pageNumber = [self pageNumberForPage:pageView].integerValue;
        pageView.frame = [self frameForPageAtIndex:pageNumber];
    }
    
    // adjust contentOffset to preserve page location based on values collected prior to location
    CGFloat pageWidth = self.pagingScrollView.bounds.size.width;
    CGFloat newOffset = (firstVisiblePageIndexBeforeRotation * pageWidth) + (percentScrolledIntoFirstVisiblePage * pageWidth);
    self.pagingScrollView.contentOffset = CGPointMake(newOffset, 0);
}

#pragma mark - Private
- (CGSize)contentSizeForPagingScrollView
{
    // We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
    CGRect bounds = self.pagingScrollView.bounds;
    return CGSizeMake(bounds.size.width * self.numberOfPages, bounds.size.height);
}

- (NSNumber *)pageNumberForPage:(UIView *)page
{
    return objc_getAssociatedObject(page, pageNumberKey);
}

- (void)setPageNumber:(NSNumber *)pageNumber forPage:(UIView *)page
{
    objc_setAssociatedObject(page, pageNumberKey, pageNumber, OBJC_ASSOCIATION_RETAIN);
}

- (void)updateCurrentPage
{
    NSInteger currentPage = self.pagingScrollView.contentOffset.x/self.pagingScrollView.frame.size.width;
    self->_currentPage = currentPage;
}

#pragma mark - Public
- (void)setCurrentPage:(NSInteger)currentPage
{
    [self setCurrentPage:currentPage animated:NO];
}

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated
{
    if (self->_currentPage != currentPage)
    {
        self->_currentPage = currentPage;
        CGPoint offset = self.pagingScrollView.contentOffset;
        offset.x = self.pagingScrollView.bounds.size.width*currentPage;
        [self.pagingScrollView setContentOffset:offset animated:animated];
    }
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index
{
    // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
    // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
    // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
    // because it has a rotation transform applied.
    CGRect bounds = self.pagingScrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.origin.x = (bounds.size.width * index);
    return pageFrame;
}

- (UIView *)dequeueReusablePage
{
    UIView *pageView = [self.recycledPages anyObject];
    if (pageView)
    {
        [[pageView retain] autorelease];
        [self.recycledPages removeObject:pageView];
    }
    
    return pageView;
}

- (void)reloadData
{
    //
    self.numberOfPages = [self.dataSource numberOfPagesInPageViewController:self];
    
    //
    if (!self.pagingScrollView.superview)
        [self.view addSubview:self.pagingScrollView];
    self.pagingScrollView.frame = self.view.bounds;
    self.pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    
    //
    [self tilePages];
    
    //
    if (self.currentPage != 0)
    {
        CGPoint offset = self.pagingScrollView.contentOffset;
        offset.x = self.pagingScrollView.bounds.size.width*self.currentPage;
        [self.pagingScrollView setContentOffset:offset animated:NO];
    }
}

@end
