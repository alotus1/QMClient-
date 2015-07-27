//
//  QMAppointmentView.h
//  AppointmentView
//
//  Created by 袁偲￼琦 on 15/7/17.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import <UIKit/UIKit.h>


@class QMAppointmentHour ;

#define QM_NOTIFICATION_RELOADDATA @"appointmentViewReloadData"
#define QM_NOTIFICATION_CALENDARRELOAD @"calendarReload"


typedef NS_ENUM(NSUInteger, QMAppointmentViewSendAppointRequestType) {
    /**
     *  发送请求类型为请求预约
     */
    QMAppointmentViewSendAppointRequestTypeAppoint,
    /**
     *  请求类型为取消预约
     */
    QMAppointmentViewSendAppointRequestTypeCancel
};

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
 *  当月每天的预约信息
 */
@property (strong , nonatomic) NSArray * monthAppointments ;

/**
 *  切换月份的时候进行的操作
 *  block中的参数为请求的日期信息
 */
@property (copy , nonatomic) void(^changeMonthBlock)(NSDate * date) ;

/**
 *  选择的日期更改后,通知控制器根据日期进行网络请求
 */
@property (copy , nonatomic) void(^wantNewDateAppointmentInformation)(NSDate * date) ;


@property (copy , nonatomic) void(^sendAppointmentRequest)(QMAppointmentHour * appointmentHour , NSDate * selectedDate , QMAppointmentViewSendAppointRequestType requestType) ;


@end
