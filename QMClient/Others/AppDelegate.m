//
//  AppDelegate.m
//  QMClient
//
//  Created by Lotus on 15/7/22.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "AppDelegate.h"

#import "QMTabbarController.h"

#import "NSDate+CQ.h"

//#import "QMRegisterAndLoginController.h"
//#import "QMNavigationController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] ;
    
    QMTabbarController * tabbarController = [[QMTabbarController alloc] init] ;
    self.window.rootViewController = tabbarController ;
    
    /*
    // 创建登录\注册界面
    QMRegisterAndLoginController * rlVc = [[QMRegisterAndLoginController alloc] init] ;
    UINavigationController * navVc = [[UINavigationController alloc] initWithRootViewController:rlVc] ;
    self.window.rootViewController = navVc ;
    */
    
    
    [QM_USERDEFAULT setBool:NO forKey:QM_USERDEFAULT_ISLOGIN] ;
    
    
    NSDateFormatter * datefor = [[NSDateFormatter alloc] init] ;
    datefor.dateFormat = @"HH:mm" ;
//    NSLog(@"%@" , [datefor stringFromDate:[NSDate timeWithNumber : 48]]) ;
    NSDate * date = [datefor dateFromString:@"00:30"] ;
    
    

    [self.window makeKeyAndVisible] ;
    
    
    
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
