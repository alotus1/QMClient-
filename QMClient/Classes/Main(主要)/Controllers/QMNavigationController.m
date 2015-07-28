//
//  QMNavigationController.m
//  QMClient
//
//  Created by Lotus on 15/7/22.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMNavigationController.h"

@interface QMNavigationController ()

@end

@implementation QMNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

+ (void)initialize {
    
    UINavigationBar * navBar = [UINavigationBar appearance] ;
    
    // 设置背景颜色
    NSString * bgImage = @"nav_back" ;
    [navBar setBackgroundImage:[UIImage imageNamed:bgImage] forBarMetrics:UIBarMetricsDefault] ;
    
    NSDictionary * attrs = @{NSForegroundColorAttributeName : [UIColor whiteColor] ,
                             NSFontAttributeName : [UIFont systemFontOfSize:18]} ;
    [navBar setTitleTextAttributes:attrs] ;
    
    
    // 设置button主题
    UIBarButtonItem * item = [UIBarButtonItem appearance] ;
    NSDictionary * itemAttrs = @{NSForegroundColorAttributeName : [UIColor whiteColor] ,
                                 NSFontAttributeName : [UIFont systemFontOfSize:16]} ;
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal] ;
    
    // 设置navigation的渲染颜色
    navBar.tintColor = [UIColor whiteColor] ;
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    //在这里加判断 ,主页的都不用隐藏,子页面隐藏
    if (self.childViewControllers.count > 0) {
        
        viewController.hidesBottomBarWhenPushed = YES ;
    }
    [super pushViewController:viewController animated:animated] ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
