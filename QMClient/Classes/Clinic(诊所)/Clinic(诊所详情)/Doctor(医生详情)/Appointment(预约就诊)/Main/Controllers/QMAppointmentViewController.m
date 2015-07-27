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

#import "RequestURL.h"
#import "AFHTTPRequestOperationManager.h"
#import "QMDataBaseManager.h"

// 医生预约的时间间隔
#define QM_TIMEINTERVAL 30 * 60

@interface QMAppointmentViewController () <UIAlertViewDelegate>

/**
 *  预约视图
 */
@property (weak , nonatomic) QMAppointmentView * appointmentView ;

//@property (strong , nonatomic) NSArray * datas ;
//
//@property (strong , nonatomic) NSArray * dayDatas ;
//
///**
// *  医生当月中每天的预约信息
// */
//@property (strong , nonatomic) NSArray * monthDatas ;

/**
 *  预约信息模型对象
 */
@property (strong , nonatomic) QMAppointment * appointment ;


/**
 *  可以预约的起始时间
 */
@property (strong , nonatomic) NSDate * startDate ;

/**
 *  可以预约的结束时间
 */
@property (strong , nonatomic) NSDate * endDate ;

/**
 *  时间格式设置(格式为HH:mm:ss)
 */
@property (strong , nonatomic) NSDateFormatter * dateFormatter ;



/**
 *  用户选择的预约时间,保存成一个全局的变量
 */
@property (strong , nonatomic) QMAppointmentHour * appointmentHour ;

/**
 *  预约\取消预约的URL地址

@property (copy , nonatomic) NSString * appointURL ;
 */

/**
 *  发送预约请求的类型 预约和取消预约
 */
@property (assign , nonatomic) QMAppointmentViewSendAppointRequestType requestType ;


@end

@implementation QMAppointmentViewController
// 假数据
/*
- (NSArray *)monthDatas {

    if (_monthDatas == nil) {
        
        NSMutableArray * datas = [NSMutableArray array] ;
        for (int i = 0 ; i < 50; i++) {
        
            QMAppointmentDay * appointmentDay = [[QMAppointmentDay alloc] init] ;
            appointmentDay.day = [NSString stringWithFormat:@"%d" , i] ;
            appointmentDay.day_status = i % 2 ? 1 : 0 ;
            
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
            QMAppointmentHour * appointmentHour = [[QMAppointmentHour alloc] init] ;
            //            dayAppointment.hour = @"10" ;
            
            // 中间空出1个小时的时间
            if ([date compare:[self.dateFormatter dateFromString:@"12:00:00"]] >= NSOrderedSame && [date compare:[self.dateFormatter dateFromString:@"13:00:00"]] < NSOrderedSame) {
//                continue ;
                appointmentHour.hourStatus = QMAppointmentHourStatusRest ;
            } else
                appointmentHour.hourStatus = i++ % 3 + 1 ;
            
            if (appointmentHour.hourStatus == QMAppointmentHourStatusRest) {
                continue ;
            }
#warning 打印的时候时间是GMT时间,但是这里获取到的时间是设置的正常时间
            NSString * timeString = [NSString stringWithFormat:@"%@ %@" , [self.dateFormatter stringFromDate:date] , [self.dateFormatter stringFromDate:[date dateByAddingTimeInterval:QM_TIMEINTERVAL]]] ;
            appointmentHour.endTime = [self.dateFormatter stringFromDate:[date dateByAddingTimeInterval:QM_TIMEINTERVAL]] ;
            appointmentHour.startTime = [self.dateFormatter stringFromDate:date] ;
            
#warning 使用模型,装载开始的时间等参数
            [datas addObject:appointmentHour] ;
        }
        
        _dayDatas = datas ;
        
    }
    return _dayDatas ;
}
*/

- (void) setupTime {
    
    /***设置起始\结束时间****/
    
    self.dateFormatter = [[NSDateFormatter alloc] init] ;
    NSLocale * local = [NSLocale systemLocale] ;
    [self.dateFormatter setLocale:local] ;
    
    [self.dateFormatter setDateFormat:@"HH:mm:ss"];
    //    NSDate* startDate = [[dateformatter dateFromString:@"10:00:00"] currentZoneDate];
    //
    //    NSDate * endDate = [[dateformatter dateFromString:@"18:00:00"] currentZoneDate] ;
    
    self.startDate = [self.dateFormatter dateFromString:@"00:00:00"] ;
    self.endDate = [self.dateFormatter dateFromString:@"23:30:00"] ;
    
    
    /***设置起始\结束时间****/
}

