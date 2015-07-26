//
//  CustomCalendar.m
//  CustomCalendar
//
//  Created by 袁偲￼琦 on 15/7/15.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "CustomCalendar.h"

#import "QMCalendarCell.h"
#import "QMCalendar.h"

#import "QMAppointmentDay.h"

#import "NSDate+CQ.h"

#define QM_SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define QM_CELLHEIGHT QM_SCALE_HEIGHT(50)
// 头部的高度
#define QM_HEADERHEIGHT QM_SCALE_HEIGHT(75)

@interface CustomCalendar () <UICollectionViewDelegateFlowLayout , UICollectionViewDataSource>

/**
 *  显示星期的视图
 */
@property (weak , nonatomic) QMWeekView * weekView ;

/**
 *  日历视图
 */
@property (assign , nonatomic) UICollectionView * calendarView ;

/**
 *  日历数据源
 */
@property (strong , nonatomic) NSArray * dataSource ;

/**
 *  记录本月有几周
 */
@property (assign , nonatomic) NSInteger weekOfCurrentMonth ;

/**
 *  记录本月第一天是周几
 */
@property (assign , nonatomic) NSInteger firstWeekdayOfMonth ;

/**
 *  保存日历对象,记录当前日历
 */
@property (strong , nonatomic) NSCalendar * gregorianCalendar ;

/**
 *  记录当前选择的日期,这样就不用频繁创建对象
 */
@property (strong , nonatomic) NSDate * currentDate ;

/**
 *  记录component的格式设置
 */
@property (assign , nonatomic) NSCalendarUnit calendarUnit ;

/**
 *  当前时间组件
 */
@property (strong , nonatomic) NSDateComponents * currentComponents ;

/**
 *  选中的cell的indexPath
 */
@property (strong , nonatomic) NSIndexPath * selectedIndexPath ;


@end

@implementation CustomCalendar

- (void)setMonthAppointments:(NSArray *)monthAppointments {

    _monthAppointments = monthAppointments ;
    
    // 刷新colletionView的数据
    [self.calendarView reloadData] ;
    
    

}

#pragma mark - 初始化相关

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
    
//        self.backgroundColor = [UIColor redColor] ;
        
        // 创建一个视图,用来显示星期
        QMWeekView * weekView = [[QMWeekView alloc] init] ;

        __weak typeof(self) view = self ;
        // 月份改变的时候进行的操作
        [weekView setButtonClickBlock:^(QMWeekView *weekView, QMWeekViewButtonType type) {
            
            SEL selector = type == QMWeekViewButtonTypeNextMonth ? @selector(changeDataSourceForNextMonth) : @selector(changeDataSourceForPreviousMonth) ;
//#warning 这个警告要怎么处理,selector会导致泄漏
            // 使用这个方法就会有警告,可能会导致泄漏,主要是因为selector是未知的,可能会有返回值,而编译器不知道返回值如何处理
//            [self performSelector:selector] ;
            [view performSelector:selector withObject:nil afterDelay:0] ;
            
        }] ;
        [self addSubview:weekView] ;
        self.weekView = weekView ;
        
        // 创建一个collectionView用来显示日历信息
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init] ;
        layout.minimumLineSpacing = 0 ;
        layout.minimumInteritemSpacing = 0 ;
        
        UICollectionView * calendarView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout] ;
        calendarView.delegate = self ;
        calendarView.dataSource = self ;
        [self addSubview:calendarView] ;
        self.calendarView = calendarView ;
        
        calendarView.backgroundView = nil ;
//        calendarView.backgroundColor = [UIColor blackColor];//
        calendarView.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:1];

        [self settingData] ;
        
        
    }
    
    return self ;
}

/**
 *  初始化一些必须要用到的数据,当天日期,日历等等
 */
- (void) settingData {


    self.gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] ;
    self.currentDate = [NSDate date] ;
    
    
    self.calendarUnit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitCalendar | NSCalendarUnitWeekday ;
    
    // 初始化时间组件,方便往后使用
    self.currentComponents = [[NSCalendar currentCalendar] components:self.calendarUnit fromDate:[NSDate date]] ;
    
    [self settingCalendarDataSource] ;
    
}

#pragma mark - 日历的数据源计算
/**
 *  获取日历(calendarView)的数据源
 */
