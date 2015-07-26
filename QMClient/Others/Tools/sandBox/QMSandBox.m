//
//  GPSandBox.m
//  快速获取沙盒目录工具类
//
//  Created by Lotus on 15-5-22.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMSandBox.h"

@implementation QMSandBox

/**获得app根目录*/
+ (NSString *) pathForHome {

    return NSHomeDirectory() ;
}

+ (NSString *)pathForDocuments {

    NSArray * objs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) ;
    
    return [objs lastObject] ;
}

/**获得library目录*/
+ (NSString *) pathForLibrary {

    NSArray * objs = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) ;
    
    return [objs lastObject] ;
}

/**获得tmp目录*/
+ (NSString *) pathForTmp {
    
    return NSTemporaryDirectory() ;

}

/**获得library下的caches目录*/
+ (NSString *) pathForLibraryCaches {

    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] ;
}

+ (NSString *) databasePath {

    return [[QMSandBox pathForDocuments] stringByAppendingPathComponent:@"my.db"] ;
}

@end
