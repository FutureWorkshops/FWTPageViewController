//
//  AppDelegate.m
//  FWTPageViewController_Test
//
//  Created by Marco Meschini on 8/17/12.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "AppDelegate.h"
#import "SamplePickerViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor colorWithRed:.91f green:.92f blue:.93f alpha:1.0f];
    UIViewController *vc = [[[SamplePickerViewController alloc] init] autorelease];
    self.window.rootViewController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
