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
#import "QMAppointmentHour.h"
#import "QMAppointmentDay.h"

#import "NSDate+CQ.h"

// 医生预约的时间间隔
#define QM_TIMEINTERVAL 30 * 60

@interface QMAppointmentViewController () <UIAlertViewDelegate>

@property (strong , nonatomic) NSArray * datas ;

@property (strong , nonatomic) NSArray * dayDatas ;

/**
 *  医生当月中每天的预约信息
 */
@property (strong , nonatomic) NSArray * monthDatas ;


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

/**
 *  用户选择的预约时间,保存成一个全局的变量
 */
@property (strong , nonatomic) QMAppointmentHour * appointmentHour ;

@end

@implementation QMAppointmentViewController

- (NSArray *)monthDatas {

    if (_monthDatas == nil) {
        
        NSMutableArray * datas = [NSMutableArray array] ;
        for (int i = 0 ; i < 50; i++) {
        
            QMAppointmentDay * appointmentDay = [[QMAppointmentDay alloc] init] ;
            appointmentDay.day = [NSString stringWithFormat:@"%d" , i] ;
            appointmentDay.status = i % 2 ? 1 : 0 ;
            
            [datas addObject:appointmentDay] ;
            
        }
        _monthDatas = datas ;
    }
    return _monthDatas ;
}

- (NSArray *)dayDatas {
    
    if (_dayDatas == nil) {
        
        [self setupTime] ;
        
        
        NSMutableArray * datas = [NSMutableArray array] ;
        
        int i = 0 ;
        for (NSDate * date = self.startDate; [date compare:self.endDate]; date = [date dateByAddingTimeInterval:QM_TIMEINTERVAL]) {
            QMAppointmentHour * dayAppointment = [[QMAppointmentHour alloc] init] ;
            //            dayAppointment.hour = @"10" ;
            
            // 中间空出1个小时的时间
            
            if ([date compare:[self.dateFormatter dateFromString:@"12:00:00"]] >= NSOrderedSame && [date compare:[self.dateFormatter dateFromString:@"13:00:00"]] < NSOrderedSame) {
                continue ;
            }
#warning 打印的时候时间是GMT时间,但是这里获取到的时间是设置的正常时间
            NSString * timeString = [NSString stringWithFormat:@"%@ %@" , [self.dateFormatter stringFromDate:date] , [self.dateFormatter stringFromDate:[date dateByAddingTimeInterval:QM_TIMEINTERVAL]]] ;
            dayAppointment.endTime = [self.dateFormatter stringFromDate:[date dateByAddingTimeInterval:QM_TIMEINTERVAL]] ;
            dayAppointment.startTime = [self.dateFormatter stringFromDate:date] ;
            dayAppointment.status = i++ % 4 ;
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

/**
 *  这里的数据是医生自己规定自己当天的出诊时间的数据
 */
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
            ap2.status = @"NO" ;
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
    
    self.title = @"预约就诊" ;
    
    __weak typeof(self) vc = self ;
    QMAppointmentView * appointmentView = [[QMAppointmentView alloc] init] ;
    // 数据传递
//    appointmentView.appointments = self.datas ;
    appointmentView.dayAppointments = self.dayDatas ;
    appointmentView.monthAppointments = self.monthDatas ;
    [appointmentView setWantNewDateAppointmentInformation:^(NSDate *date) {
#warning 网络请求date日期下每个时间段的预约信息
        NSLog(@"newDate %@" , date) ;
    }] ;
    
    [appointmentView setSendAppointmentRequest:^(QMAppointmentHour *appointmentHour , NSDate * selectedDate) {
        
        vc.appointmentHour = appointmentHour ;
        // 在这里将时间存储到预约时间段的模型中
        appointmentHour.appointmentDate = selectedDate ;
        [vc showAlertView] ;
        NSLog(@"预约时间 %@", appointmentHour.startTime) ;
    }] ;
    [self.view addSubview:appointmentView] ;
    
    
    
}

- (void) showAlertView {
    
    NSString * tipString = [NSString stringWithFormat:@"您预约了%@%@-%@在青苗儿童口腔门诊部由黄晓明医生进行复诊。我们会提前一天给您发送提醒信息，请准时到店，如需取消请提前24小时取消." , [self.appointmentHour.appointmentDate stringWithChineseDateFormatter] , self.appointmentHour.startTime , self.appointmentHour.endTime] ;

    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:tipString delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] ;
    [alertView show] ;
    
}

#pragma mark - AlertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
#warning 这里是点击了确定要预约之后,进行网络请求,然后预约医生该时间段
        NSLog(@"%@ %@" , self.appointmentHour.startTime , [self.appointmentHour.appointmentDate stringWithChineseDateFormatter]) ;
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
