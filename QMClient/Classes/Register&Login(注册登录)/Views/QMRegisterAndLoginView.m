//
//  QMRegisterAndLoginView.m
//  QMClient
//
//  Created by Lotus on 15/7/28.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMRegisterAndLoginView.h"

#import "MMPlaceHolder.h"

@interface QMRegisterAndLoginView ()

/**
 *  动画的高度约束
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
    
    
    [self showPlaceHolderWithAllSubviews] ;
    [self hidePlaceHolder] ;
}

@end
