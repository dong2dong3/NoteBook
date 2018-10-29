//
//  ObjectA1.m
//  ZJciji
//
//  Created by 张洁 on 2018/10/13.
//  Copyright © 2018年 张洁. All rights reserved.
//

#import "ObjectA1.h"

@implementation ObjectA1

- (void)handle
{
    //before 业务逻辑操作
    [super handle];
    // after 业务逻辑操作
}

+ (id) sharedInstance
{
    static ObjectA1 *instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return self;
}


@end
