//
// Created by 赵江明 on 2021/10/22.
// Copyright (c) 2021 chinaxxren. All rights reserved.
//

#import "AppDelegate.h"

#import "TestWKWebViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[TestWKWebViewController new]];
    [self.window makeKeyAndVisible];
    
    NSLog(@"%s",__func__);

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"%s",__func__);
}

@end