- (void) settingCalendarDataSource {

    self.weekView.currentDate = self.currentDate ;
    
    
    // 获取日历的第一天
    NSDate * firstDateOfMonth = nil ;
    [self.gregorianCalendar rangeOfUnit:NSCalendarUnitMonth startDate:&firstDateOfMonth interval:0 forDate:self.currentDate] ;
    firstDateOfMonth = [firstDateOfMonth currentZoneDate] ;
    
    
    // 获取本月第一天是星期几
    NSInteger weekday = [self.gregorianCalendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:firstDateOfMonth] ;
    self.firstWeekdayOfMonth = weekday ;

#warning 将self.gregorianCalendar改成当前日历
    // 获取本月有多少天
    NSInteger dayOfCurrentMonth = [self.gregorianCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.currentDate].length ;
    // 获取本月有几周
#warning 这里获取的一个月有几周在iOS7.1上不准确,但是在8.4上是正确的
    NSInteger weekOfCurrentMonth = [self.gregorianCalendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:self.currentDate].length ;
//    NSLog(@"weekOfCurrentMonth %ld" ,weekOfCurrentMonth) ;
//    NSLog(@"currentdate %@" , self.currentDate) ;
    self.weekOfCurrentMonth = weekOfCurrentMonth ;
#warning 在这里变更self的高度来适应一个月的周数
    [self changeHeight] ;
    // 计算本月collectionView有多少个cell
//    NSInteger numberOfCell = dayOfCurrentMonth + weekday - 1 ;
    
    
    NSMutableArray * dataSource = [NSMutableArray array] ;
    // 初始化数据源
    // 空cell内容为-1
    for (NSInteger i = 0; i < weekday - 1 ; i++) {
        QMCalendar * calendar = [[QMCalendar alloc] init] ;
        calendar.day = -1 ;
        calendar.isSelectedDay = NO ;
        [dataSource addObject:calendar] ;
    }
    
    // 创建NSDateComponent对象
    NSDateComponents * components = [self.gregorianCalendar components:self.calendarUnit fromDate:self.currentDate] ;
    // cell内容为日期
    for (NSInteger index = 0; index < dayOfCurrentMonth; index++) {
        QMCalendar * calendar = [[QMCalendar alloc] init] ;
        calendar.day = index + 1 ;
        // 判断是否是当天,如果是当天isCurrentDay就标记为YES
        if ([self isEqualToCurrentDate:components] && components.day == index + 1) {
            calendar.isSelectedDay = YES ;
            self.selectedIndexPath = [NSIndexPath indexPathForItem:index + self.firstWeekdayOfMonth - 1 inSection:0] ;
            NSLog(@"%ld" , self.selectedIndexPath.item) ;
        } else {
            calendar.isSelectedDay = NO ;
        }
//        components.day = calendar.day ;
//        NSDate * date = [self.gregorianCalendar dateFromComponents:components] ;
//        components = [self.gregorianCalendar components:self.calendarUnit fromDate:date] ;
        // 设置日期显示的字体颜色
        calendar.dayColor = (components.weekday == 1 || components.weekday == 7) ? [UIColor colorWithColorString:@"c0c0c0"] : [UIColor colorWithColorString:@"000000"] ;
        [dataSource addObject:calendar] ;
    }
    self.dataSource = dataSource ;
    

    [self.calendarView reloadData] ;
    
}

#warning 往后可以重构这两个方法的代码
/**
 *  更改数据源,下个月
 */
- (void) changeDataSourceForNextMonth {
    

    NSDateComponents * components = [self.gregorianCalendar components:self.calendarUnit fromDate:self.currentDate] ;
//    NSDateComponents * currentDateComponents = [self.gregorianCalendar components:self.calendarUnit fromDate:[NSDate date]] ;
    components.month ++ ;
#warning 在这里需要进行判断,年月是否与当前的日期相同,相同则不需要更改day属性
    components.day = [self isEqualToCurrentDate:components] ? self.currentComponents.day : 1 ;
#warning 在这里获取的nextDate日期不正确,但是在settingCalendarDataSource方法里面进行了矫正
    NSDate * nextDate = [self.gregorianCalendar dateFromComponents:components] ;
    self.currentDate = nextDate ;
    self.currentComponents = [self.gregorianCalendar components:self.calendarUnit fromDate:nextDate] ;
    
    
    [self settingCalendarDataSource] ;
    
    // 调用block通知上一层进行相应的操作
    if (self.changeMonthBlock) {
        
        self.changeMonthBlock(self , self.currentDate) ;
    }
    
}

/**
 *  更改数据源,上个月
 */
- (void) changeDataSourceForPreviousMonth {
    

    NSDateComponents * components = [self.gregorianCalendar components:self.calendarUnit fromDate:self.currentDate] ;
    
//    NSDateComponents * currentDateComponents = [self.gregorianCalendar components:self.calendarUnit fromDate:[[NSDate date] currentZoneDate]] ;
    components.month -- ;
    components.day = [self isEqualToCurrentDate:components] ? self.currentComponents.day : 1 ;
    // 在这里获取的nextDate日期不正确,但是在settingCalendarDataSource方法里面进行了矫正
    NSDate * nextDate = [self.gregorianCalendar dateFromComponents:components] ;
    self.currentDate = nextDate ;
    self.currentComponents = [self.gregorianCalendar components:self.calendarUnit fromDate:nextDate] ;
    
    
    [self settingCalendarDataSource] ;
    
    // 调用block通知上一层进行相应的操作
    if (self.changeMonthBlock) {
        
        self.changeMonthBlock(self , self.currentDate) ;
    }
}


#pragma mark - frame相关,布局子控件等等

