//
//  QMAppointmentView.h
//  AppointmentView
//
//  Created by 袁偲￼琦 on 15/7/17.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  预约视图
 */
@interface QMAppointmentView : UIView


/**
 *  预约信息模型数组(QMAppointment模型对象)
 *
 */
@property (strong , nonatomic) NSArray * appointments ;

/**
 *  当天中每个时间段的预约信息
 */
@property (strong , nonatomic) NSArray * dayAppointments ;

/**
 *  切换月份的时候进行的操作
 *  block中的参数为请求的日期信息
 */
@property (copy , nonatomic) void(^changeMonthBlock)(NSDate * date) ;

/**
 *  选择的日期更改后,通知控制器根据日期进行网络请求
 */
@property (copy , nonatomic) void(^wantNewDateAppointmentInformation)(NSDate * date) ;

//- (void) changeAppointmentTime : (QMAppointmentView *) appointmentView changeMonthBlock : 


@end
