//
//  QMAppointmentDay.h
//  AppointmentView
//
//  Created by Lotus on 15/7/21.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  医生一天中每个时间段的预约信息模型
 */

@interface QMAppointmentDay : NSObject

/**
 *  预约的开始时间
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
 *  预约时间对应的预约状态
 */
@property (copy , nonatomic) NSString * status ;

@end
