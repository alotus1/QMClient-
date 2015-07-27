//
//  QMDataBaseManager.m
//  数据库操作
//
//  Created by Lotus on 15-6-2.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMDataBaseManager.h"
#import "QMSandBox.h"

#import "QMAppointment.h"

#import "FMDatabase.h"


@implementation QMDataBaseManager

/**
 *  创建数据库,返回创建好的数据库地址
 *
 *  @param dataBaseName 要创建的数据库名
 *
 *  @return 返回创建成功的数据库路径
 */
+ (NSString *)createDataBaseWithDataBaseName:(NSString *)dataBaseName {

    // 获得归档对象
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults] ;
    // 获得文件管理者
    NSFileManager * manager = [NSFileManager defaultManager] ;
    
    // 拼接创建数据库的地址,创建在Documents目录下
    NSString * createPath = [QMSandBox pathForDocuments] ;
    createPath = [createPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db" , dataBaseName]] ;
    
    // 判断是否已经存在数据库,存在则不创建
    if (![manager fileExistsAtPath:createPath]) {
#warning 当需要重新创建数据库的时候将NSUserDefaults中的表属性全部设置为NO,这里需要传入一个key数组
//        // 新建的数据库,将归档清理
        [userDefaults setBool:NO forKey:QM_USERDEFAULTS_APPOINTEXIST] ;
        [userDefaults synchronize] ;
        // 创建数据库
        if ([manager createFileAtPath:createPath contents:nil attributes:nil]) {
            QMLog(@"数据库%@创建成功",dataBaseName) ;
        } else {
            QMLog(@"数据库%@创建失败",dataBaseName) ;
            return nil ;
        }
    } else {
    
        QMLog(@"数据库%@已经存在" , dataBaseName) ;
    }
    
//    // 使用NSUserDefaults保存数据库所在地址
    [userDefaults setObject:createPath forKey:QM_USERDEFAULTS_DATABASEPATH] ;
    [userDefaults synchronize] ;
    
    return createPath ;
}

/**
 *  在数据库中创建表
 *
 *  @param dataBasePath 要创建表的数据库路径
 *  @param tableName    要创建的表名
 *  @param defaultsKey  归档的key
 */
+ (void) createTableInDataBase : (NSString *) dataBasePath andSql:(NSString *)sql andDefaultsKey:(NSString *)defaultsKey {

    // 获得归档对象
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults] ;
    
    // defaultsKey为YES则表示数据库已经存在,则不需要创建
    if ([userDefaults boolForKey:defaultsKey]) {
        QMLog(@"表单已经存在") ;
        return ;
    }
    
    FMDatabase * database = [FMDatabase databaseWithPath:dataBasePath] ;
    // 表单还不存在,则创建表单
    // 链接数据库
    if (![database open]) {
        QMLog(@"数据库%@连接失败" , dataBasePath) ;
        return ;
    } else {
    
        QMLog(@"数据库%@连接成功" , dataBasePath) ;
    }
    
    // 执行sql语句
    if ([database executeUpdate:sql]) {
        QMLog(@"表格创建成功") ;
        
        // 标记表单创建成功,归档
        [userDefaults setBool:YES forKey:defaultsKey] ;
        // 存储
        [userDefaults synchronize] ;
    }
    
    [database close] ;
    
    // 打印错误信息
    QMLog(@"%@" , [database lastError]) ;
}


/**
 *  在数据库表中插入模型数据
 *
 *  @param model        要插入的模型
 *  @param databasePath 数据库的路径
 *  @param tableName    表名
 */
+ (void) insertModel : (id) model inDatabase : (NSString *) databasePath andTable : (NSString *) tableName {

    FMDatabase * database = [FMDatabase databaseWithPath:databasePath] ;
    // 连接数据库
    if ([database open]) {
        NSLog(@"数据库%@连接成功" , databasePath) ;
    } else {
        NSLog(@"数据库%@连接失败" , databasePath) ;
        NSLog(@"%@" , [database lastError]) ;
        return ;
    }
    
    
    NSString * sql ;
    // 拼接sql语句
    if ([tableName isEqualToString:QM_USERDEFAULTS_APPOINTTABLE]) {
        QMAppointment * appointment = (QMAppointment *) model ;
        sql = [NSString stringWithFormat:@"INSERT INTO %@ (id , year , month , day , doctorId , hour) values ('%ld' , '%ld' , '%ld' , '%ld' , '%@' , '%ld' ) ;" , QM_USERDEFAULTS_APPOINTTABLE , [appointment identity] , [appointment year] , [appointment month] , [appointment day] , appointment.doctorId , [appointment appointHour]] ;
        NSLog(@"%@" , sql) ;
    }
    
//    GPLog(@"%@" , sql) ;
    // 执行插入操作
    if ([database executeUpdate:sql]) {
        NSLog(@"插入成功") ;
    } else {
    
        NSLog(@"插入失败 %@" , [database lastError]) ;
        
    }
    
    [database close] ;
}


