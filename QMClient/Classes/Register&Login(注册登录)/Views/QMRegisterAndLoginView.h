//
//  QMRegisterAndLoginView.h
//  QMClient
//
//  Created by Lotus on 15/7/28.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QMRegisterAndLoginView : UIView


+ (instancetype) registerAndLoginView ;

- (void) loadGif ;


/**
 *  当浏览按钮按下之后,通知控制器进行跳转
 */
@property (copy , nonatomic) void(^browseBlock)() ;

@end
