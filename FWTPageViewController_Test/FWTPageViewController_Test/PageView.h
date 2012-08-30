//
//  RecyclableObject.h
//  TmpRecycle
//
//  Created by Marco Meschini on 8/12/12.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageView : UIView
{
    UILabel *_label;
}

@property (nonatomic, readonly, retain) UILabel *label;
@property (nonatomic, assign) UIEdgeInsets imageViewEdgeInsets;

@end
