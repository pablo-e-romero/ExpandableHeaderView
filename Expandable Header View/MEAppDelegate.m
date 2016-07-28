//
//  MEAppDelegate.m
//  Expandable Header View
//
//  Created by Pablo Romero on 6/10/14.
//  Copyright (c) 2014 Microeditionbiz. All rights reserved.
//

#import "MEAppDelegate.h"

@implementation MEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:frame];
    [self.window makeKeyAndVisible];
    
    UIStoryboard *mainFlow = [UIStoryboard storyboardWithName:@"Storyboard"
                                                       bundle:nil];
    
    UIViewController *viewController = [mainFlow instantiateInitialViewController];
    self.window.rootViewController = viewController;
    
    return YES;
}

@end
