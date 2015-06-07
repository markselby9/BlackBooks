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
#import <PgySDK/PgyManager.h>
#import "BBNavigationController.h"
#import "BBMenuController.h"
#import <PDDebugger.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AVOSCloud setApplicationId:@"3kuu7wpf8d7v6aeho00hgdoo0fxf3s2ll0uxv6742739f5f5" clientKey:@"t1qg98fpc0jb1tq8e6dqkdtbjmu9isd0ybf85j8u6hk5qcal"];
    //友盟
    [UMSocialData setAppKey:@"54f44c92fd98c5c66b00017e"];
    //蒲公英
    [[PgyManager sharedPgyManager] startManagerWithAppId:@"83143bb2cbdf41339ac7541e98ac7572"];
    [AVOSCloud useAVCloudCN];
    [BBUser registerSubclass];
    [BBBook registerSubclass];
    
    //ponyd debugger
    PDDebugger *debugger = [PDDebugger defaultInstance];
    //设置网络监控
    [debugger enableNetworkTrafficDebugging];
    [debugger forwardAllNetworkTraffic];
    //通过TCP连接至服务端
    [debugger connectToURL:[NSURL URLWithString:@"ws://localhost:9000/device"]];
    // 也可通过bonjour自动连接
    //[debugger autoConnect];
    // 或连接至指定bonjour服务
    //[debugger autoConnectToBonjourServiceNamed:@"MY PONY"];
    //设置CoreData监控
    [debugger enableCoreDataDebugging];
//    [debugger addManagedObjectContext:self.managedObjectContext withName:@"TIME Test MOC"];
    //设置视图分层监控
    [debugger enableViewHierarchyDebugging];
    //设置远程日志打印
    [debugger enableRemoteLogging];
    
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
    //home VC
    BBNavigationController *bbNavi = [[BBNavigationController alloc]initWithRootViewController:[[BBViewController alloc]init]];
    BBMenuController *bbMenu = [[BBMenuController alloc]initWithStyle:UITableViewStylePlain];
    
    REFrostedViewController *reVC = [[REFrostedViewController alloc]initWithContentViewController:bbNavi menuViewController:bbMenu];
    reVC.direction = REFrostedViewControllerDirectionLeft;
    reVC.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    reVC.liveBlur = YES;
    reVC.delegate = self;
    
    self.window.rootViewController = reVC;
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}

#pragma mark -- REFrosteddelegate
//- (void)frostedViewController:(REFrostedViewController *)frostedViewController didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer
//{
//    
//}
//
//- (void)frostedViewController:(REFrostedViewController *)frostedViewController willShowMenuViewController:(UIViewController *)menuViewController
//{
//    NSLog(@"willShowMenuViewController");
//}
//
//- (void)frostedViewController:(REFrostedViewController *)frostedViewController didShowMenuViewController:(UIViewController *)menuViewController
//{
//    NSLog(@"didShowMenuViewController");
//}
//
//- (void)frostedViewController:(REFrostedViewController *)frostedViewController willHideMenuViewController:(UIViewController *)menuViewController
//{
//    NSLog(@"willHideMenuViewController");
//}
//
//- (void)frostedViewController:(REFrostedViewController *)frostedViewController didHideMenuViewController:(UIViewController *)menuViewController
//{
//    NSLog(@"didHideMenuViewController");
//}

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
