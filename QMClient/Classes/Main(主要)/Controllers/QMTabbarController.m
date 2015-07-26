//
//  QMTabbarController.m
//  QMClient
//
//  Created by Lotus on 15/7/22.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMTabbarController.h"

#import "QMClinicViewController.h"
#import "QMMeViewController.h"
#import "QMHomeViewController.h"

#import "QMNavigationController.h"


@interface QMTabbarController ()

@end

@implementation QMTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    QMHomeViewController * homeVc = [[QMHomeViewController alloc] init] ;
    [self addChildViewController:homeVc title:@"主页" image:@"tabbar_home" selectedImage:@""] ;
    
    QMClinicViewController * clinicVc = [[QMClinicViewController alloc] init] ;
    [self addChildViewController:clinicVc title:@"诊所" image:@"tabbar_clinic" selectedImage:@""] ;
    
    QMMeViewController * meVc = [[QMMeViewController alloc] init] ;
    [self addChildViewController:meVc title:@"我" image:@"tabbar_me" selectedImage:@""] ;
    

}

- (void)loadView {
    
    [super loadView] ;
    
    
}

- (void) addChildViewController:(UIViewController *)childController title : (NSString *) title image : (NSString *) imageName selectedImage : (NSString *) selectedImage {

    
    QMNavigationController * nav = [[QMNavigationController alloc] initWithRootViewController:childController] ;
    childController.title = title ;
    childController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ;
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ;
    
    [self addChildViewController:nav] ;
    
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
