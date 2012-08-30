//
//  CustomPageViewController.m
//  FWTPageViewController_Test
//
//  Created by Marco Meschini on 8/17/12.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "CustomPageViewController.h"
#import "PageView.h"

@interface CustomPageViewController () <FWTPageViewDataSource>
@property (nonatomic, assign) UIEdgeInsets pageObjectEdgeInsetsPortrait, pageObjectEdgeInsetsLandscape;
@end

@implementation CustomPageViewController
@synthesize pageObjectEdgeInsetsPortrait = _pageObjectEdgeInsetsPortrait;
@synthesize pageObjectEdgeInsetsLandscape = _pageObjectEdgeInsetsLandscape;

- (id)init
{
    if ((self = [super init]))
    {
        self.pageObjectEdgeInsetsPortrait = UIEdgeInsetsMake(10, 10, 30, 10);
        self.pageObjectEdgeInsetsLandscape = UIEdgeInsetsMake(10, 60, 30, 60);
        self.dataSource = self;
        self.pageControlEnabled = YES;
        
        CGSize ctxSize = CGSizeMake(8, 8);
        CGRect ctxRect = CGRectMake(.0f, .0f, ctxSize.width, ctxSize.height);
        UIGraphicsBeginImageContextWithOptions(ctxSize, NO, .0f);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGRect ellipseRect = CGRectInset(ctxRect, 1, 1);
        CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
        CGContextFillEllipseInRect(ctx, ellipseRect);
        UIImage *selectedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.pageControl.selectedImage = selectedImage;
        
        UIGraphicsBeginImageContextWithOptions(ctxSize, NO, .0f);
        ctx = UIGraphicsGetCurrentContext();
        ellipseRect = CGRectInset(ctxRect, 1, 1);
        CGContextSetFillColorWithColor(ctx, [[UIColor redColor] colorWithAlphaComponent:.3f].CGColor);
        CGContextFillEllipseInRect(ctx, ellipseRect);
        UIImage *unselectedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.pageControl.unselectedImage = unselectedImage;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
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

#pragma mark - PageViewDataSource
- (NSInteger)numberOfPagesInPageViewController:(FWTPageViewController *)pageViewController
{
    return 10;
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
