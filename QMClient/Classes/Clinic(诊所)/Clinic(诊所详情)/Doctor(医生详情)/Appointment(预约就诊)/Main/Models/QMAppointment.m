//
//  QMAppointment.m
//  AppointmentView
//
//  Created by Lotus on 15/7/20.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMAppointment.h"


@implementation QMAppointment

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict] ;
    }
    return self ;
}

+ (instancetype)appointmentWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict] ;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        _identity = [value integerValue] ;
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%ld", _day];
}


@end
