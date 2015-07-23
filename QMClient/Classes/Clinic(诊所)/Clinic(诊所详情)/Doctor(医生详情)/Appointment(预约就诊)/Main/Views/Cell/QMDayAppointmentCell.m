//
//  QMDayAppointmentCell.m
//  AppointmentView
//
//  Created by Lotus on 15/7/21.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMDayAppointmentCell.h"

#import "QMAppointmentHour.h"

#import "Masonry.h"

#define QM_STRING_AVAILIABEL @"可预约"
#define QM_STRING_UNAVILIALBE @"已预约"

#define QM_FONT_STATUS [UIFont systemFontOfSize:14]
#define QM_FONT_TIME [UIFont systemFontOfSize:11]
#define QM_COLOR_ENDTIME [UIColor lightGrayColor]

#define QM_COLOR_UNAVILIABLESTATUS [UIColor grayColor]
#define QM_COLOR_AVILIABLESTATUS [UIColor blackColor]

#define QM_SMALL_PADDING 5

#define QM_LITTLE_PADDING 3

@interface QMDayAppointmentCell ()

/**
 *  开始时间标签
 */
@property (weak , nonatomic) UILabel * startTimeLabel ;

/**
 *  结束时间标签
 */
@property (weak , nonatomic) UILabel * endTimeLabel ;

/**
 *  预约状态标签
 */
@property (weak , nonatomic) UILabel * statusLabel ;

/**
 *  分隔符号
 */
@property (weak , nonatomic) UIImageView * diliverView ;


@end

@implementation QMDayAppointmentCell

- (void)setAppointmentHour:(QMAppointmentHour *)appointmentHour {

    _appointmentHour = appointmentHour ;
    
    
    // 填充数据
    [self settingData] ;
    // 重新布局
    [self setNeedsLayout] ;
}

- (void) settingData {

    self.startTimeLabel.text = self.appointmentHour.startTime ;
//    self.startTimeLabel.text = @"你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好你好" ;
    self.endTimeLabel.text = self.appointmentHour.endTime ;
    
    // 在这里判断该时间段的预约状态,然后决定diliverView的颜色
    if (self.appointmentHour.status == QMAppointmentHourStatusAvailable) {
        
        self.statusLabel.text = QM_STRING_AVAILIABEL ;
        self.statusLabel.textColor = QM_COLOR_AVILIABLESTATUS ;
        self.backgroundColor = [UIColor whiteColor] ;
        self.userInteractionEnabled = YES ;
        self.diliverView.backgroundColor = [UIColor greenColor] ;
    } else {
    
        self.statusLabel.text = QM_STRING_UNAVILIALBE ;
        self.statusLabel.textColor = QM_COLOR_UNAVILIABLESTATUS ;
        self.backgroundColor = [UIColor lightGrayColor] ;
        self.userInteractionEnabled = NO ;
        self.diliverView.backgroundColor = [UIColor grayColor] ;
    }
    
    
}


#pragma mark - 初始化相关
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 去掉背景view
        self.backgroundView = nil ;
        
        
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
        
        UIImageView * diliverView = [[UIImageView alloc] init] ;
        diliverView.clipsToBounds = YES ;
        diliverView.layer.cornerRadius = 2 ;
        [self.contentView addSubview:diliverView] ;
        self.diliverView = diliverView ;
        
        UILabel * statusLabel = [[UILabel alloc] init] ;
        [self.contentView addSubview:statusLabel] ;
        self.statusLabel = statusLabel ;
        
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

+ (instancetype)dayAppointmentCell:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath {

    static NSString * identifier = @"dayAppointmentCell" ;
    
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] forCellReuseIdentifier:identifier] ;
    QMDayAppointmentCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath] ;
    return cell ;
    
}



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
    
    [self.diliverView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(cell.contentView.mas_top).with.offset(QM_LITTLE_PADDING) ;
        make.bottom.mas_equalTo(cell.contentView.mas_bottom).with.offset(-QM_LITTLE_PADDING) ;
        make.width.mas_equalTo(3) ;
        make.leading.mas_equalTo(cell.startTimeLabel.mas_trailing).with.offset(10) ;
    }] ;
    
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(cell.contentView.mas_centerY) ;
        make.leading.mas_equalTo(cell.diliverView.mas_trailing).offset(10) ;
        make.width.mas_greaterThanOrEqualTo(0) ;
        make.height.mas_greaterThanOrEqualTo(0) ;
    }] ;
//    self.statusLabel.backgroundColor = [UIColor redColor] ;
    
    
}











@end