/**
 *  这里的数据是医生自己规定自己当天的出诊时间的数据

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
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"预约就诊" ;
    
    __weak typeof(self) vc = self ;
    QMAppointmentView * appointmentView = [[QMAppointmentView alloc] init] ;
    self.appointmentView = appointmentView ;
    // 数据传递
    [self setupTime] ;
//    appointmentView.appointments = self.datas ;
//    appointmentView.dayAppointments = self.dayDatas ;
//    appointmentView.monthAppointments = self.monthDatas ;
    [self sendRequestForHoursAppointmentDataWithDate:[NSDate date]] ;
    [self sendRequestForDaysAppointmentDataWithDate:[NSDate date]] ;
    [appointmentView setWantNewDateAppointmentInformation:^(NSDate *date) {
#warning 网络请求date日期下每个时间段的预约信息
//        NSLog(@"请求 %@每个时间段的预约信息" , date) ;
        [vc sendRequestForHoursAppointmentDataWithDate : date] ;
    }] ;
    
    // 发送预约请求信息
    [appointmentView setSendAppointmentRequest:^(QMAppointmentHour *appointmentHour , NSDate * selectedDate , QMAppointmentViewSendAppointRequestType requestType) {
        
        // 这里将开始的时间与日期拼接一下
        selectedDate = [NSDate dateWithDate:selectedDate time:appointmentHour.startTime] ;
        // 在这里将时间存储到预约时间段的模型中
        appointmentHour.appointmentDate = selectedDate ;
        
        vc.appointmentHour = appointmentHour ;
        vc.requestType = requestType ;
        
        
        // 获取预约参数
        NSInteger timeNumber = [appointmentHour.appointmentDate numberForCurrentDate] ;
        NSInteger year = [appointmentHour.appointmentDate yearForDate] ;
        NSInteger month = [appointmentHour.appointmentDate monthForDate] ;
        NSInteger day = [appointmentHour.appointmentDate dayForDate] ;
        NSDictionary * appointmentDict = @{@"year": @(year) , @"month" : @(month), @"day" : @(day), @"appointHour" : @(timeNumber) , @"doctorId" : @(1)} ;
        
        self.appointment = [QMAppointment appointmentWithDict:appointmentDict] ;

        [vc showAlertViewWithRequestType:requestType] ;
    }] ;
    
    // 切换月份的时候需要重新进行网络请求
    [appointmentView setChangeMonthBlock:^(NSDate *date) {
        
        [vc sendRequestForDaysAppointmentDataWithDate:date] ;
        [vc sendRequestForHoursAppointmentDataWithDate:date] ;
    }] ;
    [self.view addSubview:appointmentView] ;
    
    
    
}

- (void) showAlertViewWithRequestType : (QMAppointmentViewSendAppointRequestType) requestType {
    
#warning 在这里将两个接口的URL地址设定好,调用的时候直接请求URL
//    self.appointURL = requestType == QMAppointmentViewSendAppointRequestTypeAppoint ? @"预约接口" : @"取消预约接口" ;
    // 预约提示
    NSString * appointString = [NSString stringWithFormat:@"您预约了%@%@-%@在青苗儿童口腔门诊部由黄晓明医生进行复诊。我们会提前一天给您发送提醒信息，请准时到店，如需取消请提前24小时取消." , [self.appointmentHour.appointmentDate stringWithChineseDateFormatter] , self.appointmentHour.startTime , self.appointmentHour.endTime] ;
#warning 在取消预约的时候需要进行判断,是否已经超过了可以取消预约的时限(24小时),如果当前系统的时间与预约的时间相差大于24小时则可以取消预约,如果该时限小于24小时,则提示用户不可以取消预约,需要与医生联系
    // 取消预约提示判断
    NSString * cancelString = nil ;
    if (requestType == QMAppointmentViewSendAppointRequestTypeCancel) {
        if ([self canCancelAppointment]) {
            // 可以取消预约
            cancelString = [NSString stringWithFormat:@"您确定要取消%@%@-%@在青苗儿童口腔门诊部由黄晓明医生进行的复诊吗？",[self.appointmentHour.appointmentDate stringWithChineseDateFormatter] , self.appointmentHour.startTime , self.appointmentHour.endTime] ;
        } else {
            // 不可以取消预约
            cancelString = @"亲爱的用户，为了不影响医生的整体安排，我们的预约需要提前24小时取消，目前已超出取消期限，如果您确定要取消请与医生联系，需要他手动取消感谢您的支持。" ;
            // 在这里将URL置为空,在请求的时候需要进行判断 ,URL为空的时候则不进行网络请求
//            self.appointURL = nil ;
        }
    }
    
    
    NSString * tipString = requestType == QMAppointmentViewSendAppointRequestTypeAppoint ? appointString : cancelString ;
    
    NSString * title= requestType == QMAppointmentViewSendAppointRequestTypeAppoint ? @"预约" : @"取消预约" ;

    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:tipString delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] ;
    [alertView show] ;
    
}

/**
 *  判断是否可以取消预约
 *
 *  @return 返回是否可以取消预约 YES 表示可以取消 NO表示不可以取消
 */
