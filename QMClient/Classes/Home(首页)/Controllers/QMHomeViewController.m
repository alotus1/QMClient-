//
//  QMHomeViewController.m
//  QMClient
//
//  Created by Lotus on 15/7/22.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMHomeViewController.h"


#import "QMRegisterAndLoginController.h"

@interface QMHomeViewController ()

@end

@implementation QMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor greenColor] ;
    
    
    /*
    // 判断是否登录,如果未登录则modal登录界面
    if (!QM_GETLOGINSTATUS) {
        // 未登录
        QMRegisterAndLoginController * rlVc = [[QMRegisterAndLoginController alloc] init] ;
        [self presentViewController:rlVc animated:YES completion:nil] ;
    }
    */
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
