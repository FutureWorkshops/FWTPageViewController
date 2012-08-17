//
//  CustomPageViewController.h
//  FWTPageViewController_Test
//
//  Created by Marco Meschini on 8/17/12.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "FWTPageViewController.h"

@interface CustomPageViewController : FWTPageViewController <FWTPageViewDataSource>
{
    UIPageControl *_pageControl;
    UIEdgeInsets _pageObjectEdgeInsetsPortrait, _pageObjectEdgeInsetsLandscape;
}

@property (nonatomic, assign) UIEdgeInsets pageObjectEdgeInsetsPortrait, pageObjectEdgeInsetsLandscape;
@property (nonatomic, readonly, retain) UIPageControl *pageControl;

@end
