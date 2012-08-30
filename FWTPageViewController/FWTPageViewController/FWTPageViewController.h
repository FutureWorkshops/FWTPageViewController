//
//  FWTPageViewController.h
//  FWTPageViewController
//
//  Created by Marco Meschini on 8/17/12.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWTPageControl.h"

@class FWTPageViewController;
@protocol FWTPageViewDataSource <NSObject>

- (NSInteger)numberOfPagesInPageViewController:(FWTPageViewController *)pageViewController;
- (UIView *)pageViewController:(FWTPageViewController *)pageViewController pageForIndex:(NSInteger)pageIndex;

@end

typedef void (^FWTPageViewControllerCustomizePageControlBlock)(FWTPageViewController *);

@interface FWTPageViewController : UIViewController <UIScrollViewDelegate>
{
    UIScrollView *_pagingScrollView;
    NSInteger _numberOfPages, _currentPage;
    id<FWTPageViewDataSource> _dataSource;
    
    FWTPageControl *_pageControl;
    BOOL _pageControlEnabled;
    FWTPageViewControllerCustomizePageControlBlock _customizePageControlBlock;
}

@property (nonatomic, readonly, retain) UIScrollView *pagingScrollView;
@property (nonatomic, assign) NSInteger numberOfPages, currentPage;
@property (nonatomic, assign) id<FWTPageViewDataSource> dataSource;
@property (nonatomic, readonly, retain) FWTPageControl *pageControl;
@property (nonatomic, getter = isPageControlEnabled, assign) BOOL pageControlEnabled;   //  default is disabled

// default customization block
//  - resizingMask (width+topMargin)
//  - height 20px
//  - dyFromBottomEdge 10px
//
@property (nonatomic, copy) FWTPageViewControllerCustomizePageControlBlock customizePageControlBlock;

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated;

- (CGRect)frameForPageAtIndex:(NSUInteger)index;

- (UIView *)dequeueReusablePage;

- (void)reloadData;

@end