/**
 *  更换日历视图的高度
 */
- (void) changeHeight {

    CGRect frame = self.frame ;
    frame.size.height = QM_CELLHEIGHT * self.weekOfCurrentMonth + QM_HEADERHEIGHT ;
    self.frame = frame ;
    
#warning 针对项目的需求
    // 通知tableView自己的高度改变
    if (self.viewHeightChangedBlock) {
        
        self.viewHeightChangedBlock() ;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {

//    self.frame = CGRectMake(0, 0, mainScreen.bounds.size.width, mainScreen.bounds.size.height * 0.5) ;
    self.frame = CGRectMake(0, 0, QM_SCREENWIDTH, QM_CELLHEIGHT * self.weekOfCurrentMonth + QM_HEADERHEIGHT) ;
//    NSLog(@"cellhei %d week %ld head %f" , QM_CELLHEIGHT ,self.weekOfCurrentMonth ,QM_HEADERHEIGHT ) ;
    
}

- (void)layoutSubviews {

    [super layoutSubviews] ;
    
    // 设置顶部星期视图的frame
    CGFloat weekX = 0 ;
    CGFloat weekY = 0 ;
    CGFloat weekW = self.frame.size.width ;
    CGFloat weekH = self.frame.size.width * 0.2 ;
    self.weekView.frame = CGRectMake(weekX, weekY, weekW, weekH) ;
    
    // 设置colletionView的frame
    CGFloat calendarX = 0 ;
    CGFloat calendarY = CGRectGetMaxY(self.weekView.frame) ;
    CGFloat calendarW = self.frame.size.width ;
    CGFloat calendarH = QM_CELLHEIGHT * self.weekOfCurrentMonth ;
    self.calendarView.frame = CGRectMake(calendarX, calendarY, calendarW, calendarH) ;
}

#pragma mark - UICollectionView数据源方法
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataSource.count ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    QMCalendarCell * cell = (QMCalendarCell *)[QMCalendarCell calendarCellWithCollectionView:collectionView andIndexPath:indexPath] ;
    cell.calendar = self.dataSource[indexPath.item] ;
    if (indexPath.item >= self.firstWeekdayOfMonth - 1 && indexPath.item - self.firstWeekdayOfMonth + 1 < self.monthAppointments.count) {
        // 这个indexPath.item在取monthAppointment时候需要修正
        QMAppointmentDay * appointmentDay = self.monthAppointments[indexPath.row - self.firstWeekdayOfMonth + 1] ;
        cell.appointmentDay = appointmentDay ;
    }
    return cell ;
    
}

#pragma mark - UICollectionView代理方法
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake(QM_SCREENWIDTH / 7, QM_CELLHEIGHT) ;
}



- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    QMCalendarCell * cell = (QMCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath] ;
    //    NSLog(@"cell %p" , cell) ;
    NSNotificationCenter * noti = [NSNotificationCenter defaultCenter] ;
    if (![indexPath isEqual:self.selectedIndexPath]) {

//        QMLog(@"pre %p %d" , self.selectedCell ,self.selectedCell.calendar.isSelectedDay) ;
//        self.selectedCell.calendar.isSelectedDay = NO ;
        QMCalendarCell * previousCell = (QMCalendarCell *)[collectionView cellForItemAtIndexPath:self.selectedIndexPath] ;
        previousCell.calendar.isSelectedDay = NO ;
        
//        cell.selected = YES ;
//        self.selectedCell.selected = NO ;
        cell.calendar.isSelectedDay = YES ;
        
//        QMLog(@"cell %p %d" , cell ,cell.calendar.isSelectedDay) ;
        // 发送上一个cell的选中状态改变的通知
//        [noti postNotificationName:QM_CELL_DESELECTEDSTYLE object:self.selectedCell.indexPath] ;
        self.selectedIndexPath = indexPath ;
    }

//    [noti postNotificationName:QM_CELL_NOTIFICATION object:indexPath] ;
    [collectionView reloadData] ;
    

    NSDateComponents * components = [self.gregorianCalendar components:self.calendarUnit fromDate:self.currentDate] ;
    components.day = indexPath.item - self.firstWeekdayOfMonth + 2 ;
    self.weekView.currentDate = [components.date currentZoneDate] ;
    // 选择的日期比实际的偏移了self.firstWeekdayOfMonth + 2天
//    NSLog(@"%ld" , indexPath.item - self.firstWeekdayOfMonth) ;
#warning 在这里预留接口,点击相应的日期进行相应的操作
    if (self.selectDayItemBlock) {
        self.selectDayItemBlock([components.date currentZoneDate]) ;
    }
    
    
}


#pragma mark - 其他辅助方法
- (BOOL) isEqualToCurrentDate : (NSDateComponents *) dateComponents {

//    NSDateComponents * components = [self.gregorianCalendar components:self.calendarUnit fromDate:date] ;
    return self.currentComponents.year == dateComponents.year && self.currentComponents.month == dateComponents.month ;
}














@end
