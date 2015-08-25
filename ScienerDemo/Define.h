//
//  Define.h
//  ScienerDemo
//
//  Created by 谢元潮 on 14-10-29.
//  Copyright (c) 2014年 谢元潮. All rights reserved.
//

#ifndef ScienerDemo_Define_h
#define ScienerDemo_Define_h


#define kScienerAppkey @"fd2ff35ee3d8424c8665c07b7b9a7f45"
#define kScienerAppSecret @"d4a28e5dcccfeeba04d090beab42fbea"
#define kScienerRedirectUri @"http://www.sciener.cn"

#define NET_REQUEST_ERROR_NO_DATA -1001

//时效密码
typedef enum {
    TIME_PS_GROUP_DAY_1D = 1,
    TIME_PS_GROUP_DAY_2D,
    TIME_PS_GROUP_DAY_3D,
    TIME_PS_GROUP_DAY_4D,
    TIME_PS_GROUP_DAY_5D,
    TIME_PS_GROUP_DAY_6D,
    TIME_PS_GROUP_DAY_7D,
    TIME_PS_GROUP_DAY_10M
} TimePsGroup;

#endif
