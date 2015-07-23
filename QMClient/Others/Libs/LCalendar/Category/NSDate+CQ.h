//
//  NSDate+CQ.h
//  CustomCalendar
//
//  Created by 袁偲￼琦 on 15/7/16.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CQ)

/**
 *  date中的几号
 */
@property (assign , nonatomic) NSInteger day ;

/**
 *  返回当前时区的时间
 */
+ (NSDate *) currentDate ;

/**
 *  对象方法
 *
 *  @param date 需要转换成当前时区时间的日期
 *
 *  @return 返回当前时区的时间
 */
- (NSDate *) currentZoneDate ;


/**
 *  获得格式为"yyyy年mm月dd日"的字符串
 *
 *  @return 返回格式为"yyyy年mm月dd日"的字符串
 */
- (NSString *) stringWithChineseDateFormatter ;

/**
 *  给定一个1-48的数字,计算表示的时间,以半小时为划分
 *
 *  @param number 给定的数字
 *
 *  @return 返回给定数组对应的48小时的时间划分
 */
+ (NSDate *) timeWithNumber : (NSInteger) number ;




@end
