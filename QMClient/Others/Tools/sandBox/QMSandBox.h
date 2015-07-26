//
//  GPSandBox.h
//  快速获取沙盒目录工具类
//
//  Created by Lotus on 15-5-22.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMSandBox : NSObject



/**获得app根目录*/
+ (NSString *) pathForHome ;

/**获得Documents目录*/
+ (NSString *) pathForDocuments ;

/**获得library目录*/
+ (NSString *) pathForLibrary ;

/**获得tmp目录*/
+ (NSString *) pathForTmp ;

/**获得library下的caches目录*/
+ (NSString *) pathForLibraryCaches ;

+ (NSString *) databasePath ;

@end
