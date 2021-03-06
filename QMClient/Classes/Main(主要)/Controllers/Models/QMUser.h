//
//  QMUser.h
//  QMClient
//
//  Created by Lotus on 15/7/27.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  用户单例
 */
@interface QMUser : NSObject {
    /**
     *  用户已经预约的时间
     */
    NSDate * _appointedDate ;
}


/**
 *  用户的预约时间(set,get方法)
 */
@property (strong , nonatomic) NSDate * appointedDate ;

/**
 *  用户的电话号码
 */
@property (copy , nonatomic) NSString * phoneNumber ;


/**
 *  获得默认的用户
 *
 *  @return 返回已经登录的用户
 */
+ (instancetype) defaultUser ;



@end
