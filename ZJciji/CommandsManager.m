//
//  CommandsManager.m
//  ZJciji
//
//  Created by 张洁 on 2018/10/13.
//  Copyright © 2018年 张洁. All rights reserved.
//

#import "CommandsManager.h"

@implementation CommandsManager

+ (instancetype)sharedManager
{
    static CommandsManager *instance = nil;
    dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[super allocWithZone:NULL]init];
        instance.arrayCommands = [[NSMutableArray alloc]init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedManager];
}

- (instancetype)copyWithZone:(struct _NSZone *)zone
{
    return self;
}

//执行命令
+ (void)executeCommand:(Command *)cmd complition:(CommandComplitonCallBack)complition
{
    if (cmd) {
        if (![self _isExecutingCommand: cmd]) {
            [[[self sharedManager] arrayCommands] addObject:cmd];
            cmd.complition = complition;
            [cmd excute];
        }
    }
}

//取消命令
+ (void)cancleCommand:(Command *)cmd
{
    if (cmd) {
        [[[self sharedManager] arrayCommands] removeObject:cmd];
        [cmd cancel];
    }
}
//判断当前命令是否在执行.
+ (BOOL)_isExecutingCommand:(Command *)cmd
{
    if (cmd) {
        if([[[self sharedManager] arrayCommands] containsObject:cmd])
            return YES;
    }
    return NO;
}
@end
