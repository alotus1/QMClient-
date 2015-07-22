//
//  QMAppointmentViewController.m
//  QMClient
//
//  Created by Lotus on 15/7/22.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMAppointmentViewController.h"
#import "QMAppointmentView.h"

#import "QMAppointment.h"
#import "QMAppointmentDay.h"

// 医生预约的时间间隔
#define QM_TIMEINTERVAL 30 * 60

@interface QMAppointmentViewController ()

@property (strong , nonatomic) NSArray * datas ;

@property (strong , nonatomic) NSArray * dayDatas ;


/**
 *  可以预约的起始时间
 */
@property (strong , nonatomic) NSDate * startDate ;

/**
 *  可以预约的结束时间
 */
@property (strong , nonatomic) NSDate * endDate ;

/**
 *  时间格式设置
 */
@property (strong , nonatomic) NSDateFormatter * dateFormatter ;

@end

@implementation QMAppointmentViewController

- (NSArray *)dayDatas {
    
    if (_dayDatas == nil) {
        
        [self setupTime] ;
        
        
        NSMutableArray * datas = [NSMutableArray array] ;
        
        for (NSDate * date = self.startDate; [date compare:self.endDate]; date = [date dateByAddingTimeInterval:QM_TIMEINTERVAL]) {
            QMAppointmentDay * dayAppointment = [[QMAppointmentDay alloc] init] ;
            //            dayAppointment.hour = @"10" ;
            
            // 中间空出1个小时的时间
            if ([date compare:[self.dateFormatter dateFromString:@"12:00:00"]] >= NSOrderedSame && [date compare:[self.dateFormatter dateFromString:@"13:00:00"]] < NSOrderedSame) {
                continue ;
            }
#warning 打印的时候时间是GMT时间,但是这里获取到的时间是设置的正常时间
            NSString * timeString = [NSString stringWithFormat:@"%@ %@" , [self.dateFormatter stringFromDate:date] , [self.dateFormatter stringFromDate:[date dateByAddingTimeInterval:QM_TIMEINTERVAL]]] ;
            dayAppointment.endTime = [self.dateFormatter stringFromDate:[date dateByAddingTimeInterval:QM_TIMEINTERVAL]] ;
            dayAppointment.startTime = [self.dateFormatter stringFromDate:date] ;
            dayAppointment.status = @"1" ;
#warning 使用模型,装载开始的时间等参数
            [datas addObject:dayAppointment] ;
        }
        
        _dayDatas = datas ;
        
    }
    return _dayDatas ;
}

- (void) setupTime {
    
    /***设置起始\结束时间****/
    
    self.dateFormatter = [[NSDateFormatter alloc] init] ;
    NSLocale * local = [NSLocale systemLocale] ;
    [self.dateFormatter setLocale:local] ;
    
    [self.dateFormatter setDateFormat:@"HH:mm:ss"];
    //    NSDate* startDate = [[dateformatter dateFromString:@"10:00:00"] currentZoneDate];
    //
    //    NSDate * endDate = [[dateformatter dateFromString:@"18:00:00"] currentZoneDate] ;
    
    self.startDate = [self.dateFormatter dateFromString:@"10:00:00"] ;
    self.endDate = [self.dateFormatter dateFromString:@"18:00:00"] ;
    
    
    /***设置起始\结束时间****/
}

- (NSArray *)datas {
    
    if (_datas == nil) {
        
        NSMutableArray * datas = [NSMutableArray array] ;
        
        for (int i = 0; i < 100; i++) {
            
            QMAppointment * ap1 = [[QMAppointment alloc] init] ;
            ap1.day = @"20" ;
            ap1.status = @"YES" ;
            ap1.startTime = @"10" ;
            ap1.endTime = @"18" ;
            
            QMAppointment * ap2 = [[QMAppointment alloc] init] ;
            ap2.day = @"21" ;
            ap2.status = @"YES" ;
            ap2.startTime = @"12" ;
            ap2.endTime = @"18" ;
            
            [datas addObject:ap1] ;
            [datas addObject:ap2] ;
        }
        _datas = datas ;
    }
    return _datas ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    QMAppointmentView * appointmentView = [[QMAppointmentView alloc] init] ;
    // 数据传递
    appointmentView.appointments = self.datas ;
    appointmentView.dayAppointments = self.dayDatas ;
    [appointmentView setWantNewDateAppointmentInformation:^(NSDate *date) {
#warning 网络请求date日期下每个时间段的预约信息
        NSLog(@"newDate %@" , date) ;
    }] ;
    [self.view addSubview:appointmentView] ;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