- (BOOL) canCancelAppointment {

    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init] ;
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss" ;
    NSDate * currentDate = [NSDate date] ;
    
    // 预约的时间
    NSString * appointmentDateString = [NSString stringWithFormat:@"%@ %@" , [self.appointmentHour.appointmentDate stringWithoutTime] , self.appointmentHour.startTime] ;
    NSDate * appointmentDate = [dateFormatter dateFromString:appointmentDateString] ;
    
    
//    NSTimeInterval interval = [appointmentDate timeIntervalSinceDate:currentDate] ;
    // 在这里将现在的时间加上24小时,然后再与预约的时间进行比较,如果加上24小时的时间仍然小于预约的时间则是可以取消预约的,否则将不能够取消预约
    BOOL canCancelAppointment = [[currentDate dateByAddingTimeInterval:24 * 3600] compare:appointmentDate] < 0 ;
    

    return canCancelAppointment ;
}

#pragma mark - AlertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
#warning 这里是点击了确定要预约之后,进行网络请求,然后预约医生该时间段
//        NSLog(@"%@ %@" , self.appointmentHour.startTime , [self.appointmentHour.appointmentDate stringWithChineseDateFormatter]) ;
        if (self.requestType == QMAppointmentViewSendAppointRequestTypeAppoint) {
            
            [self sendRequestAddAppointment] ;
        } else if (self.requestType == QMAppointmentViewSendAppointRequestTypeCancel && [self canCancelAppointment]) {
        
            [self sendRequestCancelAppointment] ;
        }
        
    }
}

#pragma mark - 网络请求相关
/**
 *  进行预约请求
 */
- (void) sendRequestAddAppointment {

    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager] ;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer] ;
    
    
    NSString * urlString = [NSString stringWithFormat:QM_URL_ADDAPPOINTMENT , self.appointment.year , self.appointment.month , self.appointment.day , self.appointment.appointHour] ;
//    NSString * urlString = [NSString stringWithFormat:QM_URL_CANCELAPPOINTMENT , (NSInteger)15] ;
//    QMLog(@"%@" , urlString) ;
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError * error ;
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error] ;
        if (error) {
            NSLog(@"jsonError %@" , error) ;
        }
        
        
        NSDictionary * dataDict = jsonDict[@"data"] ;
        if ([jsonDict[@"code"] integerValue] != 1000) {
            
            QMLog(@"预约失败") ;
        } else {
        
            QMLog(@"预约成功") ;
            // 在这里将这次预约的信息添加到数据库中
//#warning 这里要查看返回的是什么键
            self.appointment.identity = [dataDict[@"id"] integerValue] ;
            // 预约成功后更改预约的状态为该用户已经预约
            self.appointmentHour.hourStatus = QMAppointmentHourStatusAlreadyAppointedByMe ;
            // 将数据存到数据库中
            [QMDataBaseManager insertModel:self.appointment inDatabase:[[NSUserDefaults standardUserDefaults] valueForKey:QM_USERDEFAULTS_DATABASEPATH] andTable:QM_USERDEFAULTS_APPOINTTABLE] ;
            // 通知tableView刷新表格状态,将该行改成已经预约
            NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter] ;
            [notificationCenter postNotificationName:QM_NOTIFICATION_RELOADDATA object:nil] ;

        }
        QMLog(@"%@" , jsonDict) ;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"fail %@" , error) ;
    }] ;
}

