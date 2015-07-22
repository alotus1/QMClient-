//
//  QMAppointment.m
//  AppointmentView
//
//  Created by Lotus on 15/7/20.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMAppointment.h"


@implementation QMAppointment

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ , startTime %@", _day , _startTime];
}


@end
