//
//  NSDate+CQ.m
//  CustomCalendar
//
//  Created by 袁偲￼琦 on 15/7/16.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "NSDate+CQ.h"

@implementation NSDate (CQ)

+ (NSDate *)currentDate {

//    NSDate * date = [[NSDate date] currentZoneDate:<#(NSDate *)#>]
    
    return [[NSDate date] currentZoneDate] ;
}

- (NSDate *)currentZoneDate {

    NSTimeZone * zone = [NSTimeZone systemTimeZone] ;
    // 计算时间与zone的时间差
    NSInteger interval = [zone secondsFromGMTForDate:self] ;
    // 重新创建更新时间
    NSDate * newDate = [NSDate dateWithTimeInterval:interval sinceDate:self] ;
    
    return newDate ;
}


- (NSInteger)day {

    // 获取components信息
    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] ;
    
    return components.day ;
}

- (NSString *)stringWithChineseDateFormatter {

    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init] ;
    dateFormatter.dateFormat = @"yyyy年MM月dd日" ;
    return [dateFormatter stringFromDate:self] ;
}

+ (NSDate *)timeWithNumber:(NSInteger)number {

    // 设置时间格式
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init] ;
    dateFormatter.dateFormat = @"HH:mm" ;
    
    // 计算时间间隔
    // 通过字符串获取日期
    NSDate * date = [dateFormatter dateFromString:@"00:00"] ;
    date = [date dateByAddingTimeInterval:(number - 1) * 30 * 60] ;
    
//    NSLog(@"date %@" , [dateFormatter stringFromDate:date]) ;
    
    return date ;
}

@end
