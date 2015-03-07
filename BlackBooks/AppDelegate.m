//
//  AppDelegate.m
//  BlackBooks
//
//  Created by 冯超逸 on 15/2/23.
//  Copyright (c) 2015年 com.markselby. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import "BBViewController.h"
#import "BBBook.h"
#import "BBBookManager.h"
#import "BBUser.h"
#import "UMSocial.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AVOSCloud setApplicationId:@"3kuu7wpf8d7v6aeho00hgdoo0fxf3s2ll0uxv6742739f5f5" clientKey:@"t1qg98fpc0jb1tq8e6dqkdtbjmu9isd0ybf85j8u6hk5qcal"];
    [UMSocialData setAppKey:@"54f44c92fd98c5c66b00017e"];
    [AVOSCloud useAVCloudCN];
    [BBUser registerSubclass];
    [BBBook registerSubclass];
    
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    BBViewController *bbVC = [[BBViewController alloc]init];
    UINavigationController *naviVC = [[UINavigationController alloc]initWithRootViewController:bbVC];
    self.window.rootViewController = naviVC;
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
