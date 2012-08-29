//
//  FWTPageControl.m
//  FWTPageViewController
//
//  Created by Marco Meschini on 29/08/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "FWTPageControl.h"

#define PAGE_CONTROL_IMAGE_SIZE     CGSizeMake(8.0f, 8.0f)

@implementation FWTPageControl
@synthesize currentPage = _currentPage;
@synthesize numberOfPages = _numberOfPages;

- (void)dealloc
{
    self.selectedImage = nil;
    self.unselectedImage = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat imageWidth = self.selectedImage.size.width;
    CGFloat spaceBetween = imageWidth;
    CGSize totalSize = [self sizeForNumberOfPages:self.numberOfPages];
    
    NSInteger y = (rect.size.height-totalSize.height)*.5f;
    NSInteger x = (rect.size.width-totalSize.width)*.5f;
    for(int i=0; i < self.numberOfPages; i++)
	{
		CGPoint point = CGPointMake(x+((imageWidth+spaceBetween)*i), y);
        
        if (i == self.currentPage)
            [self.selectedImage drawAtPoint:point];
        else
            [self.unselectedImage drawAtPoint:point];
	}
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat imageWidth = self.selectedImage.size.width;
    CGFloat imageHeight = self.selectedImage.size.height;
    CGFloat spaceBetween = imageWidth;
    CGFloat totalWidth = imageWidth*self.numberOfPages + spaceBetween*(self.numberOfPages-1);
    return CGSizeMake(MAX(totalWidth, self.bounds.size.width), MAX(imageHeight, self.bounds.size.height));
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount
{
    CGFloat imageWidth = self.selectedImage.size.width;
    CGFloat imageHeight = self.selectedImage.size.height;
    CGFloat spaceBetween = imageWidth;
    CGFloat totalWidth = imageWidth*self.numberOfPages + spaceBetween*(self.numberOfPages-1);
    return CGSizeMake(totalWidth, imageHeight);
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	CGPoint touchLocation = [[touches anyObject] locationInView:self];
	if (touchLocation.x < self.bounds.size.width*.5f)
		self.currentPage = MAX(self.currentPage - 1, 0) ;
	else
		self.currentPage = MIN(self.currentPage + 1, self.numberOfPages - 1) ;
    
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - Setters
- (void)setCurrentPage:(NSInteger)currentPage
{
    if (self->_currentPage != currentPage)
    {
        self->_currentPage = currentPage;
        [self setNeedsDisplay];
    }
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
	if (self->_numberOfPages != numberOfPages)
    {
		self->_numberOfPages = numberOfPages;
        
        if (self->_currentPage >= numberOfPages)
            self->_currentPage = numberOfPages - 1;
        
        [self sizeToFit];
		[self setNeedsDisplay];
	}
}

#pragma mark - Getters
- (UIImage *)selectedImage
{
    if (!self->_selectedImage)
    {
        CGSize ctxSize = PAGE_CONTROL_IMAGE_SIZE;
        CGRect ctxRect = CGRectMake(.0f, .0f, ctxSize.width, ctxSize.height);
        UIGraphicsBeginImageContextWithOptions(ctxSize, NO, .0f);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGRect ellipseRect = CGRectInset(ctxRect, 1, 1);
        CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
        CGContextFillEllipseInRect(ctx, ellipseRect);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self->_selectedImage = [image retain];
    }
    
    return self->_selectedImage;
}

- (UIImage *)unselectedImage
{
    if (!self->_unselectedImage)
    {
        CGSize ctxSize = PAGE_CONTROL_IMAGE_SIZE;
        CGRect ctxRect = CGRectMake(.0f, .0f, ctxSize.width, ctxSize.height);
        UIGraphicsBeginImageContextWithOptions(ctxSize, NO, .0f);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGRect ellipseRect = CGRectInset(ctxRect, 1, 1);
        CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] colorWithAlphaComponent:.3f].CGColor);
        CGContextFillEllipseInRect(ctx, ellipseRect);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self->_unselectedImage = [image retain];
    }
    
    return self->_unselectedImage;
}

@end
