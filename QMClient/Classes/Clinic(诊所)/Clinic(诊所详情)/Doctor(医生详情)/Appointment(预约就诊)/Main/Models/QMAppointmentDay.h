//
//  QMAppointmentDay.h
//  AppointmentView
//
//  Created by Lotus on 15/7/22.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QMAppointmentDayStatus) {
    QMAppointmentDayStatusEnable,
    QMAppointmentDayStatusDisable
};

/**
 *  医生一个月中每天的预约信息
 */
@interface QMAppointmentDay : NSObject

/**
 *  日期
 */
@property (copy , nonatomic) NSString * day ;

/**
 *  当日医生的预约状态
 */
@property (assign , nonatomic) QMAppointmentDayStatus status ;




@end
