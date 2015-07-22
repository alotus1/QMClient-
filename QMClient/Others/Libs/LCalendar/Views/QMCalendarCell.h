//
//  QMCalendarCell.h
//  CustomCalendar
//
//  Created by 袁偲￼琦 on 15/7/15.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QMCalendar ;

/**
 *  自定义日历视图cell
 */
@interface QMCalendarCell : UICollectionViewCell

/**
 *  日期模型
 */
@property (strong , nonatomic) QMCalendar * calendar ;

/**
 *  快速获取一个cell
 */
+ (UICollectionViewCell *) calendarCellWithCollectionView : (UICollectionView *) collectionView andIndexPath : (NSIndexPath *) indexPath ;

@end