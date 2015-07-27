//
//  QMUser.m
//  QMClient
//
//  Created by Lotus on 15/7/27.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMUser.h"


static QMUser * user = nil ;

@implementation QMUser

+ (instancetype)defaultUser {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        user = [[self alloc] init] ;
        
    });
    return user ;
}


- (NSDate *)appointedDate {

    return [[NSUserDefaults standardUserDefaults] valueForKey:QM_USERDEFAULTS_APPOINTEDDATE] ;
    
}
#warning 在这里要整体的保存用户对象在本地!!!!这里暂时用userdefault
- (void)setAppointedDate:(NSDate *)appointedDate {

    _appointedDate = appointedDate ;
    
    // 保存到userDefault中
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults] ;
    [userDefault setValue:appointedDate forKey:QM_USERDEFAULTS_APPOINTEDDATE] ;
    [userDefault synchronize] ;

}


@end
