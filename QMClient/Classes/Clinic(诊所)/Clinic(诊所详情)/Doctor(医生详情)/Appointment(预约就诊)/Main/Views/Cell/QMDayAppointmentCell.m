//
//  QMDayAppointmentCell.m
//  AppointmentView
//
//  Created by Lotus on 15/7/21.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMDayAppointmentCell.h"

#import "QMAppointmentDay.h"

#import "Masonry.h"

#define QM_FONT_TIME [UIFont systemFontOfSize:11]
#define QM_COLOR_ENDTIME [UIColor lightGrayColor]

#define QM_SMALL_PADDING 5

@interface QMDayAppointmentCell ()

/**
 *  开始时间标签
 */
@property (weak , nonatomic) UILabel * startTimeLabel ;

/**
 *  结束时间标签
 */
@property (weak , nonatomic) UILabel * endTimeLabel ;

@property (weak , nonatomic) UIView * testView ;

@end

@implementation QMDayAppointmentCell

- (void)setAppointmentDay:(QMAppointmentDay *)appointmentDay {

    
    _appointmentDay = appointmentDay ;
    
//    NSLog(@"%@" , appointmentDay) ;
    
    // 填充数据
    [self settingData] ;
    // 重新布局
    [self setNeedsLayout] ;
}

- (void) settingData {

    self.startTimeLabel.text = self.appointmentDay.startTime ;
//    self.startTimeLabel.text = @"你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好" ;
    self.endTimeLabel.text = self.appointmentDay.endTime ;
    
}


#pragma mark - 初始化相关
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel * startTimeLabel = [[UILabel alloc] init] ;
//        startTimeLabel.numberOfLines = 0 ;
        startTimeLabel.font = QM_FONT_TIME ;
        [self.contentView addSubview:startTimeLabel] ;
        self.startTimeLabel = startTimeLabel ;
        
        UILabel * endTimeLabel = [[UILabel alloc] init] ;
        endTimeLabel.font = QM_FONT_TIME ;
        endTimeLabel.textColor = QM_COLOR_ENDTIME ;
        [self.contentView addSubview:endTimeLabel] ;
        self.endTimeLabel = endTimeLabel ;
        
        UIView * testView = [[UIView alloc] init] ;
        [self.contentView addSubview:testView] ;
        self.testView = testView ;
        
    }
    return self ;
}

+ (instancetype)dayAppointmentCell:(UITableView *)tableView {
    
    
    static NSString * identifier = @"dayAppointmentCell" ;
    
    QMDayAppointmentCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier] ;
    
    if (cell == nil) {
        cell = [[QMDayAppointmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
    }
    cell.backgroundColor = [UIColor purpleColor] ;
    return cell ;
     

}

/*
+ (instancetype)dayAppointmentCell:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {

    static NSString * identifier = @"dayAppointmentCell" ;
    
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] forCellReuseIdentifier:identifier] ;
    QMDayAppointmentCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath] ;
    return cell ;
    
}
*/


#pragma mark - 布局相关
- (void)layoutSubviews {

    [super layoutSubviews] ;
 
    __weak typeof(self) cell = self ;
    
    [self.startTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cell.contentView).with.offset(QM_SMALL_PADDING) ;
        make.leading.mas_equalTo(cell.contentView.mas_leading).with.offset(10) ;
        make.width.mas_greaterThanOrEqualTo(0) ;
        make.height.mas_greaterThanOrEqualTo(0) ;
    }] ;
    self.startTimeLabel.backgroundColor = [UIColor yellowColor] ;
    
    [self.endTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cell.startTimeLabel.mas_bottom).with.offset(QM_SMALL_PADDING) ;
        make.leading.mas_equalTo(cell.startTimeLabel.mas_leading) ;
        make.width.mas_greaterThanOrEqualTo(0) ;
        make.height.mas_greaterThanOrEqualTo(0) ;
        make.bottom.mas_equalTo(cell.contentView.mas_bottom).with.offset(-QM_SMALL_PADDING) ;
    }] ;
    
    self.endTimeLabel.backgroundColor = [UIColor yellowColor] ;
    
    
}











@end
