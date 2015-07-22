//
//  QMAppointment.h
//  AppointmentView
//
//  Created by Lotus on 15/7/20.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  医生一天的预约信息模型
 */
@interface QMAppointment : NSObject

/**
 *  表示当天日期
 */
@property (copy , nonatomic) NSString * day ;
/**
 *  表示当天医生的状态
 */
@property (copy , nonatomic) NSString * status ;
/**
 *  医生可以预约的起始时间
 */
@property (copy , nonatomic) NSString * startTime ;
/**
 *  医生可以预约的结束时间
 */
@property (copy , nonatomic) NSString * endTime ;



@end
