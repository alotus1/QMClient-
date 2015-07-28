//
//  QMRegisterAndLoginController.m
//  QMClient
//
//  Created by Lotus on 15/7/22.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMRegisterAndLoginController.h"

#import "QMTabbarController.h"
#import "QMRegisterAndLoginView.h"
#import "AppDelegate.h"

@interface QMRegisterAndLoginController ()

@property (weak , nonatomic) QMRegisterAndLoginView * registerView ;

@end

@implementation QMRegisterAndLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录" ;
    
    // 添加通知监听 , 监听键盘的弹出
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter] ;
    [notificationCenter addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil] ;
    [notificationCenter addObserver:self selector:@selector(hiddenKeyBoard:) name:UIKeyboardWillHideNotification object:nil] ;
    
    
    __weak typeof(self) vc = self ;
    [self.registerView setBrowseBlock:^{
        
        [vc browse] ;
    }] ;
    
    [self.registerView setLoginBlock:^(NSString *phoneNumber, NSString *verifiedNumber) {
        
        [vc login] ;
    }] ;
    
    
}

/**
 *  更改注册界面的frame
 */
- (void) showKeyboard : (NSNotification *) notification {

//    NSLog(@"%@" , notification) ;
    CGRect keyBoardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] ;
    CGRect frame = self.registerView.frame ;
    frame.origin.y = - keyBoardFrame.size.height ;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.registerView.frame = frame ;
    }] ;
    
}


- (void) hiddenKeyBoard : (NSNotification *) notification {

    CGRect frame = self.registerView.frame ;
    frame.origin.y = 0 ;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.registerView.frame = frame ;
    }] ;

}

- (void)loadView {

    [super loadView] ;
    
    
    QMRegisterAndLoginView * registerView = [QMRegisterAndLoginView registerAndLoginView] ;
    registerView.frame = self.view.bounds ;
    [self.view addSubview:registerView] ;
    self.registerView = registerView ;
}


- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated] ;
    
    [self.registerView loadGif] ;
}

/**
 *  登录
 */
- (void) login {

    // 1.发送网络请求
    
    // 2.根据网络验证手机号和验证码是否合理
    
    // 3.登录,或者提示用户重新输入电话\验证码
    
}

/**
 *  浏览
 */
- (void) browse {
    
    __weak typeof(self) vc = self ;
    
    // 2.验证成功则跳转到主页
    QMTabbarController * tabbarController = [[QMTabbarController alloc] init] ;
    
    [self presentViewController:tabbarController animated:YES completion:^{
        
        AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate ;
        appDelegate.window.rootViewController = tabbarController ;
        // 在这里要保证登录界面销毁
        [vc removeFromParentViewController] ;
    }] ;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#warning 这里内存泄露
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
