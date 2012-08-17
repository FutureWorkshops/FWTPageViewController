//
//  FWTPageViewController.h
//  FWTPageViewController
//
//  Created by Marco Meschini on 8/17/12.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FWTPageViewController;
@protocol FWTPageViewDataSource <NSObject>

- (NSInteger)numberOfPagesInPageViewController:(FWTPageViewController *)pageViewController;
- (UIView *)pageViewController:(FWTPageViewController *)pageViewController pageForIndex:(NSInteger)pageIndex;

@end

@interface FWTPageViewController : UIViewController <UIScrollViewDelegate>
{
    UIScrollView *_pagingScrollView;
    NSInteger _numberOfPages, _currentPage;
    id<FWTPageViewDataSource> _dataSource;
}

@property (nonatomic, readonly, retain) UIScrollView *pagingScrollView;
@property (nonatomic, assign) NSInteger numberOfPages, currentPage;
@property (nonatomic, assign) id<FWTPageViewDataSource> dataSource;

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated;

- (CGRect)frameForPageAtIndex:(NSUInteger)index;

- (UIView *)dequeueReusablePage;

- (void)reloadData;

@end