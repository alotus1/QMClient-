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



@end
