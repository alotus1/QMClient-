//
//  QMClinicViewController.m
//  QMClient
//
//  Created by Lotus on 15/7/22.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMClinicViewController.h"

#import "QMClinicDetailViewController.h"


@interface QMClinicViewController ()

@end

@implementation QMClinicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor] ;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeContactAdd] ;
    button.center = CGPointMake(100, 100) ;
    [button addTarget:self action:@selector(btnTouch) forControlEvents:UIControlEventTouchUpInside] ;
    [self.view addSubview:button] ;
}


- (void) btnTouch {

    // 1.创建医生详情页面
    QMClinicDetailViewController * doctorVc = [[QMClinicDetailViewController alloc] init] ;
    
    // 2.进入医生详情页面
    [self.navigationController pushViewController:doctorVc animated:YES] ;
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
