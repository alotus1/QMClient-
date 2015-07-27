//
//  QMDataBaseManager.h
//  数据库操作
//
//  Created by Lotus on 15-6-2.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QMAppointment ;

@interface QMDataBaseManager : NSObject

/**
*  创建数据库,返回创建好的数据库地址
*
*  @param dataBaseName 要创建的数据库名
*
*  @return 返回创建成功的数据库路径
*/
+ (NSString *) createDataBaseWithDataBaseName : (NSString *) dataBaseName ;

/**
 *  在数据库中创建表
 *
 *  @param dataBasePath 要创建表的数据库路径
 *  @param sql          执行的sql语句
 *  @param defaultsKey  归档的字段key
 */
+ (void) createTableInDataBase : (NSString *) dataBasePath andSql : (NSString *) sql andDefaultsKey:(NSString *)defaultsKey ;

/**
 *  在数据库表中插入模型数据
 *
 *  @param model        要插入的模型
 *  @param databasePath 数据库的路径
 *  @param tableName    表名
 */
+ (void) insertModel : (id) model inDatabase : (NSString *) databasePath andTable : (NSString *) tableName ;


/**
 *  在数据库表中删除模型数据
 *
 *  @param model        要删除预约id
 *  @param databasePath 数据库的路径
 *  @param tableName    表名
 */
+ (void) deleteModel : (NSInteger) appointID inDataBase : (NSString *) databasePath andTable : (NSString *) tableName ;

/**
 *  获得数据库表单中的全部数据
 *
 *  @param dataBase  数据库路径
 *  @param tableName 表单名称
 *
 *  @return 返回查询的结果
 */
+ (NSArray *) selectAllDataInDataBase : (NSString *) dataBaseName andTable : (NSString *) tableName ;

/**
 *  获得数据库中符合预约信息的预约id
 *
 *  @param appointment 预约信息
 *
 *  @return 预约信息对应的预约id
 */
+ (NSInteger) selectAppointIdWithAppointment : (QMAppointment *) appointment ;

@end
