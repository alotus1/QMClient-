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
 *  预约"日"
 */
@property (assign , nonatomic) NSInteger day ;
/**
 *  预约"月"
 */
@property (assign , nonatomic) NSInteger month ;
/**
 *  预约"年"
 */
@property (assign , nonatomic) NSInteger year ;
/**
 *  预约时间段
 */
@property (assign , nonatomic) NSInteger appointHour ;
/**
 *  预约编号
 */
@property (assign , nonatomic) NSInteger identity ;

/**
 *  预约的医生id
 */
@property (copy , nonatomic) NSString * doctorId ;

- (instancetype)initWithDict : (NSDictionary *) dict ;
+ (instancetype) appointmentWithDict : (NSDictionary *) dict ;
//+ (instancetype) appointmentWithId : (NSInteger) identity year : (NSInteger) year month : (NSInteger) month day : (NSInteger) day appointHour : (NSInteger) appointHour ;

@end