/**
 *  在数据库表中删除模型数据
 *
 *  @param model        要删除的模型
 *  @param databasePath 数据库的路径
 *  @param tableName    表名
 */
+ (void) deleteModel : (id) model inDataBase : (NSString *) databasePath andTable : (NSString *) tableName {

    FMDatabase * database = [FMDatabase databaseWithPath:databasePath] ;
    // 连接数据库
    if ([database open]) {
        NSLog(@"数据库%@连接成功" , databasePath) ;
    } else {
        NSLog(@"数据库%@连接失败" , databasePath) ;
        NSLog(@"%@" , [database lastError]) ;
        return ;
    }
    
    NSString * sql ;
    // 拼接sql语句
//    if ([tableName isEqualToString:GP_TABLENAME_LIKEGIFT]) {
//        sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE url = '%@' ;" , GP_TABLENAME_LIKEGIFT ,[model url]] ;
//    } else if ([tableName isEqualToString:GP_TABLENAME_STRATEGY]) {
//        sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = '%@' ;" , GP_TABLENAME_STRATEGY ,[model identity]] ;
//    }
    
    if ([database executeUpdate:sql]) {
        NSLog(@"删除成功") ;
    } else {
    
        NSLog(@"删除失败 %@", [database lastError]) ;
    }
    
    [database close] ;
}


/**
 *  获得数据库表单中的全部数据
 *
 *  @param dataBase  数据库路径
 *  @param tableName 表单名称
 *
 *  @return 返回查询的结果
 */
+ (NSArray *) selectAllDataInDataBase : (NSString *) dataBaseName andTable : (NSString *) tableName {

    NSMutableArray * results = [NSMutableArray array] ;
    FMDatabase * database = [FMDatabase databaseWithPath:dataBaseName] ;
    
    // 连接数据库
    if ([database open]) {
        NSLog(@"数据库%@连接成功" , dataBaseName) ;
    } else {
        NSLog(@"数据库%@连接失败" , dataBaseName) ;
        NSLog(@"%@" , [database lastError]) ;
        return nil ;
    }
    
    // 要执行的sql语句
    NSString * sql = [NSString stringWithFormat:@"SELECT  * FROM %@ ;" , tableName] ;
    
    // 执行sql语句
    FMResultSet * resultSet = [database executeQuery:sql] ;
    
    // 迭代获取里面的内容
//    if ([tableName isEqualToString:GP_TABLENAME_LIKEGIFT]) {
//        while ([resultSet next]) {
//            GPHotItem * hotItem = [GPHotItem hotItemWithDict:[resultSet resultDictionary]] ;
//            //        NSLog(@"%@" , [resultSet resultDictionary]) ;
//            [results addObject:hotItem] ;
//        }
//    } else if ([tableName isEqualToString:GP_TABLENAME_STRATEGY]) {
//        while ([resultSet next]) {
//            GPItem * item = [GPItem itemWithDict:[resultSet resultDictionary]] ;
//                    NSLog(@"%@" , [item.identity class]) ;
//            [results addObject:item] ;
//        }
//    }
//    
    
    [database close] ;
    
    return results ;
}


/**
 *  获得数据库中符合预约信息的预约id
 *
 *  @param appointment 预约信息
 *
 *  @return 预约信息对应的预约id
 */
+ (NSInteger)selectAppointIdWithAppointment:(QMAppointment *)appointment {

//    NSMutableArray * results = [NSMutableArray array] ;
    NSString * databasePath = [[NSUserDefaults standardUserDefaults] valueForKey:QM_USERDEFAULTS_DATABASEPATH] ;
    FMDatabase * database = [FMDatabase databaseWithPath:databasePath] ;
    
    // 连接数据库
    if ([database open]) {
        NSLog(@"数据库%@连接成功" , databasePath) ;
    } else {
        NSLog(@"数据库%@连接失败" , databasePath) ;
        NSLog(@"%@" , [database lastError]) ;
        return -1 ;
    }
    
    // 拼接sql语句
    NSString * sql = [NSString stringWithFormat:@"select id from appointment where year = %ld and month = %ld and day = %ld and hour = %ld ;" , appointment.year , appointment.month , appointment.day , appointment.appointHour] ;
    NSLog(@"%@" , sql) ;
    
    FMResultSet * resultSet = [database executeQuery:sql] ;
    
    NSInteger appointId = -1 ;
    while ([resultSet next]) {
        appointId = [[[resultSet resultDictionary] valueForKey:@"id"] integerValue] ;
    }
    
    [database close] ;
    
    return appointId ;
    
}






@end
