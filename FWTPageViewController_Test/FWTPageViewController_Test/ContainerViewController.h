//
//  ContainerViewController.h
//  FWTPageViewController_Test
//
//  Created by Marco Meschini on 8/17/12.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWTPageViewController.h"

@interface ContainerViewController : UIViewController <FWTPageViewDataSource>
{
    FWTPageViewController *_pageViewController;
}
@end
