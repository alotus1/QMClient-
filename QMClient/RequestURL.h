//
//  RequestURL.h
//  QMClient
//
//  Created by Lotus on 15/7/24.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#ifndef QMClient_RequestURL_h
#define QMClient_RequestURL_h

#define QM_URL_DAYAPPOINTEDDATA @"http://101.200.199.34:8080/api/appointment/day?year=%ld&month=%ld&day=%ld&doctorId=1&userId=%@"
#define QM_URL_MONTHAPPOINTEDDATA @"http://101.200.199.34:8080/api/appointment/month?year=%ld&month=%ld&day=%ld&doctorId=1&userId=%@"

#define QM_URL_ADDAPPOINTMENT @"http://101.200.199.34:8080/api/appointment/add?year=%ld&month=%ld&day=%ld&hour=%ld&doctorId=1&userId=%@"

#define QM_URL_CANCELAPPOINTMENT @"http://101.200.199.34:8080/api/appointment/delete?appointmentId=%ld&userId=%@"


#endif
