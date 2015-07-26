//
//  QMCalendarButton.m
//  QMClient
//
//  Created by Lotus on 15/7/26.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMCalendarButton.h"

@implementation QMCalendarButton


- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.imageView.contentMode = UIViewContentModeCenter ;
//        self.backgroundColor = [UIColor yellowColor];
        self.titleLabel.font = [UIFont systemFontOfSize:14] ;
    }
    return self ;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGFloat X = 0 ;
    CGFloat Y = QM_SCALE_HEIGHT(8)  ;
    CGFloat W = QM_SCREEN_WIDTH / 7 ;
    CGFloat H = QM_SCALE_HEIGHT(22) ;
    
    
    return CGRectMake(X, Y, W, H) ;

}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat X = 0 ;
    CGFloat Y = CGRectGetMaxY(self.titleLabel.frame) + QM_SCALE_HEIGHT(2);
    CGFloat W = QM_SCREEN_WIDTH / 7 ;
    CGFloat H = QM_SCALE_HEIGHT(12) ;
    return CGRectMake(X, Y, W, H) ;

}

@end
