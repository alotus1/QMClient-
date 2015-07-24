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

// 当天状态文字格式
#define QM_FONT_STATELABEL [UIFont systemFontOfSize:10]
// 可以预约的提示信息
#define QM_STRING_AVAILABLE @"可约"
#define QM_STRING_UNAVAILABLE @"约满"
@interface QMCalendarCell ()

/**
 *  显示日期
 */
@property (weak , nonatomic) UILabel * dayLabel ;
/**
 *  显示是否可以预约信息
 */
@property (weak , nonatomic) UILabel * stateLabel ;
/**
 *  用来提示当天状态的小圆点
 */
@property (weak , nonatomic) UIImageView * tintView ;

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
        self.tintView.backgroundColor = [UIColor greenColor] ;
        self.stateLabel.text = QM_STRING_AVAILABLE ;
    } else {
    
        self.tintView.backgroundColor = [UIColor grayColor] ;
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
        for (UIView * view in self.subviews) {
            view.hidden = YES ;
        }
        // 取消cell与用户的交互
        self.userInteractionEnabled = NO ;
        return ;
    }
    
    // 取消子控件的隐藏状态
    for (UIView * view in self.subviews) {
        view.hidden = NO ;
    }
    // 开启用户交互
    self.userInteractionEnabled = YES ;
    self.dayLabel.text = [NSString stringWithFormat:@"%ld" , calendar.day] ;
    //在这里可以增加一个圆圈来表示当天,使用calendar.isCurrentDay判断
    if (calendar.isCurrentDay) {
        self.dayLabel.textColor = [UIColor blackColor] ;
        UIView * circleBackView = [[UIView alloc] init] ;
        [self.contentView addSubview:circleBackView] ;
        self.circleBackView = circleBackView ;
        circleBackView.alpha = 0.5 ;
        circleBackView.backgroundColor = [UIColor redColor] ;
        circleBackView.clipsToBounds = YES ;
    } else
        self.dayLabel.textColor = [UIColor blackColor] ;
    
    [self setNeedsLayout] ;

}

+ (UICollectionViewCell *)calendarCellWithCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath {

    static NSString * identifier = @"calendarCell" ;
    [collectionView registerClass:[self class] forCellWithReuseIdentifier:identifier] ;
    return [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath] ;
}

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        // 显示日期的标签
        UILabel * dayLabel = [[UILabel alloc] init] ;
        dayLabel.textAlignment = NSTextAlignmentCenter ;
        [self.contentView addSubview:dayLabel] ;
        self.dayLabel = dayLabel ;
        
        // 显示本日的状态(是否可以预约)
        UILabel * stateLabel = [[UILabel alloc] init] ;
        stateLabel.textAlignment = NSTextAlignmentCenter ;
        stateLabel.font = QM_FONT_STATELABEL ;
        [self.contentView addSubview:stateLabel] ;
        self.stateLabel = stateLabel ;
        
        // 提示的小圆点
        UIImageView * tintView = [[UIImageView alloc] init] ;
        tintView.clipsToBounds = YES ;
        tintView.backgroundColor = [UIColor greenColor] ;
        [self.contentView addSubview:tintView] ;
        self.tintView = tintView ;
        
        
        
    }
    return self ;
}

- (void)layoutSubviews {

    [super layoutSubviews] ;
    
    // 日期的frame
    CGFloat dayX = 0 ;
    CGFloat dayY = 0 ;
    CGFloat dayW = self.frame.size.width ;
    CGFloat dayH = dayW ;
    self.dayLabel.frame = CGRectMake(dayX, dayY, dayW, dayH) ;
//    self.dayLabel.backgroundColor = [UIColor purpleColor] ;
    
    // 状态frame
    NSDictionary * attrs = @{NSFontAttributeName : QM_FONT_STATELABEL} ;
    CGSize stateSize = [QM_STRING_AVAILABLE boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size ;
    CGFloat stateW = self.frame.size.width ;
    CGFloat stateH = stateSize.height ;
    CGFloat stateX = 0 ;
    CGFloat stateY = dayH - stateH ;
    self.stateLabel.frame = CGRectMake(stateX, stateY , stateW, stateH) ;
//    self.stateLabel.backgroundColor = [UIColor redColor] ;
    
    // 提示小圆点的frame
    CGFloat tintW = (self.frame.size.height - dayH) * 0.5 ;
    CGFloat tintH = tintW ;
    CGFloat tintX = (self.frame.size.width - tintW) * 0.5 ;
    CGFloat tintY = CGRectGetMaxY(self.dayLabel.frame) + (self.frame.size.height - CGRectGetMaxY(self.dayLabel.frame) - tintH) * 0.5 ;
    self.tintView.frame = CGRectMake(tintX, tintY, tintW, tintH) ;
    self.tintView.layer.cornerRadius = tintW * 0.5 ;
    
    if (self.calendar.isCurrentDay) {
        CGFloat backW = dayW * 0.6 ;
        CGFloat backH = backW ;
        CGFloat backX = 0 ;
        CGFloat backY = 0 ;
        self.circleBackView.frame = CGRectMake(backX, backY, backW, backH) ;
        self.circleBackView.center = self.dayLabel.center ;
        self.circleBackView.layer.cornerRadius = backW * 0.5 ;
    }
    
}







@end
