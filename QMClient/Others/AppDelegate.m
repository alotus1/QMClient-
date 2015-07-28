//
//  AppDelegate.m
//  QMClient
//
//  Created by Lotus on 15/7/22.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "AppDelegate.h"

#import "QMTabbarController.h"
#import "QMDataBaseManager.h"

#import "NSDate+CQ.h"

#import "QMSandBox.h"

#import "QMRegisterAndLoginController.h"
//#import "QMNavigationController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] ;
    
//    QMTabbarController * tabbarController = [[QMTabbarController alloc] init] ;
//    self.window.rootViewController = tabbarController ;
    

    // 创建登录\注册界面
    QMRegisterAndLoginController * rlVc = [[QMRegisterAndLoginController alloc] init] ;
//    UINavigationController * navVc = [[UINavigationController alloc] initWithRootViewController:rlVc] ;
    self.window.rootViewController = rlVc ;

    
    
    [QM_USERDEFAULT setBool:NO forKey:QM_USERDEFAULT_ISLOGIN] ;
    
    QMUser * user = [QMUser defaultUser] ;
    user.phoneNumber = @"1" ;
    
    // 更改状态栏的样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent ;
    
    

    [self.window makeKeyAndVisible] ;
    
    [self createDatabase] ;
    [self syncAppointmentInfo] ;
    NSLog(@"%@" , [QMSandBox pathForDocuments]) ;
    
    
    return YES;
}

/**
 *  从后台数据库同步当前用户的预约信息
 */
- (void) syncAppointmentInfo {
#warning 这里从后台同步用户的预约信息后,将用户当前有效的预约信息取出,存放在用户的appointedDate中,默认以后每次从QMUser中取出的都是用户当前有效的预约信息
    
}
- (void) createDatabase {

    // 创建项目数据库
    // CREATE TABLE appointment ( id integer primary key , year integer not null , month integer not null , day integer not null,doctorId text  not null, userId text not null) ;
    NSString * databasePath = [QMDataBaseManager createDataBaseWithDataBaseName:@"QMClient"] ;
    
    // 创建预约表
    NSString * sql = [NSString stringWithFormat:@"CREATE TABLE %@ ( id integer primary key , year integer not null , month integer not null , day integer not null,doctorId text not null, hour integer not null) ;" , QM_USERDEFAULTS_APPOINTTABLE] ;
    [QMDataBaseManager createTableInDataBase:databasePath andSql:sql andDefaultsKey:QM_USERDEFAULTS_APPOINTEXIST] ;
    
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
