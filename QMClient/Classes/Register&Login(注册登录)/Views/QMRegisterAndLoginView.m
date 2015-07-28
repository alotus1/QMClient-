//
//  QMRegisterAndLoginView.m
//  QMClient
//
//  Created by Lotus on 15/7/28.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMRegisterAndLoginView.h"

#import "MMPlaceHolder.h"

#define QM_TIME_PERANIMATION 0.03

@interface QMRegisterAndLoginView () <UITextFieldDelegate>

/**
 *  播放gif动画的imageView
 */
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
/**
 *  浏览一下的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *browseButton;

/**
 *  手机号输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

/**
 *  验证码输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *verifedTextField;

/**
 *  获取验证码按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *verifiedButton;

/**
 *  获取验证码
 *
 *  @param sender 按钮
 */
- (IBAction)getVerifiedNumber:(UIButton *)sender;


/**
 *  登录按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginButtonTouch:(UIButton *)sender;

/**********约束**********/
/**
 *  动画image的高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animationViewHeight;

/**
 *  手机号输入框高度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneTextFieldHeight;

/**
 *  手机号输入框宽度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneTextFieldWidth;

/**
 *  验证码输入框约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yzmTextFieldHeight;

/**
 *  登录按钮约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonWidth;

/**
 *  登录按钮上边距约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonTop;


/*******全局变量********/
/**
 *  计时器
 */
@property (strong , nonatomic) NSTimer * timer ;
/**
 *  时间(当前显示的label时间)
 */
@property (assign , nonatomic) NSInteger time ;


@end

@implementation QMRegisterAndLoginView

+ (instancetype)registerAndLoginView {

    QMRegisterAndLoginView * registerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject] ;
    
    
    return registerView ;
    
}

- (void)awakeFromNib {
    
    // 设置view的背景距离
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_back"]] ;

    // 将距离变成比例的距离
    _animationViewHeight.constant = QM_SCALE_HEIGHT(354) ;
    _phoneTextFieldWidth.constant = QM_SCALE_WIDTH(240) ;
    _loginButtonWidth.constant = QM_SCALE_WIDTH(118) ;
    _loginButtonHeight.constant = QM_SCALE_HEIGHT(44) ;
    _loginButtonTop.constant = QM_SCALE_HEIGHT(87) ;
    
    // 设置浏览一下按钮文字的显示样式
    NSDictionary * attrDict = @{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) , NSFontAttributeName : [UIFont fontWithName:@"HeiTi SC" size:14] , NSForegroundColorAttributeName : [UIColor whiteColor]} ;
    NSAttributedString * attrString = [[NSAttributedString alloc] initWithString:@"浏览一下" attributes:attrDict] ;
    [self.browseButton setAttributedTitle:attrString forState:UIControlStateNormal] ;
    
    self.time = 5 ;
    
}

/**
 *  加载gif图片
 */
- (void) loadGif {
    
    NSMutableArray * animations = [NSMutableArray array] ;
    for (int i = 0; i < 25; i++) {
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d@2x.png" , i + 1] ofType:nil]]];
        //        NSLog(@"%@ %@" , image , [NSString stringWithFormat:@"%d" , i + 1]) ;
        [animations addObject:image] ;
    }
    
    self.gifImageView.animationImages = animations ;
    
    self.gifImageView.animationDuration = QM_TIME_PERANIMATION * animations.count ;
    self.gifImageView.animationRepeatCount = 1 ;
    [self.gifImageView startAnimating] ;
    self.gifImageView.image = [animations lastObject] ;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(QM_TIME_PERANIMATION * animations.count * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.gifImageView.animationImages = nil ;
        
        self.gifImageView.image = [animations lastObject] ;
    });
    animations = nil ;
    
}


- (IBAction)browseButtonTouch:(UIButton *)sender {
    
    if (self.browseBlock) {
        self.browseBlock() ;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    // 手机号为11位的时候才可以点击获取验证码
    self.verifiedButton.enabled = self.phoneTextField.text.length >= 10 ;
    // 两个都不为空,才可以点击登录
    self.loginButton.enabled = (self.phoneTextField.text.length && self.verifedTextField.text.length) ;
    

    
    // 判断是否超过长度
    // string.length的长度为0的时候是删除键
    if (textField == self.verifedTextField) {
        return !string.length || textField.text.length < 5 ;
    } else {
        return !string.length || textField.text.length < 11 ;
    }

}






- (IBAction)getVerifiedNumber:(UIButton *)sender {
    
    sender.enabled = NO ;
    
    [self setVerifiedButtonTitle] ;
    
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countTimer) userInfo:nil repeats:YES] ;
    self.timer = timer ;
}

/**
 *  更新验证码button的显示
 */
- (void) setVerifiedButtonTitle {

    NSString * timeString = [NSString stringWithFormat:@"(%lds)" , self.time--] ;
    [self.verifiedButton setTitle:timeString forState:UIControlStateDisabled] ;
}

- (void) countTimer {

    if (self.time >= 0) {
        [self setVerifiedButtonTitle] ;
    } else {
        [self.verifiedButton setTitle:@"获取验证码" forState:UIControlStateDisabled] ;
        self.verifiedButton.enabled = YES ;
        [self.timer invalidate] ;
        self.timer = nil ;
    }
}


- (IBAction)loginButtonTouch:(UIButton *)sender {
}
@end
