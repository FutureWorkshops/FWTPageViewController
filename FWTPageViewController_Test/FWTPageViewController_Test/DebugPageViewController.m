//
//  DebugPageViewController.m
//  FWTPageViewController_Test
//
//  Created by Marco Meschini on 30/08/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "DebugPageViewController.h"
#import "PageView.h"

@interface FWTPageViewController (Private)
@property (nonatomic, getter = isPageControlUsed, assign) BOOL pageControlUsed;

- (void)pageControlValueChanged:(UIPageControl *)pageControl;

@end

@interface DebugPageViewController () <FWTPageViewDataSource>
@property (nonatomic, retain) UIPageControl *defaultPageControl;
@end

@implementation DebugPageViewController

- (void)dealloc
{
    self.defaultPageControl = nil;
    [super dealloc];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.dataSource = self;
        self.pageControlEnabled = YES;
        
        self.customizePageControlBlock = ^(FWTPageViewController *pageViewController){
            
            //
            pageViewController.pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
            
            //
            CGFloat height = 20.0f;
            CGRect frame = pageViewController.view.bounds;
            frame.size.height = height;
            pageViewController.pageControl.frame = frame;
        };
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    //
    CGFloat height = 20.0f;
    CGRect frame = self.view.bounds;
    frame.origin.y = frame.size.height-height;
    frame.size.height = height;
    self.defaultPageControl = [[[UIPageControl alloc] init] autorelease];
    self.defaultPageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    self.defaultPageControl.frame = frame;
    [self.defaultPageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.defaultPageControl];
    
    self.defaultPageControl.numberOfPages = self.numberOfPages;
    self.defaultPageControl.currentPage = self.currentPage;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Overrides
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    
    if (![self isPageControlUsed] && [self isPageControlEnabled])
        self.defaultPageControl.currentPage = self.pageControl.currentPage;
}

- (void)pageControlValueChanged:(UIPageControl *)pageControl
{
    [super pageControlValueChanged:pageControl];
    self.defaultPageControl.currentPage = self.pageControl.currentPage;
}

- (void)reloadData
{
    [super reloadData];
    
    self.defaultPageControl.numberOfPages = self.numberOfPages;
    self.defaultPageControl.currentPage = self.currentPage;
    
}

#pragma mark - PageViewDataSource
- (NSInteger)numberOfPagesInPageViewController:(FWTPageViewController *)pageViewController
{
    return 10;
}

- (UIView *)pageViewController:(FWTPageViewController *)pageViewController pageForIndex:(NSInteger)pageIndex
{
    PageView *pageObject = (PageView *)[pageViewController dequeueReusablePage];
    if (pageObject == nil)
    {
        pageObject = [[[PageView alloc] init] autorelease];
        pageObject.imageViewEdgeInsets = UIEdgeInsetsMake(20, 10, 20, 10);
    }
        
    pageObject.label.text = [NSString stringWithFormat:@"%i", pageIndex + 1];
    
    return pageObject;
}

@end
