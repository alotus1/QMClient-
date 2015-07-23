//
//  QMDoctorViewController.m
//  QMClient
//
//  Created by Lotus on 15/7/22.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMDoctorViewController.h"

#import "QMAppointmentViewController.h"
#import "QMRegisterAndLoginController.h"

@interface QMDoctorViewController ()

@end

@implementation QMDoctorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"医生详情" ;

    UIButton * button = [UIButton buttonWithType:UIButtonTypeContactAdd] ;
    button.center = CGPointMake(100, 100) ;
    [button addTarget:self action:@selector(btnTouch) forControlEvents:UIControlEventTouchUpInside] ;
    [self.view addSubview:button] ;
}


- (void) btnTouch {
    
    // 如果用户未登录则弹出登录界面
    if (!QM_GETLOGINSTATUS) {
        
        QMRegisterAndLoginController * rlVc = [[QMRegisterAndLoginController alloc] init] ;
        UINavigationController * navVc = [[UINavigationController alloc] initWithRootViewController:rlVc] ;
        [self presentViewController:navVc animated:YES completion:nil] ;

    }
    
    // 1.创建医生详情页面
    QMAppointmentViewController * appointmentVc = [[QMAppointmentViewController alloc] init] ;
    
    // 2.进入医生详情页面
    [self.navigationController pushViewController:appointmentVc animated:YES] ;
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
