//
//  QMRegisterAndLoginController.m
//  QMClient
//
//  Created by Lotus on 15/7/22.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMRegisterAndLoginController.h"

#import "QMTabbarController.h"
#import "AppDelegate.h"

@interface QMRegisterAndLoginController ()

@end

@implementation QMRegisterAndLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录" ;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeContactAdd] ;
    button.center = CGPointMake(100, 100) ;
    [button addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside] ;
    [self.view addSubview:button] ;
}

/**
 *  登录
 */
- (void) login {

    // 1.在这里发送登录的网络请求,验证用户的登录密码等等
    
    
    // 2.验证成功则跳转到主页
    QMTabbarController * tabbarController = [[QMTabbarController alloc] init] ;
    [self presentViewController:tabbarController animated:YES completion:^{
    
        AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate ;
        appDelegate.window.rootViewController = tabbarController ;
#warning 在这里要保证登录界面销毁
    }] ;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    NSLog(@"dealloc") ;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
