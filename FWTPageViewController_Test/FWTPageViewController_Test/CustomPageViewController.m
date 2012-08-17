//
//  CustomPageViewController.m
//  FWTPageViewController_Test
//
//  Created by Marco Meschini on 8/17/12.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "CustomPageViewController.h"
#import "PageView.h"

@interface CustomPageViewController ()
{
    BOOL _pageControlUsed;
}
@property (nonatomic, readwrite, retain) UIPageControl *pageControl;
@property (nonatomic, assign) BOOL pageControlUsed;
@end

@implementation CustomPageViewController
@synthesize pageControl = _pageControl;
@synthesize pageControlUsed = _pageControlUsed;
@synthesize pageObjectEdgeInsetsPortrait = _pageObjectEdgeInsetsPortrait;
@synthesize pageObjectEdgeInsetsLandscape = _pageObjectEdgeInsetsLandscape;

- (void)dealloc
{
    self.pageControl = nil;
    [super dealloc];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.pageObjectEdgeInsetsPortrait = UIEdgeInsetsMake(10, 10, 30, 10);
        self.pageObjectEdgeInsetsLandscape = UIEdgeInsetsMake(10, 60, 30, 60);
        self.dataSource = self;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    CGRect frame = self.view.bounds;
    frame.origin.y = frame.size.height-20.0f;
    frame.size.height = 20.0f;
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    self.pageControl.frame = frame;
    self.pageControl.layer.borderWidth = 1.0f;
    self.pageControl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2f];
    [self.view addSubview:self.pageControl];
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index
{
    CGRect bounds = [super frameForPageAtIndex:index];
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        insets = self.pageObjectEdgeInsetsLandscape;
    else
        insets = self.pageObjectEdgeInsetsPortrait;
    
    return UIEdgeInsetsInsetRect(bounds, insets);
}

- (void)reloadData
{
    [super reloadData];
    
    //
    self.pageControl.numberOfPages = self.numberOfPages;
    self.pageControl.currentPage = self.currentPage;
}

#pragma mark - ScrollView delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    
    // Switch the indicator when more than 50% of the previous/next page is visible
    if (!self.pageControlUsed)
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.pageControl.currentPage = page;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [super scrollViewDidEndDecelerating:scrollView];
    self.pageControlUsed = NO;
}

#pragma mark - Getters
- (UIPageControl *)pageControl
{
    if (!self->_pageControl)
    {
        self->_pageControl = [[UIPageControl alloc] init];
        [self->_pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return self->_pageControl;
}

#pragma mark - Actions
- (void)pageControlValueChanged:(UIPageControl *)pageControl
{
    int page = pageControl.currentPage;
    self.pageControlUsed = YES;
    [self setCurrentPage:page animated:YES];
}

#pragma mark - PageViewDataSource
- (NSInteger)numberOfPagesInPageViewController:(FWTPageViewController *)pageViewController
{
    return 14;
}

- (UIView *)pageViewController:(FWTPageViewController *)pageViewController pageForIndex:(NSInteger)pageIndex
{
    PageView *pageObject = (PageView *)[pageViewController dequeueReusablePage];
    if (pageObject == nil)
        pageObject = [[[PageView alloc] init] autorelease];
    
    pageObject.label.text = [NSString stringWithFormat:@"%i", pageIndex + 1];
    
    return pageObject;
}

@end
