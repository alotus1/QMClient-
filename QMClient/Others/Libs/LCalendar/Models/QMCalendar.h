//
//  QMCalendar.h
//  CustomCalendar
//
//  Created by 袁偲￼琦 on 15/7/15.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  日历中每天的模型
 */
@interface QMCalendar : NSObject

/**
 *  日期,如果为-1则显示不同的样式
 */
@property (assign , nonatomic) NSInteger day ;

/**
 *  是否是用户选中的日期
 */
@property (assign , nonatomic) BOOL isSelectedDay ;

/**
 *  是否是用户已经预约的日期
 */
@property (assign , nonatomic) BOOL isAppointedDay ;

/**
 *  记录这个cell的日期
 */
@property (strong , nonatomic) NSDate * date ;

/**
 *  显示这个日期的字体颜色
 */
@property (strong , nonatomic) UIColor * dayColor ;



@end
