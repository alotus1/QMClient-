//
//  QMAppointmentView.m
//  AppointmentView
//
//  Created by 袁偲￼琦 on 15/7/17.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMAppointmentView.h"

#import "CustomCalendar.h"
#import "QMAppointment.h"

#import "QMAppointmentHour.h"

#import "QMDayAppointmentCell.h"

#import "NSDate+CQ.h"

// 医生预约的时间间隔
#define QM_TIMEINTERVAL 30 * 60

@interface QMAppointmentView () <UITableViewDelegate , UITableViewDataSource>

/**
 *  用来显示当天预约时间段信心的tableView
 */
@property (weak , nonatomic) UITableView * tableView ;

/**
 *  日历视图
 */
@property (weak , nonatomic) CustomCalendar * calendarView ;

/**
 *  预约时间的数据源
 */
@property (strong , nonatomic) NSArray * dataSource ;


/**
 *  可以预约的起始时间

@property (strong , nonatomic) NSDate * startDate ;

/**
 *  可以预约的结束时间

@property (strong , nonatomic) NSDate * endDate ;
 */

/**
 *  当前选择的预约日期
 */
@property (strong , nonatomic) NSDate * selectedDate ;

/**
 *  时间格式设置
 */
@property (strong , nonatomic) NSDateFormatter * dateFormatter ;

@end

@implementation QMAppointmentView

#pragma mark - 数据相关
- (void)setMonthAppointments:(NSArray *)monthAppointments {

    _monthAppointments = monthAppointments ;
    
    // 将数据传递给日历视图
    self.calendarView.monthAppointments = monthAppointments ;
}

- (void)setAppointments:(NSArray *)appointments {

    _appointments = appointments ;
    
    
//    [self settingDataSource : [NSDate date].day] ;
}

- (void)setDayAppointments:(NSArray *)dayAppointments {

    _dayAppointments = dayAppointments ;
    
    [self.tableView reloadData] ;
}


/**
 *  设置tableView的数据源,获得一个数组,数组中有预约的时间信息
 *
 *  @param day 选择的日期,作为获取数据的下标
 */

/*
- (void) settingDataSource : (NSInteger) day {
    
#warning 如果医生自己规定出诊的时间,这个才会用上
 //   QMAppointment * appointment = self.appointments[day] ;
    
    NSMutableArray * times = [NSMutableArray array] ;
#warning 这里是医生自己决定出诊时间的代码
    /*
    for (NSInteger i = [appointment.startTime integerValue]; i <= [appointment.endTime integerValue]; i++) {
        NSString * timeString = [NSString stringWithFormat:@"%ld:00" , i] ;
        [times addObject:timeString] ;
    }
#warning 在控制器中进行网络请求的时候将这个数据填入,每个cell的数据模型为QMAppointmentHour类型
    for (NSDate * date = self.startDate; [date compare:self.endDate]; date = [date dateByAddingTimeInterval:QM_TIMEINTERVAL]) {
//        NSLog(@"%@" , date) ;
        // 中间空出1个小时的时间
        if ([date compare:[self.dateFormatter dateFromString:@"12:00:00"]] >= NSOrderedSame && [date compare:[self.dateFormatter dateFromString:@"13:00:00"]] < NSOrderedSame) {
            continue ;
        }
#warning 打印的时候时间是GMT时间,但是这里获取到的时间是设置的正常时间
        NSString * timeString = [NSString stringWithFormat:@"%@ - %@" , [self.dateFormatter stringFromDate:date] , [self.dateFormatter stringFromDate:[date dateByAddingTimeInterval:QM_TIMEINTERVAL]]] ;
#warning 使用模型,装载开始的时间等参数
        [times addObject:timeString] ;
    }
     
    self.dataSource = times ;
    
    // 刷新表格
    [self.tableView reloadData] ;
}
*/

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor yellowColor] ;
        
        CustomCalendar * calendar = [[CustomCalendar alloc] init] ;
