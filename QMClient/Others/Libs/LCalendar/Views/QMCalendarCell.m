//
//  QMCalendarCell.m
//  CustomCalendar
//
//  Created by 袁偲￼琦 on 15/7/15.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMCalendarCell.h"

#import "QMCalendar.h"

#import "QMAppointmentDay.h"
#import "QMCalendarButton.h"

#import "MMPlaceHolder.h"

// 当天状态文字格式
#define QM_FONT_STATELABEL [UIFont systemFontOfSize:10]
// 可以预约的提示信息
#define QM_STRING_AVAILABLE @"可约"
#define QM_STRING_UNAVAILABLE @"约满"
@interface QMCalendarCell ()

/**
 *  显示日期
 */
@property (weak , nonatomic) QMCalendarButton * dayButton ;
/**
 *  显示是否可以预约信息
 */
@property (weak , nonatomic) UILabel * stateLabel ;
/**
 *  分割线
 */
@property (weak , nonatomic) UIImageView * diliverView ;

/**
 *  标注为当前日期的背景圆圈
 */
@property (weak , nonatomic) UIView * circleBackView ;



@end

@implementation QMCalendarCell

- (void)setAppointmentDay:(QMAppointmentDay *)appointmentDay {

    _appointmentDay = appointmentDay ;
    
    // 1.将状态信息显示出来
    if (appointmentDay.day_status == QMAppointmentDayStatusEnable) {
        self.stateLabel.text = QM_STRING_AVAILABLE ;
    } else {
    
        self.stateLabel.text = QM_STRING_UNAVAILABLE ;
    }
}

/**
 *  重写setCalendar方法,在这里可以判断cell要显示的样式
 */
- (void)setCalendar:(QMCalendar *)calendar {

    _calendar = calendar ;
    
    // 将背景图片移除,为免cell复用的时候出现问题
    [self.circleBackView removeFromSuperview] ;
    
    if (calendar.day == -1) {
        self.backgroundView = nil ;
        self.backgroundColor = [UIColor clearColor] ;
        // 将cell中的子控件隐藏
        for (UIView * view in self.contentView.subviews) {
            view.hidden = YES ;
        }
//        self.contentView.hidden = NO ;
        self.diliverView.hidden = NO ;
        // 取消cell与用户的交互
        self.userInteractionEnabled = NO ;
        return ;
    }
    
    // 取消子控件的隐藏状态
    for (UIView * view in self.contentView.subviews) {
        view.hidden = NO ;
    }

    // 开启用户交互
    self.userInteractionEnabled = YES ;
    [self.dayButton setTitle:[NSString stringWithFormat:@"%ld" , calendar.day] forState:UIControlStateNormal] ;
    self.dayButton.titleLabel.font = [UIFont systemFontOfSize:21] ;
    
    
#warning 这句话一定要放在changeCellStyle方法调用之前使用,因为在changeCellStyle里还会改变title的颜色
    [self.dayButton setTitleColor:calendar.dayColor forState:UIControlStateNormal] ;

    [self changeCellStyle] ;
    
    
    
    [self setNeedsLayout] ;

}



/**
 *  改变cell样式
 */
- (void) changeCellStyle {

    if (self.calendar.isSelectedDay) {
        
        // 选中状态设置背景颜色
        self.dayButton.backgroundColor = [UIColor grayColor] ;
        [self.dayButton setImage:nil forState:UIControlStateNormal] ;
        [self.dayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
        
    } else {
        self.dayButton.backgroundColor = [UIColor clearColor] ;
        [self.dayButton setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal] ;
        [self.dayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal] ;
        
    }
}

+ (UICollectionViewCell *)calendarCellWithCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath {

    static NSString * identifier = @"calendarCell" ;
    [collectionView registerClass:[self class] forCellWithReuseIdentifier:identifier] ;
    QMCalendarCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath] ;
    cell.indexPath = indexPath ;
    return cell ;
}


- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        
        // 显示日期的标签
        QMCalendarButton * dayButton = [QMCalendarButton buttonWithType:UIButtonTypeCustom] ;
        dayButton.userInteractionEnabled = NO ;
        dayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:dayButton] ;
        self.dayButton = dayButton ;
        
        
        // 分割线
        UIImageView * diliverView = [[UIImageView alloc] init] ;
        diliverView.image = [UIImage imageNamed:@"diliver_line"] ;
        [self.contentView addSubview:diliverView] ;
        self.diliverView = diliverView ;
        
        
    }
    return self ;
}

- (void)layoutSubviews {

    [super layoutSubviews] ;

    
    // 分割线
    CGFloat diliverViewW = self.frame.size.width ;
    CGFloat diliverViewH = 1 ;
    CGFloat diliverViewX = 0 ;
    CGFloat diliverViewY = self.frame.size.height - diliverViewH ;
    self.diliverView.frame = CGRectMake(diliverViewX, diliverViewY, diliverViewW, diliverViewH) ;

    // 日期的frame
    CGFloat dayX = 0 ;
    CGFloat dayY = 0 ;
    CGFloat dayW = self.frame.size.width ;
    CGFloat dayH = self.frame.size.height - diliverViewH ;
    self.dayButton.frame = CGRectMake(dayX, dayY, dayW, dayH) ;

}







@end