- (void) sendRequestCancelAppointment {

    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager] ;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer] ;
    
    // 去数据库中查询预约id
    NSInteger appointId = [QMDataBaseManager selectAppointIdWithAppointment:self.appointment] ;
    
    NSString * urlString = [NSString stringWithFormat:QM_URL_CANCELAPPOINTMENT , appointId] ;
    NSLog(@"%@" , urlString) ;
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError * error ;
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error] ;
        if (error) {
            NSLog(@"jsonError %@" , error) ;
        }
        
        if ([jsonDict[@"code"] integerValue] == 1000) {
            
            QMLog(@"取消预约成功") ;
            // 从网络重新请求数据,刷新当天每个时段最新的预约信息
            [self sendRequestForHoursAppointmentDataWithDate:self.appointmentHour.appointmentDate] ;
        } else {
        
            
            QMLog(@"取消预约失败") ;
        }
        
        
        
        QMLog(@"jsonDict %@" , jsonDict) ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"fail %@" , error) ;
    }] ;
    
}

/**
 *  请求每个不同日期当天每个时间段的预约信息
 */
- (void) sendRequestForHoursAppointmentDataWithDate : (NSDate *) date {
    
//    QMLog(@"请求%@ 日期下的预约信息   " , date) ;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager] ;
    //此处设置后返回的默认是NSData的数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    QMAppointmentHour * appointmentHour = self.appointmentHour ;
//    NSInteger timeNumber = [appointmentHour.appointmentDate numberForCurrentDate] ;
    NSInteger year = [date yearForDate] ;
    NSInteger month = [date monthForDate] ;
    NSInteger day = [date dayForDate] ;
    
    NSString * urlString = [NSString stringWithFormat:QM_URL_DAYAPPOINTEDDATA , year , month , day] ;
//    NSLog(@"%@" , urlString) ;
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSLog(@"%@" , operation) ;
        
        NSError * error ;
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error] ;
        if (error) {
            NSLog(@"jsonError %@" , error) ;
        }
        
        NSArray * datas = [jsonDict valueForKey:@"data"] ;
        
        NSMutableArray * objs = [NSMutableArray array] ;
                for (NSDictionary * dict in datas) {
            
            QMAppointmentHour * appointmentHour = [QMAppointmentHour appointmentHourWithDict:dict] ;
            
            if (appointmentHour.hourStatus == QMAppointmentHourStatusRest || appointmentHour.hourStatus == QMAppointmentHourStatusUnavilable || appointmentHour.hourStatus == QMAppointmentHourStatusAlreadyAppointedByOthers) {
                continue ;
            }
            appointmentHour.startTime = [self.dateFormatter stringFromDate:[NSDate timeWithNumber:[appointmentHour.hour integerValue]]] ;
            
            NSDate * date = [NSDate dateWithDate:[NSDate date] time:appointmentHour.startTime] ;
            appointmentHour.endTime = [self.dateFormatter stringFromDate:[date dateByAddingTimeInterval:QM_TIMEINTERVAL]] ;
        
            
            [objs addObject:appointmentHour] ;
        }
//        NSLog(@"%@" , objs) ;
        
        self.appointmentView.dayAppointments = objs ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@" , error) ;
    }] ;

}

/**
 *  请求当月每天的预约状态信息
 */
- (void) sendRequestForDaysAppointmentDataWithDate : (NSDate *) date {

    
    QMLog(@"请求医生 %@ 月的预约信息" , date) ;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager] ;
    //此处设置后返回的默认是NSData的数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * urlString = [NSString stringWithFormat:QM_URL_MONTHAPPOINTEDDATA , [date yearForDate] , [date monthForDate] , [date dayForDate]] ;
    NSLog(@"%@ "  , urlString) ;
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError * error ;
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error] ;
        if (error) {
            NSLog(@"%@" , error) ;
        }
        
        NSArray * datas = [jsonDict valueForKey:@"data"] ;
//        NSLog(@"%@" , datas) ;
        
        NSMutableArray * objs = [NSMutableArray array] ;
        for (NSDictionary * dict in datas) {
            QMAppointmentDay * appointmentDay = [QMAppointmentDay appointmentDayWithDict:dict] ;
//            NSLog(@"%lu" , appointmentDay.day_status) ;
            [objs addObject:appointmentDay] ;
        }
        self.appointmentView.monthAppointments = objs ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@" , error) ;
    }] ;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
