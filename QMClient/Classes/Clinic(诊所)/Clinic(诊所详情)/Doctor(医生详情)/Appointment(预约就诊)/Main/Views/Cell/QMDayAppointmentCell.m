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
#define QM_STRING_UNAVILIALBE @"不可预约"
#define QM_STRING_ALREADYAPPOINTED @"已预约"

#define QM_FONT_STATUS [UIFont systemFontOfSize:14]
#define QM_FONT_TIME [UIFont systemFontOfSize:11]
#define QM_COLOR_ENDTIME [UIColor grayColor]

#define QM_COLOR_UNAVILIABLESTATUS [UIColor grayColor]
#define QM_COLOR_AVILIABLESTATUS [UIColor colorWithColorString:@"c9c9c9"]
#define QM_COLOR_ALREADYSTATUS [UIColor colorWithColorString:@"fda529"]

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
@property (weak , nonatomic) UIButton * statusButton ;

/**
 *  分隔符号
 */
@property (weak , nonatomic) UIImageView * diliverView ;

/**
 *  cell的下分割线
 */
@property (weak , nonatomic) UIImageView * bottomView ;


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
    switch (self.appointmentHour.hourStatus) {
        case QMAppointmentHourStatusAvailable: {
            // 可以预约
            [self.statusButton setTitle:QM_STRING_AVAILIABEL forState:UIControlStateNormal] ;
            [self.statusButton setTitleColor:QM_COLOR_AVILIABLESTATUS forState:UIControlStateNormal] ;
            [self.statusButton setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal] ;
            self.backgroundColor = [UIColor whiteColor] ;
            self.userInteractionEnabled = YES ;
            self.diliverView.backgroundColor = [UIColor colorWithColorString:@"c9c9c9"] ;
            break;
            
        }
        case QMAppointmentHourStatusAlreadyAppointedByOthers:
        case QMAppointmentHourStatusUnavilable: {
            // 不可预约
            [self.statusButton setTitle:QM_STRING_UNAVILIALBE forState:UIControlStateNormal] ;
            [self.statusButton setTitleColor:QM_COLOR_UNAVILIABLESTATUS forState:UIControlStateNormal] ;
            
            [self.statusButton setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal] ;
            self.backgroundColor = [UIColor lightGrayColor] ;
            self.userInteractionEnabled = NO ;
            self.diliverView.backgroundColor = [UIColor colorWithColorString:@"c9c9c9"] ;
            break;
            
        }

        case QMAppointmentHourStatusAlreadyAppointedByMe: {
            // 已经预约
            [self.statusButton setTitle:QM_STRING_ALREADYAPPOINTED forState:UIControlStateNormal] ;
            [self.statusButton setTitleColor:QM_COLOR_ALREADYSTATUS forState:UIControlStateNormal] ;
            [self.statusButton setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal] ;
            self.backgroundColor = [UIColor whiteColor] ;
            self.userInteractionEnabled = YES ;
            self.diliverView.backgroundColor = [UIColor colorWithColorString:@"c9c9c9"] ;
            break;
            
        }

            /*
        case QMAppointmentHourStatusRest: {
//            [self.statusButton setTitle:QM_STRING_UNAVILIALBE forState:UIControlStateNormal] ;
//            [self.statusButton setTitleColor:QM_COLOR_ALREADYSTATUS forState:UIControlStateNormal] ;
//            self.backgroundColor = [UIColor lightGrayColor] ;
            self.userInteractionEnabled = NO ;
//            self.diliverView.backgroundColor = [UIColor grayColor] ;
            break;
            
        }
             */
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
        
        UIButton * statusButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
        statusButton.titleLabel.font = [UIFont systemFontOfSize:18] ;
        statusButton.userInteractionEnabled = NO ;
        // 设置button的内容左对齐
        [statusButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft] ;
//        statusButton.tintAdjustmentMode = 
        [statusButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)] ;
        [self.contentView addSubview:statusButton] ;
        self.statusButton = statusButton ;
        
        UIImageView * bottomView = [[UIImageView alloc] init] ;
        bottomView.backgroundColor = [UIColor colorWithColorString:@"bfbfbf"] ;
        [self.contentView addSubview:bottomView] ;
        self.bottomView = bottomView ;
        
    }
    return self ;
}

+ (instancetype)dayAppointmentCell:(UITableView *)tableView {
    
    
    static NSString * identifier = @"dayAppointmentCell" ;
    
    QMDayAppointmentCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier] ;
    
    if (cell == nil) {
        cell = [[QMDayAppointmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] ;
    }
//    cell.backgroundColor = [UIColor purpleColor] ;
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
        make.top.mas_equalTo(cell.contentView).with.offset(QM_SCALE_HEIGHT(12)) ;
        make.leading.mas_equalTo(cell.contentView.mas_leading).with.offset(QM_SCALE_WIDTH(45)) ;
        make.width.mas_greaterThanOrEqualTo(0) ;
        make.height.mas_greaterThanOrEqualTo(0) ;
    }] ;
//    self.startTimeLabel.backgroundColor = [UIColor yellowColor] ;
    
    [self.endTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cell.startTimeLabel.mas_bottom).with.offset(QM_SCALE_HEIGHT(7)) ;
        make.leading.mas_equalTo(cell.startTimeLabel.mas_leading) ;
        make.width.mas_greaterThanOrEqualTo(0) ;
        make.height.mas_greaterThanOrEqualTo(0) ;
        make.bottom.mas_equalTo(cell.contentView.mas_bottom).with.offset(-QM_SCALE_HEIGHT(7)) ;
    }] ;
//    self.endTimeLabel.backgroundColor = [UIColor yellowColor] ;
    
    [self.diliverView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(cell.contentView.mas_top).with.offset(QM_SCALE_HEIGHT(QM_LITTLE_PADDING)) ;
        make.bottom.mas_equalTo(cell.contentView.mas_bottom).with.offset(-QM_SCALE_HEIGHT(QM_LITTLE_PADDING)) ;
        make.width.mas_equalTo(2) ;
        make.leading.mas_equalTo(cell.startTimeLabel.mas_trailing).with.offset(QM_SCALE_WIDTH(17)) ;
    }] ;
    
    [self.statusButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(cell.contentView.mas_centerY) ;
        make.leading.mas_equalTo(cell.diliverView.mas_trailing).offset(QM_SCALE_WIDTH(13)) ;
        make.width.mas_greaterThanOrEqualTo(QM_SCALE_WIDTH(100)) ;
        make.height.mas_greaterThanOrEqualTo(0) ;
    }] ;
//    self.statusButton.backgroundColor = [UIColor redColor] ;
//
    
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(0.5) ;
        make.leading.and.trailing.mas_equalTo(cell.contentView) ;
        make.bottom.mas_equalTo(cell.contentView.mas_bottom) ;
    }] ;
    
}











@end
