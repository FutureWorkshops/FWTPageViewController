//
//  ContainerViewController.m
//  FWTPageViewController_Test
//
//  Created by Marco Meschini on 8/17/12.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "ContainerViewController.h"
#import "PageView.h"

@interface ContainerViewController ()
{
    
}

@property (nonatomic, retain) FWTPageViewController *pageViewController;

@end

@implementation ContainerViewController
@synthesize pageViewController = _pageViewController;

- (void)dealloc
{
    self.pageViewController = nil;
    [super dealloc];
}

- (id)init
{
    if ((self = [super init]))
    {
        CGSize ctxSize = CGSizeMake(8, 8);
        CGRect ctxRect = CGRectMake(.0f, .0f, ctxSize.width, ctxSize.height);
        UIGraphicsBeginImageContextWithOptions(ctxSize, NO, .0f);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGRect ellipseRect = CGRectInset(ctxRect, 1, 1);
        CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
        CGContextFillEllipseInRect(ctx, ellipseRect);
        UIImage *selectedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContextWithOptions(ctxSize, NO, .0f);
        ctx = UIGraphicsGetCurrentContext();
        ellipseRect = CGRectInset(ctxRect, 1, 1);
        CGContextSetFillColorWithColor(ctx, [[UIColor redColor] colorWithAlphaComponent:.3f].CGColor);
        CGContextFillEllipseInRect(ctx, ellipseRect);
        UIImage *unselectedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.pageViewController.pageControl.tintColorUnselected = [[UIColor blackColor] colorWithAlphaComponent:.3f];
        self.pageViewController.pageControl.tintColorSelected = [[UIColor blackColor] colorWithAlphaComponent:.5f];
        
//        self.pageViewController.pageControl.selectedImage = selectedImage;
//        self.pageViewController.pageControl.unselectedImage = unselectedImage;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    self.pageViewController.view.frame = self.view.bounds;
    [self.pageViewController didMoveToParentViewController:self];
    
    self.pageViewController.view.layer.borderWidth = 1.0f;
    self.pageViewController.view.layer.borderColor = [UIColor redColor].CGColor;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Getters
- (FWTPageViewController *)pageViewController
{
    if (!self->_pageViewController)
    {
        self->_pageViewController = [[FWTPageViewController alloc] init];
        self->_pageViewController.dataSource = self;
    }
    
    return self->_pageViewController;
}

#pragma mark - FWTPageViewDataSource
- (NSInteger)numberOfPagesInPageViewController:(FWTPageViewController *)pageViewController
{
    return 18;
}

- (UIView *)pageViewController:(FWTPageViewController *)pageViewController pageForIndex:(NSInteger)pageIndex
{
    PageView *pageView = (PageView *)[pageViewController dequeueReusablePage];
    if (pageView == nil)
        pageView = [[[PageView alloc] init] autorelease];
    
    pageView.label.text = [NSString stringWithFormat:@"%i", pageIndex];
    
    return pageView;
}

@end