#warning 选择了一个日期之后,需要进行网络请求,获取医生的预约信息,在这里要实现calendar的selectDayItemBlock方法,在控制器中请求数据
        
        __weak typeof(self) viewTmp = self ;
        // 选择日期之后进行的操作
        [calendar setSelectDayItemBlock:^(NSDate *date) {
            // 选择了新的日期之后需要切换预约表格的数据源
            
            // 1.需要获取日期中的"天(day)"
#warning 这里需要根据日期来请求网络数据,让控制器请求
//            [viewTmp settingDataSource : date.day] ;
            if (viewTmp.wantNewDateAppointmentInformation) {
                viewTmp.selectedDate = date ;
                viewTmp.wantNewDateAppointmentInformation(date) ;
            }
            
        }] ;
        
        // 更改月份的时候进行的操作
        [calendar setChangeMonthBlock:^(CustomCalendar *calendar,NSDate * date) {
            
#warning 这里获取到的日期不是正确的日期
//            NSLog(@"%@" , date) ;
            // 月份更改了之后需要通知控制器 , 进行新的网络请求,请求新的一个月的预约数据
            if (self.changeMonthBlock) {

                self.changeMonthBlock(date) ;
            }
        }] ;
        
        
        
        self.calendarView = calendar ;
        __weak typeof(calendar) calTmp = self.calendarView ;
        [calendar setViewHeightChangedBlock:^{
            [viewTmp.tableView beginUpdates] ;
            viewTmp.tableView.tableHeaderView = calTmp ;
            [viewTmp.tableView endUpdates] ;
        }] ;
        
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain] ;
        tableView.rowHeight = QM_SCALE_HEIGHT(55) ;
        tableView.delegate = self ;
        tableView.dataSource = self ;
        tableView.tableHeaderView = calendar ;
        // 去掉cell的分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
        [self addSubview:tableView] ;
        self.tableView = tableView ;
        
        NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter] ;
        [notificationCenter addObserver:self selector:@selector(reloadData) name:QM_NOTIFICATION_RELOADDATA object:nil] ;
        
        
        [self setupTime] ;
        
        

    }
    return self ;
}

/**
 *  通知tableView刷新数据
 */
- (void) reloadData {
    
    [self.tableView reloadData] ;
}


- (void) setupTime {

    /***设置时间参数****/
    
    self.dateFormatter = [[NSDateFormatter alloc] init] ;
    NSLocale * local = [NSLocale systemLocale] ;
    [self.dateFormatter setLocale:local] ;
    
    [self.dateFormatter setDateFormat:@"HH:mm:ss"];
    
    self.selectedDate = [NSDate date] ;
    
    
}


#pragma mark - frame布局相关
- (void)willMoveToSuperview:(UIView *)newSuperview {

    self.frame = newSuperview.bounds ;
}

- (void)layoutSubviews {

    [super layoutSubviews] ;
    
    self.tableView.frame = self.bounds ;
    
}

#pragma mark - UITableView数据源方法
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dayAppointments.count ;
//    return self.dataSource.count ;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // 1.获取数据
    QMAppointmentHour * appointmentHour = self.dayAppointments[indexPath.row] ;
    
    /*
    static NSString * identifier = @"defaultCell" ;
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier] ;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
    }
    cell.backgroundColor = [UIColor redColor] ;
    cell.textLabel.text = dayAppointment.startTime ;
     */
    
    // 2.创建cell
    QMDayAppointmentCell * cell = [QMDayAppointmentCell dayAppointmentCell:tableView andIndexPath:indexPath] ;
    [cell setCancelAppointmentBlock:^(NSIndexPath * indexPath) {
        self.sendAppointmentRequest(self.dayAppointments[indexPath.row] , self.selectedDate , QMAppointmentViewSendAppointRequestTypeCancel) ;
    }] ;
    // 3.传递模型数据
    cell.appointmentHour = appointmentHour ;
    
    return cell ;
}

#pragma mark - UITableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    QMDayAppointmentCell * selectedCell = (QMDayAppointmentCell *)[tableView cellForRowAtIndexPath:indexPath] ;
    if (selectedCell.appointmentHour.hourStatus == QMAppointmentHourStatusAlreadyAppointedByMe) {
        return ;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSLog(@"%@" , self.dayAppointments[indexPath.row]) ;
    // 选择这个时间后可以进行预约,让控制器发送预约请求
    if (self.sendAppointmentRequest) {
        
        QMAppointmentHour * appointmentHour = self.dayAppointments[indexPath.row] ;
        
        QMAppointmentViewSendAppointRequestType type ;
        if (appointmentHour.hourStatus == QMAppointmentHourStatusAvailable) {
#warning 可以预约的状态,这里会调用预约接口
            type = QMAppointmentViewSendAppointRequestTypeAppoint ;
        } else if (appointmentHour.hourStatus == QMAppointmentHourStatusAlreadyAppointedByMe) {
#warning 用户已经预约的情况,这里会取消预约
            type = QMAppointmentViewSendAppointRequestTypeCancel ;
        }
        if (self.sendAppointmentRequest) {
            
            self.sendAppointmentRequest(self.dayAppointments[indexPath.row] , self.selectedDate , type) ;
        }
    }
}

//- (void) cancelAppointment {
//
//    self.sendAppointmentRequest(self.dayAppointments[indexPath.row] , self.selectedDate , QMAppointmentViewSendAppointRequestTypeCancel) ;
//}



@end
