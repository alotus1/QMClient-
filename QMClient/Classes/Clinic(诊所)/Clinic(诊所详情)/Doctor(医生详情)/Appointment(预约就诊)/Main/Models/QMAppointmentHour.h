//
//  QMAppointmentHour.h
//  AppointmentView
//
//  Created by Lotus on 15/7/21.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QMAppointmentHourStatus) {
    QMAppointmentHourStatusAvailable,
    QMAppointmentHourStatusUnavilable,
    QMAppointmentHourStatusFull,
    QMAppointmentHourStatusAlreadyAppointed
};

/**
 *  医生一天中每个时间段的预约信息模型
 */

@interface QMAppointmentHour : NSObject

/**
 *  预约的开始时间(这个可以存放后来传来的表示时间段的数字,往后发送预约请求的时候就可以不用再计算)
 */
@property (copy , nonatomic) NSString * hour ;

/**
 *  预约的结束时间(以00:00:00格式表示的时间字符串)
 */
@property (copy , nonatomic) NSString * endTime ;

/**
 *  预约的开始时间(以00:00:00格式表示的时间字符串)
 */
@property (copy , nonatomic) NSString * startTime ;

/**
 *  用户预约医生的日期
 */
@property (strong , nonatomic) NSDate * appointmentDate ;

/**
 *  预约时间对应的预约状态
 */
@property (assign , nonatomic) QMAppointmentHourStatus status ;

@end
