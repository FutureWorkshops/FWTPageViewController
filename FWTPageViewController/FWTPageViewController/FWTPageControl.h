//
//  FWTPageControl.h
//  FWTPageViewController
//
//  Created by Marco Meschini on 29/08/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWTPageControl : UIControl

@property (nonatomic) NSInteger numberOfPages;          // default is 0
@property (nonatomic) NSInteger currentPage;            // default is 0. value pinned to 0..numberOfPages-1
//@property (nonatomic) BOOL hidesForSinglePage;          // hide the the indicator if there is only one page. default is NO
//@property (nonatomic) BOOL defersCurrentPageDisplay;    // if set, clicking to a new page won't update the currently displayed page until -updateCurrentPageDisplay is called. default is NO

@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) UIImage *unselectedImage;

@property (nonatomic, retain) UIColor *tintColorSelected;
@property (nonatomic, retain) UIColor *tintColorUnselected;
@end
